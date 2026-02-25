# Stories

### Track P1 (Prerequisite Enabler, Formerly Epic 1): DevOps Foundation & Infrastructure

#### Story 1.1: GitHub Repository & Branching Strategy
As a **developer or AI agent**,
I want a properly configured GitHub repository with branch protection, naming conventions, and issue templates,
So that all contributors follow consistent workflows and code quality is enforced from day one.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the repository does not yet exist
- **When** the repository is created on GitHub
- **Then** it has a `main` branch and a `develop` branch
- **And** `main` has branch protection requiring: PR review, passing CI, no direct pushes
- **And** `develop` has branch protection requiring: passing CI, no direct pushes
- **And** branch naming convention is documented: `feature/*`, `fix/*`, `chore/*`
- **And** the repository has labels for: `epic:1` through `epic:13`, `bug`, `feature`, `chore`, `priority:p0`, `priority:p1`, `priority:p2`
- **And** issue templates exist for: bug report, feature request, story implementation
- **And** a PR template exists with checklist items for: tests passing, lint clean, coverage maintained, story linked
- **And** Conventional Commits format (`feat:`, `fix:`, `chore:`) is documented in CONTRIBUTING.md
- **And** the repository description and README include project name (MarketBoss) and brief overview
- **And** initial project setup uses the approved starter baseline: custom Go Clean Architecture backend layout plus `create-next-app` frontend scaffold
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

#### Story 1.2: Monorepo Directory Structure & Makefile
As a **developer or AI agent**,
I want the complete monorepo directory skeleton with a root Makefile, environment template, and gitignore,
So that I can immediately begin adding code to the correct locations with standard development commands available.
**Depends on:** 1.1
**Acceptance Criteria:**
- **Given** the GitHub repository exists with branch protection (Story 1.1)
- **When** the monorepo structure is created
- **Then** the following top-level directories exist: `backend/`, `frontend/`, `infra/`, `docs/`, `api/`, `.github/`
- **And** `infra/` is reserved for deployment/IaC artifacts for future deployment stories (placeholder allowed in Story 1.2)
- **And** concrete `infra/` filenames are deferred to Story 1.7; Story 1.2 only requires `infra/.gitkeep`
- **And** `backend/` contains placeholder directories: `cmd/server/`, `internal/domain/`, `internal/service/`, `internal/adapter/`, `internal/handler/`, `migrations/`
- **And** `frontend/` contains a placeholder `README.md` (scaffolded in Track P3)
- **And** `api/` contains a placeholder `openapi.yaml` with info section only
- **And** `backend/docs/events/` directory exists for the event schema registry
- **And** local development compose files remain at repo root (`docker-compose.yml`, `docker-compose.test.yml`)
- **And** a root `Makefile` exists with targets: `dev`, `test`, `lint`, `build`, `help`, `db-migrate-up`, `db-migrate-down`, `sqlc-generate`
- **And** `make help` prints all available targets with descriptions
- **And** a `.env.example` file exists with all required environment variables (database URL, Redis URL, JWT secrets placeholder, API keys placeholder) with safe defaults for local dev
- **And** `.gitignore` covers Go binaries, `node_modules/`, `.env`, `.next/`, IDE files, OS files
- **And** all `make` targets that depend on Docker or services print helpful errors if dependencies are missing
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

#### Story 1.3: Docker Compose Local Development Environment
As a **developer or AI agent**,
I want a Docker Compose configuration that starts PostgreSQL 18 and Redis 7.4 with a single command,
So that I can develop and test locally without installing database software on my machine.
**Depends on:** 1.2
**Acceptance Criteria:**
- **Given** the monorepo directory structure exists (Story 1.2)
- **When** `make dev` is run (or `docker compose up -d`)
- **Then** PostgreSQL 18 starts on port 5432 with a `marketboss_dev` database created
- **And** Redis 7.4+ starts on port 6379 with persistence enabled
- **And** PostgreSQL has a health check that verifies the database is accepting connections
- **And** Redis has a health check using `redis-cli ping`
- **And** data is persisted across container restarts via named volumes
- **And** a `docker-compose.test.yml` override exists for CI (ephemeral, no volumes, randomized ports)
- **And** the PostgreSQL container initializes with a `create_extensions.sql` script enabling `uuid-ossp` and `pgcrypto`
- **And** running `make dev` a second time is idempotent (does not error or recreate data)
- **And** `make dev-down` stops and removes containers (but preserves volumes)
- **And** `make dev-reset` stops containers and removes volumes for a clean slate
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

#### Story 1.4: Backend CI Pipeline (GitHub Actions)
As a **developer or AI agent**,
I want an automated backend CI pipeline that runs on every PR touching Go code,
So that code quality, architectural boundaries, and test coverage are verified before merge.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a pull request is opened or updated with changes in the `backend/` directory
- **When** the `backend-ci.yml` GitHub Actions workflow triggers
- **Then** the workflow runs on `ubuntu-latest` with Go 1.26
- **And** it starts PostgreSQL 18 and Redis 7.4 as service containers for integration tests
- **And** it runs `golangci-lint run./...` and fails the PR if lint errors are found
- **And** it runs `go-arch-lint check` and fails the PR if Clean Architecture boundary violations are detected
- **And** it runs `go test./... -race -coverprofile=coverage.out` and reports coverage
- **And** the workflow fails if overall coverage drops below 60%
- **And** it runs `sqlc diff` to verify generated code matches SQL definitions
- **And** the workflow uses path-based triggers (`paths: ['backend/**', 'api/**']`) so frontend-only changes do not trigger it
- **And** the workflow caches Go modules and build artifacts for faster subsequent runs
- **And** workflow results are posted as PR check statuses
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

#### Story 1.5: Frontend CI Pipeline (GitHub Actions)
As a **developer or AI agent**,
I want an automated frontend CI pipeline that runs on every PR touching frontend code,
So that TypeScript correctness, lint rules, component tests, and E2E tests are verified before merge.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a pull request is opened or updated with changes in the `frontend/` directory
- **When** the `frontend-ci.yml` GitHub Actions workflow triggers
- **Then** the workflow runs on `ubuntu-latest` with Node.js 24.x
- **And** it installs dependencies using `npm ci` (lockfile-exact)
- **And** it runs `npx tsc --noEmit` and fails the PR if TypeScript errors are found
- **And** it runs `npm run lint` and fails the PR if ESLint errors are found
- **And** it runs `npm run test` (Jest unit/component tests) and reports coverage
- **And** it runs Playwright E2E tests (placeholder suite — at least one health-check test)
- **And** the workflow fails if overall frontend coverage drops below 60%
- **And** the workflow uses path-based triggers (`paths: ['frontend/**']`) so backend-only changes do not trigger it
- **And** the workflow caches `node_modules/` and `.next/cache` for faster subsequent runs
- **And** workflow results are posted as PR check statuses
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

#### Story 1.6: Security Scanning Pipeline
As a **developer or AI agent**,
I want automated security scanning that runs on every PR and blocks merge when vulnerabilities are found,
So that secrets, vulnerable dependencies, and unsafe code patterns are caught before reaching the codebase.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a pull request is opened or updated
- **When** the `security-scan.yml` GitHub Actions workflow triggers
- **Then** Semgrep runs SAST analysis on both Go and TypeScript code and blocks the PR on findings
- **And** TruffleHog scans the diff for hardcoded secrets (API keys, tokens, passwords) and blocks the PR on findings
- **And** Trivy scans the Docker images defined in `docker-compose.yml` for known CVEs and blocks the PR on HIGH/CRITICAL findings
- **And** Dependabot is configured with a `dependabot.yml` that monitors both `go.mod` and `package.json` for dependency updates
- **And** Dependabot security alerts are enabled on the repository
- **And** the no-bloat tool rule is documented: no new scanner may be added without explicit justification for a missing capability
- **And** all four scanners (Semgrep, TruffleHog, Trivy, Dependabot) are PR-blocking as required by the MVP Tooling Profile
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

#### Story 1.7: Deployment Pipeline Foundation
As a **developer or AI agent**,
I want deployment pipelines for staging and production environments with a nightly OWASP ZAP security scan,
So that validated code can be automatically deployed and runtime security is continuously monitored.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the CI pipelines are in place (Stories 1.4, 1.5, 1.6)
- **When** the `deploy-staging.yml` workflow is configured
- **Then** it triggers on push to the `develop` branch (after PR merge)
- **And** it builds Docker images for backend and frontend
- **And** it deploys to DigitalOcean App Platform staging environment
- **And** it runs a post-deployment health check (`/healthz` endpoint returns 200)
- **Given** the staging pipeline works
- **When** the `deploy-production.yml` workflow is configured
- **Then** it triggers on push to the `main` branch (after release merge)
- **And** it builds production Docker images with production environment variables
- **And** it deploys to DigitalOcean App Platform production environment
- **And** it runs a post-deployment health check and smoke test
- **And** deployment workflows remain in `.github/workflows/`; any deployment manifests/scripts they use live under `infra/`
- **Given** deployment pipelines exist
- **When** the `security-nightly.yml` workflow is configured
- **Then** OWASP ZAP runs nightly against the staging environment URL
- **And** ZAP results are saved as artifacts and do NOT block PRs (per MVP Tooling Profile)
- **And** ZAP failures are reported via GitHub issue creation (not PR blocking)
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-I1]; ADR=[ADR-2c, ADR-3b]; AR=[None]; ENB=[ENB-E1]
**FRs covered:** None (Foundational/Additional)
---

### Track P2 (Prerequisite Enabler, Formerly Epic 2): Backend Scaffolding & Data Foundation

#### Story 2.1: Go Project Layout & Module Init
As a **developer or AI agent**,
I want the Go backend project initialized with Clean Architecture directory structure and a minimal HTTP server,
So that I have a working, runnable backend with the correct architectural boundaries from the start.
**Depends on:** 1.2
**Acceptance Criteria:**
- **Given** the monorepo directory structure exists (Track P1)
- **When** the Go module is initialized in `backend/`
- **Then** `go.mod` exists with module name `github.com/{org}/marketboss/backend` and Go 1.26
- **And** `cmd/server/main.go` starts an `net/http` server on a configurable port (default 8080)
- **And** the server responds to `GET /healthz` with `200 OK` and JSON body `{"status": "ok"}`
- **And** `internal/domain/` contains a `.gitkeep` or example domain entity placeholder
- **And** `internal/service/` contains a `.gitkeep` or example service placeholder
- **And** `internal/adapter/` contains sub-directories: `postgres/`, `redis/`, `ai/`, `social/`, `payment/`
- **And** `internal/handler/` contains the health handler wired to the router
- **And** the server reads configuration from environment variables (with `.env` fallback via a config loader)
- **And** `go build./...` succeeds with zero warnings
- **And** `go vet./...` passes cleanly
- **And** the server uses ONLY `net/http` for routing — no third-party HTTP frameworks
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.2: Database Connection Pool & Tenant Context
As a **developer or AI agent**,
I want a PostgreSQL connection pool with tenant context injection,
So that every database query is automatically scoped to the correct tenant via Row-Level Security.
**Depends on:** 1.3, 2.1
**Acceptance Criteria:**
- **Given** the Go server starts (Story 2.1) and PostgreSQL is running (Track P1, Story 1.3)
- **When** the pgx/v5 connection pool is configured
- **Then** the pool connects to PostgreSQL using the `DATABASE_URL` environment variable
- **And** the pool has an `AfterRelease` hook that executes `RESET ALL` on every connection return
- **And** a `TenantContext` middleware extracts `tenant_id` from the JWT claims and stores it in `context.Context`
- **And** a `WithTenant(ctx, pool)` helper acquires a connection and executes `SET app.tenant_id = $1` before returning
- **And** all database operations fail with a clear error if `tenant_id` is missing from context
- **And** the pool configuration uses sensible defaults: `MaxConns=25`, `MinConns=5`, `MaxConnLifetime=1h`
- **And** the `/healthz` endpoint now includes a database connectivity check (pool.Ping)
- **And** connection pool metrics are exposed via a `/readyz` response field
- **And** a unit test verifies that `RESET ALL` is called after connection release
- **And** a unit test verifies that queries fail without tenant context
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.3: Migration Tooling & Base Schema
As a **developer or AI agent**,
I want database migration tooling with the foundational schema (tenants, users) and RLS policies,
So that the database schema is version-controlled and tenant isolation is enforced at the database level.
**Depends on:** 2.2
**Acceptance Criteria:**
- **Given** the database connection pool is functional (Story 2.2)
- **When** golang-migrate is configured in `backend/migrations/`
- **Then** `make db-migrate-up` applies all pending migrations to the database
- **And** `make db-migrate-down` rolls back the last migration
- **And** migration files follow the `YYYYMMDDHHMMSS_description.up.sql` / `YYYYMMDDHHMMSS_description.down.sql` naming convention
- **And** the first migration (`20260224120000_base_schema`) creates:
  - `tenants` table: `id` (UUIDv7 PK), `name`, `slug` (unique), `status`, `created_at`, `updated_at`
  - `users` table: `id` (UUIDv7 PK), `tenant_id` (FK → tenants), `email` (unique per tenant), `phone`, `password_hash`, `role`, `status`, `created_at`, `updated_at`
  - `sessions` table: `id` (UUIDv7 PK), `user_id` (FK → users), `tenant_id`, `token_hash`, `device_info`, `ip_address`, `expires_at`, `created_at`
- **And** RLS policies are enabled on `users` and `sessions` tables: `USING (tenant_id = current_setting('app.tenant_id')::uuid)`
- **And** RLS is enforced for all roles except the migration user
- **And** indexes exist on: `users(tenant_id, email)`, `sessions(token_hash)`, `sessions(user_id)`
- **And** all `id` columns use UUIDv7 (generated via `gen_random_uuid` with application-level UUIDv7 override)
- **And** running migrations is idempotent (re-running does not error)
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.4: sqlc Configuration & Initial Queries
As a **developer or AI agent**,
I want sqlc configured to generate type-safe Go code from SQL queries,
So that all database access is type-safe, compile-time verified, and follows the "no ORM" rule.
**Depends on:** 2.3
**Acceptance Criteria:**
- **Given** the base schema migration has been applied (Story 2.3)
- **When** sqlc is configured with `sqlc.yaml`
- **Then** `sqlc.yaml` specifies: Go as the language, `pgx/v5` as the SQL driver, `internal/adapter/postgres/sqlc` as the output directory
- **And** query files exist in `backend/queries/`: `tenants.sql`, `users.sql`, `sessions.sql`
- **And** `tenants.sql` contains at minimum: `CreateTenant`, `GetTenantByID`, `GetTenantBySlug`
- **And** `users.sql` contains at minimum: `CreateUser`, `GetUserByEmail`, `GetUserByID`, `ListUsersByTenant`
- **And** `sessions.sql` contains at minimum: `CreateSession`, `GetSessionByTokenHash`, `DeleteSession`, `DeleteUserSessions`
- **And** `make sqlc-generate` (or `sqlc generate`) produces Go structs and methods matching the queries
- **And** `sqlc diff` runs in CI and reports if generated code is out of sync with queries
- **And** generated code compiles without errors
- **And** all queries implicitly benefit from RLS (no explicit `WHERE tenant_id =` needed in queries)
- **And** a brief integration test verifies at least one query (e.g., `CreateTenant` → `GetTenantByID`)
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.5: Redis Client & Infrastructure
As a **developer or AI agent**,
I want a Redis client with cache-aside helpers, rate limiter scaffold, and tenant-scoped key namespacing,
So that caching, rate limiting, and real-time features have a reliable shared infrastructure from the start.
**Depends on:** 1.3
**Acceptance Criteria:**
- **Given** the Go server starts and Redis is running (Track P1, Story 1.3)
- **When** the Redis client is initialized
- **Then** it connects using the `REDIS_URL` environment variable
- **And** all cache keys are namespaced by tenant: `tenant:{tenant_id}:{feature}:{key}`
- **And** a `CacheAside` helper exists: checks cache → returns if hit → calls loader function → caches result → returns
- **And** the `CacheAside` helper accepts a configurable TTL per call site
- **And** a `RateLimiter` scaffold exists using the sliding window algorithm with configurable limits per key
- **And** the rate limiter fails open (allows requests) when Redis is unavailable, as specified in the Architecture
- **And** Redis Streams setup exists with at least one tenant-scoped stream name pattern: `stream:tenant:{tenant_id}:{event_type}`
- **And** the `/healthz` endpoint includes a Redis connectivity check
- **And** a unit test verifies cache-aside behavior (cache miss → load → cache hit)
- **And** a unit test verifies rate limiter fails open when Redis is down
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.6: OpenAPI Spec & Code Generation
As a **developer or AI agent**,
I want the OpenAPI 3.1 specification foundation with generated server stubs and shared types,
So that the API contract is defined first and both backend and frontend consume consistent type definitions.
**Depends on:** 2.1
**Acceptance Criteria:**
- **Given** the Go server is running with health endpoints (Story 2.1)
- **When** the OpenAPI spec is authored in `api/openapi.yaml`
- **Then** the spec is valid OpenAPI 3.1 with proper `info`, `servers`, `security` (Bearer JWT), and `paths` sections
- **And** the spec defines at minimum: `/healthz` (GET), `/readyz` (GET), `/api/v1/auth/register` (POST), `/api/v1/auth/login` (POST) as placeholder paths
- **And** error responses use RFC 7807 Problem Details schema (`type`, `title`, `status`, `detail`, `instance`)
- **And** `oapi-codegen` is configured to generate Go server interfaces and types from the spec
- **And** `make api-generate` (or equivalent) runs oapi-codegen and produces output in `internal/handler/generated/`
- **And** the generated server interface is implemented by the handler layer
- **And** a CI step validates the OpenAPI spec on each PR (`npx @redocly/cli lint api/openapi.yaml`)
- **And** `api/` also contains an `openapi-typescript` config for frontend type generation (used in Track P3)
- **And** the spec includes common response schemas: `PaginatedResponse`, `ErrorResponse` (RFC 7807)
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.7: Structured Logging & Observability
As a **developer or AI agent**,
I want structured logging, distributed tracing, and error tracking integrated into the backend,
So that application behavior is observable, debuggable, and errors are captured with full context in all environments.
**Depends on:** 2.1
**Acceptance Criteria:**
- **Given** the Go server is running (Story 2.1)
- **When** observability is integrated
- **Then** Zap is configured as the structured logger with JSON format in production and console format in development
- **And** every log entry includes: `timestamp`, `level`, `message`, `request_id`, `tenant_id` (if available), `user_id` (if available)
- **And** an HTTP middleware injects a `request_id` (UUIDv4) into every request's context and response headers (`X-Request-ID`)
- **And** OpenTelemetry is initialized with an OTLP exporter configured via `OTEL_EXPORTER_OTLP_ENDPOINT` environment variable
- **And** an OTel HTTP middleware creates a span for every incoming request with attributes: `http.method`, `http.route`, `http.status_code`, `tenant.id`
- **And** Sentry is initialized with `SENTRY_DSN` environment variable and captures unhandled panics
- **And** Sentry breadcrumbs are attached for key operations (DB queries, Redis operations, external API calls)
- **And** log levels are configurable via `LOG_LEVEL` environment variable (debug, info, warn, error)
- **And** a test verifies that request_id propagates through the middleware chain
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

#### Story 2.8: Error Handling & Middleware Stack
As a **developer or AI agent**,
I want a standardized RFC 7807 error response format and a properly ordered middleware chain,
So that all API errors are consistent, the server is resilient to panics, and cross-cutting concerns are handled uniformly.
**Depends on:** 2.7
**Acceptance Criteria:**
- **Given** logging and observability are in place (Story 2.7)
- **When** the error handling and middleware system is implemented
- **Then** an `AppError` type exists with fields: `Type` (URI), `Title`, `Status` (HTTP code), `Detail`, `Instance`, `Extensions` (map)
- **And** an `ErrorResponder` helper serializes `AppError` to JSON matching RFC 7807 format with `Content-Type: application/problem+json`
- **And** common error constructors exist: `NotFound`, `BadRequest`, `Unauthorized`, `Forbidden`, `InternalError`, `Conflict`, `TooManyRequests`
- **And** a recovery middleware catches panics, logs the stack trace, reports to Sentry, and returns a 500 RFC 7807 response
- **And** a CORS middleware is configured with allowed origins from environment variable, supporting credentials
- **And** a request-logging middleware logs: method, path, status code, duration, request_id for every request
- **And** the middleware chain is ordered: Recovery → RequestID → Logging → CORS → OTel → TenantContext → [route handlers]
- **And** all middleware and error handlers have unit tests
- **And** the server compiles and all existing tests pass with the new middleware chain wired in
**Traceability:** FR=[None]; NFR=[NFR-S3, NFR-I1]; ADR=[ADR-1a, ADR-1b]; AR=[None]; ENB=[ENB-E2]
**FRs covered:** None (Foundational/Additional)
---

### Track P3 (Prerequisite Enabler, Formerly Epic 3): Frontend Scaffolding & Design System

#### Story 3.1: Next.js Project Initialization
As a **developer or AI agent**,
I want the Next.js 16 frontend project initialized with App Router, TypeScript, and Tailwind CSS 4,
So that I have a working, runnable frontend with the correct project structure from the start.
**Depends on:** 1.2
**Acceptance Criteria:**
- **Given** the monorepo directory structure exists (Track P1)
- **When** the Next.js project is created in `frontend/` using `create-next-app`
- **Then** the project uses Next.js 16 with TypeScript strict mode enabled
- **And** App Router is configured (not Pages Router)
- **And** the `src/` directory structure is used: `src/app/`, `src/components/`, `src/lib/`, `src/hooks/`, `src/stores/`, `src/types/`
- **And** Tailwind CSS 4 is configured with the default preset
- **And** Turbopack is enabled for development (`next dev --turbopack`)
- **And** the root layout (`src/app/layout.tsx`) includes: HTML lang="en", proper metadata (title: "MarketBoss", description), viewport meta for mobile
- **And** Google Fonts Inter is loaded as the primary font via `next/font/google`
- **And** a basic health page exists at `/` that renders "MarketBoss" as a heading
- **And** `npm run dev` starts the dev server without errors
- **And** `npm run build` produces a production build without errors
**And** `npx tsc --noEmit` passes with zero TypeScript errors
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.2: Design System Tokens & Global Styles
As a **developer or AI agent**,
I want CSS custom properties defining the complete design system (colors, typography, spacing) from the UX specification,
So that all components use consistent, themeable design tokens instead of hardcoded values.
**Depends on:** 3.1
**Acceptance Criteria:**
- **Given** the Next.js project is initialized (Story 3.1)
- **When** the design system tokens are defined in `src/app/globals.css`
- **Then** CSS custom properties exist for the full color palette from the UX spec (primary, secondary, accent, semantic: success/warning/error/info, neutral scale)
- **And** dark mode variants are defined using `@media (prefers-color-scheme: dark)` and a `.dark` class toggle
- **And** typography scale tokens exist: `--font-xs` through `--font-3xl` with corresponding line heights
- **And** spacing scale tokens exist: `--space-1` through `--space-16` following a 4px base grid
- **And** border radius tokens exist: `--radius-sm`, `--radius-md`, `--radius-lg`, `--radius-full`
- **And** shadow tokens exist: `--shadow-sm`, `--shadow-md`, `--shadow-lg`
- **And** animation tokens exist: `--duration-fast` (150ms), `--duration-normal` (300ms), `--duration-slow` (500ms)
- **And** the Tailwind config extends with these custom properties so `bg-primary`, `text-secondary` etc. work
- **And** a `prefers-reduced-motion` media query disables animations globally when the user prefers reduced motion
- **And** all token values are documented with inline CSS comments
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.3: shadcn/ui & Component Library Setup
As a **developer or AI agent**,
I want shadcn/ui initialized with Radix Primitives and foundational components configured to use our design tokens,
So that I have accessible, themeable base components ready for feature development.
**Depends on:** 3.2
**Acceptance Criteria:**
- **Given** design system tokens are defined (Story 3.2)
- **When** shadcn/ui is initialized in the project
- **Then** `components.json` is configured with the project's styling approach (CSS variables, Tailwind)
- **And** Radix UI Primitives are installed as peer dependencies
- **And** the following shadcn/ui components are installed: Button, Input, Label, Card, Dialog, Sheet (bottom sheet on mobile), Separator, Skeleton, Toast, Badge
- **And** all installed components use the project's CSS custom property tokens (not hardcoded colors)
- **And** the `Sheet` component is configured as the default mobile dialog pattern (bottom sheet, never centered modal)
- **And** each component lives in its own file under `src/components/ui/` (one component per file rule)
- **And** no barrel `index.ts` exports exist (no barrel exports rule)
- **And** a simple storybook-style test page at `/dev/components` renders all installed components for visual verification
- **And** all components meet 48×48px minimum touch target on mobile
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.4: State Management & Data Fetching
As a **developer or AI agent**,
I want Zustand for global state, TanStack Query for server state, and React Hook Form + Zod for form handling,
So that the frontend has a clear, consistent data management pattern from the start.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the Next.js project and component library are set up (Stories 3.1-3.3)
- **When** the state management layer is configured
- **Then** Zustand v5 is installed with a single store scaffold at `src/stores/app-store.ts`
- **And** the Zustand store includes initial slices: `auth` (user, isAuthenticated, token), `ui` (theme, sidebarOpen, toasts)
- **And** a custom ESLint rule warns when Zustand is imported outside of `src/stores/` or custom hooks
- **And** TanStack Query v5 is configured with a `QueryClientProvider` in the root layout
- **And** default query options are set: `staleTime: 5 * 60 * 1000`, `retry: 2`, `refetchOnWindowFocus: false`
- **And** a `src/lib/query-keys.ts` file defines a query key factory pattern for type-safe cache management
- **And** React Hook Form is installed with Zod resolver (`@hookform/resolvers/zod`)
- **And** a sample form schema exists at `src/lib/schemas/example.ts` demonstrating Zod + RHF integration
- **And** `useEffect` is NOT used for any data fetching (TanStack Query or Server Components only)
- **And** React Context is NOT used for global state (Zustand only)
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.5: API Client & Type Generation
As a **developer or AI agent**,
I want auto-generated TypeScript types from the OpenAPI spec and a BFF proxy route,
So that the frontend consumes type-safe API types without hardcoding backend URLs.
**Depends on:** 2.6
**Acceptance Criteria:**
- **Given** the OpenAPI spec exists in `api/openapi.yaml` (Track P2, Story 2.6)
- **When** the API client layer is set up
- **Then** `openapi-typescript` generates TypeScript types from the OpenAPI spec into `src/types/api.generated.ts`
- **And** a `make frontend-types` (or `npm run generate:types`) command regenerates types from the spec
- **And** a BFF proxy route exists at `src/app/api/v1/[...proxy]/route.ts` that forwards requests to the backend
- **And** the proxy reads the backend URL from `BACKEND_URL` environment variable (never hardcoded)
- **And** the proxy forwards cookies (httpOnly JWT) transparently
- **And** a typed fetch wrapper exists at `src/lib/api-client.ts` that: adds credentials, handles RFC 7807 errors, integrates with TanStack Query
- **And** the fetch wrapper returns typed responses using the generated OpenAPI types
- **And** no `axios` or `lodash` or other frozen dependencies are used (dependency freeze rule)
- **And** a unit test verifies the BFF proxy route forwards requests correctly
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.6: Shared UI Components
As a **developer or AI agent**,
I want shared utility components (loading, error, empty, offline, currency) built with the design system,
So that all feature pages have consistent feedback patterns for every application state.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the component library and design tokens are in place (Stories 3.2-3.3)
- **When** the shared components are created
- **Then** `LoadingSkeleton` exists with configurable `width`, `height`, `variant` (text, card, avatar, list-item) — uses shimmer animation, never spinner
- **And** `ErrorBoundary` exists as a React error boundary that catches render errors, reports to Sentry, and renders `ErrorState`
- **And** `ErrorState` renders an error message with a retry button, accepts `onRetry` callback
- **And** `EmptyState` renders an illustration placeholder, title, description, and optional action button
- **And** `OfflineBanner` detects `navigator.onLine` changes and shows/hides a persistent banner with "You're offline — changes will sync when you reconnect"
- **And** `CurrencyDisplay` formats amounts as Nigerian Naira (₦) with proper thousand separators and 2 decimal places
- **And** each component is in its own file under `src/components/shared/` (one component per file)
- **And** each component has a unit test verifying its primary rendering behavior
- **And** all components use design system tokens (no hardcoded colors, spacing, or fonts)
- **And** all components are accessible (proper ARIA attributes, keyboard navigable where interactive)
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.7: Service Worker & Offline Foundation
As a **developer or AI agent**,
I want a service worker configured for precaching and offline fallback,
So that the app loads reliably on slow Nigerian networks and provides graceful offline handling.
**Depends on:** 3.1
**Acceptance Criteria:**
- **Given** the Next.js project is running (Story 3.1)
- **When** @serwist/next is configured
- **Then** a service worker is registered and activated on production builds
- **And** the service worker precaches the app shell (HTML, CSS, JS bundles) using the Serwist default strategy
- **And** an offline fallback page is served when the user navigates while offline
- **And** the service worker uses a `NetworkFirst` strategy for API requests with a 30-second timeout (Nigerian network baseline)
- **And** the service worker uses a `CacheFirst` strategy for static assets (images, fonts)
- **And** the initial payload size (HTML + CSS + JS) is under 500KB as required by NFR-M5
- **And** subsequent navigation payloads are under 100KB as required by NFR-M5
- **And** the service worker does NOT run in development mode (to avoid caching issues during dev)
- **And** a Playwright test verifies the offline fallback page renders when network is severed
**Traceability:** FR=[None]; NFR=[NFR-M5]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

#### Story 3.8: Frontend Testing & Dev Tooling
As a **developer or AI agent**,
I want Jest, Playwright, ESLint, and MSW configured for comprehensive frontend testing,
So that component tests, E2E tests, and API mocks work reliably from the first feature story.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the frontend project is fully scaffolded (Stories 3.1-3.7)
- **When** testing and tooling are configured
- **Then** Jest is configured with `@testing-library/react` for component testing
- **And** Jest uses the `jsdom` environment and supports TypeScript via SWC transform
- **And** Playwright is configured with a `playwright.config.ts` targeting Chromium and Mobile Chrome viewports
- **And** Playwright has at least one passing test: navigates to `/` and verifies the page title contains "MarketBoss"
- **And** MSW (Mock Service Worker) is configured with a handler file at `src/mocks/handlers.ts` for network mocking
- **And** MSW handlers include a mock for `/healthz` and `/api/v1/auth/login` endpoints
- **And** MSW integrates with both Jest (via `setupServer`) and browser (via `setupWorker`)
- **And** ESLint is configured with: `@typescript-eslint`, `eslint-plugin-react`, `eslint-plugin-react-hooks`, Next.js recommended rules
- **And** A custom ESLint rule warns if `useEffect` is used for data fetching (prefer TanStack Query)
- **And** `npm run lint` passes with zero errors on the current codebase
- **And** `npm run test` passes with all component tests green
- **And** `npx playwright test` passes with the health check E2E test
**Traceability:** FR=[None]; NFR=[NFR-M1, NFR-M3]; ADR=[ADR-4a, ADR-4c]; AR=[None]; ENB=[ENB-E3]
**FRs covered:** None (Foundational/Additional)
---

### Epic 4: Authentication & Multi-Tenancy

#### Story 4.1: Registration & OTP Verification
As a **seller**,
I want to sign up using my email and phone number with OTP verification,
So that my identity is verified and I can access a secure account from the start.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a new user visits the registration page
- **When** they submit their email, phone number, and password
- **Then** the backend creates a pending user record with `status: pending_verification`
- **And** an OTP is sent to the provided email address
- **And** an OTP is sent to the provided phone number via SMS
- **And** OTPs expire after 10 minutes and are single-use
- **And** the user must verify at least the email OTP to activate their account
- **And** phone OTP verification is tracked but does not block activation
- **And** after successful email OTP verification, the user's status changes to `active`
- **And** the registration endpoint returns RFC 7807 errors for: duplicate email, invalid phone format, weak password
- **And** a new `tenants` record is automatically created for the seller (1:1 tenant per seller in MVP)
- **And** the user is associated with the new tenant as `role: owner`
- **And** the database migration for this story adds: `otp_verifications` table (user_id, code_hash, type, expires_at, verified_at) with RLS
- **And** passwords are hashed using bcrypt with cost factor 12
**Traceability:** FR=[FR1]; NFR=[NFR-S7, NFR-S9]; ADR=[ADR-2a, ADR-2b]; AR=[None]; ENB=[None]
**FRs covered:** FR1
---

#### Story 4.2: JWT Authentication & Login
As a **seller**,
I want to log in with my email and password and receive a secure JWT session,
So that I can authenticate to the platform without re-entering credentials on every request.
**Depends on:** 4.1
**Acceptance Criteria:**
- **Given** a seller has a verified account (Story 4.1)
- **When** they submit valid email and password to the login endpoint
- **Then** the backend validates credentials against the stored bcrypt hash
- **And** on success, it issues an RS256-signed access token (15-minute expiry) and refresh token (7-day expiry)
- **And** tokens are set as `httpOnly`, `Secure`, `SameSite=Strict` cookies with `__Host-` prefix
- **And** the access token payload includes: `user_id`, `tenant_id`, `role`, `exp`, `iat`
- **And** no tokens are ever returned in the JSON response body (cookies only)
- **And** a refresh endpoint exists that issues a new access token using a valid refresh token
- **And** refresh token rotation is implemented: each use invalidates the old refresh token and issues a new one
- **And** if a revoked refresh token is used, ALL sessions for that user are invalidated (replay attack protection)
- **And** the login endpoint returns RFC 7807 `401 Unauthorized` for invalid credentials without leaking whether the email exists
- **And** session timeout follows NFR-S7: seller sessions expire at 72 hours
**Traceability:** FR=[FR5]; NFR=[NFR-S7]; ADR=[ADR-2a, ADR-2b]; AR=[None]; ENB=[None]
**FRs covered:** FR5
---

#### Story 4.3: Tenant Provisioning & Isolation Testing
As a **platform operator**,
I want automated tenant provisioning on registration with a comprehensive isolation test suite,
So that I am confident no data leaks between tenant boundaries under any query pattern.
**Depends on:** 4.1
**Acceptance Criteria:**
- **Given** a user registers and a tenant is created (Story 4.1)
- **When** the tenant provisioning process completes
- **Then** the new tenant has a unique `slug` derived from a sanitized business name or a generated value
- **And** RLS policies on `users`, `sessions`, and `otp_verifications` tables are verified to restrict queries to the active tenant
- **And** a cross-tenant isolation test suite exists as Go integration tests that:
  - Creates two tenants (Tenant A, Tenant B) with one user each
  - Verifies Tenant A user queries return ONLY Tenant A data
  - Verifies Tenant B user queries return ONLY Tenant B data
  - Verifies that queries WITHOUT tenant context return zero rows (not leaked data)
  - Verifies that `INSERT` with mismatched tenant_id is rejected by RLS
- **And** the test suite runs automatically in CI (backend-ci pipeline)
- **And** any data-touching PR that fails the isolation test suite CANNOT merge
- **And** the test suite is documented as a mandatory requirement for all future stories that create tables
**Traceability:** FR=[None]; NFR=[NFR-S7, NFR-S9]; ADR=[ADR-2a, ADR-2b]; AR=[AR-TEN-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 4.4: Session Management
As a **seller**,
I want to view my active sessions and terminate any session remotely,
So that I can secure my account if I lose a device or notice suspicious access.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is logged in with one or more active sessions
- **When** they request the session list endpoint (`GET /api/v1/auth/sessions`)
- **Then** the response includes all active sessions for their user: session ID, device info (user-agent parsed), IP address, created_at, last_active_at
- **And** the current session is marked with `is_current: true`
- **Given** a seller has multiple active sessions
- **When** they terminate a specific session (`DELETE /api/v1/auth/sessions/{id}`)
- **Then** that session's refresh token is invalidated
- **And** any access token for that session becomes ineffective at next validation
- **And** the terminated session no longer appears in the session list
- **Given** a seller wants to secure their account
- **When** they terminate all sessions except the current one (`POST /api/v1/auth/sessions/revoke-all`)
- **Then** all other sessions are invalidated
- **And** only the current session remains active
- **And** frontend displays a session management page listing all active sessions with "Revoke" buttons
- **And** the current session shows a "Revoke All Others" action
**Traceability:** FR=[FR106]; NFR=[NFR-S7, NFR-S9]; ADR=[ADR-2a, ADR-2b]; AR=[None]; ENB=[None]
**FRs covered:** FR106
---

#### Story 4.5: Suspicious Activity Detection
As a **seller**,
I want to be alerted when my account is accessed from a new device or IP, or when unusual bulk data access occurs,
So that I can take immediate action if my account is compromised.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller logs in from a device or IP not seen in their last 10 sessions
- **When** the login completes successfully
- **Then** a `suspicious_activity` event is created with type: `new_device` or `new_ip`
- **And** a notification is dispatched to the seller via their preferred channel (default: email in MVP)
- **And** the notification includes: device info, IP address, timestamp, and a "Not you? Secure your account" link
- **Given** a seller's account performs an unusual number of API requests
- **When** the request count exceeds 100 requests/minute for data endpoints
- **Then** a `suspicious_activity` event is created with type: `bulk_data_access`
- **And** a notification is dispatched to the seller
- **And** the event is logged in the immutable audit log with all relevant context
- **Given** any suspicious activity event is created
- **When** the event is persisted
- **Then** it is stored in a `security_events` table (user_id, tenant_id, event_type, metadata JSONB, created_at) with RLS
- **And** the table has an immutable constraint (no UPDATE or DELETE allowed via application role)
- **And** security events are queryable through internal admin troubleshooting APIs
**Traceability:** FR=[FR107]; NFR=[NFR-S7, NFR-S9]; ADR=[ADR-2a, ADR-2b]; AR=[None]; ENB=[None]
**FRs covered:** FR107
---

#### Story 4.6: Frontend Auth Pages
As a **seller**,
I want polished login, registration, and OTP verification pages optimized for mobile,
So that I can create an account and sign in easily on my phone with a smooth, professional experience.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a user navigates to the login page
- **When** the page renders
- **Then** it displays email and password fields, a "Sign In" button, and a "Create Account" link
- **And** form validation uses Zod schema: email format, password minimum 8 characters
- **And** validation errors appear inline below each field (not as alert dialogs)
- **And** the form submits via TanStack Query mutation and shows a loading skeleton during submission
- **And** on error, the RFC 7807 error detail is displayed as a toast notification
- **And** on success, the user is redirected to the dashboard (or onboarding if incomplete)
- **Given** a user navigates to the registration page
- **When** the page renders
- **Then** it displays email, phone, password, and "confirm password" fields
- **And** Zod validation enforces: valid email, Nigerian phone format (+234), password strength, passwords match
- **And** on submission, the user is redirected to the OTP verification page
- **Given** a user is on the OTP verification page
- **When** the page renders
- **Then** it displays a 6-digit OTP input with auto-focus and auto-advance between digits
- **And** a "Resend OTP" button appears after 60-second countdown
- **And** OTP resend is rate-limited to 3 attempts per 10-minute window
- **And** all auth pages are mobile-first: single column layout, 48px touch targets, bottom-aligned CTAs
- **And** all pages work on 320px minimum viewport width
**Traceability:** FR=[None]; NFR=[NFR-S7, NFR-S9]; ADR=[ADR-2a, ADR-2b]; AR=[AR-AUTH-UX-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 4.7: Auth Rate Limiting & Security Hardening
As a **platform operator**,
I want rate limiting on authentication endpoints and brute force protection,
So that the platform is resilient to automated attacks and credential stuffing.
**Depends on:** 2.5
**Acceptance Criteria:**
- **Given** any client IP address
- **When** it exceeds 5 login attempts per minute
- **Then** subsequent requests receive `429 Too Many Requests` with RFC 7807 response
- **And** the response includes a `Retry-After` header indicating when to retry
- **And** rate limiting uses the Redis sliding window rate limiter (from Story 2.5)
- **Given** any client IP address
- **When** it exceeds 3 registration attempts per hour
- **Then** subsequent requests receive `429 Too Many Requests`
- **And** a security event is logged for potential automated registration abuse
- **Given** a user account
- **When** 5 consecutive failed login attempts are made
- **Then** the account is temporarily locked for 15 minutes
- **And** a notification is sent to the account owner about the lockout
- **And** the lockout counter resets after a successful login
- **Given** rate limiting is configured
- **When** Redis is unavailable
- **Then** rate limiting fails open (allows requests) per the Architecture's rate limiter fail-open rule
- **And** a warning is logged about rate limiter degradation
- **And** all rate-limiting rules are configurable via environment variables
- **And** rate limiting is tested in integration tests
**Traceability:** FR=[None]; NFR=[NFR-S7, NFR-S9]; ADR=[ADR-2a, ADR-2b]; AR=[AR-SEC-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

### Epic 5: Seller Onboarding & Business Profile

#### Story 5.1: Platform Selection & Onboarding Flow
As a **seller**,
I want to choose my primary social platform and see a clear onboarding progress tracker,
So that I know exactly what steps remain and can complete setup at my own pace.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has registered and logged in for the first time
- **When** they begin the onboarding flow
- **Then** they are presented with a platform selection screen: Instagram or WhatsApp (single selection for MVP)
- **And** their selection is persisted to a `seller_profiles` table (tenant_id, user_id, primary_platform, onboarding_status, onboarding_step, created_at, updated_at) with RLS
- **And** an onboarding progress tracker component shows all steps: Platform → Connect Account → Brand Voice → Business Profile → Category → First Post
- **And** each step shows status: completed ✓, current →, or locked 🔒
- **And** the seller can navigate back to previous completed steps to edit
- **And** the onboarding state machine tracks: `platform_selected`, `account_connected`, `brand_voice_trained`, `profile_completed`, `category_selected`, `first_post_created`
- **And** the onboarding flow is completable within 10 minutes (NFR-P11)
- **And** the flow uses bottom sheets on mobile (never centered modals) per UX spec
- **And** the database migration creates the `seller_profiles` table with appropriate indexes
- **And** cross-tenant isolation tests are extended to cover the new table
**Traceability:** FR=[FR2]; NFR=[NFR-P11]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR2
---

#### Story 5.2: Instagram Business API Connection
As a **seller**,
I want to connect my Instagram Business account to MarketBoss,
So that the platform can publish posts and access my account data on my behalf.
**Depends on:** 5.1
**Acceptance Criteria:**
- **Given** a seller selected Instagram as their primary platform (Story 5.1)
- **When** they initiate the Instagram connection flow
- **Then** the seller is redirected to Meta's OAuth consent screen with required permissions: `instagram_basic`, `instagram_content_publish`, `instagram_manage_insights`, `pages_show_list`
- **And** on successful authorization, the backend receives an authorization code and exchanges it for a long-lived access token (60-day expiry)
- **And** the access token is encrypted using AES-256 and stored in a `social_connections` table (tenant_id, platform, access_token_enc, refresh_token_enc, external_account_id, username, status, expires_at) with RLS
- **And** the token is NEVER exposed in API responses or logged (NFR-S2)
- **And** the backend implements an Instagram adapter following the adapter/provider pattern (NFR-I1)
- **And** the connection status is displayed on the onboarding flow and settings page: Connected (username), Disconnected, or Expired
- **And** a token refresh job is scheduled to proactively refresh tokens 7 days before expiry
- **And** the onboarding state machine advances to `account_connected` on successful connection
- **And** error states are handled: user denies permissions, token exchange fails, account is not a Business account
- **And** cross-tenant isolation tests are extended to cover `social_connections`
**Traceability:** FR=[FR9]; NFR=[NFR-I1, NFR-S2]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR9
---

#### Story 5.3: WhatsApp Business API Connection
As a **seller**,
I want to connect my WhatsApp Business account to MarketBoss,
So that the platform can send/receive messages and manage my catalog on my behalf.
**Depends on:** 5.1, 5.2
**Acceptance Criteria:**
- **Given** a seller selected WhatsApp as their primary platform (Story 5.1)
- **When** they initiate the WhatsApp connection flow
- **Then** the seller is guided through the WhatsApp Cloud API embedded signup flow
- **And** on successful connection, the backend stores: WhatsApp Business Account ID, phone number ID, and access token (encrypted AES-256)
- **And** the connection is stored in the same `social_connections` table (Story 5.2) with `platform: whatsapp`
- **And** the backend registers a webhook endpoint for incoming WhatsApp messages
- **And** the webhook endpoint validates the Meta webhook verification challenge
- **And** the webhook endpoint processes incoming messages with idempotency via `message_id` (Architecture: webhook idempotency)
- **And** the backend implements a WhatsApp adapter following the adapter/provider pattern (NFR-I1)
- **And** the connection status is displayed: Connected (phone number), Disconnected
- **And** the onboarding state machine advances to `account_connected` on successful connection
- **And** error states are handled: phone number already registered, API key invalid, business verification pending
- **And** cross-tenant isolation tests cover WhatsApp connection data
**Traceability:** FR=[FR10]; NFR=[NFR-I1]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR10
---

#### Story 5.4: Brand Voice Training
As a **seller**,
I want to train my Brand Voice by providing sample captions and content,
So that AI-generated content matches my unique communication style and tone.
**Depends on:** 5.2
**Acceptance Criteria:**
- **Given** a seller has connected their social account (Story 5.2 or 5.3)
- **When** they reach the Brand Voice training step
- **Then** the UI presents a clear explanation of what Brand Voice is and why 5+ inputs are needed
- **And** the seller can input content via: typing captions directly, pasting existing captions, or uploading voice notes (transcribed, stretch goal)
- **And** each input is stored in a `brand_voice_samples` table (tenant_id, user_id, content_text, source_type, created_at) with RLS
- **And** a counter shows progress: "3 of 5 minimum inputs provided"
- **And** the seller CANNOT proceed past onboarding if fewer than 5 inputs are provided
- **And** AI post generation is globally blocked for this seller until the 5-input threshold is met (FR8)
- **And** the onboarding state machine advances to `brand_voice_trained` only when sample_count >= 5
- **And** the training data feeds into the Brand Voice profile (consumed by Epic 6 for AI calibration)
- **And** previously submitted samples can be viewed and deleted (with re-count)
- **And** the UI is mobile-first with clear input areas and a "paste" button for quick mobile entry
- **And** cross-tenant isolation tests cover `brand_voice_samples`
**Traceability:** FR=[FR3, FR8]; NFR=[NFR-P11, NFR-S3]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR3, FR8
---

#### Story 5.5: Business Profile Form
As a **seller**,
I want to fill out a comprehensive Business Profile,
So that AI can generate accurate content and respond to buyer inquiries with my specific business information.
**Depends on:** 5.4
**Acceptance Criteria:**
- **Given** a seller has completed Brand Voice training (Story 5.4)
- **When** they reach the Business Profile step
- **Then** the form captures: business name, description, product categories (multi-select), pricing ranges, shipping policy (delivery areas + costs + timelines), return/refund policy, accepted payment methods, operating hours, physical location (optional), contact channels, and common FAQs (up to 10)
- **And** all fields are stored in a `business_profiles` table (tenant_id, user_id, data JSONB, completed_fields, completion_percentage, created_at, updated_at) with RLS
- **And** the form uses progressive disclosure: sections expand one at a time on mobile
- **And** required fields are clearly marked; optional fields are labeled
- **And** form progress auto-saves every 30 seconds (NFR-R10 draft auto-save) using IndexedDB for offline resilience
- **And** Zod validation runs on each section before advancing
- **And** the form shows a completion percentage indicator
- **And** the onboarding state machine advances to `profile_completed` when all required fields are filled
- **And** the form is usable one-handed on mobile (one-handed use optimization from UX spec)
- **And** cross-tenant isolation tests cover `business_profiles`
**Traceability:** FR=[FR12]; NFR=[NFR-R10]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR12
---

#### Story 5.6: Product Category & Compliance
As a **seller**,
I want to select my product category during onboarding, with prohibited categories blocked and regulated categories requiring certification,
So that the platform ensures legal compliance before I start selling.
**Depends on:** 5.5
**Acceptance Criteria:**
- **Given** a seller is completing their Business Profile (Story 5.5)
- **When** they reach the product category selection
- **Then** a curated list of product categories is displayed (fashion, electronics, food, cosmetics, home goods, etc.)
- **And** prohibited categories (weapons, drugs, counterfeit goods, etc.) are visually blocked with an explanation
- **And** selecting a prohibited category shows a clear error: "This category is not permitted on MarketBoss"
- **And** regulated categories (food, cosmetics) are marked with a ⚠️ warning badge
- **Given** a seller selects a regulated category
- **When** they confirm the selection
- **Then** a certification upload step appears requiring: NAFDAC registration (food/cosmetics), relevant business permits
- **And** the upload accepts: PDF, JPG, PNG up to 10MB per file, stored in S3-compatible storage
- **And** uploaded certifications are stored in a `compliance_documents` table (tenant_id, category, file_url, status: pending_review, approved, rejected, uploaded_at) with RLS
- **And** the seller can proceed with onboarding, but product listing is blocked until certification is reviewed (admin Epic 13)
- **And** the seller sees the certification status on their settings page
- **And** category selection is stored in the `seller_profiles` table
- **And** cross-tenant isolation tests cover `compliance_documents`
**Traceability:** FR=[FR6, FR7]; NFR=[NFR-P11, NFR-S3]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR6, FR7
---

#### Story 5.7: Social Data Ingestion & Pre-fill
As a **seller**,
I want my existing social platform data automatically imported to pre-fill my Business Profile,
So that I don't have to re-enter information that's already available on my connected accounts.
**Depends on:** 5.2, 5.3
**Acceptance Criteria:**
- **Given** a seller has connected their Instagram account (Story 5.2)
- **When** the social data ingestion runs
- **Then** the system fetches: business name, category, bio, website URL, profile picture from the Instagram API
- **And** Instagram product tags (if available) are ingested and stored as pre-fill suggestions
- **And** pre-filled fields are marked as "Imported from Instagram — verify and edit"
- **Given** a seller has connected their WhatsApp account (Story 5.3)
- **When** the social data ingestion runs
- **Then** the system fetches: business name, description, address, category from the WhatsApp Business Profile API
- **And** WhatsApp catalog items (if available) are ingested as product pre-fill data
- **And** pre-filled fields are marked as "Imported from WhatsApp — verify and edit"
- **Given** data has been ingested from any platform
- **When** the seller views their Business Profile form
- **Then** pre-filled fields show the imported value with a visual indicator (imported badge)
- **And** the seller can accept, edit, or clear any pre-filled value
- **And** ingestion is a one-time operation per connection (not continuous sync at this stage)
- **And** ingestion failures are logged but do NOT block onboarding (graceful degradation)
- **And** API rate limits are respected during ingestion (NFR-I3)
**Traceability:** FR=[FR13]; NFR=[NFR-I3]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR13
---

#### Story 5.8: Per-Product Quick Form & RAG Integration
As a **seller**,
I want to quickly add product details via a minimal form and have an AI advisory gap indicator,
So that AI has enough context to generate accurate content and buyer responses for each product.
**Depends on:** 5.5
**Acceptance Criteria:**
- **Given** a seller has completed their Business Profile (Story 5.5)
- **When** they create or add a product during onboarding
- **Then** a per-product quick form captures: product name, price (₦), key features (3-5 bullet points), availability status
- **And** product data is stored in a `products` table (tenant_id, name, price, features JSONB, availability, media_urls, created_at, updated_at) with RLS
- **And** the form is intentionally minimal — 30 seconds to complete per product
- **Given** products and Business Profile data exist
- **When** the advisory gap indicator runs (FR15)
- **Then** the system analyzes combined Business Profile + product data against a library of common buyer questions
- **And** gaps are displayed as: "Buyers often ask about shipping times — consider adding this to your profile"
- **And** the gap indicator shows a score: "AI readiness: 7/10 — 3 common questions cannot be answered yet"
- **Given** Business Profile and product data are stored
- **When** the RAG pipeline integration runs (FR16)
- **Then** all seller-specific data (Business Profile + products + Brand Voice samples) are indexed for the RAG pipeline
- **And** the RAG index is tenant-scoped (no cross-tenant data in the index)
- **And** pre-MarketBoss baseline metrics (follower count, engagement rate, post reach) are captured and stored at this stage (FR4)
- **And** cross-tenant isolation tests cover `products` table
**Traceability:** FR=[FR14, FR15, FR16, FR4]; NFR=[NFR-P11, NFR-S3]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR4, FR14, FR15, FR16
---

#### Story 5.9: First Post Guide & Onboarding Completion
As a **seller**,
I want a step-by-step guide for creating my first AI-generated post,
So that I experience the core value of MarketBoss immediately and complete onboarding successfully.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has completed all previous onboarding steps
- **When** they reach the first post creation guide (FR11)
- **Then** a step-by-step walkthrough appears: "1. Select a product → 2. Generate caption → 3. Review & edit → 4. Publish or schedule"
- **And** each step highlights the relevant UI element with a tooltip/spotlight overlay
- **And** the guide uses AI content generation when enabled for the tenant, or shows a "Coming soon — you'll create your first AI post here" placeholder with a skip option
- **And** the walkthrough is dismissible and can be replayed from settings
- **Given** the seller completes all onboarding steps (or skips the AI generation step if it is not yet enabled)
- **When** the onboarding flow is marked complete
- **Then** the `onboarding_status` in `seller_profiles` changes to `completed`
- **And** the seller is redirected to the main dashboard/home feed
- **Given** a seller has NOT completed all onboarding steps
- **When** they navigate away from onboarding
- **Then** a persistent banner/prompt appears on every page: "Complete your setup to unlock AI features"
- **And** clicking the prompt returns them to their last incomplete step
- **And** the prompt shows their completion percentage from the `seller_profiles` record
- **And** incomplete onboarding detection runs on every authenticated page load
- **And** the onboarding completion event is logged for analytics
**Traceability:** FR=[FR11]; NFR=[NFR-P11, NFR-S3]; ADR=[ADR-1d, ADR-4b]; AR=[None]; ENB=[None]
**FRs covered:** FR11
---

### Epic 6: AI-Powered Content Creation

#### Story 6.1: AI Pipeline Smoke Test
As a **developer or AI agent**,
I want an end-to-end architectural spike that proves the AI router → privacy proxy → provider → response chain works,
So that we validate the highest-risk technical architecture before investing in feature stories.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the backend is running with Redis and database (Epics 1-2)
- **When** the AI pipeline smoke test is implemented
- **Then** a `POST /api/v1/ai/smoke-test` endpoint exists (dev-only, gated by feature flag)
- **And** the endpoint sends a hardcoded prompt ("Generate a short product caption for a fashion item") through the full pipeline:
  1. Request → AI Router (classifies as Tier 1)
  2. Router → Privacy Proxy (strips tenant PII, replaces with tokens)
  3. Privacy Proxy → Single AI provider (DeepSeek R1 0528 as Tier 1 MVP)
  4. Provider → Privacy Proxy (re-injects PII tokens)
  5. Privacy Proxy → Response to caller
- **And** the privacy proxy runs as a Go middleware/service — it is non-bypassable (Architecture requirement)
- **And** the smoke test verifies: response received, PII was stripped in outbound request, PII was restored in response
- **And** the entire chain completes within 5 seconds (NFR-AI3: T1 ≤2s p95)
- **And** errors at any stage produce clear, logged error messages with the failing component identified
- **And** the smoke test is runnable via `make ai-smoke-test` for local development
- **And** a Go integration test automates the smoke test assertions
- **And** the database migration creates: `ai_requests` table (tenant_id, request_type, tier_used, provider, latency_ms, token_count, cost_estimate, status, created_at) with RLS
**Traceability:** FR=[None]; NFR=[NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[AR-AI-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 6.2: Privacy Proxy & 3-Tier AI Router
As a **platform operator**,
I want a non-bypassable privacy proxy and intelligent 3-tier AI router,
So that tenant PII is never sent to external AI providers and requests are routed to the optimal cost/quality tier.
**Depends on:** 6.1
**Acceptance Criteria:**
- **Given** the smoke test validates the basic pipeline (Story 6.1)
- **When** the full privacy proxy and router are implemented
- **Then** the privacy proxy intercepts ALL outbound AI requests — there is no code path that bypasses it
- **And** the proxy strips: seller name, business name, customer names, phone numbers, email addresses, and replaces with tokenized placeholders
- **And** the proxy re-injects original values into AI responses before returning to the caller
- **And** PII patterns are detected via regex + configuration (not hardcoded)
- **And** the AI router classifies incoming requests by task complexity:
  - **Tier 1** (self-hosted 7B model / DeepSeek R1 0528): simple captions, template-based content
  - **Tier 2** (RAG API / Gemini 2.5 Flash): context-aware responses, business-specific Q&A
  - **Tier 3** (premium creative / GPT-4o): complex creative content, nuanced cultural adaptation
- **And** the router classification runs within ≤100ms (NFR-AI2)
- **And** each tier has a configured provider with adapter pattern (swappable)
- **And** cross-tier fallback works: if Tier 3 fails → try Tier 2 → try Tier 1 → return fallback template
- **And** per-tier latency limits are enforced: T1 ≤2s, T2 ≤4s, T3 ≤5s p95 (NFR-AI3)
- **And** all AI requests are logged to the `ai_requests` table with tier, provider, latency, and cost
- **And** the router is tested with unit tests for classification logic and integration tests for failover
**Traceability:** FR=[None]; NFR=[NFR-AI2, NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[AR-AI-2]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 6.3: Brand Voice Caption Generation
As a **seller**,
I want to generate AI-powered captions calibrated to my Brand Voice, iterate with feedback, and edit before publishing,
So that every piece of content sounds authentically like me while saving hours of writing time.
**Depends on:** 5.4
**Acceptance Criteria:**
- **Given** a seller has completed Brand Voice training (Epic 5, Story 5.4) with >=5 samples
- **When** they request a caption via `POST /api/v1/content/generate`
- **Then** the AI generates a caption calibrated to their Brand Voice profile using their training samples as context
- **And** the request includes: product_id (optional), caption_type (product showcase, promotion, engagement, story), tone preference (professional, casual, playful)
- **And** the response includes: generated caption text, Brand Voice fidelity score (0-100), tier used, and generation time
- **And** the response includes an audio preview contract: `audio_preview_url` (signed URL) and `audio_preview_duration_ms`
- **And** the caption is stored in a `content_drafts` table (tenant_id, product_id, caption_text, caption_type, tone, fidelity_score, status: draft/published/archived, created_at) with RLS
- **And** captions render within <=5s p95 with progressive skeleton loading after 2s (NFR-P1)
- **Given** a seller wants to hear a generated caption before publishing
- **When** they request audio preview via `POST /api/v1/content/{id}/audio-preview`
- **Then** the system returns a playable audio asset for the current draft text in <=10 seconds
- **And** audio preview is available on mobile publish surfaces before publish is attempted
- **Given** a seller has a generated caption
- **When** they request regeneration with feedback (`POST /api/v1/content/{id}/regenerate`)
- **Then** the feedback text is included in the AI prompt context for improved results
- **And** a new draft is created (previous draft preserved for comparison)
- **And** up to 5 regenerations are allowed per caption
- **Given** a seller has a generated caption
- **When** they edit the caption text directly
- **Then** the edited version is saved as the final draft
- **And** the edit is tracked for learning purposes in the AI feedback log
- **Given** a seller attempts to publish a draft
- **When** they submit the per-post "Sounds Like Me" trust rating
- **Then** publish is enabled only when rating is 4/5 or 5/5
- **And** ratings of 1/5 to 3/5 block publish and force regenerate-or-edit flow before retry
- **And** the trust rating and gate decision are logged in `content_draft_ratings` (tenant_id, draft_id, rating, gate_passed, created_at) with RLS
**Traceability:** FR=[FR113, FR114, FR17, FR18, FR19]; NFR=[NFR-P1]; ADR=[ADR-1c, ADR-2d]; AR=[None]; ENB=[None]
**FRs covered:** FR17, FR18, FR19, FR113, FR114
---
#### Story 6.4: Payment Link CTA & Content Uniqueness
As a **seller**,
I want payment link CTAs embedded in my captions and assurance that my content is unique,
So that every post drives sales and my content doesn't look like other sellers' posts.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller generates a caption for a product that has an active payment link
- **When** the caption is generated
- **Then** the AI automatically embeds a natural call-to-action with the payment link
- **And** the CTA style matches the caption tone (e.g., "Tap the link to grab yours 👆" for casual, "Order now via secure checkout" for professional)
- **And** if no payment link exists yet, the CTA placeholder reads "[payment link will be added]"
- **Given** a seller generates content in a category with other sellers
- **When** the cross-tenant uniqueness check runs (FR21)
- **Then** the system compares the generated caption against recent captions from other tenants in the same product category
- **And** similarity above 70% triggers automatic regeneration with a variation prompt
- **And** the check uses text similarity (not exact match) to catch paraphrased content
- **And** the uniqueness check is tenant-aware but does NOT expose other tenants' content
- **Given** a seller generates multiple captions over time
- **When** the AI detection resistance system runs (FR22)
- **Then** the system varies: sentence structure, vocabulary, emoji usage, hashtag patterns, and paragraph length
- **And** consecutive captions for the same seller NEVER use the same opening pattern
- **And** variation is seeded per-tenant to maintain individual consistency while avoiding cross-tenant repetition
**Traceability:** FR=[FR20, FR21, FR22]; NFR=[NFR-P1, NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[None]; ENB=[None]
**FRs covered:** FR20, FR21, FR22
---

#### Story 6.5: Batch Generation & Fidelity Scoring
As a **seller**,
I want to generate content for multiple products at once and know how well AI matches my voice,
So that I can prepare a week's content in minutes and maintain brand consistency.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has multiple products in their catalog
- **When** they request batch content generation (`POST /api/v1/content/batch`)
- **Then** they can select 2-10 products and a caption type for each
- **And** the system queues all generation requests and processes them asynchronously
- **And** progress is reported via SSE: "Generating 3 of 7..."
- **And** results are delivered as they complete (not waiting for all to finish)
- **And** each generated caption includes its individual Brand Voice fidelity score
- **Given** a seller views their generated content
- **When** the Brand Voice fidelity score is displayed (FR24)
- **Then** the score is 0-100 based on similarity to the seller's training samples
- **And** scores below 60 show a warning: "This caption may not sound like you — consider adding more training samples"
- **And** scores below 40 show: "Low Brand Voice match — recalibrate recommended"
- **Given** a seller wants to improve their Brand Voice accuracy
- **When** they submit additional training samples (FR25)
- **Then** the Brand Voice profile is updated and the next generation request uses the enriched profile
- **And** the system confirms: "Brand Voice updated with X new samples — fidelity should improve"
- **And** Brand Voice updates are reflected in the NEXT generation request — no batch delay (NFR-P12)
**Traceability:** FR=[FR23, FR24, FR25]; NFR=[NFR-P12]; ADR=[ADR-1c, ADR-2d]; AR=[None]; ENB=[None]
**FRs covered:** FR23, FR24, FR25
---

#### Story 6.6: Nigerian Market Localization
As a **seller**,
I want AI to generate content with Nigerian Pidgin English, local slang, and cultural references,
So that my content resonates authentically with my Nigerian audience and feels natural, not foreign.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller's profile indicates Nigerian market (default for MVP)
- **When** they generate a caption
- **Then** the AI incorporates Nigerian Pidgin English where appropriate based on the seller's Brand Voice tone
- **And** cultural references are contextually appropriate (e.g., seasonal events, local holidays, market days)
- **And** local slang and expressions are used naturally (not forced): "How far", "Na wa", "Pepper dem", etc.
- **And** currency is always displayed in Naira (₦) with Nigerian number formatting
- **And** a `localization` parameter allows: `standard_english`, `light_pidgin`, `heavy_pidgin`, `mixed`
- **And** the localization preference is stored in the seller's profile and used as default for all generations
- **And** the AI model prompt includes a Nigerian cultural context library maintained as a JSON resource file
- **And** inappropriate or offensive cultural references are filtered out pre-delivery
- **And** the localization module is tested with example outputs reviewed for cultural accuracy
**Traceability:** FR=[FR26]; NFR=[NFR-P1, NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[None]; ENB=[None]
**FRs covered:** FR26
---

#### Story 6.7: Learning from Seller Corrections
As a **seller**,
I want the AI to learn from my edits and corrections to improve future output,
So that content gets better over time without me repeatedly giving the same feedback.
**Depends on:** 6.3
**Acceptance Criteria:**
- **Given** a seller edits a generated caption before publishing (Story 6.3)
- **When** the edit is saved
- **Then** the original and edited versions are stored in a `content_corrections` table (tenant_id, draft_id, original_text, edited_text, diff_summary, created_at) with RLS
- **And** the diff_summary captures: additions, deletions, tone shifts, structural changes
- **Given** a seller has accumulated ≥10 corrections
- **When** the learning system analyzes the correction patterns
- **Then** common patterns are extracted: preferred phrases, avoided words, structural preferences, emoji usage patterns
- **And** these patterns are stored as supplementary Brand Voice signals in the seller's profile
- **And** subsequent caption generations include these learned patterns in the AI prompt context
- **And** the seller can view their correction history and the learned patterns on their Brand Voice settings page
- **And** learning is tenant-isolated (no cross-tenant learning from corrections)
- **And** the learning system runs as a background job (not blocking the edit flow)
**Traceability:** FR=[FR27]; NFR=[NFR-P1, NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[None]; ENB=[None]
**FRs covered:** FR27
---

#### Story 6.8: Fallback Templates & AI Budget Tracking
As a **seller**,
I want content available even when AI is down, and visibility into my AI usage costs,
So that I'm never stuck without content options and can manage my usage within my tier limits.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the AI provider is unavailable or returns errors
- **When** the fallback system activates (FR28)
- **Then** within 5 minutes of AI failure, the system switches to cached templates (NFR-R4)
- **And** cached templates are pre-generated category-specific caption templates (at least 20 per category)
- **And** templates include placeholder tokens for: product name, price, CTA link
- **And** the seller is notified: "AI is temporarily unavailable — using templates"
- **And** after 1 hour of AI unavailability, manual mode is activated: seller writes their own content with a simplified editor
- **And** when AI recovers, normal generation resumes automatically
- **Given** a seller generates AI content
- **When** AI budget tracking runs
- **Then** each request's estimated cost is logged in the `ai_requests` table (token count × provider rate)
- **And** cumulative monthly cost per tenant is tracked in a `tenant_ai_budgets` table (tenant_id, month, total_tokens, total_cost, budget_limit, created_at) with RLS
- **And** when a tenant reaches 80% of their monthly budget, a warning is displayed using the FR69 usage-warning pattern
- **And** when a tenant exceeds 100% of their budget, AI requests are routed to Tier 1 only (cheapest) instead of being blocked
- **And** budget limits are configurable per tier through admin-managed tenant limit settings
- **And** the seller can view their AI usage on a settings page: requests this month, tokens used, estimated cost
**Traceability:** FR=[FR28]; NFR=[NFR-R4]; ADR=[ADR-1c, ADR-2d]; AR=[None]; ENB=[None]
**FRs covered:** FR28
---

#### Story 6.9: Hybrid Composition Image Pipeline
As a **seller**,
I want professional flyers and posters generated using AI backgrounds combined with programmatic text composition and my brand assets,
So that I get pixel-perfect promotional graphics with legible text, accurate prices, and consistent branding — never garbled AI-generated text.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has product photos and a Brand Kit uploaded (logo, hex colors, TTF/OTF font)
- **When** they request a visual via `POST /api/v1/content/visual/generate`
- **Then** the pipeline executes in 3 stages:
  1. **Step 1 — AI Background:** DALL-E 3 (or Stable Diffusion) generates ONLY textures and thematic background elements (e.g., "gold confetti background", "minimal gradient", "festive pattern") — NO text, NO logos, NO product names
  2. **Step 2 — Vector Composition:** Go `gogpu/gg` v0.14.0 (GPU-accelerated 2D graphics) composites the final image by layering: AI background → product photo(s) → text overlays → borders → price badges → CTA buttons with exact pixel coordinates
  3. **Step 3 — Brand Kit Injection:** Tenant's uploaded logo is placed in a predefined safe zone, primary/secondary hex colors are applied to overlays, tenant's TTF/OTF font is used for ALL text rendering
- **And** text is NEVER rendered by the AI model — all text (product names, prices, CTAs) is composited programmatically with guaranteed legibility
- **And** the seller selects: product photo(s), layout template, style preset (modern, bold, minimal, festive, sale/promo)
- **And** the output image is generated at the selected aspect ratio: 1:1 (feed), 9:16 (story), 4:5 (portrait)
- **And** the generated image is stored in S3-compatible storage under the tenant's media folder
- **And** the seller receives 2-3 variations (different AI backgrounds with same text composition)
- **And** the full pipeline completes within ≤15 seconds with a progress indicator per stage
- **And** AI background generation requests are logged in `ai_requests` with type: `background_generation`
- **And** the privacy proxy strips PII from the AI background prompt (which should contain only style descriptors)
- **And** if AI background generation fails, a solid color/gradient from the Brand Kit is used as fallback
- **And** cross-tenant isolation: each tenant's Brand Kit assets and generated images are stored in tenant-scoped S3 prefixes
**Traceability:** FR=[None]; NFR=[NFR-P1, NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[AR-VIS-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 6.10: Layout Templates & Brand Kit Onboarding
As a **seller**,
I want pre-designed layout templates with safe zones and to upload my brand assets during onboarding,
So that every generated visual matches my brand identity and I get instant, professional results.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller wants to create visual content
- **When** they browse the template library
- **Then** at least 15 pre-designed layout templates are available across categories: product showcase, promotional banner, new arrival, testimonial, story format, sale/discount
- **And** each template defines compositional rules in JSON: safe zones for logo, text areas (headline, subtitle, price, CTA), product photo placement, border specifications, overlay positions
- **And** templates specify exact coordinates and dimensions for each element zone
- **And** templates render at multiple aspect ratios: 1:1 (Instagram feed), 9:16 (stories/reels), 4:5 (portrait)
- **Given** a seller is in onboarding or settings
- **When** they configure their Brand Kit
- **Then** they can upload: logo (PNG/SVG, transparent background), primary and secondary hex colors, TTF/OTF font file
- **And** Brand Kit assets are stored in S3 under a tenant-scoped prefix with appropriate access controls
- **And** a Brand Kit preview shows the seller's assets applied to a sample template
- **And** Brand Kit is stored in a `brand_kits` table (tenant_id, logo_url, primary_color, secondary_color, font_url, created_at, updated_at) with RLS
- **And** defaults are provided if the seller skips Brand Kit setup: MarketBoss neutral colors + Inter font
- **And** the template system is extensible: new templates are added via JSON config + SVG layout files (no code changes)
- **And** the Go `gogpu/gg` composition service reads template JSON + Brand Kit + AI background + product photo and produces the final PNG/JPEG
- **And** cross-tenant isolation tests cover `brand_kits` table
**Traceability:** FR=[None]; NFR=[NFR-P1, NFR-AI3]; ADR=[ADR-1c, ADR-2d]; AR=[AR-VIS-2]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

### Epic 7: Social Publishing & Channel Management

#### Story 7.1: Instagram Post Publishing
As a **seller**,
I want to publish single-image and carousel posts to Instagram directly from MarketBoss,
So that I can share my AI-generated content and flyers with my followers without switching apps.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has a connected Instagram Business account (Epic 5) and a ready-to-publish content draft (Epic 6)
- **When** they publish a post via `POST /api/v1/posts/publish`
- **Then** the backend uploads the image(s) to Instagram via Meta Graph API using the seller's stored access token
- **And** single-image posts upload one photo with caption
- **And** carousel posts upload 2-10 images with a shared caption
- **And** the caption from the content draft is included with the post
- **And** the post is associated with the product(s) it references
- **And** publishing completes within ≤5s including image upload (NFR-P8)
- **And** the published post's Instagram URL, post ID, and timestamp are stored in a `published_posts` table (tenant_id, platform, external_post_id, post_url, caption, media_urls, product_ids, published_at) with RLS
- **And** publishing errors are handled gracefully: token expired → prompt reconnection, image too large → resize and retry, API error → show user-friendly message
- **And** the seller sees a success confirmation with a link to view the post on Instagram
- **And** cross-tenant isolation tests cover `published_posts`
**Traceability:** FR=[FR29]; NFR=[NFR-P8]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR29
---

#### Story 7.2: AI-Recommended Scheduling & Queue Management
As a **seller**,
I want to schedule posts for AI-recommended optimal times and manage my scheduled queue,
So that my content reaches followers when they're most active without me having to time it manually.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has a content draft ready to publish
- **When** they choose "Schedule" instead of "Publish Now"
- **Then** the AI recommends 3 optimal posting times based on: the seller's historical engagement data (if available), general best-practice times for their category, and day of week
- **And** the seller can accept a recommended time or pick a custom date/time
- **And** the scheduled post is stored in a `scheduled_posts` table (tenant_id, draft_id, scheduled_at, status: queued/published/failed/cancelled, created_at) with RLS
- **And** a background job executes scheduled posts within a 5-minute window of their scheduled time (NFR-R8)
- **Given** a seller has scheduled posts
- **When** they view their scheduled queue
- **Then** a feed-native contextual surface shows upcoming posts in chronological order (not a calendar — calendar is post-MVP per FR31)
- **And** each scheduled post shows: thumbnail, caption preview, scheduled date/time, status
- **And** the seller can reschedule (change time), cancel, or edit a scheduled post
- **And** the queue loads within ≤3s for 30 days of data (NFR-P9)
- **Given** a scheduled post fails to publish
- **When** the failure is detected
- **Then** the post is re-queued at 15-minute intervals for up to 6 hours (NFR-R11)
- **And** after 6 hours of failures, the post is marked `failed` and the seller is notified
- **And** the seller can retry or reschedule the failed post manually
**Traceability:** FR=[FR30, FR31]; NFR=[NFR-P9, NFR-R11, NFR-R8]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR30, FR31
---

#### Story 7.3: Rate Limit Detection & Graceful Degradation
As a **platform operator**,
I want the system to detect API rate limits and gracefully degrade service,
So that the platform never gets blocked by Instagram or WhatsApp and users experience minimal disruption.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the system is making API calls to Instagram or WhatsApp
- **When** the rate limit monitor detects usage approaching 80% of the limit
- **Then** auto-throttling activates: request spacing increases to stay under the limit (NFR-I3)
- **And** a log entry is created: "Rate limit approaching for tenant {id} on {platform}: {current}/{limit}"
- **Given** a rate limit is exceeded (HTTP 429 from the platform API)
- **When** the system receives the 429 response
- **Then** all requests for that platform + tenant are paused for the duration specified in the response headers (or 15 minutes default)
- **And** live DMs are prioritized over scheduled/bulk messages during degradation (FR34)
- **And** the seller is notified: "Posting paused for ~15 minutes due to platform limits — your messages are queued"
- **And** queued messages are automatically resumed when the rate limit window expires
- **Given** rate limiting is active
- **When** the degradation persists
- **Then** the system follows priority order: live DMs > scheduled posts > bulk communications
- **And** rate limit events are logged for admin monitoring and alerting pipelines
- **And** per-tenant rate limit state is tracked in Redis with tenant-scoped keys
**Traceability:** FR=[FR34]; NFR=[NFR-I3]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR34
---

#### Story 7.4: Business Hours & After-Hours Auto-Responses
As a **seller**,
I want to configure my business hours and have automated after-hours responses,
So that customers get immediate acknowledgment even when I'm not working.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is in settings
- **When** they configure business hours
- **Then** they can set: operating days (checkboxes), opening time, closing time per day
- **And** they can set different hours for different days (e.g., Mon-Fri 9-6, Sat 10-2, Sun closed)
- **And** business hours are stored in the `business_profiles` table (operating_hours JSONB)
- **And** timezone is detected from the seller's profile (default: WAT / Africa/Lagos)
- **Given** business hours are configured
- **When** a customer message arrives outside business hours
- **Then** an automatic response is sent: default "Thanks for your message! We're currently closed and will respond during business hours: {hours}. For urgent orders, visit {link}"
- **And** the auto-response is sent within ≤2s of message receipt
- **And** the seller can customize the auto-response message text and toggle it on/off
- **And** auto-responses are sent at most once per customer per after-hours window (no spam on multiple messages)
- **And** auto-responses are clearly attributed as system-generated in the conversation log
**Traceability:** FR=[FR35]; NFR=[NFR-P8, NFR-R8]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR35
---

#### Story 7.5: Message Delivery Prioritization
As a **platform operator**,
I want all outbound messages prioritized correctly with real-time event publishing,
So that live customer conversations are never delayed by scheduled or bulk operations.
**Depends on:** None
**Acceptance Criteria:**
- **Given** multiple message types are queued for delivery
- **When** the message delivery system processes the queue
- **Then** priority order is enforced: 1) Live DM responses (highest), 2) Scheduled post publications, 3) Bulk/segmented communications (lowest)
- **And** the priority queue is implemented using Redis Sorted Sets with priority scores
- **And** live DMs preempt scheduled messages — a scheduled message waits if a live DM is pending
- **And** WhatsApp message delivery (API submission) completes within ≤2s (NFR-P3)
- **And** Redis Streams publish events for real-time feed updates: `post.published`, `message.sent`, `message.received`, `message.failed`
- **And** event consumers can subscribe to tenant-scoped stream patterns
- **And** the SSE endpoint (`GET /api/v1/events/stream`) delivers real-time events to the frontend with Last-Event-ID reconnection support (Architecture: SSE with reconnection)
- **And** a polling fallback exists for clients that don't support SSE
- **And** message delivery metrics are logged: queue depth, processing latency, delivery success rate
**Traceability:** FR=[FR36]; NFR=[NFR-P3]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR36
---

#### Story 7.6: WhatsApp Catalog Sync
As a **seller**,
I want my MarketBoss product catalog synced to my WhatsApp Business catalog,
So that customers browsing my WhatsApp can see up-to-date products without me manually updating two systems.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has a connected WhatsApp account and products in their catalog
- **When** catalog sync is triggered
- **Then** products are synced to the WhatsApp Business Catalog via the Catalog API
- **And** sync includes: product name, description, price (₦), availability, image URL, product URL
- **And** sync is triggered on: product create, product update, product delete, and a daily full reconciliation
- **And** sync status is tracked in a `catalog_sync_log` table (tenant_id, platform, product_id, sync_status, synced_at, error_message) with RLS
- **And** sync conflicts are resolved with MarketBoss as source of truth (last-write-wins)
- **And** the seller sees sync status on their product list: ✅ Synced, ⏳ Syncing, ❌ Failed
- **And** failed syncs are retried automatically up to 3 times with exponential backoff
- **And** API rate limits for the WhatsApp Catalog API are respected (NFR-I3)
**Traceability:** FR=[FR37]; NFR=[NFR-I3]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR37
---

#### Story 7.7: Segmented Messaging & Platform Health
As a **seller**,
I want to send messages to customer segments with preview+confirm, and be alerted if my platform connections break,
So that I can run targeted campaigns safely and reconnect before missing customer messages.
**Depends on:** 7.5
**Acceptance Criteria:**
- **Given** a seller has customer segments defined (Epic 9)
- **When** they compose a segmented list message
- **Then** they can select a segment (e.g., "wholesale customers", "new leads") and compose a message
- **And** a preview screen shows: segment name, recipient count, message preview, and estimated delivery time
- **And** the seller must explicitly confirm before sending: "Send to 47 recipients?"
- **And** delivery is queued at bulk priority (lowest) per Story 7.5
- **And** delivery progress is shown: "Sent 23 of 47..."
- **And** delivery results are logged per recipient: sent, delivered, failed, with error details
- **Given** a seller's Instagram or WhatsApp connection breaks
- **When** the platform disconnection is detected (FR39)
- **Then** the system detects disconnection within 5 minutes via: failed API call, webhook health check failure, or token expiry
- **And** the seller is immediately notified: "Your {platform} connection was lost"
- **And** a guided reconnection flow appears with step-by-step instructions
- **And** all scheduled posts for the disconnected platform are paused (not cancelled)
- **And** when reconnection succeeds, paused scheduled posts are automatically resumed
- **And** disconnection events are logged for admin monitoring
**Traceability:** FR=[FR38, FR39]; NFR=[NFR-P8, NFR-R8]; ADR=[ADR-3d, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR38, FR39
---

### Epic 8: Product Catalog & Sales Pipeline

#### Story 8.1: Product CRUD & Media Upload
As a **seller**,
I want to create, view, edit, and delete products with image uploads,
So that I have a complete product catalog to power AI content generation and order management.
**Depends on:** 5.8, 7.6
**Acceptance Criteria:**
- **Given** a seller is authenticated and onboarded
- **When** they create a product via `POST /api/v1/products`
- **Then** the product is stored in the `products` table (extends Epic 5 Story 5.8) with fields: name, description, price (₦), compare_at_price, SKU (optional), category_id, features JSONB, availability, media_urls, created_at, updated_at
- **And** the seller can upload 1-10 product images per product
- **And** images are uploaded to S3-compatible storage under the tenant's media prefix
- **And** images are automatically resized to: original, 800px (display), 200px (thumbnail) on upload
- **And** supported formats: JPEG, PNG, WebP — max 10MB per image
- **And** the product list endpoint (`GET /api/v1/products`) supports: pagination (cursor-based), filtering by category, sorting by name/price/created_at, text search
- **And** product detail endpoint (`GET /api/v1/products/{id}`) returns full product with media URLs
- **And** each product has a shareable public link (`{base_url}/p/{product_slug}`) usable across WhatsApp, Instagram, and other channels
- **And** product update (`PUT /api/v1/products/{id}`) updates fields and triggers catalog sync (Epic 7 Story 7.6)
- **And** product delete (`DELETE /api/v1/products/{id}`) soft-deletes (sets `deleted_at`) and removes from active catalog
- **And** products display in a mobile-optimized card grid in the frontend with skeleton loading
- **And** all product endpoints validate input via Zod schemas
- **And** cross-tenant isolation tests cover product operations
**Traceability:** FR=[FR40, FR41, FR52]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR40, FR41, FR52
---

#### Story 8.2: Inventory Tracking & Low Stock Alerts
As a **seller**,
I want real-time stock counts with automatic low-stock alerts,
So that I never oversell and can restock before running out.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a product exists in the catalog
- **When** inventory is managed
- **Then** each product has a `stock_quantity` field and a `low_stock_threshold` field (default: 5)
- **And** stock quantity is updated via: manual adjustment (`PATCH /api/v1/products/{id}/inventory`), order creation (decrement), order cancellation (increment)
- **And** stock adjustments are logged in an `inventory_log` table (tenant_id, product_id, previous_qty, new_qty, adjustment_type, reference_id, created_at) with RLS for audit trail
- **Given** a product's stock quantity drops to or below the low_stock_threshold
- **When** the threshold is breached
- **Then** a `low_stock` notification is dispatched to the seller
- **And** the notification includes: product name, current stock, threshold value
- **And** the product is visually flagged with a warning badge in the product list
- **Given** a product's stock reaches zero
- **When** stock_quantity = 0
- **Then** the product is automatically marked as `unavailable`
- **And** AI content generation for this product is paused (won't include out-of-stock items in batch generation)
- **And** the seller is notified: "{Product} is now out of stock — new orders will be paused"
- **And** when stock is replenished above 0, the product is automatically re-enabled
- **And** inventory data loads within ≤2s for up to 500 products
- **And** cross-tenant isolation tests cover `inventory_log`
**Traceability:** FR=[None]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[AR-OPS-INV-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 8.3: Pricing Engine & Bulk Operations
As a **seller**,
I want to set prices, manage wholesale tiers, apply discounts, and update prices in bulk,
So that I can run promotions and manage different customer price points efficiently.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has products in their catalog
- **When** they configure pricing
- **Then** each product has: retail price (₦), compare_at_price (original/strikethrough), wholesale price (optional)
- **And** prices are stored as integer cents (kobo) to avoid floating-point errors — displayed as ₦ with 2 decimal places
- **And** wholesale pricing tiers can be configured: minimum quantity → tier price (e.g., 10+ units → ₦800 each)
- **And** wholesale tier data is stored in a `pricing_tiers` table (tenant_id, product_id, min_quantity, tier_price, created_at) with RLS
- **Given** a seller wants to update prices in bulk
- **When** they use the bulk price update feature (`POST /api/v1/products/bulk/pricing`)
- **Then** they can: apply a percentage increase/decrease to selected products, or set a fixed price for selected products
- **And** the operation supports up to 100 products per batch
- **And** a preview shows the before/after prices before confirming
- **And** the bulk operation runs asynchronously with progress reporting
- **Given** a seller wants to run a promotion
- **When** they configure a discount
- **Then** they can set: percentage off, fixed amount off, or buy-X-get-Y
- **And** discounts have start/end dates and apply automatically during the active period
- **And** discounted prices are reflected in AI-generated captions and flyers
- **And** cross-tenant isolation tests cover `pricing_tiers`
**Traceability:** FR=[None]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[AR-OPS-PRICING-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 8.4: Order Intake & Status Tracking
As a **seller**,
I want to create orders from customer conversations and track them through a complete lifecycle,
So that I have a reliable system for managing every sale from inquiry to delivery.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is managing customer conversations in the inbox
- **When** they create an order from a conversation
- **Then** an order is created via `POST /api/v1/orders` with: customer_id, line items (product_id, quantity, unit_price), delivery_address, payment_method, notes
- **And** the order is stored in an `orders` table (tenant_id, order_number, customer_id, status, total_amount, delivery_address, payment_status, created_at, updated_at) with RLS
- **And** order line items are stored in an `order_items` table (order_id, product_id, quantity, unit_price, total_price) with RLS
- **And** order numbers are auto-generated: `MB-{YYYYMMDD}-{sequential}` (e.g., MB-20260222-0042)
- **And** inventory is automatically decremented for each line item on order creation
- **Given** an order exists
- **When** the seller updates the order status
- **Then** the status lifecycle is enforced: `received` → `confirmed` → `processing` → `shipped` → `delivered`
- **And** each status change is timestamped in an `order_timeline` table (order_id, status, note, created_at) with RLS
- **And** the customer is optionally notified of status changes via their platform (WhatsApp/Instagram DM)
- **And** the seller can add notes to timeline entries (e.g., "Shipped via GIG Logistics, tracking: XYZ123")
- **Given** a seller views their orders
- **When** the order list loads
- **Then** orders are filterable by: status, date range, customer, payment status
- **And** a visual timeline shows the order's journey through statuses (FR48)
- **And** the order list loads within ≤3s for up to 1000 orders
- **And** cross-tenant isolation tests cover `orders`, `order_items`, `order_timeline`
**Traceability:** FR=[FR46, FR48]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR46, FR48
---

#### Story 8.5: Delivery Coordination
As a **seller**,
I want to configure delivery zones, calculate costs, and share tracking links with buyers,
So that I can manage logistics efficiently and keep buyers informed about their deliveries.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is in settings
- **When** they configure delivery
- **Then** they can define delivery zones: local (within city), regional (within state), national
- **And** each zone has: name, coverage description, base delivery cost (₦), estimated delivery time
- **And** delivery zones are stored in a `delivery_zones` table (tenant_id, zone_name, coverage, base_cost, estimated_days, is_active) with RLS
- **Given** an order is being created
- **When** delivery cost is calculated
- **Then** the cost is determined by matching the delivery address to the nearest delivery zone
- **And** the delivery cost is added to the order total and shown to the seller
- **And** free delivery thresholds can be set per zone (e.g., "Free delivery on orders over ₦10,000")
- **Given** an order is shipped
- **When** the seller enters a tracking number or delivery partner reference
- **Then** a shareable tracking link is generated: `{base_url}/track/{order_id}` (public, no auth required)
- **And** the tracking page shows: order status, estimated delivery date, and a timeline of status updates
- **And** the tracking link can be shared with the buyer via WhatsApp/Instagram DM with one tap
- **And** sellers can send delivery progress updates (shipped, in-transit, delivered) directly to buyers from the order timeline
- **And** future integration with delivery partners (GIG, Kwik, Sendbox) is prepared via an adapter interface (not implemented in MVP, but interface defined)
**Traceability:** FR=[FR53]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR53
---

#### Story 8.6: Returns & Refund Processing
As a **seller**,
I want to process return requests and track refund status,
So that I can handle post-sale issues professionally and maintain customer trust.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a delivered order exists
- **When** a return is initiated (by seller on behalf of customer)
- **Then** a return record is created via `POST /api/v1/orders/{id}/returns` with: reason (defective, wrong item, changed mind, etc.), description, photo evidence (optional)
- **And** the return is stored in a `returns` table (tenant_id, order_id, reason, description, status, refund_amount, created_at) with RLS
- **And** return status lifecycle: `requested` → `approved` → `item_received` → `refunded` (or `rejected`)
- **Given** a return is approved
- **When** the seller processes the refund
- **Then** the refund amount and method are recorded
- **And** refund status is tracked: `pending` → `processed` → `completed`
- **And** inventory is automatically incremented when a returned item is received back
- **And** the order status is updated to reflect the return
- **Given** a seller views their returns
- **When** the return list loads
- **Then** returns are filterable by: status, date range, reason
- **And** return reason analytics show breakdown by reason (pie chart) for the last 30/90 days
- **And** cross-tenant isolation tests cover `returns`
**Traceability:** FR=[None]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[AR-OPS-RETURNS-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 8.7: Customer Feedback & Disputes
As a **seller**,
I want to collect customer ratings and handle disputes with a structured resolution flow,
So that I can improve service quality and resolve issues before they escalate.
**Depends on:** None
**Acceptance Criteria:**
- **Given** an order is delivered
- **When** the seller requests feedback from the customer
- **Then** a feedback request message is sent via the customer's platform (WhatsApp/Instagram DM)
- **And** the message includes a simple rating prompt (1-5 stars) and optional text feedback
- **And** feedback is stored in a `customer_feedback` table (tenant_id, order_id, customer_id, rating, comment, created_at) with RLS
- **Given** a customer submits a negative rating (1-2 stars)
- **When** the feedback is received
- **Then** it is flagged for seller attention with a notification
- **And** the seller can initiate a dispute resolution flow: acknowledge → investigate → propose resolution → resolve/escalate
- **And** dispute records are stored in a `disputes` table (tenant_id, feedback_id, order_id, status, resolution_notes, resolved_at) with RLS
- **Given** a seller views feedback analytics
- **When** the dashboard loads
- **Then** average rating is displayed (overall and per-product)
- **And** rating distribution is shown (1-5 star breakdown)
- **And** recent feedback is listed with order references
- **And** cross-tenant isolation tests cover `customer_feedback` and `disputes`
**Traceability:** FR=[FR63]; NFR=[NFR-P6, NFR-S3]; ADR=[ADR-1a, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR63
---

#### Story 8.8: Contextual Sales Performance Insights
As a **seller**,
I want contextual sales performance insights showing revenue, top products, conversion rates, and repeat customers,
So that I can make data-driven decisions about my business and identify growth opportunities.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has order history
- **When** they open home/feed/inbox contextual insights cards
- **Then** the contextual insights show for a selectable period (7d, 30d, 90d, custom):
  - **Revenue chart**: line chart of daily/weekly revenue (₦) with trend indicator
  - **Top products**: ranked list of products by revenue and units sold
  - **Conversion rate**: posts published → inquiries → orders → deliveries funnel
  - **Repeat customers**: percentage and count of customers with 2+ orders
  - **Average order value**: total revenue ÷ total orders
- **And** all analytics are computed from the seller's own data only (tenant-scoped)
- **And** analytics queries are optimized with materialized views or pre-computed aggregates refreshed daily
- **And** contextual insight surfaces load within ≤4s for up to 90 days of data (NFR-P5)
- **And** all monetary values are displayed in ₦ with proper Nigerian formatting
- **And** charts use the design system color tokens and are mobile-responsive
- **And** selecting an insight opens an inline detail panel or bottom sheet (not a dedicated MVP dashboard page)
- **And** any dedicated full analytics dashboard route is feature-gated for post-MVP/Growth
**Traceability:** FR=[FR50]; NFR=[NFR-P5]; ADR=[ADR-1a, ADR-1c]; AR=[None]; ENB=[None]
**FRs covered:** FR50
---
### Epic 9: Customer Engagement & Conversational Commerce

#### Story 9.1: Unified Inbox & Conversation Threading
As a **seller**,
I want a single inbox showing all customer conversations across Instagram and WhatsApp,
So that I never miss a message and can manage all customer communication from one screen.
**Depends on:** 7.5
**Acceptance Criteria:**
- **Given** a seller has connected Instagram and/or WhatsApp accounts (Epic 5)
- **When** they view the unified inbox
- **Then** all conversations are listed in a single feed, sorted by most recent message
- **And** each conversation shows: customer name/handle, platform icon (IG/WA), last message preview, timestamp, unread badge
- **And** conversations from different platforms for the same customer are threaded together when linkable (same phone/name)
- **And** the inbox supports: filtering by platform, filtering by unread/all, text search across messages
- **And** conversations are stored in a `conversations` table (tenant_id, customer_id, platform, last_message_at, unread_count, status: active/archived) with RLS
- **And** messages are stored in a `messages` table (tenant_id, conversation_id, sender_type: customer/seller/ai/system, content, media_url, platform_message_id, created_at) with RLS
- **And** incoming messages appear in real-time via SSE (Story 7.5) without page refresh
- **And** buyer-initiated messages are always ingested and displayed, even when seller outbound messaging limits are reached
- **And** the inbox loads within ≤3s showing the 50 most recent conversations (NFR-P2)
- **And** mobile layout: conversation list → tap → full conversation view (standard chat pattern)
- **And** cross-tenant isolation tests cover `conversations` and `messages`
**Traceability:** FR=[FR32, FR33, FR61]; NFR=[NFR-P2]; ADR=[ADR-3d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR32, FR33, FR61
---

#### Story 9.2: AI Auto-Response Engine
As a **seller**,
I want AI to automatically respond to common buyer questions using my business data,
So that customers get instant answers 24/7 without me typing every response.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a customer sends a message to the seller
- **When** the AI auto-response engine evaluates the message
- **Then** the AI classifies the message intent: product inquiry, price check, availability, shipping, returns, general greeting, order status, or unknown
- **And** for classified intents, the AI generates a response using the seller's RAG pipeline data (Business Profile + products + FAQs from Epic 5)
- **And** the response is calibrated to the seller's Brand Voice (Epic 6)
- **And** auto-responses are generated within ≤2s (NFR-P3)
- **And** the AI confidence score is attached to each auto-response (0-100)
- **Given** AI confidence is ≥80%
- **When** auto-response mode is set to "Auto-send"
- **Then** the response is sent automatically to the customer
- **And** the seller is notified of the auto-sent message with an option to review
- **Given** AI confidence is <80% or auto-response mode is "Suggest"
- **When** a draft response is generated
- **Then** the response appears in the inbox as a suggested reply the seller can: send as-is, edit then send, or discard
- **And** the seller can toggle between "Auto-send" and "Suggest" modes per conversation or globally
- **And** auto-response can be disabled for specific conversations or globally
- **And** all auto-responses are logged with the AI tier used, confidence score, and RAG sources consulted
**Traceability:** FR=[None]; NFR=[NFR-P3]; ADR=[ADR-3d, ADR-4a]; AR=[AR-CONV-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 9.3: Human Handoff & Escalation
As a **seller**,
I want AI to recognise when a conversation needs human attention and escalate automatically,
So that complex or emotional customer situations get my personal touch.
**Depends on:** None
**Acceptance Criteria:**
- **Given** the AI auto-response engine is processing a message
- **When** escalation triggers are detected
- **Then** the conversation is flagged for human handoff when: AI confidence is below 50%, customer expresses frustration/anger (sentiment analysis), customer explicitly asks for a human, the conversation involves a complaint or dispute, the message contains payment or refund topics
- **And** escalated conversations appear at the top of the inbox with a 🔴 escalation badge
- **And** the seller is notified immediately: "Customer {name} needs your attention — AI couldn't help"
- **Given** a conversation is escalated
- **When** the seller takes over
- **Then** AI auto-responses are paused for that conversation
- **And** the seller can resume AI assistance when the issue is resolved
- **And** the escalation reason is displayed for context
- **And** escalation events are logged in the conversation timeline
**And** escalation rules are configurable: sellers can add custom keywords/topics that trigger handoff
**And** escalation metrics are tracked: count, avg time to human response, resolution rate
**Traceability:** FR=[FR56]; NFR=[NFR-P3, NFR-R14]; ADR=[ADR-3d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR56
---

#### Story 9.4: AI/Human Message Attribution
As a **seller**,
I want every message in a conversation clearly labeled as sent by AI, me, or a team member,
So that I always know what's been communicated to my customers and by whom.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a conversation contains messages from multiple senders
- **When** the conversation is displayed
- **Then** each message shows a clear attribution badge: "AI" (auto-generated), "You" (seller), team member name, or "System" (auto-responses, notifications)
- **And** AI-generated messages show a subtle indicator (e.g., ⚡ icon) distinguishable from human messages
- **And** the `sender_type` field in the `messages` table accurately records: `customer`, `seller`, `ai`, `team_member`, `system`
- **And** team member messages show the responding team member's display name when applicable
- **And** system messages (after-hours auto-reply, order updates) are styled differently from human/AI messages
- **And** attribution is visible to the seller but NOT visible to the customer (customer sees all messages as from the business)
- **And** attribution cannot be forged or changed after message creation
**Traceability:** FR=[FR62]; NFR=[NFR-P3, NFR-R14]; ADR=[ADR-3d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR62
---

#### Story 9.5: Customer Labels & Segmentation
As a **seller**,
I want to label customers and create segments for targeted communication,
So that I can organize my customer base and send relevant messages to the right groups.
**Depends on:** 7.7
**Acceptance Criteria:**
- **Given** a seller has customer conversations
- **When** they manage customer labels
- **Then** customers are stored in a `customers` table (tenant_id, name, phone, email, platform, external_id, labels JSONB, total_orders, total_spent, first_contact_at, last_contact_at) with RLS
- **And** the seller can create custom labels: e.g., "VIP", "Wholesale", "New Lead", "Repeat Buyer"
- **And** labels are stored in a `customer_labels` table (tenant_id, label_name, color, created_at) with RLS
- **And** the seller can assign/remove labels on any customer via the conversation view or customer list
- **Given** labels are assigned to customers
- **When** the seller creates a segment 
- **Then** segments are defined by combining labels with AND/OR logic: e.g., "VIP AND Wholesale", "New Lead OR first order in last 7 days"
- **And** segments can also filter by: total_orders range, total_spent range, last_contact date range
- **And** segments are saved as named filters for reuse in segmented messaging (Epic 7 Story 7.7)
- **And** each segment shows an estimated recipient count in real-time
- **And** cross-tenant isolation tests cover `customers` and `customer_labels`
**Traceability:** FR=[FR59, FR60]; NFR=[NFR-P3, NFR-R14]; ADR=[ADR-3d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR59, FR60
---

#### Story 9.6: Quick Reply Templates & Saved Responses
As a **seller**,
I want quick reply templates and saved responses for common messages,
So that I can respond faster to frequent questions without typing the same answers repeatedly.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is in a conversation
- **When** they access quick replies
- **Then** a "/" command or button opens a searchable list of saved templates
- **And** the seller can create, edit, and delete templates with: title (for search), content (message text with placeholders like {customer_name}, {product_name}, {price})
- **And** templates are stored in a `reply_templates` table (tenant_id, title, content, category, usage_count, created_at) with RLS
- **And** templates support categories: greeting, product info, shipping, returns, payment, custom
- **And** placeholders are auto-filled from the conversation context when available
- **And** the top 5 most-used templates appear first in the list
- **And** AI can suggest the most relevant template based on the customer's last message
- **And** templates sync across devices (stored server-side, not local)
- **And** cross-tenant isolation tests cover `reply_templates`
**Traceability:** FR=[FR57, FR58]; NFR=[NFR-P3, NFR-R14]; ADR=[ADR-3d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR57, FR58
---

#### Story 9.7: Customer Purchase History & Conversation Insights
As a **seller**,
I want to see a customer's purchase history and conversation insights in the chat sidebar,
So that I have full context when responding to customers and can personalize my service.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller opens a customer conversation
- **When** the conversation detail view loads
- **Then** a sidebar panel shows the customer profile: name, platform, labels, first contact date, total orders, total spent (₦)
- **And** the sidebar shows recent orders: up to 5 most recent orders with status, amount, and date
- **And** the sidebar shows conversation insights: total messages, average response time, last interaction date
- **Given** a seller has conversation history with a customer
- **When** conversation insights are computed (FR55)
- **Then** average response time is calculated across all human-responded messages
- **And** message volume trends are shown (messages per day/week)
- **And** AI vs human response ratio is displayed
- **And** sentiment trend is shown if available (positive/neutral/negative over time)
- **And** the sidebar loads within ≤1s alongside the conversation
- **And** customer profile data is aggregated from orders (Epic 8) and conversations
- **And** all customer data is tenant-scoped
**Traceability:** FR=[FR55]; NFR=[NFR-P3, NFR-R14]; ADR=[ADR-3d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR55
---

### Epic 10: Payment, Subscription & Billing Operations

#### Story 10.1: Payment Link Generation (Paystack)
As a **seller**,
I want to generate Paystack payment links for my products and orders,
So that customers can pay securely with one tap from our conversation.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has a Paystack account connected (API keys configured in settings)
- **When** they generate a payment link via `POST /api/v1/payments/links`
- **Then** a payment link is created via the Paystack API with: amount (₦), product/order reference, customer email (optional), metadata
- **And** the generated link is stored in a `payment_links` table (tenant_id, order_id, paystack_reference, amount, currency: NGN, status, link_url, expires_at, created_at) with RLS
- **And** the link is shareable: copy to clipboard, send via WhatsApp/Instagram DM with one tap
- **And** each payment link is wrapped in a MarketBoss tracking URL and click events are logged for attribution
- **And** payment links expire after 24 hours by default (configurable)
- **And** the payment page is Paystack-hosted (not custom) for PCI compliance
- **And** Paystack API keys are encrypted with AES-256 and stored in a `payment_configs` table (tenant_id, provider, api_key_enc, created_at) with RLS
- **And** API keys are NEVER exposed in API responses or logged
- **And** cross-tenant isolation tests cover `payment_links` and `payment_configs`
**Traceability:** FR=[FR42, FR45]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR42, FR45
---

#### Story 10.2: Payment Status Tracking & Webhooks
As a **seller**,
I want real-time payment status updates and automatic order confirmation on payment,
So that I know immediately when a customer pays and can process their order without manual checking.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a payment link has been shared with a customer
- **When** the customer completes payment on Paystack
- **Then** a Paystack webhook is received at `POST /api/v1/webhooks/paystack`
- **And** the webhook is verified using the Paystack webhook secret (HMAC-SHA512)
- **And** the webhook is processed idempotently using the Paystack reference ID
- **And** the payment status in `payment_links` is updated to: `paid`, `failed`, or `abandoned`
- **And** on successful payment, the associated order's `payment_status` is updated to `paid`
- **And** a digital receipt is generated with seller identity, order/product details, amount, and support contact
- **And** verified sellers display a Verification Badge on receipts and payment links 
- **And** the seller is notified in real-time: "Payment of ₦{amount} received for order {number}"
- **And** payment events are published to Redis Streams for real-time UI updates
- **Given** a customer has not paid after a configurable period
- **When** 2 hours have elapsed since the link was shared
- **Then** an optional payment reminder is sent to the customer (seller can enable/disable)
- **And** if the link expires unpaid, the seller is notified
- **And** billing lifecycle notifications are issued for grace-period start, downgrade warning, and suspension warning based on seller preferences
- **And** payment tracking events are logged in a `payment_events` table (tenant_id, payment_id, event_type, metadata JSONB, created_at) with RLS
- **And** cross-tenant isolation tests cover `payment_events`
**Traceability:** FR=[FR105, FR43, FR44, FR51]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR43, FR44, FR51, FR105
---

#### Story 10.3: Payment Provider Outage Fallback

As a **seller**,
I want an automatic fallback payment option when the primary provider is unavailable,
So that I can still collect payments during provider outages.
**Depends on:** 10.1, 10.2
**Acceptance Criteria:**

- **Given** primary payment-provider health checks fail repeatedly or checkout initialization returns provider-unavailable
- **When** fallback mode is activated
- **Then** affected checkout flows switch to a bank-transfer fallback within 60 seconds
- **And** fallback instructions include account name, account number, bank name, amount, and unique payment reference
- **And** the seller and buyer are notified that fallback mode is active and primary checkout will resume automatically when recovered
- **And** fallback payment attempts are logged with status `pending_manual_confirmation` in `payment_events`
- **Given** fallback mode is active
- **When** provider health remains stable for 5 consecutive minutes
- **Then** primary provider checkout is restored automatically for new payment links
- **And** fallback-mode events remain auditable with start/end timestamps
**Traceability:** FR=[FR49]; NFR=[NFR-R9, NFR-P4]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR49
---
#### Story 10.4: Installment Payments & Partial Payments
As a **seller**,
I want to offer installment plans and accept partial payments,
So that I can make higher-priced items accessible to more customers.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller creates an order for a higher-priced item
- **When** they enable installment payment 
- **Then** they can split the total into 2-4 installments with dates for each
- **And** each installment generates its own payment link
- **And** installment plans are stored in an `installment_plans` table (tenant_id, order_id, total_amount, installment_count, status, created_at) with RLS
- **And** individual installments are stored: (plan_id, installment_number, amount, due_date, payment_id, status: pending/paid/overdue)
- **And** overdue installments are flagged and the seller is notified
- **Given** a customer makes a partial payment 
- **When** the payment amount is less than the order total
- **Then** the partial payment is recorded and the remaining balance is tracked
- **And** the order status reflects: "Partially paid (₦{paid} of ₦{total})"
- **And** a follow-up payment link is auto-generated for the remaining balance
- **And** the seller can view all partial payments against an order
- **And** cross-tenant isolation tests cover `installment_plans`
**Traceability:** FR=[FR47]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR47
---

#### Story 10.5: Payment Reconciliation & Reports
As a **seller**,
I want daily payment reconciliation and downloadable financial reports,
So that I can track all money flowing through my business and reconcile with my bank.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has payment history
- **When** they view payment reconciliation
- **Then** a daily summary shows: total payments received, total refunds, net revenue, transaction count
- **And** each transaction is listed with: date, customer, amount, method, status, Paystack reference
- **And** the seller can filter by: date range, payment status, payment method
- **And** the billing summary shows current subscription plan, renewal date, and usage counters
- **Given** a seller needs financial reports 
- **When** they export reports
- **Then** CSV and PDF export options are available for the filtered transaction list
- **And** the PDF report includes: summary totals, transaction table, and date range
- **And** generated invoices/receipts include seller business branding (business name, logo, contact details)
- **And** scheduled weekly/monthly email reports can be configured
- **And** reconciliation data is computed from `payment_links` and `payment_events` tables
- **And** reports load within ≤5s for up to 12 months of data
- **And** all amounts are in ₦ with proper Nigerian formatting
**Traceability:** FR=[FR109, FR112, FR54]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR54, FR109, FR112
---

#### Story 10.6: Refund Processing via Paystack
As a **seller**,
I want to process refunds through Paystack from within MarketBoss,
So that I can handle returns without logging into a separate payment dashboard.
**Depends on:** 8.6
**Acceptance Criteria:**
- **Given** a paid order has a return approved (Epic 8 Story 8.6)
- **When** the seller initiates a refund
- **Then** a refund is created via the Paystack Refund API for the original transaction
- **And** the refund supports: full refund or partial refund amount
- **And** refund status is tracked: `initiated` → `processing` → `completed` → `failed`
- **And** on successful refund, the order's payment status updates to `refunded` or `partially_refunded`
- **And** the seller is notified when the refund completes
- **And** refund events are logged in `payment_events` with type: `refund`
- **And** refund failures are retried once automatically; on second failure, the seller is notified to process manually
**Traceability:** FR=[None]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[AR-PAY-REFUND-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 10.7: Payment Dispute Handling & Security
As a **seller**,
I want to be notified of payment disputes and have secure handling of all payment data,
So that I can respond to chargebacks promptly and comply with financial regulations.
**Depends on:** 4.5
**Acceptance Criteria:**
- **Given** Paystack receives a dispute/chargeback for a transaction
- **When** the dispute webhook is received
- **Then** the seller is immediately notified: "Payment dispute received for order {number} — respond within 7 days"
- **And** the dispute is stored in a `payment_disputes` table (tenant_id, payment_id, reason, amount, deadline, status, created_at) with RLS
- **And** the seller can view dispute details and submit evidence (text response + document upload)
- **And** dispute resolution status is tracked: `open` → `evidence_submitted` → `won` → `lost`
- **Given** payment data is handled
- **When** security measures are evaluated
- **Then** no raw card data touches MarketBoss servers (Paystack handles PCI compliance)
- **And** all Paystack API keys and webhook secrets are encrypted at rest (AES-256)
- **And** payment webhook endpoints validate signatures before processing
- **And** payment operations are logged in the immutable audit trail (Epic 4 Story 4.5)
- **And** cross-tenant isolation tests cover `payment_disputes`
**Traceability:** FR=[None]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[AR-PAY-DISPUTE-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 10.8: Billing Notification Channel Preferences
As a **seller**,
I want to configure billing notification channels per event type,
So that I receive payment and billing updates on the channels that work best for me.
**Depends on:** 10.2
**Acceptance Criteria:**
- **Given** a seller opens billing notification settings
- **When** they configure preferences for billing events
- **Then** they can enable/disable push, WhatsApp, SMS, and email per event type (payment received, grace warning, downgrade, suspension, invoice issued)
- **And** preferences are stored in `notification_preferences` scoped by tenant and user
- **And** channel selection validates availability (e.g., WhatsApp requires connected number, SMS requires verified phone)
- **And** delivery attempts follow the critical-event fallback rule (primary + fallback channel within 5 minutes)
- **And** preference updates are audited with actor, timestamp, and changed fields
**Traceability:** FR=[FR104]; NFR=[NFR-R14, NFR-P10]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR104
---

#### Story 10.9: Subscription Tier Upgrade/Downgrade
As a **seller**,
I want to upgrade or downgrade my subscription tier with clear impact preview,
So that I can choose the right plan without billing surprises.
**Depends on:** 10.5
**Acceptance Criteria:**
- **Given** a seller is on the billing plan page
- **When** they select a new tier
- **Then** the UI shows current vs new limits (posts, messages, products, connected accounts) before confirmation
- **And** the change flow shows proration/next-charge impact and effective-date behavior
- **And** upgrade changes apply immediately after successful payment authorization
- **And** downgrade changes apply at cycle boundary unless seller confirms immediate downgrade rules
- **And** tier changes are persisted in billing records and emitted as auditable events
- **And** sellers receive confirmation notifications through their configured billing channels
**Traceability:** FR=[FR110]; NFR=[NFR-P4, NFR-S5]; ADR=[ADR-2d, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR110
---
### Epic 11: Team Collaboration & Role Management

#### Story 11.1: Role-Based Team Member Management
As a **seller (business owner)**,
I want to invite team members with specific roles and permissions,
So that I can delegate customer support and content creation while controlling what each person can access.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is the tenant owner
- **When** they invite a team member via `POST /api/v1/team/invite`
- **Then** an invitation email is sent with a unique sign-up link tied to the tenant
- **And** the team member registers using the link and is associated with the tenant as the assigned role
- **And** available roles are: Owner (full access), Manager (all except billing/team management), Agent (conversations only), Content Creator (content + products only)
- **And** roles and permissions are stored in a `team_members` table (tenant_id, user_id, role, invited_by, status: pending/active/deactivated, created_at) with RLS
- **And** permissions are enforced at the API level: each endpoint checks the caller's role against required permissions (FR81)
- **And** the owner can update roles, deactivate team members, and revoke access
- **And** deactivated team members cannot log in and their active sessions are terminated
- **And** a permissions matrix is documented: which role can access which endpoints/features
- **And** permission checks are unit-tested for each role
- **And** cross-tenant isolation tests ensure team members cannot access other tenants' data
**Traceability:** FR=[FR71, FR72, FR73, FR81]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR71, FR72, FR73, FR81
---

#### Story 11.2: Conversation Assignment & Transfer
As a **seller or manager**,
I want to assign conversations to team members and transfer between them,
So that the right person handles each customer and workload is distributed fairly.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a conversation exists in the unified inbox
- **When** the seller or manager assigns it to a team member
- **Then** the conversation's `assigned_to` field is set in the `conversations` table
- **And** the assigned team member is notified: "New conversation assigned: {customer_name}"
- **And** only the assigned member (and owner/manager) can respond to the conversation
- **And** the assignment is logged in the conversation timeline
- **Given** a team member needs to transfer a conversation
- **When** they transfer to another team member (FR82)
- **Then** the `assigned_to` is updated and the new assignee is notified
- **And** the previous handler's context (customer notes, recent messages) is preserved
- **And** transfer history is tracked in the conversation timeline
- **Given** conversations are unassigned
- **When** team members view the inbox
- **Then** unassigned conversations appear in a shared "Unassigned" queue visible to all agents
- **And** team members can claim conversations from the unassigned queue
- **And** customizable auto-response messages are available per team member (FR83)
**Traceability:** FR=[FR74, FR75, FR76, FR82, FR83]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR74, FR75, FR76, FR82, FR83
---

#### Story 11.3: Internal Notes & Team Communication
As a **team member**,
I want to leave internal notes on conversations visible only to the team,
So that I can share context about customers without the customer seeing it.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a team member is viewing a conversation
- **When** they add an internal note 
- **Then** the note is stored in the `messages` table with `sender_type: internal_note` and `is_internal: true`
- **And** internal notes are displayed with a distinct visual style (yellow background, "Internal" badge)
- **And** internal notes are NEVER sent to the customer and NEVER visible on external platforms
- **And** notes support @mentions of team members, which trigger notifications
- **Given** a team needs to communicate about a conversation
- **When** they use the internal notes thread 
- **Then** multiple team members can add sequential notes forming an internal discussion
- **And** @mentioned team members receive a notification with the note content
- **And** internal notes are searchable within the conversation
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[AR-COLLAB-NOTES-1]; ENB=[None]
**FRs covered:** None (Foundational/Additional)
---

#### Story 11.4: Team Performance Analytics
As a **seller (business owner)**,
I want to see how each team member is performing,
So that I can identify training needs and reward high performers.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a team has been active for a measurable period
- **When** the owner/manager views team performance analytics (FR78)
- **Then** the dashboard shows per team member for a selectable period (7d, 30d, 90d):
  - Conversations handled count
  - Average response time (time from customer message to team member response)
  - Customer satisfaction (average rating from feedback)
  - Messages sent count
  - Escalations handled count
  - Active hours (approximate based on activity)
- **And** a team leaderboard ranks team members by response time and conversations handled
- **And** the data is computed from `messages`, `conversations`, and `customer_feedback` tables
- **And** analytics are only visible to Owner and Manager roles
- **And** the dashboard loads within ≤5s
**Traceability:** FR=[FR78]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR78
---

#### Story 11.5: Workload-Based Auto-Assignment
As a **seller (business owner)**,
I want new conversations automatically assigned to the team member with the lightest workload,
So that work is distributed evenly without manual assignment for every conversation.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a new conversation arrives (customer sends first message)
- **When** auto-assignment is enabled
- **Then** the conversation is assigned to the online team member with the fewest active (non-archived) conversations
- **And** if multiple members have equal workload, round-robin is used
- **And** the assigned member is notified immediately
- **And** auto-assignment respects team member availability: members marked as "offline" or "away" are skipped
- **And** auto-assignment can be configured: enabled/disabled, include/exclude specific members, working hours only
- **And** auto-assignment is logged in the conversation timeline: "Auto-assigned to {member_name}"
**Traceability:** FR=[None]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[AR-WORKLOAD-1]; ENB=[None]
**FRs covered:** None (Additional)
---
#### Story 11.6: Team Activity Audit Log
As a **seller (business owner)**,
I want a complete audit log of all team actions,
So that I can monitor team activity and investigate any issues.
**Depends on:** None
**Acceptance Criteria:**
- **Given** any team member performs an action in the system
- **When** the action is executed
- **Then** the action is logged in a `team_audit_log` table (tenant_id, user_id, action_type, resource_type, resource_id, metadata JSONB, created_at) with RLS
- **And** logged actions include: message sent, conversation assigned/transferred, order created/updated, product created/updated, payment processed, team member invited/deactivated
- **And** the audit log is viewable by Owner and Manager roles only (FR77)
- **Given** an owner views the audit log
- **When** the log is displayed
- **Then** entries are filterable by: team member, action type, date range
- **And** each entry shows: timestamp, team member name, action description, resource reference
- **And** the audit log is immutable (no UPDATE or DELETE) (FR77)
- **And** the log supports pagination for large datasets
- **And** cross-tenant isolation tests cover `team_audit_log`
**Traceability:** FR=[FR77]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR77
---

#### Story 11.7: Emergency Pause Auto-Replies
As a **team member with appropriate permissions**,
I want to activate an emergency "Pause Auto-Replies" control,
So that I can immediately stop automated replies during sensitive or high-risk conversations.
**Depends on:** None
**Acceptance Criteria:**
- **Given** auto-replies are enabled for a tenant
- **When** an authorized team member triggers `POST /api/v1/team/auto-replies/pause`
- **Then** all AI auto-replies for that tenant are paused immediately
- **And** incoming conversations are still ingested and visible in the inbox
- **And** outbound automated messages are blocked until resume is explicitly requested
- **And** a visible tenant-wide banner is shown: "Auto-replies paused"
- **And** pause/resume actions are logged in `team_audit_log` with actor, timestamp, and reason
- **And** only Owner and Manager roles can resume auto-replies
**Traceability:** FR=[FR79]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR79
---

#### Story 11.8: Catalog Staleness Warning (6+ Hours)
As a **seller (business owner)**,
I want a warning when my product catalog has not been updated for 6+ hours,
So that I can refresh product data before stale information affects AI replies and sales.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has an active product catalog
- **When** no catalog update (create/edit/stock/price change) occurs for 6+ hours
- **Then** the system raises a staleness warning in feed/home surfaces and settings
- **And** the warning includes last-update timestamp and a one-tap action to open catalog management
- **And** warning severity escalates after 24 hours of inactivity
- **And** staleness checks run at least every 30 minutes via background job
- **And** warning events are stored in `catalog_staleness_events` (tenant_id, detected_at, last_catalog_update_at, severity, resolved_at)
**Traceability:** FR=[FR80]; NFR=[NFR-S9, NFR-S10]; ADR=[ADR-2c, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR80
---
### Epic 12: Growth Insights & Contextual Analytics

#### Story 12.1: Contextual Engagement Metrics Surfaces
As a **seller**,
I want to see how my social posts perform across platforms,
So that I know what content resonates and can create more effective posts.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has published posts
- **When** they view engagement insights in home/feed/inbox contextual surfaces
- **Then** contextual cards show per-post metrics: likes, comments, shares, saves, reach, impressions
- **And** engagement data is fetched from Instagram Insights API and stored in a `post_metrics` table (tenant_id, post_id, platform, metric_type, value, fetched_at) with RLS
- **And** metrics are refreshed daily via a background job (not real-time)
- **And** aggregate insights show: total engagement rate, average engagement per post, best-performing posts
- **And** selecting a card opens an inline trend view (line/bar charts) without requiring a dedicated MVP dashboard page
- **And** engagement insights are filterable by platform, date range, and post type
- **And** contextual insight surfaces load within ≤4s
- **And** dedicated analytics dashboard routes remain feature-gated for post-MVP/Growth
**Traceability:** FR=[FR64]; NFR=[NFR-P5]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR64
---
#### Story 12.2: AI vs Human Performance Comparison
As a **seller**,
I want to compare AI-generated content performance against my manually created content,
So that I can see the value AI adds and optimize my content strategy.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has both AI-generated and manually created posts
- **When** they view the AI vs Human comparison 
- **Then** a side-by-side comparison shows: average engagement rate, average reach, average conversion (inquiry/order rate) for AI posts vs manual posts
- **And** the comparison covers: same time period, same post types, same products where possible
- **Given** AI auto-responses are active
- **When** AI response effectiveness is measured 
- **Then** metrics show: AI response rate (% of conversations handled entirely by AI), customer satisfaction on AI-handled conversations, escalation rate, average AI confidence score
- **And** a trend line shows AI effectiveness improving over time as Brand Voice training accumulates
- **And** all comparison data is tenant-scoped
- **And** the analytics page uses design system tokens and is mobile-responsive
**Traceability:** FR=[FR65]; NFR=[NFR-P5, NFR-P10]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR65
---

#### Story 12.3: Revenue Attribution & ROI Tracking
As a **seller**,
I want to see which posts and conversations drive the most revenue,
So that I can focus on high-value content and maximize my return on investment.
**Depends on:** 5.8
**Acceptance Criteria:**
- **Given** a seller has posts, conversations, and orders
- **When** they view revenue attribution 
- **Then** the system tracks the chain: post → customer inquiry → order → payment
- **And** each post shows attributed revenue: total ₦ from orders traced back to that post
- **And** each conversation shows attributed revenue: total ₦ from orders created during that conversation
- **Given** revenue is attributed
- **When** ROI tracking is computed 
- **Then** ROI shows: total AI costs (from `tenant_ai_budgets`) vs total attributed revenue
- **And** ROI is displayed as: "For every ₦1 spent on AI, you earned ₦{X}"
- **And** before/after comparison uses the pre-MarketBoss baseline metrics captured during onboarding (Epic 5 Story 5.8)
- **And** attribution data is pre-computed daily as a background job
- **And** the dashboard loads within ≤5s
**Traceability:** FR=[FR66]; NFR=[NFR-P5, NFR-P10]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR66
---

#### Story 12.4: Growth Trend Analysis & Recommendations
As a **seller**,
I want to see my growth trajectory and get AI-powered recommendations,
So that I can understand what's working and take action to grow faster.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has accumulated performance data over weeks
- **When** they view growth analysis 
- **Then** line charts show: follower growth, engagement rate trend, revenue trend, order volume trend over time
- **And** each metric shows a percentage change vs previous period
- **Given** growth data is available
- **When** AI recommendations are generated 
- **Then** the system produces 3-5 actionable recommendations: e.g., "Your Tuesday posts get 2x engagement — schedule more for Tuesdays", "Product X drives 40% of revenue — create more content for it", "Response time has increased — consider enabling AI auto-responses"
- **And** recommendations are generated weekly by the AI router (Tier 1)
- **And** recommendations are stored in a `growth_recommendations` table (tenant_id, recommendation_text, category, generated_at) with RLS
- **And** the seller can dismiss or mark recommendations as "done"
**Traceability:** FR=[FR67]; NFR=[NFR-P5, NFR-P10]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR67
---

#### Story 12.5: Customer Behavior Analytics
As a **seller**,
I want to understand my customer demographics and behavior patterns,
So that I can tailor my products and marketing to who's actually buying.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has customer data from conversations and orders
- **When** they view customer analytics 
- **Then** the dashboard shows:
  - Customer acquisition trend: new customers per week/month
  - Customer retention: repeat purchase rate
  - Average customer lifetime value (₦)
  - Top customers by spend
  - Platform distribution: % from Instagram vs WhatsApp
  - Peak engagement times: when do customers most frequently message
- **And** all customer analytics are computed from `customers`, `orders`, and `conversations` tables
- **And** analytics are tenant-scoped (no cross-tenant data)
- **And** the dashboard loads within ≤5s
**Traceability:** FR=[FR68]; NFR=[NFR-P5, NFR-P10]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR68
---

#### Story 12.6: Content Performance Insights
As a **seller**,
I want detailed insights into which content types and topics perform best,
So that I can optimize my content strategy based on data.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller has published multiple types of content
- **When** they view content performance insights 
- **Then** the dashboard shows performance by:
  - Content type: product showcase vs promotion vs engagement vs story
  - Tone: professional vs casual vs playful
  - Time of day posted
  - Day of week posted
  - Product category
  - Caption length correlation with engagement
- **And** a "best practices" summary highlights: optimal posting time, best-performing tone, ideal caption length range
- **And** insights are refreshed daily from `post_metrics` and `content_drafts` data
- **And** the dashboard is mobile-responsive with swipeable chart cards
**Traceability:** FR=[FR69]; NFR=[NFR-P5, NFR-P10]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR69
---

#### Story 12.7: Report Export & Scheduled Reports
As a **seller**,
I want to export analytics reports and schedule automatic report delivery,
So that I can share performance data with stakeholders and track progress without logging in daily.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a seller is viewing any analytics dashboard
- **When** they click "Export" 
- **Then** the current view is exportable as CSV (data tables) or PDF (formatted report with charts)
- **And** the PDF includes: report title, date range, summary metrics, and all visible charts
- **And** exports complete within ≤10s
- **Given** a seller wants automated reports
- **When** they configure scheduled reports 
- **Then** they can set: report type (sales, engagement, team performance), frequency (weekly, monthly), delivery method (email), format (PDF)
- **And** scheduled reports are generated and emailed on the configured schedule
- **And** report schedules are stored in a `scheduled_reports` table (tenant_id, report_type, frequency, format, recipient_email, next_run_at) with RLS
- **Given** a seller wants custom date ranges 
- **When** they select a custom range
- **Then** all dashboards support: 7d, 30d, 90d, 12m, and custom date picker
- **And** comparison mode is available: "vs previous period" overlay on all charts
- **And** cross-tenant isolation tests cover `scheduled_reports`
**Traceability:** FR=[FR70]; NFR=[NFR-P5, NFR-P10]; ADR=[ADR-1d, ADR-4a]; AR=[None]; ENB=[None]
**FRs covered:** FR70
---

### Epic 13: Platform Administration & Compliance

#### Story 13.1: Super Admin Dashboard & Tenant Overview
As a **super admin**,
I want a platform-wide dashboard showing all tenants and system health,
So that I can monitor the platform's performance and proactively address issues.
**Depends on:** 4.5
**Acceptance Criteria:**
- **Given** a super admin authenticates (MFA required per NFR-S10)
- **When** they access the admin dashboard
- **Then** the dashboard shows:
  - Total active tenants, new tenants this week/month
  - Platform-wide metrics: total orders, total revenue processed, total AI requests
  - System health: API response time p95, error rate, database connection pool, Redis status
  - Resource usage: storage consumed, API calls by tenant
- **And** a tenant list shows all tenants with: name, plan, created date, last active, status (FR87)
- **And** each tenant has a detail view showing their profile, usage stats, compliance status (FR89)
- **And** the admin dashboard is accessible only to users with `super_admin` role
- **And** super admin role bypasses tenant-scoped RLS (uses a separate database role)
- **And** all admin actions are logged in the immutable security audit log (Epic 4 Story 4.5)
**Traceability:** FR=[FR84, FR86, FR87, FR89, FR90]; NFR=[NFR-S10]; ADR=[ADR-2c, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR84, FR86, FR87, FR89, FR90
---

#### Story 13.2: Tenant Suspension & Health Monitoring
As a **super admin**,
I want to suspend tenants that violate policies and monitor tenant health,
So that the platform remains safe and I can identify tenants needing support.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a super admin identifies a policy violation
- **When** they suspend a tenant (FR88)
- **Then** the tenant's status is changed to `suspended`
- **And** all active sessions for the tenant's users are terminated
- **And** the tenant's social API operations (publishing, messaging) are paused
- **And** the tenant owner is notified via email with: reason, steps to resolve, appeal process
- **And** suspended tenant data is preserved (not deleted) for up to 90 days
- **Given** the platform is running
- **When** tenant health monitoring runs (FR91)
- **Then** the system monitors: API error rates per tenant, failed webhook deliveries, token expiry status, storage usage
- **And** tenants exceeding thresholds (e.g., >5% error rate, nearing storage limits) are flagged for admin review
- **And** health status is shown on the tenant list: 🟢 Healthy, 🟡 Warning, 🔴 Critical
**Traceability:** FR=[FR88, FR91]; NFR=[NFR-S10, NFR-S6]; ADR=[ADR-2c, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR88, FR91
---

#### Story 13.3: System Configuration & Feature Flags
As a **super admin**,
I want to manage system-wide configuration and toggle features per tenant,
So that I can roll out features gradually and manage platform behavior without code deployments.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a super admin needs to change system behavior
- **When** they access system configuration (FR100)
- **Then** they can update global settings: default AI budget limits, rate limiting thresholds, security parameters, maintenance mode toggle
- **And** configuration changes take effect immediately (no restart required)
- **And** configuration is stored in a `system_config` table with version tracking
- **Given** a super admin wants to control feature availability
- **When** they manage feature flags (FR100)
- **Then** they can toggle features per tenant or globally: AI auto-responses, image generation, batch generation, installment payments, team collaboration
- **And** feature toggles are evaluated at runtime via the middleware stack
- **And** tier-based limits (daily posts, messages, products, connected accounts) are enforced server-side on all request paths
- **And** feature flag state is cached in Redis with a 60-second TTL
- **And** feature flag changes are logged in the admin audit log
**Traceability:** FR=[FR100, FR101, FR103, FR111, FR99]; NFR=[NFR-S10, NFR-S6]; ADR=[ADR-2c, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR99, FR100, FR101, FR103, FR111
---

#### Story 13.4: Compliance Document Review Workflow
As a **super admin**,
I want to review and approve/reject compliance documents submitted by sellers,
So that regulated sellers can start operating and the platform stays legally compliant.
**Depends on:** 5.6
**Acceptance Criteria:**
- **Given** a seller uploaded compliance documents during onboarding (Epic 5 Story 5.6)
- **When** a super admin reviews the documents (FR85)
- **Then** a review queue shows pending documents: seller name, category, document type, upload date, thumbnail
- **And** the admin can: download the document, approve (seller proceeds), reject with reason (seller must re-upload)
- **And** document review status is updated in the `compliance_documents` table
- **And** the seller is notified of the review outcome via email and in-app notification
- **And** approved sellers can list products in the regulated category
- **And** rejected sellers see: "Certification rejected: {reason} — please re-upload"
- **And** sellers can submit NDPA consent-withdrawal requests by consent type, with request status tracked and timestamped
- **And** review decisions are logged in the admin audit log with the reviewer's ID
**Traceability:** FR=[FR102, FR108, FR85, FR92, FR93, FR94, FR95]; NFR=[NFR-S10, NFR-S6]; ADR=[ADR-2c, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR85, FR92, FR93, FR94, FR95, FR102, FR108
---

#### Story 13.5: Platform-Wide Analytics & Reporting
As a **super admin**,
I want platform-level analytics and reports for business decisions,
So that I can track growth, identify trends, and report to stakeholders.
**Depends on:** None
**Acceptance Criteria:**
- **Given** a super admin views platform analytics (FR96)
- **When** the dashboard loads
- **Then** it shows:
  - Tenant growth: new signups, active tenants, churn rate over time
  - Revenue metrics: total payment volume processed, average revenue per tenant
  - AI usage: total AI requests, cost by tier, average cost per tenant
  - Platform health: uptime percentage, p95 latency trend, error rate trend
  - Feature adoption: % of tenants using AI auto-responses, scheduling, payments, team features
- **Given** a super admin needs reports (FR97)
- **When** they export platform reports
- **Then** CSV and PDF exports are available for all metrics
- **And** the report includes a platform summary dashboard and detailed breakdowns
- **And** reports are schedulable (weekly/monthly email to admin team)
- **And** all platform analytics aggregate across tenants (no individual tenant data in platform reports)
**Traceability:** FR=[FR96, FR97, FR98]; NFR=[NFR-S10, NFR-S6]; ADR=[ADR-2c, ADR-3c]; AR=[None]; ENB=[None]
**FRs covered:** FR96, FR97, FR98





