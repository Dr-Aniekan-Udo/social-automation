# Project Structure & Boundaries

### Complete Project Directory Structure

```text
marketboss/
├── .github/
│   └── workflows/
│       ├── backend-ci.yml                       # Go lint → test → build (trigger: backend/**)
│       ├── frontend-ci.yml                      # TS lint → test → build (trigger: frontend/**)
│       ├── deploy-staging.yml                   # Deploy on merge to develop
│       └── deploy-production.yml                # Deploy on merge to main
├── .env.example                                 # Template with all required vars (committed)
├── docker-compose.yml                           # Local dev: PG18 + Redis 7.4 + Privacy Proxy mock
├── docker-compose.test.yml                      # CI: PG + Redis for integration tests
├── Makefile                                     # Top-level orchestration
├── README.md
├── docs/
│   ├── planning-artifacts/                      # Architecture, PRD, UX specs
│   └── adr/                                     # Architectural Decision Records (ongoing)
├── api/
│   └── openapi.yaml                             # OpenAPI 3.1 — single source of truth
│
├── backend/
│   ├── go.mod
│   ├── go.sum
│   ├── Makefile                                 # generate, lint, test, build
│   ├── Dockerfile
│   ├── go-arch-lint.yaml                        # Import dependency rules (CI enforced)
│   ├── .env.local                               # (gitignored)
│   ├── cmd/
│   │   └── server/
│   │       └── main.go                          # Entry point, DI wiring, graceful shutdown
│   ├── internal/
│   │   ├── domain/                              # ── ZERO external imports ──
│   │   │   ├── auth/
│   │   │   │   ├── entity.go                    # User, Role, Session, RefreshToken
│   │   │   │   ├── repository.go                # UserRepository, SessionRepository
│   │   │   │   └── errors.go                    # ErrInvalidCredentials, ErrTokenExpired
│   │   │   ├── tenant/
│   │   │   │   ├── entity.go                    # Tenant, TenantConfig, Subscription
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── product/
│   │   │   │   ├── entity.go                    # Product, ProductVariant, StockLevel
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── messaging/
│   │   │   │   ├── entity.go                    # Conversation, Message, DraftMessage, Customer
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── payment/
│   │   │   │   ├── entity.go                    # PaymentLink, Transaction, PaymentStatus
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── ai/
│   │   │   │   ├── entity.go                    # Draft, BrandVoice, ModelTier, AIUsage, BrandVoiceMaturity
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── publishing/
│   │   │   │   ├── entity.go                    # ScheduledPost, ContentQueue, PlatformAccount
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── analytics/
│   │   │   │   ├── entity.go                    # EngagementMetric, PostingTimeSlot, ABTest
│   │   │   │   ├── repository.go
│   │   │   │   └── errors.go
│   │   │   ├── feed/
│   │   │   │   ├── entity.go                    # FeedItem, FeedFilter (9-state machine)
│   │   │   │   └── repository.go
│   │   │   └── event.go                         # EventEnvelope, NewEvent() (enforces TenantID)
│   │   │
│   │   ├── service/                             # ── imports domain/ only ──
│   │   │   ├── auth/
│   │   │   │   ├── service.go                   # Login, Register, RefreshToken, Logout
│   │   │   │   └── service_test.go
│   │   │   ├── tenant/
│   │   │   │   ├── service.go                   # CreateTenant, UpdateConfig, ManageSubscription
│   │   │   │   └── service_test.go
│   │   │   ├── product/
│   │   │   │   ├── service.go                   # CRUD, NLP price parsing, stock management
│   │   │   │   └── service_test.go
│   │   │   ├── messaging/
│   │   │   │   ├── service.go                   # SendReply, GetConversations, TriggerDraft
│   │   │   │   └── service_test.go
│   │   │   ├── payment/
│   │   │   │   ├── service.go                   # CreateLink, ProcessWebhook, CheckExpiry
│   │   │   │   └── service_test.go
│   │   │   ├── ai/
│   │   │   │   ├── router.go                    # 3-tier model routing
│   │   │   │   ├── privacy_proxy.go             # PII stripping (NDPA)
│   │   │   │   ├── draft_generator.go           # Draft orchestration + 3-draft limit
│   │   │   │   ├── brand_voice.go               # Training + tone switching
│   │   │   │   └── service_test.go
│   │   │   ├── publishing/
│   │   │   │   ├── service.go                   # Schedule, Publish, OptimalTimeCalc
│   │   │   │   └── service_test.go
│   │   │   ├── analytics/
│   │   │   │   ├── service.go                   # CollectMetrics, PostingTimeOptimizer, ABTest
│   │   │   │   └── service_test.go
│   │   │   ├── feed/
│   │   │   │   ├── service.go                   # AggregateFeed, ApplyFilters, StreamUpdates
│   │   │   │   └── service_test.go
│   │   │   └── tx.go                            # TxManager interface
│   │   │
│   │   ├── adapter/                             # ── implements domain/ interfaces ──
│   │   │   ├── postgres/
│   │   │   │   ├── auth_repo.go
│   │   │   │   ├── tenant_repo.go
│   │   │   │   ├── product_repo.go
│   │   │   │   ├── messaging_repo.go
│   │   │   │   ├── payment_repo.go
│   │   │   │   ├── ai_repo.go
│   │   │   │   ├── publishing_repo.go
│   │   │   │   ├── analytics_repo.go
│   │   │   │   ├── feed_repo.go
│   │   │   │   ├── tx_manager.go                # pgx transaction wrapper
│   │   │   │   ├── connection.go                # pgx pool + AfterRelease tenant reset
│   │   │   │   ├── queries/                     # sqlc generated (DO NOT HAND-EDIT)
│   │   │   │   └── migrations/                  # golang-migrate (YYYYMMDDHHMMSS)
│   │   │   ├── redis/
│   │   │   │   ├── cache.go                     # Cache-aside
│   │   │   │   ├── event_bus.go                 # Redis Streams + in-memory buffer
│   │   │   │   ├── rate_limiter.go              # Sliding window (fails open)
│   │   │   │   └── connection.go                # Client setup + ACLs
│   │   │   ├── ai/
│   │   │   │   ├── deepseek.go                  # Tier 1 — routine
│   │   │   │   ├── gemini.go                    # Tier 2 — creative
│   │   │   │   ├── openai.go                    # Tier 3 — complex
│   │   │   │   └── semantic_cache.go            # Prompt similarity cache
│   │   │   ├── platform/
│   │   │   │   ├── instagram.go                 # Meta Graph API (polling 30-60s)
│   │   │   │   ├── whatsapp.go                  # WhatsApp Business API (webhooks)
│   │   │   │   └── platform.go                  # PlatformAdapter interface
│   │   │   └── payment/
│   │   │       ├── paystack.go
│   │   │       └── flutterwave.go
│   │   │
│   │   └── handler/                             # ── calls service/, never adapter/ ──
│   │       ├── middleware/
│   │       │   ├── auth.go                      # JWT + __Host- cookie
│   │       │   ├── tenant.go                    # tenant_id → SET app.current_tenant_id
│   │       │   ├── ratelimit.go
│   │       │   ├── cors.go
│   │       │   ├── requestid.go                 # X-MarketBoss-RequestId
│   │       │   └── recovery.go                  # Panic recovery
│   │       ├── response.go                      # { data, meta } + RFC 7807
│   │       ├── auth_handler.go
│   │       ├── tenant_handler.go                 # /api/v1/settings/tenant
│   │       ├── product_handler.go
│   │       ├── messaging_handler.go
│   │       ├── payment_handler.go
│   │       ├── draft_handler.go
│   │       ├── brand_voice_handler.go            # /api/v1/brand-voice/*
│   │       ├── publishing_handler.go
│   │       ├── analytics_handler.go
│   │       ├── feed_handler.go
│   │       ├── sse_handler.go                   # /api/v1/feed/stream
│   │       ├── webhook_handler.go               # Platform callbacks (idempotent)
│   │       └── router.go                        # Routes + /healthz + /readyz
│   │
│   ├── db/
│   │   ├── sqlc.yaml
│   │   └── queries/                             # Raw SQL for sqlc
│   │       ├── auth.sql
│   │       ├── tenants.sql
│   │       ├── products.sql
│   │       ├── conversations.sql
│   │       ├── messages.sql
│   │       ├── payments.sql
│   │       ├── drafts.sql
│   │       ├── posts.sql
│   │       ├── analytics.sql
│   │       └── feed.sql
│   ├── docs/events/                             # Event schema registry
│   │   ├── README.md
│   │   ├── product.created.md
│   │   ├── message.received.md
│   │   ├── draft.completed.md
│   │   ├── payment.confirmed.md
│   │   └── webhook.failed.md
│   └── test/
│       ├── e2e/                                 # Full HTTP lifecycle
│       ├── isolation/                           # Cross-tenant data leakage tests
│       ├── contract/                            # OpenAPI contract validation
│       └── testutil/                            # Shared helpers, fixtures, containers
│
└── frontend/
    ├── package.json
    ├── next.config.ts
    ├── tsconfig.json
    ├── tailwind.config.ts
    ├── postcss.config.ts
    ├── .env.local                               # (gitignored)
    ├── jest.config.ts
    ├── playwright.config.ts
    ├── .eslintrc.cjs                            # + custom Zustand/API rule
    ├── app/
    │   ├── layout.tsx                           # Root: providers, fonts, metadata
    │   ├── globals.css                          # Tailwind base + design tokens
    │   ├── not-found.tsx
    │   ├── error.tsx
    │   ├── loading.tsx
    │   ├── (auth)/
    │   │   ├── layout.tsx
    │   │   ├── login/page.tsx                   # Phone OTP login
    │   │   └── register/page.tsx                # Business registration
    │   ├── (dashboard)/
    │   │   ├── layout.tsx                       # Dashboard shell (sidebar, nav)
    │   │   ├── page.tsx                         # Revenue Command Feed
    │   │   ├── loading.tsx
    │   │   ├── messages/
    │   │   │   ├── page.tsx                     # Unified inbox
    │   │   │   ├── loading.tsx
    │   │   │   └── [conversation_id]/page.tsx   # Conversation + DraftBox
    │   │   ├── products/
    │   │   │   ├── page.tsx                     # Product catalog
    │   │   │   ├── loading.tsx
    │   │   │   ├── new/page.tsx                 # Voice/camera entry
    │   │   │   └── [product_id]/page.tsx        # Detail/edit
    │   │   ├── payments/
    │   │   │   ├── page.tsx
    │   │   │   └── loading.tsx
    │   │   ├── analytics/
    │   │   │   ├── page.tsx
    │   │   │   └── loading.tsx
    │   │   └── settings/
    │   │       ├── page.tsx                     # General
    │   │       ├── brand-voice/page.tsx         # Brand Voice training
    │   │       ├── team/page.tsx                # Team RBAC
    │   │       └── billing/page.tsx             # Subscription
    │   └── api/v1/[...proxy]/route.ts           # BFF proxy to Go backend
    ├── components/
    │   ├── ui/                                  # shadcn/ui (DO NOT HAND-EDIT)
    │   ├── feed/
    │   │   ├── FeedItem.tsx                     # 9-state feed item
    │   │   ├── FeedItemSkeleton.tsx
    │   │   ├── FeedFilters.tsx
    │   │   ├── FeedVirtualList.tsx              # TanStack Virtual
    │   │   └── FeedStream.tsx                   # SSE connection
    │   ├── messaging/
    │   │   ├── ConversationList.tsx
    │   │   ├── ConversationListSkeleton.tsx
    │   │   ├── DraftBox.tsx                     # AI draft editor (3-draft)
    │   │   ├── DraftBoxSkeleton.tsx
    │   │   ├── PrimingCard.tsx                  # Customer context
    │   │   └── MessageBubble.tsx
    │   ├── product/
    │   │   ├── ProductCard.tsx
    │   │   ├── ProductCardSkeleton.tsx
    │   │   ├── ProductForm.tsx
    │   │   └── ProductGrid.tsx
    │   ├── payment/
    │   │   ├── PaymentLinkCreator.tsx
    │   │   ├── TransactionList.tsx
    │   │   └── TransactionListSkeleton.tsx
    │   ├── analytics/
    │   │   ├── EngagementChart.tsx
    │   │   ├── PostingHeatmap.tsx
    │   │   └── InsightCard.tsx
    │   └── shared/
    │       ├── LoadingSkeleton.tsx
    │       ├── ErrorBoundary.tsx
    │       ├── ErrorState.tsx
    │       ├── EmptyState.tsx
    │       ├── OfflineBanner.tsx
    │       └── CurrencyDisplay.tsx              # ₦ kobo formatter
    ├── hooks/
    │   ├── api/                                 # TanStack Query (one per resource)
    │   │   ├── useProducts.ts
    │   │   ├── useConversations.ts
    │   │   ├── useMessages.ts
    │   │   ├── useDrafts.ts
    │   │   ├── usePaymentLinks.ts
    │   │   ├── usePosts.ts
    │   │   ├── useAnalytics.ts
    │   │   └── useFeed.ts
    │   ├── useNetworkStatus.ts                  # Online/offline + connection type
    │   ├── useSSE.ts                            # SSE + Last-Event-ID reconnection
    │   └── useMediaCapture.ts                   # Camera/voice product entry
    ├── stores/
    │   └── appStore.ts                          # Single Zustand store
    ├── types/generated/
    │   └── api.ts                               # openapi-typescript (DO NOT HAND-EDIT)
    ├── lib/
    │   ├── api-client.ts                        # Typed API client
    │   ├── format.ts                            # Currency (kobo→₦), date (UTC→WAT)
    │   ├── constants.ts
    │   └── query-client.ts                      # TanStack Query config
    ├── public/
    │   ├── sw.ts                                # @serwist/next service worker
    │   ├── manifest.json                        # PWA manifest
    │   └── icons/                               # PWA icons
    └── e2e/                                     # Playwright tests
        ├── auth.spec.ts
        ├── feed.spec.ts
        ├── messaging.spec.ts
        └── fixtures/
```

### Architectural Boundaries

#### API Boundaries

| Boundary | From | To | Protocol |
| --- | --- | --- | --- |
| Client → BFF | Browser | Next.js `/api/v1/[...proxy]` | HTTPS |
| BFF → Backend | Next.js server | Go `:8080` | HTTP (internal) |
| Platform → Backend | Instagram/WhatsApp | Go `/api/v1/webhooks` | HTTPS webhooks |
| Backend → AI | Go Privacy Proxy | DeepSeek/Gemini/GPT-4o | HTTPS |
| Backend → Payment | Go adapter | Paystack/Flutterwave | HTTPS |

#### Data Flow

```text
Webhook arrival → handler → service (validates + business rules) → domain events
                                ↓                                        ↓
                           adapter (DB write)               Redis Streams publish
                                                                   ↓
                                                          SSE → Frontend feed
```

### Requirements to Structure Mapping

| FR Domain | Backend Path | Frontend Route | Components | API Hook |
| --- | --- | --- | --- | --- |
| AI Content | `domain/ai/` → `service/ai/` → `adapter/ai/` | `settings/brand-voice/` | `messaging/DraftBox` | `useDrafts` |
| Unified Inbox | `domain/messaging/` → `service/messaging/` | `messages/` | `messaging/*` | `useConversations`, `useMessages` |
| Payments | `domain/payment/` → `service/payment/` | `payments/` | `payment/*` | `usePaymentLinks` |
| Products | `domain/product/` → `service/product/` | `products/` | `product/*` | `useProducts` |
| Analytics | `domain/analytics/` → `service/analytics/` | `analytics/` | `analytics/*` | `useAnalytics` |
| Publishing | `domain/publishing/` → `service/publishing/` | (in feed) | `feed/*` | `usePosts` |
| Multi-Tenancy | `domain/tenant/` → middleware → RLS | `settings/` | (implicit) | — |
| Auth + RBAC | `domain/auth/` → `service/auth/` | `(auth)/` | — | — |
| Revenue Feed | `domain/feed/` → `service/feed/` → SSE | `(dashboard)/page.tsx` | `feed/*` | `useFeed` |

### Cross-Cutting Concerns Location

| Concern | Backend Location | Frontend Location |
| --- | --- | --- |
| Tenant isolation | `handler/middleware/tenant.go` + RLS | Implicit (cookies) |
| Privacy Proxy | `service/ai/privacy_proxy.go` | — |
| Observability | OpenTelemetry middleware + Zap | Sentry SDK |
| Rate limiting | `adapter/redis/rate_limiter.go` + middleware | 429 handling |
| Offline support | — | `sw.ts` + `useNetworkStatus` + `OfflineBanner` |
| Auth | `handler/middleware/auth.go` | `(auth)/` route group |
| Error formatting | `handler/response.go` (RFC 7807) | `ErrorBoundary` + `ErrorState` |

### Validation Refinements (Advanced Elicitation)

The following 20 refinements were identified through 5 stress-testing methods (Pre-mortem Analysis, Failure Mode Analysis, Self-Consistency Validation, Comparative Analysis Matrix, Graph of Thoughts) and accepted for inclusion.

#### Critical Architectural Rules

1. **AI Budget Tracking** — `domain/ai/entity.go` includes `AIUsage` entity with per-tenant monthly cost cap. `service/ai/router.go` checks budget before routing any AI call.
2. **Tenant Isolation Test Suite** — `test/isolation/` contains tests that create 2 tenants and verify zero data leakage across ALL tables.
3. **Webhook Idempotency** — `handler/webhook_handler.go` deduplicates webhook processing using `event_id`/`message_id` to prevent double-processing of platform retries.
4. **Health Endpoints** — `handler/router.go` registers `/healthz` (liveness) and `/readyz` (readiness: PG + Redis connectivity) endpoints.
5. **Cross-Domain Service Rule** — Services MAY call other services for cross-domain data. Services MUST NOT import repositories from other domains. Handlers NEVER orchestrate between services.
6. **AI ↔ Messaging Circular Prevention** — `service/ai` MUST NOT import `service/messaging`. Customer context is passed as domain value objects (parameters), not fetched by the AI service.
7. **Test Double Rule** — All external adapters (AI providers, platform APIs, payment gateways) MUST have an in-memory test double implementing the same domain interface.

#### Important Architectural Refinements

1. **Brand Voice Maturity Signal** — `domain/ai/entity.go` includes `BrandVoiceMaturity` (draft_count, feedback_score). Model router promotes immature Brand Voices to higher-tier models automatically.
2. **Offline Draft Persistence** — DraftBox auto-saves to IndexedDB via the service worker. On reconnection, any locally-saved drafts sync to the backend.
3. **Retry Authority** — `lib/query-client.ts` (TanStack Query config) is the single retry authority for all API calls. `lib/api-client.ts` does NOT retry — it throws on failure.
4. **Cache Bypass on Failure** — `adapter/redis/cache.go` uses a circuit breaker pattern. On Redis outage, cache operations are bypassed and the app queries PostgreSQL directly.
5. **Stream Backpressure** — Redis Streams use `MAXLEN ~1000` per stream for automatic trimming. `XAUTOCLAIM` recovers stuck messages from failed consumers.
6. **AI Template Fallback** — `service/ai/draft_generator.go` maintains pre-built response templates. When all 3 AI providers are unavailable, the user is offered template-based drafts categorized by message intent.
7. **Action Endpoint Convention** — Sub-resource action endpoints use verbs: `POST /conversations/{id}/reply`, `POST /posts/{id}/publish`, `POST /payment-links/{id}/cancel`.
8. **Publishing Scheduler Resilience** — Scheduled post publishing is idempotent. If the scheduler crashes mid-publish, it re-queues the post on restart without duplicating the publish action.
9. **Async AI Drafts** — Draft generation returns immediately with a `pending` status. The completed draft is delivered via domain event → Redis Streams → SSE to the frontend DraftBox.

#### Minor Refinements

1. **PG Connection Pool Config** — `adapter/postgres/connection.go` documents max pool size, idle timeout, and max connection lifetime with recommended values for the expected tenant count.
2. **SSE Scalability** — Document max concurrent SSE connections per Go process. Horizontal scaling strategy: sticky sessions via DigitalOcean load balancer `hash $request_uri`.
3. **Tenant Handler** — `handler/tenant_handler.go` added for `GET/PATCH /api/v1/settings/tenant` endpoints (settings page needs it).
4. **Brand Voice Handler** — `handler/brand_voice_handler.go` added for `/api/v1/brand-voice/*` endpoints. Separated from draft_handler for clear domain ownership.
