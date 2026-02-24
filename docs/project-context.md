---
project_name: 'social-automation'
user_name: 'Aniekan'
date: '2026-02-22'
sections_completed: ['technology_stack', 'language_rules', 'framework_rules', 'testing_rules', 'quality_rules', 'workflow_rules', 'anti_patterns']
status: 'complete'
rule_count: 45
optimized_for_llm: true
---

# Project Context for AI Agents

_This file contains critical rules and patterns that AI agents must follow when implementing code in this project. Focus on unobvious details that agents might otherwise miss._

**Canonical Standards Pointer:** For cross-document conflicts, follow `architecture > ux spec > prd > ux html > product-brief`. This file (`docs/project-context.md`) is a derived implementation contract and must not override that chain.

---

## Technology Stack & Versions

### Backend

- **Go** 1.26 — standard library `net/http` for HTTP server (no framework)
- **PostgreSQL** 18 — primary data store with Row-Level Security (RLS)
- **Redis** 7.4+ — caching, session store, event bus (Streams), rate limiting
- **pgx/v5** — PostgreSQL driver (pure Go, no CGO)
- **sqlc** — type-safe SQL → Go code generation (no ORM)
- **golang-migrate** — database migration tool
- **Zap** — structured logging
- **OpenTelemetry** — distributed tracing, metrics → exports to SigNoz
- **google/uuid** v1.6+ — UUIDv7 generation for all primary keys

### Frontend

- **Next.js** 16 — App Router, React Server Components
- **React** 19 — with Server Components and Suspense
- **Node.js** 24.x — runtime
- **TypeScript** 5.x — strict mode enabled
- **Tailwind CSS** 4 — utility-first styling
- **shadcn/ui** — component library (Radix primitives + Tailwind)
- **Zustand** 5 — single `appStore.ts` for client state
- **TanStack Query** 5 — server state management and caching
- **Serwist** — PWA service worker (offline support)
- **Sentry** — frontend error tracking

### External APIs

- **DeepSeek** (Lite + Full) — primary AI provider (cost-effective)
- **Google Gemini** — secondary AI provider
- **OpenAI GPT-4o** — tertiary AI provider (premium tier)
- **WhatsApp Business API** — messaging
- **Meta Graph API** — Instagram/Facebook publishing
- **Paystack** — primary payment gateway (Nigeria)
- **Flutterwave** — secondary payment gateway

### Infrastructure

- **DigitalOcean** — App Platform for hosting
- **Docker Compose** — local development environment
- **S3-compatible object storage + CDN capability** — canonical media storage/delivery requirement (Cloudflare optional, not mandatory)

### MVP Tooling Profile (Canonical)

- **PR security gates:** Semgrep + Dependabot + TruffleHog + Trivy are required and PR-blocking.
- **DAST phasing:** OWASP ZAP runs nightly/pre-release in MVP and is not PR-blocking.
- **Performance gating phasing:** k6 is a pre-beta performance signoff gate only (not nightly, not Kubernetes-dependent).
- **API contract canon:** OpenAPI source lives at `api/openapi.yaml`, with `oapi-codegen` (Go) and `openapi-typescript` (frontend types).
- **No-bloat tool rule:** Add a new library/scanner only for a missing capability; do not add overlapping tools for the same risk class without explicit justification.

### Critical AI Agent Stack Constraints

When implementing this stack, AI agents MUST overcome their default training tendencies:

1. **The "No Framework" Go Rule** — Agents instinctively reach for `gin`, `fiber`, or `echo`. **DO NOT use them.** Use only the standard library `net/http` for routing and JSON handling.
2. **The "No ORM" Database Rule** — Agents instinctively write `GORM` code or unsafe raw SQL strings. **DO NOT use them.** Default to `sqlc`-generated type-safe queries from explicit `.sql` files with `pgx/v5`; use direct `pgx` parameterized SQL only for constrained dynamic query cases that cannot be expressed cleanly in sqlc.
3. **The React 19 Modernity Rule** — Agents instinctively write `useEffect` for data fetching or legacy React context. **DO NOT use them.** You must use React Server Components where possible, and TanStack Query v5 + Suspense for all client-side data fetching. Global state goes to Zustand, nowhere else.
4. **The BFF API Connection Rule** — Do not hardcode remote backend URLs in frontend components. The Next.js app uses a BFF (Backend-for-Frontend) proxy. All client-side fetch calls must go to relative `/api/*` endpoints.
5. **The Dependency Freeze Rule** — Do not add "helpful" libraries like `axios`, `lodash`, or `moment` to `package.json`, or generic helper modules to `go.mod`. Stick strictly to the defined lean stack unless explicitly authorized by the user.
6. **The Tenant ID Forgetting Rule** — When writing database queries, agents often forget Row-Level Security (RLS). Every database interaction must be explicitly scoped to the active `TenantID` from the request context.

## Critical Implementation Rules

### Language-Specific Rules

#### Go (Backend)

- **The Interface Rule:** Accept interfaces, return structs. Interfaces belong in the _consuming_ package (Domain), not the implementing package (Adapter).
- **The Context Rule:** EVERY database query and external API call MUST take `ctx`. Never use `context.Background()` or `context.TODO()` in production code.
- **The HTTP Timeout Rule:** All external HTTP clients MUST have explicit timeouts configured to prevent resource exhaustion.
- **The Resource Leak Rule:** Always `defer resp.Body.Close()`. Check `rows.Err()` after a `rows.Next()` loop finishes in pgx/sqlc.
- **Error Handling & Logging:** Wrap every error with rich context (`fmt.Errorf("...: %w", err)`). Never log raw PII. If compliance requires sensitive-field observability, log only redacted or hashed values via structured Zap logging. At the handler layer, map errors to RFC 7807 problem details (`handler/response.go`).
- **The SQL Parameterization Rule:** NEVER use `fmt.Sprintf` for SQL queries. SQL MUST be parameterized via `sqlc` or explicit parameterized `pgx` statements (for approved dynamic-query paths) to prevent SQL injection.
- **Concurrency:** Avoid naked goroutines. Always use `errgroup` for structured concurrency when fanning out tasks, ensuring proper context cancellation.

#### TypeScript (Frontend)

- **The Server Component Default:** Default to React Server Components. Only add `"use client"` at the lowest possible leaf node in the component tree where interactivity (`useState`, `onClick`) is explicitly required.
- **The Zod Boundary Rule:** Never trust any data crossing the network boundary, even from our own Go backend. Responses must be parsed with a Zod schema in the TanStack Query fetcher function before entering application state.
- **The Anti-Casting Rule:** The `as` keyword is strictly forbidden for type casting (e.g., `data as User`). You must use Zod parsing or TypeScript type predicates.
- **Strict Typing:** `strict: true` is enabled. You must never use `any`. Use `unknown` for unvalidated data.
- **Types vs Interfaces:** Use `interface` for object shapes and component props. Use `type` only for unions, intersections, and primitives.
- **Async/Await:** Avoid `.then().catch()` chains. Always use `async/await` with `try/catch` blocks for readability and consistent error handling.

### Framework-Specific Rules

#### Next.js (App Router) & React 19

- **The "No `useEffect` for Data" Rule:** Agents instinctively write `useEffect` to fetch data. **DO NOT do this.** Data must be fetched via React Server Components (RSC) and passed as props, OR fetched client-side exclusively via TanStack Query hooks.
- **The BFF Token Rule:** The Next.js frontend MUST NEVER hold or understand JWTs. Authentication is handled by the Go backend setting a `__Host-session` HTTP-only cookie. Next.js API routes (acting as a BFF) automatically forward this cookie to the Go backend.
- **The Hydration Rule:** When passing data from a Server Component to a Client Component that uses TanStack Query, you MUST use the `QueryClient` `prefetchQuery` + `HydrationBoundary` pattern to avoid client-side waterfalls.
- **The Server Actions Boundary:** Server Actions (`"use server"`) should ONLY be used for simple form submissions or mutations that don't require complex optimistic UI updates. For robust, high-frequency mutations (like saving drafts), use the Go backend API via TanStack Query's `useMutation`.
- **The Business Profile RAG Rule:** Business Profile data is the primary RAG knowledge source — all AI-generated responses (DM replies, caption suggestions, product descriptions) MUST reference it. If no Business Profile exists, AI must fall back to generic responses with a prompt to complete the profile.

### UX-Mandated Implementation Rules

- **The 48px Touch Target Rule:** Every interactive element (buttons, chips, stars, toggles, links) MUST have a minimum 48×48px touch target. Use padding/margin to achieve this even if the visual element is smaller.
- **The Skeleton-First Loading Rule:** NEVER show blank screens or raw spinners. All loading states MUST use skeleton placeholders that match the shape of the incoming content.
- **The Bottom Sheet Over Modal Rule:** On mobile viewports, NEVER use centered dialog modals. Use bottom sheets exclusively for confirmations, options, and contextual actions.
- **The GPU Animation Rule:** Only animate `transform` and `opacity` properties. NEVER animate `width`, `height`, `top`, `left`, or `margin` — these trigger expensive reflows on low-end devices (Tecno, Infinix).
- **The Optimistic UI Rule:** Use optimistic UI only for reversible actions, with a brief undo window (3–5s). For irreversible send actions (message send, payment-link send), use delivery-confirmed states (`sending` → `delivered`/`failed`) instead of blind optimistic success.

#### State Management

- **The Strict Separation Rule:**
  - **Zustand** = Ephemeral UI state ONLY (e.g., `isSidebarOpen`, `selectedTheme`, `activeDraftId`). It is completely erased on page refresh.
  - **TanStack Query** = Server state ONLY (e.g., `userProfile`, `inboxMessages`). It handles caching, background sync, and deduplication.
- **The "No Duplication" Rule:** NEVER sync data from TanStack Query into Zustand. If components need server data, they must call `useQuery` directly. TanStack Query's cache _is_ the state.
- **The Retry Authority Rule:** `lib/query-client.ts` (TanStack Query config) is the SINGLE authority for all API retries. Do NOT write `try/catch` retry loops inside component functions or API fetchers (`lib/api-client.ts`).

### Testing Rules

#### The CI Coverage Gates

- **The AI Quality Gate:** AI agents MUST write tests for all new lines of code. Tests are reviewed for _assertion quality_ (testing actual logic), not just coverage padding.
- **Coverage Blocks:** PRs will be blocked if overall coverage drops below 60%, new code below 80%, domain layer below 90%, or service layer below 80%. Critical E2E paths must 100% pass.

#### Go Testing (Backend)

- **The "No DB Mocks" Rule:** NEVER use `sqlmock` or mock the `pgx` interfaces. All repository tests MUST use Testcontainers (or a local test DB) to execute against a real PostgreSQL 18 instance. Mocks hide SQL syntax errors.
- **The Test Double Rule:** All external adapters (AI providers, platform APIs, payment gateways) MUST have an in-memory test double implementing the same domain interface. Do not use generic mocking libraries like `gomock` for this; write explicit test double structs.
- **The Table-Driven Assertion Rule:** All Go unit tests must use the table-driven test pattern (`[]struct{ name, input, expected }`). Use `github.com/stretchr/testify/assert` and `require` for all test assertions instead of manual `if err != nil { t.Fatal(err) }` checks.
- **The Tenant Isolation Suite:** When modifying `internal/domain` or `internal/adapter/postgres`, you MUST run the `test/isolation/` suite to prove your changes don't leak data between `TenantID`s.

#### TypeScript Testing (Frontend)

- **The Network Mocking Rule:** NEVER mock `fetch` globally or mock TanStack Query hooks directly (e.g., `vi.mock('useQuery')`). You MUST use MSW (Mock Service Worker) to intercept network requests at the HTTP level. This tests the _actual_ TanStack query configuration.
- **The Behavior-Driven DOM Rule:** When using React Testing Library, NEVER query by DOM structure (e.g., `querySelector('.my-class')`). You MUST use explicit accessibility queries: `getByRole`, `getByLabelText`, or `getByText`.
- **The Frontend Test Runner Rule:** Front-end unit and component tests run with Jest + React Testing Library; end-to-end tests run with Playwright. Keep browser-like test environments configured (`jsdom`) for DOM-based Jest suites.

### Code Quality & Style Rules

#### Linting & Enforcement

- **Complexity Boundaries:** Functions must be ≤50 lines, and files ≤500 lines. Excessive length must be refactored into smaller, focused helpers. Cyclomatic complexity is capped at 15.
- **Documentation Requirement:** All exported Go functions and structs MUST have godoc comments (enforced by `revive`).
- **Go Clean Architecture Linting:** The backend strictly uses `go-arch-lint`. Code that fails architectural boundary checks (e.g., a Handler importing a Repository) MUST be redesigned. You cannot bypass this linter.
- **Frontend Zustand Isolation:** There is a custom ESLint rule that strictly prevents importing `lib/api-client` directly into Zustand stores. You MUST trigger API calls from components via TanStack Query, never from Zustand actions.

#### The Naming Conventions Matrix

AI Agents MUST strictly adhere to this exact naming boundary map when tracking a field across the stack:

- **Database (PostgreSQL):** `snake_case` (e.g., `brand_voice_maturity`)
- **Backend Protocol (Go Structs):** `PascalCase` (e.g., `BrandVoiceMaturity`)
- **Network Data (JSON/API):** `snake_case` (e.g., `brand_voice_maturity`)
- **Network Routes (URLs):** `kebab-case` (e.g., `/api/v1/brand-voice`)
- **Frontend Components (React):** `PascalCase` (e.g., `BrandVoiceConfig.tsx`)

#### File & Component Organization

- **The "One Component Per File" Rule:** Do not write multiple React components in a single file unless they are strictly private sub-components of less than 20 lines. Split large files.
- **The "Index.ts Barrel" Rule:** Do not use `index.ts` files to re-export modules ("barrel files"). They break Next.js tree-shaking and cause circular dependencies. Import directly from the specific file: `import { Button } from '@/components/ui/button'`.
- **The "Magic String" Ban:** Never hardcode configuration values, API URLs, or route paths as strings in the code. Extract them to clearly named constants at the top of the file or in a centralized `constants.ts`/`config.go`.

#### Standardized Error Formatting

- **RFC 7807 Problem Details:** The backend must return errors formatted exactly to RFC 7807 (type, title, status, detail, instance). Custom JSON error envelopes like `{ "error": "message" }` are strictly forbidden.

### Development Workflow Rules

#### Git & Repository Rules

- **Main + Develop Flow:** Use short-lived feature branches branching off `develop`; merge release branches into `main` and back-merge to `develop`.
- **Branch Naming:** Format: `type/feature-name` (e.g., `feature/ai-drafts`, `fix/tenant-isolation`, `chore/deps`).
- **Commit Messages:** Use Conventional Commits (e.g., `feat: add deepseek model routing`).

#### The "Trust But Verify" CI Pipeline

AI Agents MUST NOT assume their code is correct just because they wrote it. You MUST verify your code against these tools before considering a task complete:

1. **`golangci-lint run`:** Run this locally to catch Go syntax and style errors.
2. **`go-arch-lint check`:** Run this locally. It is the absolute authority on Clean Architecture. If it fails, your imports are wrong and must be refactored.
3. **`npm run lint` & TypeScript `tsc --noEmit`:** Run this to guarantee you haven't broken the Next.js/React build rules or introduced `any` types.
4. **Test Suites:** Run `go test ./...` and `npm run test` to guarantee test coverage.

#### Definition of Done (DoD)

An AI Agent has NOT completed a feature until all of these are true:

- 🚫 No `// TODO`, `// FIXME`, or placeholder implementations exist in the generated code.
- 🗄️ Database schema changes (if any) are written as proper `golang-migrate` up/down files, and `sqlc generate` has been successfully re-run.
- 🔒 The `test/isolation/` suite passes, proving the new feature does not leak data across `TenantID` boundaries.
- 🧪 A Test Double exists for any newly introduced external API adapter.
- 🔑 **No Hardcoded Secrets:** Code contains absolutely zero hardcoded API keys or credentials.

#### The AI Agent Debugging Chain

When diagnosing CI failures or runtime errors, you MUST stop guessing and use the full context stack:

1. **GitHub MCP:** Read the exact CI failure output and PR review feedback before writing fixes.
2. **Sentry (API/Web):** Find the exact stack trace and user breadcrumbs for crashes.
3. **OpenTelemetry / SigNoz:** Trace the request across boundaries (Next.js → Go → Postgres).
4. **Zap Logs:** Search structured logs by `trace_id` or `tenant_id` to understand the exact state before failure.

### Critical Don't-Miss Rules

#### The Architecture Boundaries

1. **The Tenant ID Safety Boundary:** Every database schema table MUST have a `tenant_id` column. Every read/write query MUST explicitly filter by `tenant_id` pulled from the context. Rely on PostgreSQL Row-Level Security (RLS) as the final safety net.
2. **The AI Privacy Proxy Boundary:** AI Agents MUST never send raw inputs to external AI providers. All data must pass through `service/ai/privacy_proxy.go` to be aggressively stripped of PII before transmission.
3. **The Event Envelope Pattern:** EVERY event published to Redis MUST use the standard `EventEnvelope` struct (`{ event_id, tenant_id, type, payload, timestamp }`). The `event_id` is critical for ensuring consumers can process idempotently and safely retry.
4. **The "No Direct DB in Handlers" Boundary:** Handlers may only call Interfaces defined in `domain/`. The `service/` layer implements the business logic by calling the repository.

### Rules for AI MCP Tooling

#### Browser/Playwright Automation Rules

- **Behavior OVER Pixels:** When using Playwright to verify Next.js UI features or write E2E tests, AI agents MUST NEVER assert on exact DOM structures, element classes (e.g., Tailwind classes), or pixel dimensions. You MUST query by accessibility roles (`getByRole`, `getByLabel`).
- **The "Wait for TanStack" Rule:** Before asserting that data is loaded in a Playwright session, the AI MUST explicitly await the resolution of TanStack Query suspense boundaries or loading skeletons. Do not use generic `sleep()` or timeout waits.
- **The Localhost Execution Rule:** AI agents should only run Playwright sessions against the local hot-reloaded Next.js dev server (`npm run dev`), never against remote staging environments unless explicitly instructed.
- **The Lovable Design Reference Rule:** If provided with a Lovable visual design (screenshots or React code), re-implement the UI using our strictly defined stack (React 19 + shadcn/ui + Tailwind CSS 4 + CSS custom properties/tokens). DO NOT blindly copy Lovable's raw source code components. Use Playwright MCP screenshots to compare your local Next.js implementation against the design reference for visual parity.

#### GitHub Automation Rules

- **The "Never Push to Main" Rule:** AI agents using the GitHub MCP MUST NEVER push code directly to the `main` branch. All work must be pushed to a `feature/*`, `fix/*`, or `chore/*` branch.
- **The "Link the Issue" Rule:** When creating a Pull Request via GitHub MCP, the AI MUST link the PR to the relevant Epic story or issue ID from the project planning artifacts.
- **The "Self-Review Before PR" Rule:** Before opening a PR via the GitHub MCP, the AI agent MUST run the full CI Pipeline (`golangci-lint`, `go-arch-lint`, Go tests, Jest unit/component tests, Playwright E2E where applicable) locally. Do not rely on GitHub Actions to catch basic compilation or linting errors.

---

## Usage Guidelines

##### For AI Agents

- Read this file before implementing any code
- Follow ALL rules exactly as documented
- Treat all `must`, `never`, `every`, `only`, `do not`,`all`, `only`, and `mandatory` statements as hard constraints.
- When in doubt, prefer the more restrictive option
- Update this file if new patterns emerge

##### For Humans

- Keep this file lean and focused on agent needs
- Update when technology stack changes
- Review quarterly for outdated rules
- Remove rules that become obvious over time

Last Updated: 2026-02-22
