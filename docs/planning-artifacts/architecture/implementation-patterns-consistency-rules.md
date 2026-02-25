# Implementation Patterns & Consistency Rules

Patterns ensuring multiple AI agents write compatible, consistent code.

### Naming Patterns

#### Database Naming (PostgreSQL)

| Element | Convention | Example |
| --- | --- | --- |
| Tables | `snake_case`, plural | `products`, `message_drafts`, `payment_links` |
| Columns | `snake_case` | `created_at`, `tenant_id`, `brand_voice_config` |
| Primary keys | `id` (UUID) | `id UUID DEFAULT gen_random_uuid()` |
| Foreign keys | `{table_singular}_id` | `product_id`, `tenant_id`, `user_id` |
| Indexes | `idx_{table}_{columns}` | `idx_products_tenant_id_created_at` |
| Constraints | `{type}_{table}_{columns}` | `uq_users_email`, `chk_products_price_positive` |
| RLS policies | `{table}_{action}_tenant` | `products_select_tenant`, `messages_insert_tenant` |
| Migrations | `{timestamp}_{action}_{subject}.sql` | `20260219_create_products.up.sql` |
| Enums | `snake_case` type, `UPPER_CASE` values | `CREATE TYPE plan_tier AS ENUM ('FREE', 'STARTER', 'PRO')` |

#### API Naming (REST)

| Element | Convention | Example |
| --- | --- | --- |
| Endpoints | `kebab-case`, plural | `/api/v1/products`, `/api/v1/message-drafts` |
| Route params | `{snake_case}` | `/api/v1/products/{product_id}` |
| Query params | `snake_case` | `?page_size=20&sort_by=created_at` |
| Headers | `X-MarketBoss-{PascalCase}` | `X-MarketBoss-TenantId`, `X-MarketBoss-RequestId` |
| JSON fields | `snake_case` | `{ "product_id": "...", "created_at": "..." }` |
| API versioning | URL path prefix | `/api/v1/`, `/api/v2/` |

#### Go Code Naming

| Element | Convention | Example |
| --- | --- | --- |
| Packages | `lowercase`, single word | `product`, `messaging`, `payment` |
| Exported types | `PascalCase` | `Product`, `MessageDraft`, `TenantConfig` |
| Unexported | `camelCase` | `validatePrice`, `tenantFromCtx` |
| Interfaces | `PascalCase` + verb-er | `ProductRepository`, `DraftGenerator`, `PaymentGateway` |
| Interface impls | `PascalCase` + adapter name | `PostgresProductRepository`, `DeepSeekDraftGenerator` |
| Errors | `Err{Name}` | `ErrProductNotFound`, `ErrInsufficientCredits` |
| Constants | `PascalCase` (exported) / `camelCase` (unexported) | `MaxDraftsPerMinute`, `defaultPageSize` |
| Test files | `{file}_test.go` | `product_service_test.go` |
| Constructors | `New{Type}` | `NewProductService(repo, cache)` |

#### Frontend Code Naming (Next.js / React / TypeScript)

| Element | Convention | Example |
| --- | --- | --- |
| Components | `PascalCase` file + export | `ProductCard.tsx`, `DraftBox.tsx` |
| Hooks | `use{Name}` | `useProducts.ts`, `useDraftGenerator.ts` |
| Utilities | `camelCase` file + export | `formatCurrency.ts`, `parseDate.ts` |
| Types/Interfaces | `PascalCase` | `Product`, `MessageDraft`, `ApiError` |
| Constants | `UPPER_SNAKE_CASE` | `MAX_FEED_ITEMS`, `API_BASE_URL` |
| CSS classes | `kebab-case` (Tailwind) | `product-card`, `draft-box-expanded` |
| Route files | Next.js App Router | `app/(dashboard)/products/page.tsx` |
| API hooks | `hooks/api/` | `hooks/api/useProducts.ts` |
| Generated types | `types/generated/` | `types/generated/api.ts` (never hand-edit) |

### Structure Patterns

#### Backend Project Structure (Go Clean Architecture)

```text
backend/
├── cmd/api/main.go                          # Entry point, DI wiring
├── internal/
│   ├── domain/{feature}/                       # Business entities & rules (ZERO external imports)
│   │   ├── entity.go                           # Structs, value objects
│   │   ├── repository.go                       # Repository interface (port)
│   │   └── errors.go                           # Domain-specific errors
│   ├── service/{feature}/                      # Application use cases (orchestration)
│   │   ├── service.go                          # Calls repo + cache + events
│   │   └── service_test.go                     # Unit tests with mocked ports
│   ├── adapter/                                # Infrastructure implementations
│   │   ├── postgres/                           # PostgreSQL repos + sqlc generated + migrations
│   │   ├── redis/                              # Cache + event bus (Redis Streams)
│   │   ├── ai/                                 # DeepSeek, Gemini, GPT-4o adapters
│   │   └── platform/                           # Instagram, WhatsApp adapters
│   └── handler/                                # HTTP handlers + middleware
│       ├── middleware/                          # auth, ratelimit, tenant
│       ├── {feature}_handler.go
│       ├── sse_handler.go
│       └── webhook_handler.go
├── db/queries/*.sql                            # Raw SQL for sqlc
├── backend/docs/events/*.json                  # Event schema registry
├── api/openapi.yaml                            # OpenAPI 3.1 spec (source of truth)
├── Makefile, Dockerfile, go.mod
```

Import rules: `domain/` → zero imports | `service/` → imports `domain/` only | `adapter/` → implements `domain/` interfaces | `handler/` → calls `service/`, never `adapter/`

#### Frontend Project Structure (Next.js 16 App Router)

```text
frontend/
├── app/
│   ├── (auth)/login, register/                 # Auth route group
│   ├── (dashboard)/                            # Main app (feed, messages, products, payments, settings)
│   ├── api/v1/[...proxy]/route.ts              # Thin BFF proxy to Go backend
│   ├── layout.tsx                              # Root layout (providers, fonts)
│   └── globals.css                             # Tailwind base + design tokens
├── components/
│   ├── ui/                                     # shadcn/ui primitives (auto-generated, never hand-edit)
│   ├── {feature}/                              # Feature-grouped components
│   └── shared/                                 # Cross-feature reusable (LoadingSkeleton, ErrorBoundary)
├── hooks/api/                                  # TanStack Query hooks (one per resource)
├── stores/appStore.ts                          # Single Zustand store (client-only state)
├── types/generated/api.ts                      # OpenAPI-generated types (never hand-edit)
├── lib/                                        # API client, formatters, constants
└── public/sw.ts                                # @serwist/next service worker
```

#### Test Organization

| Layer | Location | Framework | What's Tested |
| --- | --- | --- | --- |
| Go unit | Co-located `*_test.go` | testify | Service logic with mocked ports |
| Go integration | Co-located `*_test.go` (build tag: `integration`) | testcontainers | DB + RLS + Redis |
| Go E2E | `backend/test/e2e/` | httptest | Full HTTP request lifecycle |
| Frontend unit | Co-located `*.test.tsx` | Jest + RTL | Component rendering + hooks |
| Frontend E2E | `frontend/e2e/` | Playwright | Full user journeys |
| API contract | `backend/test/contract/` | OpenAPI validator | Request/response matches spec |

#### Configuration & Environment

```text
project-root/
├── .env.example                                # Template (committed)
├── docker-compose.yml                          # Local dev (PG + Redis + Privacy Proxy)
├── docker-compose.test.yml                     # CI test environment
├── Makefile                                    # Top-level orchestration
├── backend/.env.local                          # Backend env (gitignored)
├── frontend/.env.local                         # Frontend env (gitignored)
```

### Format Patterns

#### API Response Format

Success (single item): `{ "data": { ... } }`
Success (collection): `{ "data": [ ... ], "meta": { "page": 1, "page_size": 20, "total_count": 142, "has_next": true } }`

Error (RFC 7807 Problem Details):

```json
{
  "type": "https://api.marketboss.ng/errors/insufficient-credits",
  "title": "Insufficient Credits",
  "status": 422,
  "detail": "You need 5 credits to generate a draft but have 2 remaining.",
  "instance": "/api/v1/drafts",
  "errors": [{ "field": "credits", "message": "Minimum 5 required" }],
  "trace_id": "abc123"
}
```

#### HTTP Status Code Convention

| Code | When |
| --- | --- |
| `200 OK` | GET, PUT, PATCH success |
| `201 Created` | POST creates resource |
| `204 No Content` | DELETE success |
| `400 Bad Request` | Malformed JSON, missing fields |
| `401 Unauthorized` | Missing/expired JWT |
| `403 Forbidden` | Valid JWT, wrong tenant/role |
| `404 Not Found` | Not found OR wrong tenant (prevents enumeration) |
| `409 Conflict` | Duplicate entry |
| `422 Unprocessable Entity` | Business rule violations |
| `429 Too Many Requests` | Rate limit exceeded |
| `500 Internal Server Error` | Unexpected (always log trace_id) |

#### Date/Time & Currency

| Data | Format | Example |
| --- | --- | --- |
| JSON dates | ISO 8601 UTC | `"2026-02-19T15:43:30Z"` |
| DB dates | `TIMESTAMPTZ` (UTC) | Always stored UTC |
| UI dates | Localized WAT/UTC+1 | `"19 Feb 2026, 4:43 PM"` |
| JSON currency | Integer (kobo) | `"amount": 150000` (= ₦1,500.00) |
| DB currency | `BIGINT` (kobo) | Never float/decimal |
| UI currency | `Intl.NumberFormat('en-NG')` | `"₦1,500.00"` |

#### JSON Field Conventions

- Naming: `snake_case` throughout
- Nulls: omit null fields (Go `omitempty`) — absent field = null
- Booleans: `true`/`false` (never `1`/`0`)
- IDs: UUID strings
- Enums: `UPPER_SNAKE_CASE` strings (e.g., `"DRAFT_READY"`)
- Empty arrays: `[]` (never null)

### Communication Patterns

#### Event System (Redis Streams)

Event naming: `{domain}.{action}` — e.g., `product.created`, `message.received`, `draft.completed`

Event envelope:

```json
{
  "event_id": "uuid",
  "event_type": "product.created",
  "event_version": 1,
  "tenant_id": "uuid",
  "timestamp": "2026-02-19T16:00:00Z",
  "source": "product-service",
  "data": { "product_id": "uuid", "name": "Ankara Fabric Bundle", "price": 750000 },
  "metadata": { "trace_id": "abc123", "user_id": "uuid" }
}
```

Rules: every event includes `tenant_id` at envelope level | `event_version` starts at 1, increment on breaking changes | stream names: `events:{tenant_id}:{domain}` | consumer groups: `{service}-{action}` | schemas validated against `backend/docs/events/{event_type}.json` in CI

#### SSE Format

```text
event: feed.update
id: 1708358400000-0
data: {"type":"message.received","item":{...},"action":"prepend"}
```

`id` = Redis Stream message ID (enables `Last-Event-ID` reconnection) | `action`: `prepend`, `update`, `remove` | heartbeat every 30s

#### State Management

Single Zustand store (`stores/appStore.ts`) for all client-only state (filters, UI toggles, notifications). Server state exclusively in TanStack Query. Atomic selectors: `useAppStore(s => s.activeFilter)` — never subscribe to full store. Actions are methods on the store.

TanStack Query: query keys `['resource', ...params]` | mutations use `invalidateQueries` | `gcTime: 5min` | `staleTime: 30s` | `placeholderData: keepPreviousData`

#### Logging (Zap Structured)

| Level | When | Example |
| --- | --- | --- |
| `Debug` | Dev troubleshooting | Query execution details |
| `Info` | Normal business events | Product created, draft generated |
| `Warn` | Recoverable issues | Rate limit approaching, AI fallback |
| `Error` | Failures requiring action | Payment timeout, RLS violation |

Rules: every log includes `tenant_id` + `trace_id` | never log PII | structured fields only (no string interpolation) | log at function boundaries, not inside loops

### Process Patterns

#### Error Handling

Backend: services return domain errors (`ErrNotFound`, `ErrInsufficientCredits`) — handlers translate to RFC 7807. All 500s logged with stack trace + `trace_id`. Never expose internals to client.

Frontend: one error boundary per major feature section (`FeedErrorBoundary`, `MessagingErrorBoundary`). TanStack Query `onError` → toast notification. Network errors → "You're offline" banner.

#### Loading States

Skeleton loading (shimmer) — never raw spinners. Every component has a matching `{Component}Skeleton`. Skeletons match actual component dimensions. Page navigation: Next.js `loading.tsx`. Data fetch: TanStack Query `isLoading` + skeleton.

#### Retry & Recovery

| Scenario | Strategy | Config |
| --- | --- | --- |
| API call failure | Exponential backoff | 3 retries: 1s → 2s → 4s |
| SSE disconnection | Auto-reconnect | 5 retries, then polling fallback |
| AI draft timeout | Retry with cheaper model | 30s timeout → fallback to DeepSeek R1 |
| Payment webhook miss | Retry queue | 3 retries: 1min → 5min → 30min |
| DB connection loss | pgx pool auto-reconnect | Transparent to application |

#### Authentication Flow

1. Login: `POST /api/v1/auth/login` → `Set-Cookie` (httpOnly JWT + `is_authenticated` indicator)
2. Every request: cookies auto-sent → middleware validates JWT → extracts `tenant_id` → `SET app.current_tenant_id`
3. Token refresh: `POST /api/v1/auth/refresh` (auto on 401). Refresh rotation: each use invalidates previous token
4. Logout: `POST /api/v1/auth/logout` → clears cookies server-side
5. Service worker checks `is_authenticated` cookie for offline routing

#### Validation

| Layer | Tool | Purpose |
| --- | --- | --- |
| Frontend | Zod + React Hook Form | UX convenience (instant feedback) |
| Backend | Go validator + domain rules | Source of truth (always re-validates) |

Validation errors: `422` with `errors[]` array. Backend validates at service layer (not handler, not adapter).

### Enforcement Guidelines

All AI agents MUST:

1. Follow these naming patterns exactly — no variations
2. Place files in the defined structure locations
3. Use the standard API response wrapper and error format
4. Include `tenant_id` and `trace_id` in every log and event
5. Never hand-edit generated code (`sqlc`, `openapi-typescript`, `shadcn/ui`)
6. Write co-located tests with matching skeletons for data-fetching components
7. Use domain errors in services, RFC 7807 in handlers — never mix layers
8. Use UUIDv7 (time-sorted) for all primary keys
9. Event constructors require `TenantID` parameter (compile-time enforcement)
10. Server Components in `app/` route files, Client Components in `components/` with `'use client'`

### Advanced Elicitation: Pattern Stress-Testing

_3 methods applied to validate implementation patterns for agent consistency._

#### Code Review Gauntlet

| Reviewer | Concern | Refinement |
| --- | --- | --- |
| Pragmatist | Event JSON Schema registry is overkill for MVP (5 event types) | Keep registry in MVP - lightweight `backend/docs/events/*.json` schemas + CI validation prevent producer/consumer drift |
| Pragmatist | `__Host-` cookies fail on `http://localhost` | Environment-aware prefix: `__Host-` in production, none in dev |
| Pragmatist | "Skeletons for every component" too strict | Skeletons only for data-fetching components (updated in enforcement) |
| Purist | No tooling enforces import dependency rules | `go-arch-lint.yaml` in project root + CI enforcement |
| Purist | Nothing prevents endpoints without OpenAPI spec | CI route-spec alignment check: registered routes must match OpenAPI paths |
| Purist | Missing transaction boundary pattern | Transactions at service layer via `TxManager` interface |
| Performance | UUIDv4 random — poor B-tree insert locality | UUIDv7 (time-sorted) for all PKs — insert perf matches auto-increment |
| Performance | `omitempty` prevents unsetting fields via PATCH | GET responses omit nulls. PATCH accepts explicit `null` to unset fields |

#### Agent Failure Mode Analysis

| Failure | Blast Radius | Prevention |
| --- | --- | --- |
| Agent uses camelCase DB columns | HIGH — breaks codegen pipeline | SQL linter (sqlfluff/squawk) in CI enforces snake_case |
| Agent puts server data in Zustand | MEDIUM — stale data | ESLint rule: Zustand stores must not call API client |
| Agent forgets tenant_id in event | CRITICAL — cross-tenant corruption | Event constructor with required TenantID param (compile-time) |

#### Chaos Monkey Scenarios

| What Broke | Resilience | Fix |
| --- | --- | --- |
| Two agents add same-timestamp migration | LOW | Migration timestamps use seconds precision `YYYYMMDDHHMMSS` |
| Redis goes down completely | MEDIUM — rate limiter blocks all requests | Rate limiter fails open on Redis outage |
| Redis Streams unavailable | MEDIUM — events lost | Bounded in-memory buffer (100 events), discard oldest |
| Agent mixes Server/Client Components | MEDIUM — hydration errors | Explicit boundary: `page.tsx`/`layout.tsx` = Server, `components/` = Client |

#### CI Enforcement Pipeline

Automated checks that prevent pattern violations:

1. `go-arch-lint` — validates import dependency rules (domain → service → adapter → handler)
2. `sqlfluff`/`squawk` — enforces snake_case SQL naming
3. Route-spec alignment — registered HTTP routes must match OpenAPI paths
4. `sqlc generate` — diff check ensures generated code matches committed code
5. `openapi-typescript` — diff check ensures generated types match committed types
6. Migration filename lint — validates `YYYYMMDDHHMMSS` timestamp format
7. ESLint custom rule — Zustand stores must not import API client
##### MVP Tooling Profile (Canonical)

- **PR gates (MVP):** Semgrep (SAST), Dependabot (SCA), TruffleHog (secrets), Trivy (image/dependency scanning)
- **Nightly / pre-release:** OWASP ZAP (DAST) to avoid MVP PR-cycle bloat
- **Pre-beta performance signoff:** k6 load/performance validation against MVP NFR thresholds
- **Policy note:** k6 usage is release-readiness focused and is not coupled to Kubernetes adoption
