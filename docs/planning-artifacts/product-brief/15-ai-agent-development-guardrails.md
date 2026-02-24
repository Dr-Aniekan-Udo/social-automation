# 15. AI Agent Development Guardrails

> [!CAUTION]
> When AI coding agents (Copilot, Cursor, Claude, Antigravity, etc.) are building features, **tighter rules apply**. AI-generated code is treated as untrusted until it passes the full CI pipeline. The following guardrails are mandatory.

### 15.1 Architecture Compliance Rules

AI agents **MUST** follow Clean Architecture boundaries:

| Rule | Enforcement | What Happens on Violation |
| ------ | ------------ | -------------------------- |
| Domain layer has ZERO external imports | `go-arch-lint` in CI | PR blocked |
| Usecase layer only imports domain | `go-arch-lint` in CI | PR blocked |
| Adapters implement domain interfaces | Code review + lint | PR blocked |
| No business logic in port/handler layer | Code review | PR rejected |
| Every new adapter has a domain interface | Code review | PR rejected |

##### Agent Pre-Commit Checklist (automated via pre-commit hooks)

```bash
#!/bin/bash
# .git/hooks/pre-commit — enforced for all contributors including AI agents
set -e

echo "🔒 Running pre-commit checks..."

# 1. Architecture lint
go-arch-lint check || { echo "❌ Architecture violation detected"; exit 1; }

# 2. Unit tests with race detection
go test -race -short ./... || { echo "❌ Tests failed"; exit 1; }

# 3. Security scan
semgrep ci --config p/golang --config p/owasp-top-ten || { echo "❌ Security issues found"; exit 1; }

# 4. Check for hardcoded secrets
trufflehog filesystem . --only-verified || { echo "❌ Secrets detected"; exit 1; }

# 5. Go vet + staticcheck
go vet ./... || { echo "❌ Go vet failed"; exit 1; }
staticcheck ./... || { echo "❌ Staticcheck failed"; exit 1; }

echo "✅ All pre-commit checks passed"
```

### 15.2 Security Rules for AI Agents

| Rule | Detection | Rationale |
| ------ | ----------- | ----------- |
| No hardcoded secrets or API keys | TruffleHog + Semgrep | Leaked credentials are the #1 vulnerability |
| No direct SQL (must use repository pattern) | Semgrep custom rule | SQL injection prevention |
| No `fmt.Sprintf` for SQL queries | Semgrep pattern: `fmt.Sprintf("SELECT` | Parameterized queries only |
| All external inputs validated at handler layer | Code review | Defense in depth |
| PII logged only via structured logging with redaction | Semgrep custom rule | NDPA compliance |
| No `context.TODO()` in production code | Semgrep custom rule + code review | Proper context propagation |
| All HTTP clients must have timeouts | Semgrep custom rule | Prevent resource exhaustion |

##### Custom Semgrep Rules (`.semgrep.yml`)

```yaml
rules:
  - id: no-raw-sql-sprintf
    pattern: fmt.Sprintf("... SELECT ...", ...)
    message: "Do not use fmt.Sprintf for SQL queries. Use parameterized queries via repository pattern."
    severity: ERROR
    languages: [go]

  - id: no-hardcoded-secrets
    patterns:
      - pattern: |
          $X = "sk_live_..."
      - pattern: |
          $X = "pk_live_..."
    message: "Hardcoded Paystack/API key detected. Use environment variables."
    severity: ERROR
    languages: [go]

  - id: no-context-todo-production
    pattern: context.TODO()
    message: "Do not use context.TODO() in production code. Propagate context from caller."
    severity: WARNING
    languages: [go]

  - id: http-client-needs-timeout
    pattern: |
      &http.Client{}
    message: "HTTP clients must specify a Timeout to prevent resource exhaustion."
    severity: ERROR
    languages: [go]
```

### 15.3 Testing Rules for AI Agents

- Every new function **MUST** have a corresponding test
- Every new adapter **MUST** have integration tests using `testcontainers-go`
- Table-driven tests required for functions with >2 parameters
- No PR merged without test coverage for new lines of code
- AI-generated tests are reviewed for assertion quality (not just coverage padding)

### 15.4 Error Context Tooling — Agent Debugging Chain

> [!TIP]
> When an AI agent encounters an error during development, these tools provide the **full context chain** needed to diagnose and fix the issue without guessing.

##### Error Context Stack (Already in Our Tech Stack)

```text
Error occurs in production/staging/CI
    │
    ├─→ Sentry (§11) — Full stack trace, breadcrumbs, user context, environment
    │   └── Query: Sentry REST API → GET /api/0/issues/{issue_id}/events/latest/
    │
    ├─→ OpenTelemetry + SigNoz (§11) — Distributed trace spanning all services
    │   └── Trace ID links: HTTP handler → service → adapter → DB/Redis/API
    │
    ├─→ Structured Logging (zap) (§11) — Correlated by request_id, tenant_id
    │   └── Query: SigNoz Logs → filter by trace_id or request_id
    │
    └─→ Full picture: WHAT failed, WHERE (stack + trace), WHY (breadcrumbs + logs)
```

##### For the AI Coding Agent (IDE Context)

| Tool | How Agent Uses It | What It Provides |
| ------ | ------------------- | ------------------ |
| **Terminal output** (`command_status` / `read_terminal`) | Run tests, see build errors | Full compiler output, test failure details |
| **GitHub MCP** (`mcp__github__*`) | Check CI status, read review comments, view action logs | Pipeline failure reasons, reviewer feedback |
| **Playwright MCP** (`mcp__playwright__*`) | Navigate frontend, interact with UI elements, capture screenshots | Visual validation, E2E test debugging, component state verification |
| **Sentry API** (optional MCP) | Query error events by release or issue | Stack traces, breadcrumbs, environment data, affected users |
| **SigNoz dashboard** (browser agent) | View distributed traces | Request lifecycle, latency breakdown, span errors |
| **Go test output** (`go test -v ./...`) | Run targeted tests | Assertion failures, panic traces, race conditions |

##### GitHub MCP Workflow for AI Agents

```text
1. Agent creates feature branch     → mcp__github__create_branch (BEFORE any coding)
2. Agent codes locally              → IDE editing, running tests, iterating
3. Agent runs all validations       → go test, lint, security, architecture checks
4. User reviews and approves        → User verifies requirements are met
5. Agent pushes code changes        → mcp__github__push_files
6. Agent creates PR                 → mcp__github__create_pull_request
7. Agent monitors CI pipeline       → mcp__github__pull_request_read(method: get_status)
8. If CI fails:
   a. Read failure details          → mcp__github__pull_request_read(method: get_files) (diff)
   b. Read review comments          → mcp__github__pull_request_read(method: get_comments)
   c. Fix code and push again       → mcp__github__push_files
9. When CI passes + required reviews + user approval → mcp__github__merge_pull_request
```

### 15.5 Code Quality Standards

| Metric | Target | Enforcement |
| -------- | -------- | ------------- |
| Cyclomatic complexity | ≤15 per function | `gocyclo` in CI |
| Function length | ≤50 lines | Code review |
| File length | ≤500 lines | Code review |
| Package coupling | Domain imports nothing, service imports only domain | `go-arch-lint` |
| Error handling | All errors wrapped with context (`fmt.Errorf("...: %w", err)`) | Code review + `staticcheck` |
| Documentation | All exported functions have godoc comments | `revive` (via `golangci-lint`) |

### 15.6 Playwright MCP — Frontend Navigation & E2E Testing

> [!NOTE]
> The **Playwright MCP server** provides the AI agent with direct browser control capabilities. This enables the agent to navigate the frontend, interact with UI components, verify visual output, capture screenshots, and run E2E test flows — all without leaving the IDE.

##### Available Capabilities

| Capability | MCP Tool | Use Case |
| ------------ | ---------- | ---------- |
| Navigate to URL | `mcp__playwright__browser_navigate` | Load specific pages/routes for inspection |
| Click elements | `mcp__playwright__browser_click` | Interact with buttons, links, form controls |
| Fill forms | `mcp__playwright__browser_fill_form` | Enter text into inputs, textareas, search bars |
| Take screenshots | `mcp__playwright__browser_take_screenshot` | Capture current page state for visual validation |
| Get page content | `mcp__playwright__browser_snapshot` | Read rendered text for assertion/verification |
| Wait for elements | `mcp__playwright__browser_wait_for` | Ensure dynamic content has loaded before interacting |
| Evaluate JavaScript | `mcp__playwright__browser_evaluate` | Inspect component state, localStorage, API responses |
| Select options | `mcp__playwright__browser_select_option` | Interact with dropdowns and select elements |
| Handle dialogs | `mcp__playwright__browser_handle_dialog` | Accept/dismiss alerts, confirms, prompts |

##### Agent E2E Testing Workflow

```text
1. Agent starts dev server                → run_command (npm run dev)
2. Agent navigates to page under test     → mcp__playwright__browser_navigate
3. Agent interacts with UI elements       → mcp__playwright__browser_click / mcp__playwright__browser_fill_form
4. Agent captures visual state            → mcp__playwright__browser_take_screenshot
5. Agent verifies expected text/elements  → mcp__playwright__browser_snapshot
6. Agent checks for console errors        → mcp__playwright__browser_console_messages
7. If test fails:
   a. Screenshot the failure state        → mcp__playwright__browser_take_screenshot
   b. Read error details                  → mcp__playwright__browser_snapshot
   c. Fix code and re-test                → repeat steps 2-6
8. Agent runs full E2E suite              → run_command (npx playwright test)
```

##### When to Use Playwright MCP vs Playwright Test Suite

| Scenario | Tool | Rationale |
| ---------- | ------ | ----------- |
| Quick visual check during development | Playwright MCP | Faster feedback loop, no test file needed |
| Verifying a specific component renders correctly | Playwright MCP | Ad-hoc exploration |
| Automating regression tests for CI | Playwright test suite (`.spec.ts`) | Repeatable, runs in CI pipeline |
| Debugging a failing E2E test | Playwright MCP | Step through the flow interactively |
| Replicating a Lovable design (§15.7) | Playwright MCP | Compare live output against reference screenshots |

### 15.7 Lovable Design Reference Workflow

> [!IMPORTANT]
> **Lovable** (AI design tool) may be used to generate initial frontend designs. These designs serve as **visual references** — not source code. The AI agent replicates the design using our actual tech stack (React 19.x / Next.js 16.x) while following our architecture and coding standards.

##### Design Reference Inputs (When Provided)

| Input | Format | What Agent Uses It For |
| ------- | -------- | ------------------------ |
| Lovable-generated code | React/JSX source files | Component structure inspiration, layout patterns, color schemes |
| Lovable live URL | Browser-accessible URL | Visual reference via Playwright MCP screenshots |
| Screenshot/mockups | Image files (`.png`, `.webp`) | Pixel-level design targets |

##### Agent Workflow — With Lovable Reference

```text
Design Reference Provided
    │
    ├─→ Step 1: Visual Analysis
    │   └── Navigate to Lovable URL via Playwright MCP
    │   └── Take screenshots of each page/component
    │   └── Identify: layout grid, color palette, typography, spacing, animations
    │
    ├─→ Step 2: Component Extraction
    │   └── Read Lovable source code (if provided)
    │   └── Map Lovable components → our component structure
    │   └── Identify reusable patterns: cards, forms, tables, modals, navigation
    │
    ├─→ Step 3: Re-Implementation
    │   └── Build components using our stack (React 19, Next.js 16, Tailwind CSS 4 + CSS custom properties)
    │   └── Maintain visual fidelity: colors, spacing, typography, responsiveness
    │   └── Apply our coding standards (§15.8) and architecture rules
    │   └── Replace any Lovable-specific patterns with standard React patterns
    │
    ├─→ Step 4: Visual Comparison
    │   └── Navigate to our implementation via Playwright MCP
    │   └── Screenshot each page/component
    │   └── Compare against Lovable reference screenshots
    │   └── Iterate until visual parity achieved
    │
    └─→ Step 5: Validation
        └── Responsive check (mobile, tablet, desktop via Playwright viewport)
        └── Accessibility audit (semantic HTML, ARIA labels, contrast ratios)
        └── Performance check (Core Web Vitals targets from §16.4)
```

##### Agent Workflow — Without Lovable Reference (Default)

```text
No Design Reference (or provided later)
    │
    ├─→ Agent builds UI from:
    │   └── Product brief requirements (user stories, features)
    │   └── UI/UX Design Principles (§15.8)
    │   └── Revenue Command Feed task-first conventions
    │   └── Accessibility-first approach
    │
    ├─→ Agent creates:
    │   └── Design system (CSS custom properties: colors, spacing, typography)
    │   └── Component library (reusable, composable)
    │   └── Responsive layouts (mobile-first)
    │
    └─→ When Lovable reference is provided LATER:
        └── Agent compares existing implementation against new reference
        └── Generates a diff/gap analysis: what needs to change
        └── Incrementally updates components to match new design
        └── Preserves existing functionality and test coverage
        └── Updates design system tokens (colors, fonts, spacing) first
        └── Then updates individual components
```

> [!TIP]
> The architecture is designed for **design adaptability**. Because we use a centralized design system (CSS custom properties + component library), swapping visual themes is a token update — not a rewrite. The agent can absorb a Lovable reference at ANY point in development.

### 15.8 UI/UX Design Principles & Coding Standards

> [!IMPORTANT]
> These standards ensure visual consistency, maintainability, and a premium user experience across all frontend work — whether built from scratch or replicated from a design reference.

#### 15.8.1 UI/UX Design Principles

| Principle | Standard | Rationale |
| ----------- | ---------- | ----------- |
| **Mobile-First** | Design for 375px (iPhone SE) first, then scale up | 70%+ of Nigerian SMBs access via mobile |
| **Accessibility** | WCAG 2.1 AA minimum. Semantic HTML. ARIA labels. 4.5:1 contrast ratio | Inclusive design, legal compliance |
| **Consistency** | Design system with tokens for colors, spacing, typography, shadows | Prevents visual drift across pages |
| **Performance** | LCP < 2.5s, INP < 200ms, CLS < 0.1 | Users on variable network speeds |
| **Progressive Disclosure** | Show essential actions first; advanced options behind expandable sections | Reduces cognitive load for SMB users |
| **Feedback** | Every action gets visual feedback within 100ms (loading states, toasts, transitions) | Users must never wonder "did it work?" |
| **Whitespace** | Generous padding/margins. Never crowd elements | Premium feel, readability |
| **Typography** | Max 2 font families. Clear hierarchy (h1-h6). Min 16px body text | Readability across devices |
| **Color System** | Primary, secondary, accent, neutral, semantic (success/warning/error/info) | Consistent meaning across the app |
| **Dark Mode** | Launch light mode in MVP. Dark tokens are prepared and activated in Phase 2 | Light-mode clarity first for Nigerian outdoor usage; phased rollout reduces MVP complexity |

#### 15.8.2 Frontend Coding Standards

| Standard | Rule | Enforcement |
| ---------- | ------ | --------- |
| **Component Size** | Max 200 lines per component file. Extract sub-components if larger | Code review |
| **Naming Convention** | PascalCase for components, camelCase for functions/variables, kebab-case for CSS classes | ESLint + Stylelint |
| **CSS Approach** | Tailwind CSS 4 + CSS custom properties/tokens. CSS Modules (`.module.css`) optional for isolated component overrides. NO inline styles except dynamic values | Stylelint |
| **Design Tokens** | All colors, spacing, fonts, shadows defined as CSS custom properties in `globals.css` | Code review |
| **Responsive** | Use CSS Grid + Flexbox. Minimum supported width: `320px` (optimized for `360px+`). Canonical breakpoints: `sm:480px`, `md:768px`, `lg:1024px` | Visual review |
| **Images** | Next.js `<Image>` component only. WebP format. Alt text required. Lazy loading default | ESLint plugin |
| **State Management** | TanStack Query for server state and Zustand for client UI state. `useState`/`useReducer` for local component state only | Code review |
| **Data Fetching** | Server Components (RSC) for initial data. TanStack Query hooks for client-side data and cache lifecycle | Code review |
| **Error Boundaries** | Every page wrapped in error boundary. Fallback UI for all error states | Code review |
| **Loading States** | Skeleton loaders for content. Spinner for actions. Never show blank screens | Visual review + E2E |
| **TypeScript** | Strict mode. No `any` types. Interface-first design. Zod for runtime validation | `tsc --strict` |
| **Testing** | Every component has a test file. Playwright for E2E. Test IDs on interactive elements | CI coverage gate |


> [!IMPORTANT]
> Canonical implementation standards are defined in `docs/planning-artifacts/architecture.md`, `docs/planning-artifacts/ux-design-specification.md`, `docs/planning-artifacts/prd.md`, and UX HTML artifacts (`ux-design-directions.html`, `ux-color-themes.html`). `docs/project-context.md` is derived and must follow that chain.

#### 15.8.3 Stack Versions (Pinned & Verified)

> [!CAUTION]
> These versions are **pinned** as of February 2026. AI agents must NOT upgrade major versions without explicit approval. Use exact versions in `package.json` (no `^` or `~` for core dependencies).

| Dependency | Pinned Version | Release Date | EOL / Support |
| ------------ | --------------- | ------------- | --------------- |
| **Go** | 1.26 | Feb 10, 2026 | Supported (current) |
| **PostgreSQL** | 18 | Sep 2025 | Nov 2030 |
| **Redis** | 7.4+ | 2025 | Active |
| **Node.js** | 24.x (Krypton LTS) | Oct 2025 | Apr 2027 |
| **React** | 19.x | Dec 2024 | Active (current) |
| **Next.js** | 16.x | 2026 | Active (current) |
| **TypeScript** | 5.7+ | 2025 | Active |
| **Playwright** | 1.50+ | 2025 | Active |
| **SigNoz** | 0.110.x | 2025 | Active |
| **Sentry Go SDK** | 0.32+ | 2025 | Active |
| **Sentry JS SDK** | 9.x | 2025 | Active |
| **testify** | 1.10+ | 2025 | Active |
| **testcontainers-go** | 0.34+ | 2025 | Active |

##### `package.json` Version Locking Rule

```json
{
  "dependencies": {
    "react": "19.1.0",
    "next": "16.0.0",
    "typescript": "5.7.3"
  },
  "overrides": {
    "react": "$react"
  }
}
```

##### `go.mod` Version Rule

```go
go 1.26

require (
    github.com/stretchr/testify v1.10.0
    github.com/testcontainers/testcontainers-go v0.34.0
)
```
