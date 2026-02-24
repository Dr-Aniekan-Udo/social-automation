# Project Context Analysis

### Requirements Overview

##### Functional Requirements

| Domain | Key FRs | Architectural Impact |
| -------- | --------- | --------------------- |
| **AI Content Generation** | Brand Voice training, 3-tier model routing (DeepSeek → Gemini → GPT-4o), tone switching, "Sounds Like Me" feedback loop | AI orchestration layer, model router, prompt caching, per-tenant model training data |
| **Unified Inbox (DM Close)** | WhatsApp + Instagram DM aggregation, AI draft pre-generation on DM arrival, PrimingCard context overlay, 3-draft limit, payment link embedding | Real-time webhook processing, message queue, customer context service, payment gateway integration |
| **Payment Integration** | Paystack + Flutterwave, 24h link expiry, webhook-driven status updates, escrow (future), ₦ currency formatting | Payment gateway adapter pattern, webhook handlers, transaction state machine |
| **Product Catalog** | Voice/camera product entry, NLP price parsing, stock tracking, cross-sell intelligence | Media processing pipeline, NLP service, inventory management |
| **Analytics & Algorithm Intelligence** | Engagement data collection, posting time optimizer, A/B testing, hashtag engine, per-platform algorithm signal mapping | Data pipeline, statistical analysis service, background job scheduling |
| **Multi-Platform Publishing** | Instagram, WhatsApp, TikTok (future), Facebook — content scheduling, optimal time posting | Platform adapter pattern, job scheduler, content queue |
| **Multi-Tenancy** | Tenant isolation via PostgreSQL RLS, per-tenant Brand Voice, per-tenant analytics, RBAC | Row-Level Security, tenant context middleware, data partitioning strategy |

##### Non-Functional Requirements

| NFR | Target | Architectural Implication |
| ----- | -------- | -------------------------- |
| **Performance** | LCP <2.5s, INP <200ms, CLS <0.1, DM reply <10s | PWA with service worker caching, pre-generated AI drafts, optimistic UI |
| **Device Support** | Tecno Spark 10 (3GB RAM), Infinix Hot 30 (2GB RAM), 720p screens | Virtual scrolling (@tanstack/virtual), CSS-only animations, aggressive bundle optimization |
| **Offline Capability** | Cached feed, offline send queue, graceful reconnection | IndexedDB persistence, service worker, offline-first architecture |
| **Security** | NDPA + GAID compliance, PII stripping proxy, TLS 1.3, data encryption at rest | Privacy-Preserving Proxy layer, encryption middleware, audit logging |
| **Scalability** | Modular monolith → microservices, multi-tenant from Day 1 | Clean Architecture (ports & adapters), tenant-scoped data access |
| **Reliability** | 99.9% uptime, graceful degradation, circuit breakers | Health checks, retry mechanisms, fallback patterns |
| **Network** | 3G (750Kbps) as primary, 2G (50Kbps) as worst-case | Aggressive compression, lazy loading, Data Saver header respect |

##### Scale & Complexity

| Indicator | Assessment | Evidence |
| ----------- | ----------- | ---------- |
| Real-time features | 🔴 High | SSE for DM notifications and live feed updates, plus webhook-driven event processing |
| Multi-tenancy | 🔴 High | PostgreSQL RLS, per-tenant AI models, per-tenant analytics, RBAC |
| Regulatory compliance | 🔴 High | NDPA, GAID, PCI-DSS via gateways, WhatsApp/Meta ToS, TikTok policies |
| Integration complexity | 🔴 High | WhatsApp Business API, Meta Graph API, Paystack, Flutterwave, 3 AI providers |
| User interaction complexity | 🔴 High | 15 custom components, 9-state feed item state machine, inline expansion |
| Data complexity | 🟡 Medium-High | Multi-tenant analytics, customer history, A/B results, cross-platform attribution |

- Primary domain: Full-stack SaaS (Go backend + Next.js PWA frontend)
- Complexity level: Enterprise-grade
- Estimated architectural components: 12-15 major services/modules

### Technical Constraints & Dependencies

| Constraint | Impact |
| ----------- | -------- |
| **Device constraint** (2-3GB RAM, 720p, 3G) | Drives aggressive frontend optimization — virtual scrolling, CSS-only animations, service worker caching, font subsetting |
| **WhatsApp API verification** (2-6 weeks) | MVP launch baseline is Instagram-first; WhatsApp is included in MVP only if approval lands within the build window, otherwise added immediately after approval |
| **AI cost management** | 3-tier model routing + semantic caching required from Day 1 |
| **Meta API rate limits** | Polling-based Instagram DM detection (30-60s) vs webhook-based WhatsApp (1-3s) |
| **Nigerian payment landscape** | Dual-gateway pattern (Paystack + Flutterwave), no card storage (PCI via gateways) |
| **BSUID transition** (WhatsApp) | Identity resolution schema must support multi-identifier from Day 1 |
| **Channel diversification** | Never 100% dependent on Meta — Telegram/RCS/SMS fallback in architecture |
| **Pinned stack versions** | Go 1.26, PostgreSQL 18, Redis 7.4+, Node.js 24.x, React 19.x, Next.js 16.x |

MVP launch policy is explicit: ship Instagram-first by default, and enable WhatsApp in MVP only when Business API approval clears during the MVP build window.

### Cross-Cutting Concerns Identified

1. **Tenant Isolation** — Every data access, AI call, and analytics query must be tenant-scoped
2. **Privacy-Preserving Proxy** — PII stripping before AI API calls (NDPA compliance)
3. **Observability** — OpenTelemetry + SigNoz traces, Sentry errors, structured logging (zap) with tenant/request context
4. **Offline Resilience** — IndexedDB persistence, service worker, offline queue, graceful reconnection
5. **Cultural Intelligence** — Pidgin/English/Formal tone support, Naira formatting, emerald+gold color system
6. **Rate Limiting & Cost Control** — AI model cost monitoring, platform API rate limiting, 3-draft-per-DM limits
7. **Authentication & Authorization** — Phone OTP signup, RBAC (Owner/Manager/Staff), team features
8. **Error Handling** — Wrapped errors with context (`fmt.Errorf`), error boundaries on frontend, user-friendly messages

### UX-Driven Architecture Requirements

From the UX Design Specification (2,675 lines):

- **Component complexity:** 15 custom components across 3 implementation tiers, 9-state feed item state machine
- **Animation/transition:** CSS-only animations (no JS animation libraries), `prefers-reduced-motion` support, Tecno device stress-tested
- **Real-time updates:** DM notifications, payment status, feed refresh — SSE for frontend updates
- **Platform-specific:** PWA with service worker, bottom sheet patterns, safe area insets
- **Accessibility:** WCAG 2.1 Level AA, axe-core CI gate (min score 95), screen reader support (ARIA), keyboard navigation
- **Responsive:** Mobile-first with 3 breakpoints (480px, 768px, 1024px), container queries
- **Offline:** Cached feed, offline send queue, stale-while-revalidate
- **Performance:** LCP <2.5s on 3G, virtual scrolling, skeleton loading, image optimization (WebP + JPEG fallback)

---
