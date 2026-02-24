# 12. Security & DevSecOps

### CI/CD Pipeline

```yaml
name: CI/CD Pipeline
on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

jobs:
  security:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Semgrep (SAST)
        uses: returntocorp/semgrep-action@v1
        with:
          config: >-
            p/golang
            p/owasp-top-ten
            p/sql-injection
      - name: Run Dependabot Check (SCA)
        run: gh api repos/${{ github.repository }}/vulnerability-alerts
      - name: Run Trivy (filesystem/dependency scan)
        uses: aquasecurity/trivy-action@0.22.0
        with:
          scan-type: fs
          scan-ref: .
          exit-code: '1'
          ignore-unfixed: true
      - name: Check for hardcoded secrets
        uses: trufflesecurity/trufflehog@main
        with:
          extra_args: --only-verified

  lint-architecture:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Architecture lint (reject dependency violations)
        run: go-arch-lint check
      - name: Go vet + staticcheck
        run: |
          go vet ./...
          staticcheck ./...

  unit-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: '1.26'
      - name: Run unit tests with race detection
        run: go test -v -race -short -coverprofile=coverage.out ./...
      - name: Enforce coverage threshold (80% minimum for new code)
        run: |
          COVERAGE=$(go tool cover -func=coverage.out | grep total | awk '{print $3}' | sed 's/%//')
          echo "Total coverage: ${COVERAGE}%"
          if (( $(echo "$COVERAGE < 60" | bc -l) )); then
            echo "::error::Coverage ${COVERAGE}% is below 60% minimum"
            exit 1
          fi
      - name: Upload coverage
        uses: codecov/codecov-action@v4

  integration-test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:18
        env:
          POSTGRES_PASSWORD: test
          POSTGRES_DB: marketboss_test
        ports: ['5432:5432']
      redis:
        image: redis:7.4
        ports: ['6379:6379']
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-go@v5
        with:
          go-version: '1.26'
      - name: Run integration tests
        run: go test -v -race -tags=integration ./...
        env:
          DATABASE_URL: postgres://postgres:test@localhost:5432/marketboss_test
          REDIS_URL: redis://localhost:6379

  e2e-test:
    runs-on: ubuntu-latest
    needs: [unit-test]
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-node@v4
        with:
          node-version: '24'
      - name: Install dependencies & run Playwright
        run: |
          cd frontend && npm ci
          npx playwright install --with-deps
          npx playwright test
      - uses: actions/upload-artifact@v4
        if: failure()
        with:
          name: playwright-report
          path: frontend/playwright-report/

  build-deploy:
    needs: [security, lint-architecture, unit-test, integration-test, e2e-test]
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - name: Build & scan Docker image
        run: |
          docker build -t marketboss:${{ github.sha }} .
          docker run --rm aquasec/trivy:latest image marketboss:${{ github.sha }}
      - name: Deploy to DigitalOcean
        uses: digitalocean/app_action@main
        with:
          app_name: marketboss-production
          token: ${{ secrets.DIGITALOCEAN_TOKEN }}
```

#### MVP Security/Performance Gate Profile (Canonical)

- PR-blocking gates: Semgrep + Dependabot + TruffleHog + Trivy.
- OWASP ZAP runs on nightly/pre-release schedules (not PR-blocking in MVP).
- k6 runs at pre-beta performance signoff as a release gate (not nightly, not Kubernetes-dependent).

## Branch Protection Rules

```yaml
# GitHub branch protection settings (configured via repo settings or Terraform)
branch_protection:
  main:
    required_reviews: 2
    dismiss_stale_reviews: true
    require_status_checks:
      - security
      - lint-architecture
      - unit-test
      - integration-test
      - e2e-test
    enforce_admins: true
    restrict_pushes: true  # No direct pushes — PRs only
    require_linear_history: true  # Squash merge only

  develop:
    required_reviews: 1
    require_status_checks:
      - security
      - lint-architecture
      - unit-test
    enforce_admins: false
    restrict_pushes: true
```

### RBAC (Role-Based Access Control)

```go
type RBACService struct {
    db *sql.DB
}

const (
    RoleOwner  = "owner"
    RoleAdmin  = "admin"
    RoleMember = "member"
    RoleViewer = "viewer"
)

func (rbac *RBACService) CheckPermission(ctx context.Context, userID, resource, action string) (bool, error) {
    role := rbac.getUserRole(ctx, userID)
    permissions := map[string][]string{
        RoleOwner:  {"read", "write", "delete", "admin"},
        RoleAdmin:  {"read", "write", "admin"},
        RoleMember: {"read", "write"},
        RoleViewer: {"read"},
    }
    return contains(permissions[role], action), nil
}
```

---
