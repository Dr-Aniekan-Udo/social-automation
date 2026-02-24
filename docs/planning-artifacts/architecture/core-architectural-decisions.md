# Core Architectural Decisions

### Decision Priority Analysis

##### Critical Decisions (Block Implementation)

| # | Decision | Choice | Version | Rationale |
| --- | --- | --- | --- | --- |
| 1a | ORM / Query Builder | sqlc + pgx/v5 | v1.30.0 | Type-safe Go from SQL. PG parser validates queries at build time. Full SQL power for RLS + complex joins |
| 1b | Migration Tool | golang-migrate | v4.19.1 | Battle-tested, simple timestamped SQL files, pgx/v5 compatible |
| 2a | Auth Strategy | Custom JWT (golang-jwt) | v5.3.0 | Full control over tenant claims, NDPA-compliant, no vendor lock-in |
| 2b | JWT Implementation | RS256, 15min access + 7d refresh, httpOnly cookies | — | Asymmetric signing, rotation, device fingerprinting, XSS-proof |
| 3a | API Style | REST (JSON) | — | Simple, cacheable, maps cleanly to resources, lightweight for budget devices |
| 3b | API Documentation | OpenAPI spec-first (oapi-codegen + openapi-typescript) | — | Single source of truth, auto-synced types between Go and TypeScript |
| 3d | Event Bus | Redis Streams | 7.4+ | Persistent events with consumer groups. No extra infra. Handles webhook → SSE bridging |

##### Important Decisions (Shape Architecture)

| # | Decision | Choice | Rationale |
| --- | --- | --- | --- |
| 1c | Caching Strategy | Cache-Aside (Redis) | Per-type TTLs: drafts 5min, catalog 30min, config 1hr, sessions 15min |
| 1d | Search | PostgreSQL Full-Text Search | Zero extra infra, sufficient for < 100K records/tenant, custom text configs for Nigerian English |
| 2c | API Security | Redis sliding window rate limiting + CORS + CSRF + webhook HMAC | Per-tenant fairness, signed webhooks |
| 2d | Encryption | AES-256-GCM column-level for PII + TLS 1.3 in transit | NDPA compliance, Privacy Proxy strips PII before AI calls |
| 3c | Error Handling | RFC 7807 Problem Details | Standard, machine-parseable, includes error codes and context |
| 4a | State Management | TanStack Query (server) + Zustand (client) | TQ for caching/refetch/optimistic. Zustand (1KB) for UI state |
| 4b | Form Handling | React Hook Form + Zod | Uncontrolled inputs = fewer re-renders on budget devices. Zod = shared validation |
| 4c | API Client | Generated TypeScript client + TanStack Query | Auto-synced with OpenAPI spec, zero manual type maintenance |
| 4d | Animations | CSS transitions only (MVP) | CSS-only for MVP product surfaces (`transform`/`opacity` only) with `prefers-reduced-motion` support |

##### Deferred Decisions (Post-MVP)

| Decision | Deferral Rationale |
| --- | --- |
| GraphQL API layer | REST sufficient for MVP. Revisit if mobile app needs flexible field selection |
| Meilisearch / Elasticsearch | PG Full-Text sufficient at MVP scale. Add when search UX requires typo-tolerance |
| Go Workspaces (multi-module) | Single module with `internal/` sufficient. Needed only when extracting microservices |
| HashiCorp Vault | DO env vars sufficient for MVP. Vault when team grows or dynamic secrets needed |
| gRPC (internal) | REST between frontend-backend sufficient. gRPC if we add inter-service communication |

### Data Architecture

##### Database Layer

- **Primary:** PostgreSQL 18 with Row-Level Security (RLS)
- **Cache:** Redis 7.4+ (Cache-Aside pattern with per-type TTLs)
- **Query Layer:** sqlc v1.30.0 → generates type-safe Go from SQL files
- **Driver:** pgx/v5 (recommended sqlc driver, high-performance PostgreSQL)
- **Migrations:** golang-migrate v4.19.1 (timestamped up/down SQL files)
- **Search:** PostgreSQL Full-Text Search (tsvector + GIN indexes)
- **Media storage & delivery:** S3-compatible object storage fronted by CDN capability (vendor-agnostic; provider choice is implementation-specific)

##### Caching TTLs

| Data Type | TTL | Strategy |
| --- | --- | --- |
| AI draft cache | 5 min | Drafts change with conversation context |
| Product catalog | 30 min | Rarely changes mid-session |
| Tenant config / Brand Voice | 1 hour | Stable configuration data |
| Session data | 15 min | Redis-only, matches JWT access token TTL |
| Feed items | 2 min | Real-time feel without over-fetching |

### Authentication & Security

##### Auth Flow

- Custom JWT with `golang-jwt/jwt` v5.3.0 (RS256 asymmetric signing)
- Access token: 15 min TTL, stored in httpOnly cookie
- Refresh token: 7 day TTL, httpOnly cookie, rotation on every use
- Device fingerprinting: stored alongside refresh token record
- Tenant claim: `tenant_id` injected into every JWT payload

##### Session → RLS Pipeline

1. Request arrives → JWT middleware extracts `tenant_id` from token
2. Middleware calls `SET app.current_tenant_id = $1` on PostgreSQL session
3. All RLS policies reference `current_setting('app.current_tenant_id')`
4. Query executes with automatic tenant isolation — no application-level filtering needed

##### Encryption

- In transit: TLS 1.3 (DigitalOcean-managed)
- At rest: DigitalOcean Managed DB disk encryption
- PII columns: AES-256-GCM application-level (customer phone, name, email)
- AI pipeline: Privacy Proxy strips PII before any AI provider call (mandatory, non-bypassable)

##### API Security

- Rate limiting: Redis sliding window, per-tenant quotas
- CORS: Frontend domain whitelist only
- CSRF: SameSite=Strict cookies + CSRF token for state changes
- Input validation: Zod (FE) + Go struct validation (BE) — never trust client
- Webhook verification: HMAC SHA-256 + IP allowlisting per platform

### API & Communication Patterns

##### API Design

- REST (JSON) with versioned endpoints (`/api/v1/`)
- OpenAPI 3.1 spec-first: spec lives in `api/openapi.yaml`
- Go server stubs: `oapi-codegen` generates handler interfaces from spec
- TypeScript client: `openapi-typescript` generates types from same spec
- CI validation: implementation is checked against spec on every PR

##### Error Standard (RFC 7807)

```json
{
  "type": "https://api.marketboss.ng/errors/{error-type}",
  "title": "Human-readable error title",
  "status": 400,
  "detail": "Specific details about what went wrong",
  "instance": "/api/v1/{endpoint}",
  "tenant_id": "tenant_xxx"
}
```

##### Internal Event Bus (Redis Streams)

- Persistent event delivery with consumer groups
- Webhook events → Redis Streams (primary event backbone) → SSE handlers push to frontend
- Domain events: messaging.dm_received → ai.draft_requested → ai.draft_completed
- Payment events: payment.status_changed → feed.update_required
- Consumer groups ensure at-least-once delivery with idempotency keys

### Frontend Architecture

##### State Management

- Server state: TanStack Query (caching, background refetch, optimistic updates)
- Client state: Zustand (1KB, no Provider wrapper, React 19 compatible)
- No global client store for server state — TanStack Query cache remains authoritative

**Forms:** React Hook Form + Zod (uncontrolled inputs for budget device performance)

**API Client:** OpenAPI-generated TypeScript client wrapped in TanStack Query hooks

##### Animations (Device-Aware)

- Default: CSS transitions for all micro-interactions
- No JS animation libraries in MVP app flows; keep interactions CSS-only for performance and consistency
- Detection: `navigator.deviceMemory` API → graceful degradation
- React 19 View Transitions for route changes where supported

### Infrastructure & Deployment

**Hosting:** DigitalOcean App Platform (Docker containers)

- Backend: Go Docker image → Web Service (HTTP + SSE)
- Frontend: Next.js Docker image → Web Service
- Workers: Go Docker image (different entrypoint) → Worker component
- Database: DigitalOcean Managed PostgreSQL 18
- Cache: DigitalOcean Managed Redis 7.4+

**Environment Management:** DO App Platform env vars (production) + `.env.local` (development)

##### CI/CD Migration Strategy

- Dev/Staging: Auto-migrate on deploy
- Production: Separate migration CI step with manual approval in GitHub Actions
- Every migration has up + down files (golang-migrate enforces)
- Destructive changes require 2 PR approvals + phased migration

##### Observability Stack

| Layer | Tool | Key Feature |
| --- | --- | --- |
| Structured Logging | Zap | JSON logs with tenant_id, request_id |
| Distributed Tracing | OpenTelemetry → SigNoz | Request traces across services + DB + AI |
| Metrics | OpenTelemetry → SigNoz | Latency, AI cost/tenant, Redis hit ratio |
| Error Tracking | Sentry (Go + Next.js) | Runtime errors with breadcrumbs |
| Uptime | DigitalOcean Uptime Checks | Health monitoring + alerting |
| LLM Tracing & Prompt Mgmt | Langfuse (self-hosted) | Per-call prompt/response traces, token cost, prompt versioning, evaluation scores |
| LLM → OTel Bridge | OpenLLMetry | Emits OTel spans for every AI call — correlated with SigNoz infra traces via shared `trace_id` |

_Every log and trace includes `tenant_id` + `request_id` for per-tenant debugging and cost attribution._

> [!NOTE]
> **Deferred:** Arize Phoenix (RAG evaluation + local debugging) is noted for Phase 3 when a retrieval-augmented pipeline is introduced.

### Decision Impact Analysis

##### Implementation Sequence

1. Project scaffolding (Go layout + create-next-app) — foundational
2. PostgreSQL schema + RLS policies + golang-migrate setup — data layer first
3. sqlc configuration + initial queries — data access layer
4. JWT auth middleware + tenant context injection — security before features
5. OpenAPI spec + oapi-codegen + openapi-typescript — API contract
6. Redis setup (cache + streams) — infrastructure for real-time features
7. TanStack Query + Zustand + React Hook Form — frontend data layer
8. Platform adapters (Instagram, WhatsApp) — feature development begins
9. AI router + privacy proxy — AI integration
10. Observability (OTel + SigNoz + Sentry) — monitoring from first deploy

##### Cross-Component Dependencies

```text
OpenAPI Spec ──→ oapi-codegen (Go handlers) ──→ Backend implementation
     │
     └──→ openapi-typescript (TS types) ──→ TanStack Query hooks ──→ Frontend

JWT Middleware ──→ tenant_id extraction ──→ PostgreSQL SET session var ──→ RLS enforcement

Redis Streams ──→ Webhook handlers (publish) ──→ SSE handlers (subscribe) ──→ Frontend feed

Privacy Proxy ──→ AI Router ──→ AI Providers (DeepSeek/Gemini/GPT-4o) ──→ Draft cache
```

### Advanced Elicitation: Decision Stress-Testing

_5 methods applied to validate and harden the 20 core architectural decisions._

#### Red Team vs Blue Team (Security Hardening)

| Attack Vector | Vulnerability | Defense (New Requirement) |
| --- | --- | --- |
| Subdomain cookie theft | Wildcard `.marketboss.ng` cookie scope | `__Host-` cookie prefix — prevents cross-subdomain attacks entirely |
| RLS bypass via connection pool | pgx pool returns connection with previous tenant's session var | pgx `AfterRelease` hook: `RESET ALL` on every connection return to pool |
| Redis event injection/snooping | No per-stream access control | Redis 7.4+ ACLs + tenant-scoped stream names (`events:{tenant_id}:*`) |
| Privacy Proxy bypass | Developers import AI adapter directly | `go-arch-lint` rule: only `internal/service/ai/` may import `internal/adapter/ai/` |
| PII key in env vars | No envelope encryption, manual rotation | Envelope encryption: data key wrapped by master key, rotate data keys independently |

#### Self-Consistency Validation (Contradiction Resolution)

| Contradiction | Resolution |
| --- | --- |
| sqlc (static SQL) vs dynamic filter/search queries | **Hybrid approach:** sqlc for 90% fixed CRUD, pgx direct with parameterized SQL for dynamic search/filter (e.g., squirrel query builder) |
| Cache TTL (30min) vs SSE real-time event push | **Write-triggered cache invalidation:** on product/message update → invalidate Redis key → publish event to Stream. TTL is backup expiry only |
| No single source of truth for Redis Streams event schemas | **Event schema registry:** JSON Schema files in `docs/events/` — CI validates producers and consumers match schema |
| httpOnly cookies invisible to PWA service worker | **Auth indicator cookie:** non-sensitive `is_authenticated=true` readable cookie for SW routing decisions. Actual JWT remains httpOnly |

#### Pre-mortem Analysis (Failure Prevention)

| Failure Scenario | Root Cause | Prevention |
| --- | --- | --- |
| SSE drops constantly on 2G/3G Nigerian networks | Unstable connections + no reconnection strategy | Auto-reconnect with `lastEventId` + polling fallback after 3 failures in 60s + draft completion persisted in DB |
| AI cost explosion (₦2.5M/month vs ₦200K budget) | No trigger-level rate limiting | Per-tenant: max 5 AI drafts/min + daily budget cap per plan tier + degrade to DeepSeek R1 at 80% budget |
| Production migration breaks all INSERTs | NOT NULL column without DEFAULT | Migration linting: NOT NULL requires DEFAULT + staging environment with anonymized prod data snapshots |
| WhatsApp webhook storm (5K messages in 30min) | No backpressure on AI pipeline | Max 3 concurrent AI calls/tenant + LIFO priority + batch mode at queue depth > 50 |
| Admin endpoint leaks cross-tenant data | Admin routes bypass tenant middleware | ALL endpoints through tenant middleware (no exceptions) + integration test: wrong tenant_id → 0 rows or 403 |

#### Performance Profiler Panel (Bottleneck Prevention)

##### Database (PostgreSQL + sqlc)

- Feed query: materialized view for 5-table JOIN + composite `(tenant_id, created_at DESC)` indexes on every RLS table
- Full-text search: partial GIN indexes (active products only) + async tsvector column updates via background job
- Bulk operations: explicit pgx transactions wrapping multiple sqlc calls
- Connection pool: increase pgx pool to 50 connections for production (default 25 insufficient)

##### Frontend (Next.js + React 19 + Budget Devices)

- TanStack Query memory: `gcTime: 5min`, max 3 cached pages, `placeholderData` over `keepPreviousData`
- Zustand re-renders: atomic selectors (subscribe per filter value) + 150ms debounce on filter changes
- Service worker: defer registration to `load` event, `@serwist/next` lazy mode — avoid 200-500ms FCP penalty

##### Infrastructure (DigitalOcean + Redis)

- Cold starts: Pro tier minimum ($12/mo, no sleeping) + health check endpoint warms DB pool
- Redis memory: MAXLEN 10K events per stream OR MINID 24hr retention, prevent unbounded growth
- SSE limits: monitor connection count in SigNoz + auto-scale on connections (not just CPU) + 5min idle timeout

#### Trolley Problem Resolutions (Hard Trade-offs)

| Dilemma | Decision | Compromise |
| --- | --- | --- |
| DX speed vs Security (Privacy Proxy in local dev) | **Security wins** — proxy runs locally | Mock mode: logs PII stripping decisions without calling AI, fast iteration |
| Cache freshness vs Device RAM | **Adaptive strategy** | `navigator.connection.effectiveType` + `deviceMemory` → dynamic prefetch aggressiveness. 2G/2GB: fetch-on-demand. 4G/4GB+: prefetch 2 pages |
| Shared vs Per-tenant Redis | **Shared + quotas** | Tenant-prefixed keys + per-tenant memory monitoring via SigNoz. Throttle at 10% total memory |
| DO lock-in vs Platform neutrality | **DO-native for MVP** | Clean Architecture ports/adapters already enable cloud migration — app doesn't know it's on DO |
| Comprehensive testing vs Ship speed | **No compromise on tenant isolation** | Mandatory integration tests for every endpoint. Other tests (UI, E2E) deferred post-MVP |
