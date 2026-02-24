# Non-Functional Requirements

*Enhanced via Advanced Elicitation: Red Team vs Blue Team, Failure Mode Analysis, Chaos Monkey Scenarios, Architecture Decision Records, Self-Consistency Validation. Informed by open-source LLM and hybrid AI architecture research.*

> **Quality Contract:** These NFRs define HOW WELL the system must perform. Each requirement is specific, measurable, and testable. Architecture and engineering decisions must satisfy these thresholds.

### Performance

- NFR-P1: AI caption generation completes within 5 seconds (p95 target), 10 seconds hard ceiling (p99). UX shows progressive loading placeholder/skeleton after 2 seconds; full AI draft appears only when complete
- NFR-P2: Page load time ≤ 3 seconds on 3G connection (Nigerian mobile baseline)
- NFR-P3: WhatsApp message delivery (API submission) completes within 2 seconds
- NFR-P4: Payment link generation completes within 3 seconds
- NFR-P5: MVP contextual analytics surfaces (feed, inbox, home revenue card) render within 4 seconds with up to 90 days of data; dedicated analytics dashboard pages apply post-MVP/Growth
- NFR-P6: Search and filter operations across products, contacts, and conversations return results within 2 seconds
- NFR-P7: System supports 500 concurrent sellers with <10% performance degradation
- NFR-P8: Instagram post publishing (API submission) completes within 5 seconds including image upload
- NFR-P9: Scheduled-post queue/context surfaces load within 3 seconds while showing up to 30 days of scheduled posts; dedicated calendar pages are post-MVP/Growth
- NFR-P10: Real-time notifications (new DM, payment received) delivered within 5 seconds of event
- NFR-P11: Onboarding flow (signup → first post created) completable within 10 minutes end-to-end. Each onboarding step loads within 2 seconds
- NFR-P12: Brand Voice profile updates (from seller corrections) are reflected in next generation request. No batch delay — corrections applied immediately to the seller's voice profile
- NFR-P13: Voice note transcription completes within 10 seconds for messages up to 2 minutes. Transcription accuracy ≥ 85% for Nigerian English accents
- NFR-P14: Invoice/receipt PDF generation completes within 3 seconds. Invoice accessible via unique URL for minimum 1 year
- NFR-P15: MarketBoss tracking URL redirects (link router) complete within 500ms. Click logging is asynchronous — never delays redirect

### Security

- NFR-S1: All data encrypted at rest (AES-256) and in transit (TLS 1.3)
- NFR-S2: Social media tokens stored with application-level encryption; never exposed in API responses or logs
- NFR-S3: Multi-tenant data isolation enforced at database layer (row-level security) AND application layer — tested with automated cross-tenant access tests
- NFR-S4: KYC data (NIN, BVN, biometric hashes) stored in dedicated encrypted storage with access logging
- NFR-S5: Payment processing complies with PCI-DSS Level 4 (delegated to Paystack/Flutterwave — no raw card data stored)
- NFR-S6: Personal data processing complies with NDPA requirements including consent management, data export, and deletion within 72 hours of request
- NFR-S7: Session timeout tiered by role: Sellers 72 hours inactivity, Marketplace Admin 8 hours inactivity, Super Admin 1 hour inactivity. All sessions terminate on password change
- NFR-S8: Super Admin accounts require MFA (hardware key), IP whitelisting, and 90-day credential rotation
- NFR-S9: All state-changing API endpoints require authentication and authorization. Rate limits tiered: read endpoints 200 req/min/user, state-changing endpoints 30 req/min/user, authentication endpoints 5 req/min/IP
- NFR-S10: Audit logs for admin actions are immutable (append-only). MVP requires immutable core compliance/admin events with minimum 90-day hot retention. Growth+ expands to tiered retention: hot storage 90 days (instant query), warm storage 91 days–1 year (query within 1 hour), cold archive 1–3 years (query within 24 hours). Total retention: 3 years.
- NFR-S11: Cross-tenant data leak triggers immediate: (1) affected tenant isolation within 60 seconds, (2) admin alert within 60 seconds, (3) affected data audit within 4 hours. Breach reporting to NDPC within 72 hours per NDPA Article 40

### Scalability

- NFR-SC1: System architecture supports horizontal scaling from 100 users (beta) to 10,000 users without architecture changes
- NFR-SC2: Database design supports seamless migration from shared multi-tenant to dedicated per-tenant instances for enterprise accounts
- NFR-SC3: AI request queue handles burst traffic (10x normal) by queueing with priority (paid tier > free tier) and graceful degradation
- NFR-SC4: Image/media storage scales independently of application servers, using object storage (S3-compatible) with CDN distribution
- NFR-SC5: Background job processing (KYC verification, analytics aggregation, notification delivery) scales independently via worker pool
- NFR-SC6: API design supports pagination, cursor-based navigation, and field filtering to prevent over-fetching as data grows
- NFR-SC7: When concurrent user threshold is approached (80%), system activates request queuing. At 100%, new logins are queued with 'high demand' wait screen. System never crashes — always degrades gracefully

### Reliability & Availability

- NFR-R1: Platform targets 99.5% uptime (~3.65 hours/month planned maintenance), measured monthly
- NFR-R1a: Payment-related endpoints target 99.9% availability using Paystack/Flutterwave dual-gateway resilience (Phase 2+)
- NFR-R2: Payment gateway failover triggers within 30 seconds of primary provider failure (3 consecutive health check failures, Phase 2+)
- NFR-R3: SMS notification failover triggers within 60 seconds (Termii → Africa's Talking, Phase 2+)
- NFR-R4: AI service degradation activates cached template fallback within 5 minutes; manual posting mode after 1 hour
- NFR-R5: No data loss on any single infrastructure failure — all writes acknowledged by durable storage before confirming to user
- NFR-R6: Enterprise tenant database failover completes within 30 seconds with automatic promotion of read replica
- NFR-R7: System gracefully handles Nigerian network conditions: request timeouts ≤ 30 seconds, automatic retry with exponential backoff (max 3 retries)
- NFR-R8: Scheduled posts execute within 5-minute window of scheduled time, even during partial system degradation
- NFR-R9: Complete dual-gateway payment failure triggers degraded payment mode (bank transfer details) within 60 seconds. Seller notification within 120 seconds (Phase 2+)
- NFR-R10: Content drafts auto-saved every 30 seconds. Unsaved work recoverable for 24 hours after last auto-save. Payment transactions are atomic — partial completion is impossible
- NFR-R11: Scheduled posts that fail due to network timeout are automatically re-queued with 15-minute retry intervals for up to 6 hours. Seller notified after 3 failed attempts
- NFR-R12: System monitors settlement SLAs from payment providers. If settlement exceeds 24-hour SLA, proactive seller notification sent with expected resolution date. Admin dashboard shows settlement health
- NFR-R13: Dispute acknowledgment within 4 hours (automated). Admin mediation response within 48 hours. Dispute resolution (decision rendered) within 7 business days
- NFR-R14: Critical notifications (payment received, security alert, billing event) have guaranteed delivery: primary channel + fallback within 5 minutes. Non-critical (engagement prompt) best-effort, single channel

### Integration

- NFR-I1: All third-party integrations use adapter/provider pattern — adding a new payment gateway, KYC provider, AI model, or messaging service requires implementing an interface, not modifying core logic
- NFR-I2: Webhook endpoints process inbound events within 5 seconds and return HTTP 200; failed processing retried from dead letter queue
- NFR-I3: Social media API rate limits monitored in real-time with automatic throttling at 80% of limit ceiling
- NFR-I4: Integration health checks run from a centralized monitoring service (not per-instance). Critical services (payment, messaging) checked every 30 seconds; non-critical (analytics, KYC) every 5 minutes. Status broadcast via pub/sub to all application instances
- NFR-I5: All API credentials stored in secrets manager (not environment variables or code) with automatic rotation support
- NFR-I6: Open API (Phase 3) supports RESTful design, URL-based API versioning, and webhook event system
- NFR-I7: If social API rate limit is hit (HTTP 429), system immediately pauses all queued posts for that seller, notifies seller with estimated resume time, and does not retry for minimum 15 minutes
- NFR-I8: System monitors third-party API deprecation notices. Admin alerted 60 days before any API version end-of-life. Integration adapter supports running two API versions simultaneously during migration

### Mobile-First & Localization

- NFR-M1: Mobile-first responsive design with minimum supported width of 320px (optimized for 360px+), using canonical breakpoints at 480px (large phones), 768px (tablets), and 1024px (desktop) — no layout-breaking on any viewport
- NFR-M2: Application functions on minimum Android 10 / iOS 14 via mobile browser (Chrome, Safari)
- NFR-M3: Critical workflows (create post, respond to DM, generate payment link) are completable with one thumb on mobile. Minimum touch target size 48×48px. No critical actions behind long-press or precision taps
- NFR-M4: Application supports Pidgin English content generation and Nigerian English UI copy
- NFR-M5: Initial page payload ≤ 500KB compressed. Subsequent page navigations ≤ 100KB. Service worker caching for offline-tolerant patterns
- NFR-M6: Application supports offline-tolerant patterns: optimistic UI updates only for reversible actions (with undo), background sync when connectivity returns, and delivery-confirmed states (`sending` → `delivered`/`failed`) for irreversible sends
- NFR-M7: Offline-to-online sync conflicts resolved via last-write-wins with conflict notification to all parties. Seller sees 'This was changed while you were offline' alert with option to keep their version or the current version

### AI Provider Architecture

*Hybrid 3-tier model informed by open-source LLM research (Llama 4 Maverick, DeepSeek V3, Falcon 180B, Command R+, Llama 3 70B, Qwen 2.5 7B). Phased adoption from API-only (MVP) to self-hosted hybrid (Phase 3+).*

- NFR-AI1: System supports pluggable AI provider pattern with 3 tiers: Tier 1 (self-hosted 7B model for simple tasks — classification, routing, tagging), Tier 2 (RAG-optimized API for knowledge grounding — customer summaries, Brand Voice calibration), Tier 3 (premium API for creative content — caption generation, content strategy). Models switchable per tier without application changes
- NFR-AI2: AI request router classifies task complexity and routes to appropriate tier. Routing decision adds ≤ 100ms latency. Routing classifier itself runs on Tier 1 (self-hosted)
- NFR-AI3: Per-tier latency targets: Tier 1 (self-hosted) ≤ 2 seconds for simple tasks, Tier 2 (RAG API) ≤ 4 seconds for grounded generation, Tier 3 (creative API) ≤ 5 seconds p95 / 10 seconds p99 for creative content. All tiers support fallback to next tier on failure
