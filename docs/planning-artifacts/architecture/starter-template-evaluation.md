# Starter Template Evaluation

### Technical Preferences (Pre-Established)

| Category | Decision | Source |
| --- | --- | --- |
| Backend Language | Go 1.26 | Product Brief |
| Frontend Framework | Next.js 16 + React 19 | Product Brief |
| Database | PostgreSQL 18 + Redis 7.4+ | Product Brief |
| UI Library | shadcn/ui + Radix Primitives | UX Spec |
| Styling | Tailwind CSS 4.x + CSS custom properties | UX Spec |
| Architecture | Clean Architecture (Hexagonal / Ports & Adapters) | Product Brief |
| Deployment | DigitalOcean (App Platform + Managed DB) | Product Brief |
| CI/CD | GitHub Actions | Product Brief |
| Observability | OpenTelemetry + SigNoz, Sentry, Zap logging | Product Brief |
| Testing | Go: testify + testcontainers / Frontend: Jest + Playwright | Product Brief |

### Starter Options Evaluated

##### Backend — Comparative Analysis (Weighted Scoring)

| Option | Stack Match (30%) | Custom Effort (25%) | Maintainability (20%) | Community (15%) | Prod Ready (10%) | Weighted |
| --- | --- | --- | --- | --- | --- | --- |
| **Custom Go Layout** | 10 | 8 | 9 | 7 | 7 | **8.55** |
| go-clean-template | 6 | 5 | 8 | 6 | 8 | 6.45 |
| go-clean-architecture-example | 7 | 6 | 7 | 5 | 6 | 6.40 |
| Go gRPC Boilerplate | 4 | 3 | 7 | 5 | 8 | 4.90 |

##### Frontend — Comparative Analysis (Weighted Scoring)

| Option | Stack Match (30%) | Custom Effort (25%) | Maintainability (20%) | Community (15%) | Prod Ready (10%) | Weighted |
| --- | --- | --- | --- | --- | --- | --- |
| **create-next-app (official)** | 10 | 9 | 9 | 10 | 8 | **9.35** |
| T3 Stack | 7 | 5 | 8 | 8 | 9 | 7.15 |
| Vercel commerce template | 5 | 3 | 7 | 7 | 9 | 5.70 |
| Custom from scratch | 10 | 3 | 6 | 3 | 3 | 5.60 |

### Selected Starters

#### Backend: Custom Go Clean Architecture Layout

**Rationale:** Off-the-shelf Go starters bundle wrong versions, wrong routers, and microservice assumptions requiring more rip-out work than starting from a defined layout. Custom layout matches our exact Clean Architecture decisions with zero friction.

##### Go Project Structure (Simplified via Occam's Razor)

```text
backend/
├── cmd/api/main.go              # Minimal: wire deps, start server
├── internal/
│   ├── app/                     # Application wiring & dependency injection
│   ├── domain/                  # Domain entities, value objects (ZERO imports)
│   │   ├── messaging/           # DM, conversations, customer context
│   │   ├── ai/                  # Brand Voice, draft generation
│   │   ├── payment/             # Transactions, payment links
│   │   ├── catalog/             # Products, inventory
│   │   ├── analytics/           # Engagement, algorithm intelligence
│   │   ├── tenant/              # Tenant, RBAC, team management
│   │   └── identity/            # Customer identity resolution (BSUID)
│   ├── port/                    # Interfaces (ports)
│   │   ├── http/                # HTTP handlers (inbound adapter)
│   │   └── repository/          # Repository interfaces (outbound ports)
│   ├── adapter/                 # Implementations (adapters)
│   │   ├── postgres/            # PostgreSQL repositories
│   │   ├── redis/               # Cache, pub/sub, event bus
│   │   ├── whatsapp/            # WhatsApp Business API adapter
│   │   ├── instagram/           # Meta Graph API adapter
│   │   ├── paystack/            # Paystack payment adapter
│   │   ├── flutterwave/         # Flutterwave payment adapter
│   │   └── ai/                  # AI provider adapters (DeepSeek, Gemini, GPT-4o)
│   ├── service/                 # Application services (use cases)
│   ├── middleware/              # HTTP middleware (tenant, auth, privacy proxy)
│   └── privacy/                 # PII stripping proxy (internal only)
├── migrations/                  # SQL migrations (golang-migrate)
├── config/                      # Configuration (Viper, env + YAML)
└── test/                        # Integration tests
```

##### Key Decisions (Enhanced by Advanced Elicitation)

- **Router:** `net/http` (Go 1.22+ enhanced mux) — standard library now supports path params and method matching. Fewer deps = fewer CVEs (War Room finding)
- **DI:** Wire (Google) or manual injection
- **Linting:** golangci-lint + go-arch-lint (enforces package boundaries)
- **Domain Events:** Shared event mechanism for cross-module communication (e.g., messaging → AI draft trigger)

#### Frontend: create-next-app (Next.js 16 — Verified Current Stable)

**Rationale:** Official CLI gives clean, opinionated baseline that exactly matches stack. Minimal customization, massive community, Vercel-maintained.

##### Initialization Command

```bash
npx -y create-next-app@latest ./frontend \
  --typescript \
  --tailwind \
  --eslint \
  --app \
  --src-dir \
  --turbopack \
  --import-alias "@/*"
```

##### What This Provides

- TypeScript 5.x with strict mode
- Tailwind CSS 4.x (matches UX Spec)
- App Router with Server Components (matches ADR-005)
- Turbopack (default in Next.js 16)
- ESLint with Next.js config
- `src/` directory for cleaner organization

##### Additions After Scaffolding

- shadcn/ui + Radix Primitives (per UX Spec)
- `@serwist/next` for PWA service worker (not deprecated next-pwa — War Room finding)
- TanStack Virtual for virtual scrolling (replaces react-window — better TS support)
- Playwright + Jest testing
- Sentry for error tracking

### Monorepo Structure

```text
social-automation/
├── backend/                     # Go 1.26 API (Clean Architecture)
├── frontend/                    # Next.js 16 PWA
├── infra/                       # Deployment/IaC artifacts (DigitalOcean configs)
│   └── .gitkeep                 # Placeholder in scaffolding stories
├── docs/                        # Planning artifacts, OpenAPI specs
│   ├── planning-artifacts/      # PRD, architecture, UX spec
│   └── api/                     # OpenAPI specs (codegen shared types)
├── .github/                     # GitHub Actions CI/CD (path-based triggers)
├── Makefile                     # make dev, make test, make lint, make help
└── README.md                    # Project overview, dev setup instructions
```

##### Monorepo Decisions (from Advanced Elicitation)

- **Path-based CI triggers** — backend changes don't rebuild frontend (DevOps War Room finding)
- **OpenAPI codegen for shared types** — replaces `shared/` directory (Occam's Razor finding)
- **Makefile with `make help`** — developer onboarding (`make dev-backend`, `make dev-frontend`, `make test`)
- **Docker Compose at repo root** — one command spins up PostgreSQL 18 + Redis 7.4 locally

### Alternatives Rejected (from What-If Scenarios)

| Alternative | Reason for Rejection |
| --- | --- |
| Remix instead of Next.js | Smaller ecosystem, fewer shadcn integrations, stack already committed |
| Separate repos (not monorepo) | Cross-repo PRs painful for solo dev, shared types harder to sync |
| Supabase instead of raw PostgreSQL | Vendor lock-in, conflicts with DigitalOcean, limits Go architectural control |
| Next.js API routes (no Go backend) | Can't match Go concurrency for webhooks, RLS weaker in Prisma, would require rewrite |
| Go Workspaces (multi-module) | Premature for MVP — single module with `internal/` is simpler. Noted as Phase 2 migration path |

### Chaos Monkey Validation

All 5 structural stress tests passed:

| Scenario | Result |
| --- | --- |
| Add TikTok adapter | ✅ New adapter implements existing platform port |
| Extract AI into microservice | ✅ Clean Architecture boundaries make extraction mechanical |
| New developer onboarding | ✅ `cmd/api/main.go` → `domain/` → predictable navigation |
| PostgreSQL outage | ✅ Service worker cache + circuit breaker + reconciliation worker |
| Bundle size regression | ✅ CI gate + App Router code splitting + dynamic imports |

**Note:** Project initialization using these starters should be the first implementation story.

---
