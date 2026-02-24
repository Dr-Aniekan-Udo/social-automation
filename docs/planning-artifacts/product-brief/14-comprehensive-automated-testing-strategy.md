# 14. Comprehensive Automated Testing Strategy

> [!IMPORTANT]
> Testing is the primary quality gate. AI-generated code is held to the **same or higher** testing standards as human-written code. Coverage gates are enforced in CI — no exceptions.

### 14.1 Testing Pyramid

| Layer | Tool | Coverage Target | Scope | Run Location |
| ------- | ------ | ---------------- | ------- | ------------- |
| **Unit** | Go `testing` + `testify` v1.10+ | 90% domain, 80% service | Pure logic, no I/O | CI (every PR) |
| **Integration** | `testcontainers-go` v0.34+ | 70% adapters | PostgreSQL, Redis, external API mocks | CI (every PR) |
| **API Contract** | OpenAPI 3.1 + `oapi-codegen` + `openapi-typescript` | 100% endpoints | Contract-first schema validation and typed code generation | CI (every PR) |
| **E2E** | Playwright v1.50+ | Critical user paths | Full user flows in Next.js frontend | CI (every PR) |
| **Performance** | k6 v1.0+ | Baseline regressions | Load testing, p95 latency thresholds | Pre-beta signoff (release gate) |
| **Security** | Semgrep + Dependabot + TruffleHog + Trivy (PR) + OWASP ZAP (nightly/pre-release) | All code + dependencies + images + HTTP surface | SAST, SCA, secret scanning, vulnerability scanning, DAST | CI (PR + scheduled) |
| **AI Quality** | Custom validators + LangSmith | All AI-generated outputs | Hallucination detection, PII leakage, brand consistency | CI + runtime |

### 14.2 Unit Testing Conventions (Go)

```go
// Table-driven tests required for functions with >2 parameters
func TestAIRouter_SelectProvider(t *testing.T) {
    tests := []struct {
        name     string
        taskType string
        want     string // expected tier name
    }{
        {"chat reply routes to budget", "chat_reply", "budget"},
        {"marketing copy routes to balanced", "marketing_copy", "balanced"},
        {"dispute routes to premium", "dispute", "premium"},
        {"unknown defaults to budget", "unknown_task", "budget"},
    }

    router := NewAIRouter(mockBudget, mockBalanced, mockPremium)
    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            provider := router.selectProvider(tt.taskType)
            assert.Equal(t, tt.want, provider.Name())
        })
    }
}
```

##### Rules

- Domain layer: 90%+ coverage, pure functions, no mocks needed
- Usecase layer: 80%+ coverage, mock interfaces via `testify/mock`
- Table-driven tests for any function with >2 parameters
- Test names: `Test<Type>_<Method>_<Scenario>`

### 14.3 Integration Testing (Adapter Layer)

```go
//go:build integration
// +build integration

func TestPostgresOrderRepo_CreateOrder(t *testing.T) {
    ctx := context.Background()

    // testcontainers spins up a real PostgreSQL 18 instance
    pgContainer, err := postgres.RunContainer(ctx,
        testcontainers.WithImage("postgres:18"),
        postgres.WithDatabase("test_db"),
    )
    require.NoError(t, err)
    defer pgContainer.Terminate(ctx)

    connStr, _ := pgContainer.ConnectionString(ctx)
    repo := NewPostgresOrderRepo(connStr)

    // Run migrations
    require.NoError(t, repo.Migrate(ctx))

    // Test with RLS — set tenant context
    order := &Order{
        TenantID:     uuid.New(),
        CustomerName: "Test Customer",
        Amount:       15000.00,
        Status:       "pending",
    }

    err = repo.Create(ctx, order)
    assert.NoError(t, err)
    assert.NotEmpty(t, order.ID)

    // Verify tenant isolation — different tenant should not see this order
    otherTenantCtx := context.WithValue(ctx, "tenantID", uuid.New())
    _, err = repo.GetByID(otherTenantCtx, order.ID)
    assert.ErrorIs(t, err, ErrNotFound)
}
```

### 14.4 E2E Testing (Frontend — Playwright)

```typescript
// tests/e2e/onboarding.spec.ts
import { test, expect } from '@playwright/test';

test.describe('SMB Onboarding Flow', () => {
  test('completes Instagram readiness check wizard', async ({ page }) => {
    await page.goto('/onboarding');

    // Step 1: Business Account check
    await expect(page.getByText('Is your account a Business or Creator Account?')).toBeVisible();
    await page.getByRole('button', { name: 'Yes' }).click();

    // Step 2: Facebook Page check
    await expect(page.getByText('Do you have a Facebook Page linked to your Instagram?')).toBeVisible();
    await page.getByRole('button', { name: 'Yes' }).click();

    // Step 3: OAuth redirect
    await expect(page.getByRole('button', { name: 'Connect Instagram' })).toBeVisible();
  });

  test('blocks unready accounts with tutorial links', async ({ page }) => {
    await page.goto('/onboarding');
    await page.getByRole('button', { name: 'No' }).click();

    await expect(page.getByText('convert-to-business')).toBeVisible();
    await expect(page.getByRole('button', { name: 'Connect Instagram' })).toBeDisabled();
  });
});
```

### 14.5 AI Output Validation Testing

```go
type AIOutputValidator struct {
    piiDetector    *PIIDetector
    toxicityFilter *ToxicityFilter
    brandChecker   *BrandConsistencyChecker
}

func TestAIOutputValidator_DetectsPII(t *testing.T) {
    validator := NewAIOutputValidator()

    tests := []struct {
        name   string
        output string
        hasPII bool
    }{
        {"clean output", "Check out our new product line!", false},
        {"contains phone", "Call us at 08012345678 for orders", true},
        {"contains BVN", "Your BVN 12345678901 is verified", true},
        {"contains email", "Send to john@example.com", true},
    }

    for _, tt := range tests {
        t.Run(tt.name, func(t *testing.T) {
            result := validator.Validate(tt.output)
            assert.Equal(t, tt.hasPII, result.ContainsPII)
        })
    }
}

func TestAIOutputValidator_BrandConsistency(t *testing.T) {
    validator := NewAIOutputValidator()
    brandKit := &BrandKit{
        BusinessName: "Amaka's Fashion",
        Tone:         "friendly, professional",
        Forbidden:    []string{"cheap", "bargain", "knockoff"},
    }

    output := "Get our cheap knockoff bags today!"
    result := validator.CheckBrandConsistency(output, brandKit)

    assert.False(t, result.IsConsistent)
    assert.Contains(t, result.Violations, "cheap")
    assert.Contains(t, result.Violations, "knockoff")
}
```

### 14.6 Coverage Gates (CI Enforcement)

| Metric | Threshold | Action on Failure |
| -------- | ----------- | ------------------- |
| Overall coverage | ≥60% | Block PR merge |
| New code coverage | ≥80% | Block PR merge |
| Domain layer | ≥90% | Block PR merge |
| Usecase layer | ≥80% | Block PR merge |
| Critical path E2E | 100% pass | Block PR merge |
| Security scan findings (HIGH+) | 0 | Block PR merge |

### 14.7 Test Data Strategy

- **Factories:** Use `factory` pattern for test data generation (never production data)
- **Fixtures:** Seed data loaded via `testfixtures/v3` for integration tests
- **Isolation:** Each test gets its own tenant context via RLS
- **Cleanup:** `t.Cleanup()` ensures resources are released

---
