# Epic List

> [!IMPORTANT]
> **Epic taxonomy update (readiness remediation):** Items formerly labeled Epics 1-3 are now treated as **Prerequisite Enabler Tracks** (P1-P3), outside the primary product-value epic sequence. Product-value delivery sequence starts at Epic 4.

### Track P1 (Prerequisite Enabler, Formerly Epic 1): DevOps Foundation & Infrastructure

Developers and AI agents can clone, configure, build, and deploy the application with full CI/CD protection, automated security scanning, and a reproducible local development environment.

**FRs covered:** None (Foundational/Additional)

> [!IMPORTANT]
> **Time-box:** Epics 1-3 (DevOps + Backend + Frontend scaffolding) should be completed within ~2-3 weeks combined. Focus on minimal viable scaffolding — avoid gold-plating. Each story should produce the minimum structure needed for feature epics to build upon.

**Scope:** GitHub repo setup (branching strategy, branch protection, labels, issue templates), monorepo directory structure, Docker Compose local dev environment (PG18 + Redis 7.4 + privacy proxy mock), Makefile orchestration, CI/CD pipelines (GitHub Actions: lint, test, build, deploy-staging, deploy-production), security scanners (Semgrep, Dependabot, TruffleHog, Trivy), OWASP ZAP nightly config, .env.example template.

---

### Track P2 (Prerequisite Enabler, Formerly Epic 2): Backend Scaffolding & Data Foundation

The Go backend is operational with Clean Architecture structure, database schema foundation, migration tooling, query generation, Redis infrastructure, observability instrumentation, and health endpoints — ready to receive feature implementations.

**FRs covered:** None (Foundational/Additional)

**Scope:** Go 1.26 project layout (cmd/server, internal/domain, service, adapter, handler), golang-migrate setup with base schemas (tenants, users, sessions), RLS framework policies, sqlc configuration + initial query files, pgx/v5 connection pool (with AfterRelease RESET ALL), Redis client (cache-aside, streams, rate limiter scaffold), OpenAPI 3.1 spec foundation + oapi-codegen server stubs, event schema registry (backend/docs/events/), Zap structured logging, OpenTelemetry instrumentation, Sentry error tracking, health endpoints (/healthz, /readyz), go-arch-lint configuration.

---

### Track P3 (Prerequisite Enabler, Formerly Epic 3): Frontend Scaffolding & Design System

The Next.js frontend is operational with App Router, design system tokens, component library integration, state management, API client generation, service worker, and observability — ready to receive feature implementations.

**FRs covered:** None (Foundational/Additional)

**Scope:** Next.js 16 project (create-next-app with TypeScript, Tailwind CSS 4, App Router, src/ directory, Turbopack), shadcn/ui + Radix Primitives setup, design system tokens (colors, typography, spacing from UX spec), Zustand single store scaffold, TanStack Query client configuration, openapi-typescript type generation, React Hook Form + Zod setup, @serwist/next service worker, Sentry frontend SDK, shared components (LoadingSkeleton, ErrorBoundary, ErrorState, EmptyState, OfflineBanner, CurrencyDisplay), BFF proxy route (api/v1/[...proxy]), root layout (providers, fonts, metadata), globals.css with Tailwind base + tokens, Jest + Playwright config, ESLint + custom Zustand rule.

---

### Epic 4: Authentication & Multi-Tenancy

Sellers can register with email and phone via OTP verification, log in securely, manage their active sessions, and receive alerts about suspicious account activity. The platform enforces complete tenant data isolation.

**FRs covered:** FR1, FR5, FR106, FR107

**Scope:** OTP verification (email + phone), JWT auth (RS256, httpOnly cookies, __Host- prefix, 15min access + 7d refresh), tenant context injection → RLS pipeline, session management (view + terminate), suspicious activity detection (new device, IP, bulk access), frontend auth pages (login, register), cross-tenant isolation test suite, rate limiting on auth endpoints (5 req/min/IP).

---

### Epic 5: Seller Onboarding & Business Profile

Sellers complete a guided onboarding journey: choose their social platform, connect Instagram/WhatsApp accounts, train their Brand Voice with sample content, set up their comprehensive Business Profile, and receive AI readiness indicators — establishing the foundation for AI-powered content and customer engagement.

**FRs covered:** FR2, FR3, FR4, FR6, FR7, FR8, FR9, FR10, FR11, FR12, FR13, FR14, FR15, FR16

**Scope:** Platform selection (IG/WhatsApp primary), Instagram Business API connection flow, WhatsApp Business API connection flow, Brand Voice onboarding (5 inputs minimum, blocks AI until met), pre-MarketBoss baseline metrics capture, product category selection (prohibited category blocking), regulated category certification uploads, Business Profile Form (comprehensive), social platform data ingestion (pre-fill from IG tags / WA catalog), per-product quick form, advisory gap indicator, RAG pipeline data integration, incomplete onboarding detection + persistent prompts, first post creation guided walkthrough.

---

### Epic 6: AI-Powered Content Creation

Sellers create brand-authentic, market-appropriate AI-powered content with quality controls, iteration workflows, and fallback mechanisms. The AI engine calibrates to each seller's unique voice and adapts to the Nigerian market context.

**FRs covered:** FR17, FR18, FR19, FR20, FR21, FR22, FR23, FR24, FR25, FR26, FR27, FR28, FR113, FR114

> [!CAUTION]
> **Highest-risk epic** (scored 15/25 in Comparative Analysis). The 3-tier AI router + privacy proxy + 3 external providers is the most technically complex work in the project. **The first story in this epic MUST be an "AI Pipeline Smoke Test"** — a focused architectural spike that proves the router → privacy proxy → provider → response chain works E2E with a single provider before building any feature stories.

**Scope:** AI Pipeline Smoke Test (E2E architectural spike), 3-tier AI router (DeepSeek / Gemini / GPT-4o) with privacy proxy, Brand Voice-calibrated caption generation, content iteration (regenerate with feedback, edit before publish), audio preview before publish (FR113), mandatory "Sounds Like Me" publish trust gate (FR114), payment link CTA embedding in captions, cross-tenant uniqueness checking, AI detection resistance (pattern variation), batch content generation, Brand Voice fidelity scoring + recalibration, Nigerian market localization (Pidgin English, local slang, cultural references), learning from seller corrections, fallback templates when AI unavailable, AI budget tracking per tenant.

---

### Epic 7: Social Publishing & Channel Management

Sellers publish AI-generated content to connected social platforms, schedule posts at AI-recommended optimal times, manage their social channels, and handle platform-level messaging operations with resilient delivery.

**FRs covered:** FR29, FR30, FR31, FR34, FR35, FR36, FR37, FR38, FR39

**Scope:** Instagram post publishing (single-image, carousel), AI-recommended optimal time scheduling, scheduled post queue management (feed-native contextual surface), rate limit detection + graceful degradation, business hours configuration + after-hours auto-responses, message delivery prioritization (live DMs > scheduled > bulk), WhatsApp catalog sync, segmented list messaging (preview + confirm), platform disconnection detection + reconnection guidance, Redis Streams event publishing for real-time feed updates.

**Dependencies:** Epic 5 (platform connections), Epic 6 (AI-generated content to publish)

> [!NOTE]
> **Partial dependency on Epic 6:** Only publishing stories (FR29-FR31, FR30 AI scheduling) require Epic 6. Channel management stories (FR34-FR39: rate limits, business hours, catalog sync, segmented messaging, disconnection handling) can start immediately after Epic 5, in parallel with Epic 6 work.

---

### Epic 8: Product Catalog & Sales Pipeline

Sellers manage product catalog operations, track order journeys, coordinate delivery updates, and handle buyer dispute intake with sales visibility.

**FRs covered:** FR40, FR41, FR46, FR48, FR50, FR52, FR53, FR63

**Scope:** Product CRUD + media management, shareable product links, inventory tracking and low-stock alerts, pricing/bulk operations, order intake and lifecycle tracking, delivery coordination with customer progress updates, returns/refund workflows, customer feedback + dispute intake, and contextual sales insights surfaces.

---

### Epic 9: Customer Engagement & Conversational Commerce

Sellers manage customer conversations in a unified inbox, apply labels/segments and reusable templates, hand off complex threads to humans, and preserve clear AI/human attribution.

**FRs covered:** FR32, FR33, FR55, FR56, FR57, FR58, FR59, FR60, FR61, FR62

**Scope:** Unified inbox for WhatsApp/Instagram messages, WhatsApp payment-link delivery in conversations, human handoff for escalations, response templates + team template access, customer labels and segmentation, buyer-message ingestion that is never blocked, and explicit system-vs-human attribution.

**Dependencies:** Epic 5 (platform connections), Epic 6 (AI drafts), Epic 7 (messaging infrastructure), Epic 8 (payment links for DMs)

> [!NOTE]
> **Partial dependencies — stories can start earlier:** Unified inbox (FR32), response templates (FR57-FR58), customer tagging/segmentation (FR59-FR60), and attribution logging (FR62) only require Epic 5 (platform connections). AI draft features (FR55, FR56 — the "3-tap DM Close") require Epic 6. Payment link in DMs (FR33) requires Epic 8. Stories should be ordered to maximize parallelism.

---

### Epic 10: Payment, Subscription & Billing Operations

Sellers manage payment collection, settlement workflows, subscription billing controls, and billing communications from a unified operational flow.

**FRs covered:** FR42, FR43, FR44, FR45, FR47, FR49, FR51, FR54, FR104, FR105, FR109, FR110, FR112

**Scope:** Payment link generation + tracking, webhook-driven payment status updates, multi-method payment support with fallback paths, installment/partial payment handling, reconciliation + settlement reporting, billing lifecycle communications, notification-channel preferences, subscription-tier operations, and branded invoice/receipt output.

---

### Epic 11: Team Collaboration & Role Management

Sellers delegate work to team members with granular RBAC permissions, manage draft approval workflows, track team activity with clear attribution, and maintain operational control including emergency overrides.

**FRs covered:** FR71, FR72, FR73, FR74, FR75, FR76, FR77, FR78, FR79, FR80, FR81, FR82, FR83

**Scope:** Team member invitations (phone/email), granular RBAC permissions (view, respond, create drafts, publish, analytics, settings), role-based UI simplification, draft creation + scheduling (pending owner approval), remote approval/rejection workflow, activity logging with system vs human attribution, team performance metrics (without revenue visibility), workload-based conversation auto-assignment, explicit emergency "Pause Auto-Replies" control (FR79), explicit catalog staleness warning at 6h+ (FR80), access revocation, team member → independent account upgrade path, after-hours auto-response customization.

---

### Epic 12: Growth Insights & Contextual Analytics

Sellers analyze performance trends through contextual analytics, compare outcomes against baseline, and receive actionable growth recommendations directly in operational surfaces.

**FRs covered:** FR64, FR65, FR66, FR67, FR68, FR69, FR70

**Scope:** Contextual engagement insights surfaces, AI-vs-human performance comparison, revenue attribution + ROI tracking, growth trend analysis, customer behavior analytics, content performance insights, and exportable scheduled reports with contextual action prompts.

---

### Epic 13: Platform Administration & Compliance

Super Admins and Marketplace Admins can manage the platform, moderate content, resolve disputes, configure tenant and platform settings, and ensure full NDPA regulatory compliance with immutable audit trails.

**FRs covered:** FR84, FR85, FR86, FR87, FR88, FR89, FR90, FR91, FR92, FR93, FR94, FR95, FR96, FR97, FR98, FR99, FR100, FR101, FR102, FR103, FR108, FR111

**Scope:** Super Admin account management (create/remove), Marketplace Admin onboarding review, admin role separation (onboarding ≠ disputes), platform health metrics (uptime, AI usage, active users, signups), support ticket management (urgency-based), user-level analytics + content history (troubleshooting), admin Brand Voice recalibration, dispute mediation + resolution (4h ack, 48h response, 7d resolution), immutable consent records (NDPA), data deletion requests (72h compliance), content moderation (flagging, takedowns, appeals), pre-publication content screening (prohibited categories), multi-tenant data isolation enforcement, customer data export (PII anonymized), voice note support submissions, tenant-level limits configuration, platform-wide settings (commission rates, grace periods, feature gates), seller billing management, trust journey tracking.

---

