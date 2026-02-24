# Requirements Inventory

### Functional Requirements

**Seller Onboarding & Identity (FR1–FR16)**

- FR1: Seller can sign up using email and phone with OTP verification
- FR2: Seller can choose a primary social platform (Instagram or WhatsApp) during onboarding
- FR3: Seller can complete Brand Voice Onboarding by submitting minimum 5 brand-voice training inputs (captions, product listings, or voice samples); seller is never dropped from onboarding, but AI post generation is blocked until the minimum input threshold is met
- FR4: System captures the seller's pre-MarketBoss baseline metrics (reach, engagement, follower count) at signup
- FR5: Seller can complete low-friction onboarding verification at signup; enhanced KYC is deferred and required for payment features and higher transaction limits
- FR6: Seller can select their product category during onboarding, with prohibited categories blocked
- FR7: Sellers in regulated categories (food, cosmetics) can upload required certifications for verification before first sale
- FR8: System detects incomplete onboarding (insufficient brand-voice training input or incomplete Business Profile) and shows a persistent prompt to complete it; post generation remains blocked until requirements are met
- FR9: Seller can connect their Instagram Business account to the platform
- FR10: Seller can connect their WhatsApp Business account to the platform
- FR11: System guides new sellers through first post creation step-by-step
- FR12: Seller completes a Business Profile Form during onboarding capturing: business name, description, product categories, pricing ranges, shipping policy (delivery areas, costs, timelines), return/refund policy, accepted payment methods, operating hours, physical location (if applicable), contact channels, and common FAQs
- FR13: System ingests product information from connected social platforms (Instagram product tags, WhatsApp catalog) and pre-fills Business Profile fields where possible
- FR14: Seller captures minimal per-product data when creating a post using quick form and/or multimodal shortcuts (camera-assisted product capture and voice input), always storing product name, price, key features, and availability so AI has sufficient context for buyer inquiry responses
- FR15: AI analyzes the combined Business Profile + product data against a library of common buyer questions and displays an advisory gap indicator
- FR16: Business Profile and per-product data feed into the RAG pipeline, enabling AI to answer buyer DMs and generate content with accurate, seller-specific information

**AI Content Creation (FR17–FR28)**

- FR17: Seller can generate AI-powered captions calibrated to their Brand Voice profile
- FR18: Seller can regenerate AI content with feedback to improve results
- FR19: Seller can edit AI-generated content before publishing
- FR20: System generates captions with embedded payment link calls-to-action
- FR21: System performs cross-tenant uniqueness checking to prevent niche collision between sellers in the same category
- FR22: System varies AI content patterns to resist AI detection by followers
- FR23: Seller can generate content in batch for multiple products
- FR24: System scores Brand Voice fidelity and warns when calibration data is insufficient
- FR25: Seller can recalibrate their Brand Voice profile with additional captions
- FR26: System generates contextually appropriate content for Nigerian market (including Pidgin English, local slang, cultural references)
- FR27: System learns from seller content corrections to improve future AI output
- FR28: System provides fallback content options (cached templates, manual mode) when AI is unavailable

**Social Channel Management (FR29–FR39)**

- FR29: Seller can publish single-image and carousel posts to Instagram
- FR30: Seller can schedule posts for AI-recommended optimal times
- FR31: Seller can view, reschedule, and cancel scheduled posts through a feed-native scheduled queue (MVP contextual surface), with full calendar views deferred to post-MVP/Growth
- FR32: Seller can view and respond to WhatsApp messages through a unified inbox
- FR33: Seller can send payment links via WhatsApp messages
- FR34: System detects rate limits and gracefully degrades (prioritizing live DMs over queued messages)
- FR35: Seller can configure business hours, with automated after-hours responses for incoming messages
- FR36: System prioritizes message delivery: live DMs > scheduled messages > bulk communications
- FR37: Seller can sync product catalog to WhatsApp Business
- FR38: Seller can preview and confirm messages before sending to segmented lists
- FR39: System detects social platform disconnection and guides seller through reconnection

**Sales & Payment Processing (FR40–FR54)**

- FR40: Seller can manage product catalog (add, edit, remove products with pricing and stock levels)
- FR41: Seller can upload and manage product media (photos/videos)
- FR42: Seller can generate payment links tied to specific customer inquiries
- FR43: Buyer receives a digital receipt with seller identity, product details, amount, and support contact after payment
- FR44: Verified sellers display a Verification Badge on receipts and payment links
- FR45: System generates and logs MarketBoss tracking URLs for seller bios and payment links
- FR46: Seller can track customer inquiries as lead cards with status progression
- FR47: Seller can manage multi-stage deals (e.g., deposit → work-in-progress → final payment)
- FR48: System tracks cross-platform customer journeys (e.g., IG post → WhatsApp DM → payment → delivery)
- FR49: System provides a fallback payment method (bank transfer details) when the primary payment provider is unavailable
- FR50: Seller can view a Content Performance Score showing engagement metrics per post
- FR51: Seller can view and manage active/expired payment links
- FR52: Seller can generate shareable product links for any channel
- FR53: Seller can share progress updates with customers during multi-stage deals
- FR54: Seller can view payout history and settlement reports

**Customer Engagement & Conversations (FR55–FR63)**

- FR55: Seller receives a customer summary card (conversation priming) when a new inquiry arrives
- FR56: Seller can take over automated conversations with a one-tap human handoff
- FR57: Seller can set up response templates for common inquiries
- FR58: Team members can use response templates set up by the account owner
- FR59: Seller can tag contacts with relationship types (e.g., regular, new, wholesale) and assign price tiers
- FR60: Seller can segment customer lists for targeted communications
- FR61: Buyer-initiated messages are never blocked, regardless of the seller's messaging limit
- FR62: System logs system-generated vs human-generated responses for clear attribution
- FR63: Buyer can initiate a dispute during escrow period

**Growth Insights & Analytics (FR64–FR70)**

- FR64: Seller can view contextual MVP analytics (post performance, engagement rate, follower growth) within feed/inbox/home surfaces; dedicated analytics dashboard is post-MVP/Growth
- FR65: System provides engagement prompts suggesting actions to increase reach
- FR66: System alerts the seller when their reach drops below their pre-MarketBoss baseline
- FR67: System shows sellers their progress compared to their pre-MarketBoss baseline
- FR68: System provides content strategy suggestions tailored to the seller's account type and niche
- FR69: Seller receives a warning when approaching their tier usage limits (at 80% threshold)
- FR70: Seller can view pending-task summaries directly in home/feed/inbox contextual surfaces without requiring a dedicated MVP analytics dashboard

**Team Collaboration (FR71–FR83)**

- FR71: Seller (account owner) can invite team members via phone or email
- FR72: Seller can assign granular permissions to team members (view inquiries, respond, create drafts, publish, view analytics, change settings)
- FR73: Team members see a simplified role-based UI matching their permissions
- FR74: Team members can create draft posts that require owner approval before publishing
- FR75: Team members can schedule drafts pending owner approval
- FR76: Account owner can review and approve/reject draft posts remotely
- FR77: System logs all team member activity with clear system vs human attribution
- FR78: Team members can view their performance metrics without seeing revenue figures
- FR79: Team members can activate an emergency "Pause Auto-Replies" function
- FR80: System warns when product catalog has not been updated for 6+ hours
- FR81: Seller can revoke team member access
- FR82: Team member can upgrade to an independent MarketBoss account
- FR83: Seller can customize after-hours auto-response messages

**Platform Administration & Compliance (FR84–FR103)**

- FR84: Super Admin can create and remove marketplace admin accounts
- FR85: Marketplace Admin can review and approve seller onboarding applications
- FR86: Admin roles are separated: onboarding admin cannot perform dispute resolution, and vice versa
- FR87: Admin can view platform health metrics (uptime, AI usage, active users, signups)
- FR88: Admin can manage support tickets with urgency-based prioritization
- FR89: Admin can access user-level analytics and content history for troubleshooting
- FR90: Admin can initiate Brand Voice recalibration for a seller's account
- FR91: Admin can mediate and resolve buyer-seller disputes
- FR92: System maintains immutable consent records for data protection compliance (timestamped, purpose-specific)
- FR93: System processes data deletion requests within the required compliance timeframe
- FR94: Admin can moderate content (review flagged posts, process takedown requests)
- FR95: System screens content pre-publication for prohibited categories and restricted content
- FR96: System enforces multi-tenant data isolation (zero cross-tenant data leakage)
- FR97: Sellers can export their customer data (with PII anonymized per policy)
- FR98: System supports voice note submissions for support requests with transcription
- FR99: Admin can configure tenant-level limits (post limits, message limits, products, storage)
- FR100: Admin can configure platform-wide settings (commission rates, grace periods, feature gate defaults)
- FR101: Admin can manage seller billing (view payment status, retry failed payments, manual adjustments)
- FR102: Seller can appeal content moderation decisions
- FR103: System tracks trust journey progression as an internal admin metric

**Notifications & Security (FR104–FR108)**

- FR104: Seller can configure notification preferences (channel: push, WhatsApp, SMS, email)
- FR105: Seller receives notifications about billing lifecycle events (grace period, downgrade, suspension)
- FR106: Seller can view and terminate their active sessions
- FR107: System alerts users about suspicious account activity (new device, new IP, bulk data access)
- FR108: Users can withdraw specific consent types (NDPA requirement)

**Subscription & Billing (FR109–FR112)**

- FR109: Seller can view their current subscription plan and usage
- FR110: Seller can upgrade or downgrade their subscription tier
- FR111: System enforces tier-based limits server-side (daily posts, messages, products, connected accounts)
- FR112: System generates invoices/receipts with seller's business branding

**AI Trust Controls (FR113-FR114)**

- FR113: Seller can play an audio preview of AI-generated caption content before publishing
- FR114: System requires a per-post "Sounds Like Me" trust rating before publish; publish is enabled only when rating is 4/5 or 5/5, while lower ratings require regenerate or edit before publish

### Non-Functional Requirements

**Performance (NFR-P1–NFR-P15)**

- NFR-P1: AI caption generation ≤5s p95, 10s hard ceiling p99. Progressive skeleton after 2s
- NFR-P2: Page load ≤3s on 3G (Nigerian mobile baseline)
- NFR-P3: WhatsApp message delivery (API submission) ≤2s
- NFR-P4: Payment link generation ≤3s
- NFR-P5: MVP contextual analytics render ≤4s with 90 days data
- NFR-P6: Search/filter operations ≤2s
- NFR-P7: 500 concurrent sellers with <10% degradation
- NFR-P8: Instagram post publishing ≤5s including image upload
- NFR-P9: Scheduled-post queue loads ≤3s (30 days)
- NFR-P10: Real-time notifications ≤5s of event
- NFR-P11: Onboarding flow completable within 10 minutes
- NFR-P12: Brand Voice updates reflected in next generation request (no batch delay)
- NFR-P13: Voice note transcription ≤10s for 2min, ≥85% accuracy for Nigerian English
- NFR-P14: Invoice/receipt PDF generation ≤3s, URL accessible ≥1 year
- NFR-P15: Tracking URL redirects ≤500ms, click logging async

**Security (NFR-S1–NFR-S11)**

- NFR-S1: AES-256 at rest, TLS 1.3 in transit
- NFR-S2: Social media tokens encrypted, never exposed in API/logs
- NFR-S3: Multi-tenant isolation at DB (RLS) + application layer, automated testing
- NFR-S4: KYC data in dedicated encrypted storage with access logging
- NFR-S5: PCI-DSS Level 4 compliance (delegated to Paystack/Flutterwave)
- NFR-S6: NDPA compliance (consent, export, deletion within 72h)
- NFR-S7: Session timeouts tiered by role (Seller 72h, Admin 8h, Super Admin 1h)
- NFR-S8: Super Admin requires MFA + IP whitelisting + 90-day rotation
- NFR-S9: Auth + rate limits tiered per endpoint type
- NFR-S10: Immutable audit logs with tiered retention (90-day hot MVP)
- NFR-S11: Cross-tenant leak triggers isolation within 60s + admin alert

**Scalability (NFR-SC1–NFR-SC7)**

- NFR-SC1: Horizontal scaling 100 → 10,000 users without architecture changes
- NFR-SC2: Migration path to dedicated per-tenant DB instances
- NFR-SC3: AI queuing with tier priority + graceful degradation on 10x bursts
- NFR-SC4: Independent media storage scaling (S3-compatible + CDN)
- NFR-SC5: Independent background job scaling via worker pool
- NFR-SC6: Pagination, cursor-based navigation, field filtering
- NFR-SC7: Graceful degradation at capacity: queuing → wait screen → never crash

**Reliability & Availability (NFR-R1–NFR-R14)**

- NFR-R1: 99.5% uptime monthly
- NFR-R1a: Payment endpoints 99.9% (dual-gateway, Phase 2+)
- NFR-R2–R3: Payment/SMS failover within 30–60s (Phase 2+)
- NFR-R4: AI degradation → cached templates (5min) → manual mode (1hr)
- NFR-R5: No data loss on single infrastructure failure
- NFR-R6: Enterprise DB failover ≤30s
- NFR-R7: Nigerian network handling: 30s timeout, 3 retries exponential backoff
- NFR-R8: Scheduled posts within 5-min window during partial degradation
- NFR-R9: Dual payment failure → bank transfer fallback (60s)
- NFR-R10: Draft auto-save 30s, recoverable 24h. Payment atomic
- NFR-R11: Failed scheduled posts re-queued 15min intervals, 6hr max
- NFR-R12: Settlement SLA monitoring with proactive notification
- NFR-R13: Dispute lifecycle: 4h ack, 48h admin response, 7-day resolution
- NFR-R14: Critical notifications guaranteed (primary + fallback in 5min)

**Integration (NFR-I1–NFR-I8)**

- NFR-I1: Adapter/provider pattern for all integrations
- NFR-I2: Webhook processing ≤5s with dead letter queue retry
- NFR-I3: Social API rate limit monitoring with auto-throttle at 80%
- NFR-I4: Centralized health checks (30s critical, 5min non-critical)
- NFR-I5: Secrets manager for all API credentials
- NFR-I6: Open API with RESTful design + versioning (Phase 3)
- NFR-I7: Rate limit 429 → pause + notify + 15min backoff
- NFR-I8: Third-party API deprecation monitoring (60-day alerts)

**Mobile-First & Localization (NFR-M1–NFR-M7)**

- NFR-M1: Mobile-first responsive (320px min, optimized 360px+, breakpoints 480/768/1024)
- NFR-M2: Android 10+ / iOS 14+ via mobile browser
- NFR-M3: Critical workflows completable with one thumb, 48×48px touch targets
- NFR-M4: Pidgin English content + Nigerian English UI
- NFR-M5: Initial payload ≤500KB, subsequent ≤100KB, service worker caching
- NFR-M6: Offline-tolerant: optimistic UI (reversible only) + background sync
- NFR-M7: Offline sync: last-write-wins + conflict notification

**AI Provider Architecture (NFR-AI1–NFR-AI3)**

- NFR-AI1: Pluggable 3-tier AI (Tier 1: self-hosted 7B, Tier 2: RAG API, Tier 3: premium creative). Models switchable per tier
- NFR-AI2: AI router classifies task complexity, ≤100ms latency. Router runs on Tier 1
- NFR-AI3: Per-tier latency: T1 ≤2s, T2 ≤4s, T3 ≤5s p95 / 10s p99. Cross-tier fallback

### Additional Requirements

**Readiness Remediation IDs (for enabler/additional traceability):**

- ENB-E1: DevOps foundation prerequisite track (repo governance, CI/CD, security scanning, deploy pipeline)
- ENB-E2: Backend foundation prerequisite track (Clean Architecture scaffolding, migrations, sqlc, Redis, observability)
- ENB-E3: Frontend foundation prerequisite track (Next.js scaffolding, design system, state/query layers, PWA, test harness)
- AR-TEN-1: Cross-tenant isolation validation is mandatory for all data-touching stories
- AR-AUTH-UX-1: Mobile auth UX hardening and verification screens are required implementation support work
- AR-SEC-1: Authentication attack-resilience controls (rate limiting, lockout, brute-force mitigation) are required
- AR-AI-1: AI pipeline smoke-test validation is required before feature-level AI rollout
- AR-AI-2: Privacy proxy + 3-tier AI routing and failover are required operational controls
- AR-VIS-1: Hybrid composition image pipeline remains approved MVP additional scope
- AR-VIS-2: Layout templates + Brand Kit onboarding remain approved MVP additional scope
- AR-OPS-INV-1: Inventory low-stock and stock-governance controls are required operational safeguards
- AR-OPS-PRICING-1: Pricing-tier and bulk-pricing operations are required merchandising controls
- AR-OPS-RETURNS-1: Returns/refund workflow capture is required post-sale operations support
- AR-CONV-1: AI auto-response operations are required conversation-scale support capabilities
- AR-PAY-REFUND-1: Refund operations via provider APIs are required financial operations support
- AR-PAY-DISPUTE-1: Dispute/security workflow is required payment operations risk control
- AR-COLLAB-NOTES-1: Internal team notes are required collaboration support capability
- AR-WORKLOAD-1: Workload-based conversation auto-assignment is approved additional operational scope

**From Architecture:**

- Starter template: Custom Go Clean Architecture layout (backend) + create-next-app (frontend) — project scaffolding is the first implementation work
- Implementation sequence: scaffolding → DB schema + RLS + migrations → sqlc → JWT auth + tenant context → OpenAPI spec + codegen → Redis (cache + streams) → Frontend data layer → Platform adapters → AI router + privacy proxy → Observability
- Clean Architecture import rules: domain(zero) → service(domain only) → adapter(implements domain) → handler(calls service only)
- Cross-domain service rule: services MAY call other services, MUST NOT import cross-domain repositories
- UUIDv7 for all primary keys
- Event schema registry with CI validation
- Monorepo: backend/ + frontend/ + infra/ + docs/ + api/ + .github/
- Docker Compose for local dev (PG18 + Redis 7.4)
- GitHub Actions CI/CD with path-based triggers
- Makefile orchestration (make dev, make test, make lint)
- Tenant isolation test suite mandatory for all data-touching changes
- Webhook idempotency via event_id/message_id
- Privacy Proxy mandatory and non-bypassable for all AI calls
- pgx AfterRelease hook: RESET ALL on every connection return
- Redis ACLs + tenant-scoped stream names
- Envelope encryption for PII data keys
- SSE with Last-Event-ID reconnection + polling fallback
- Async AI draft generation (returns pending → SSE delivers result)
- AI budget tracking per tenant with monthly cost cap
- Brand Voice maturity signal drives model tier promotion
- Rate limiter fails open on Redis outage

**From UX Design Specification:**

- WCAG 2.1 Level AA compliance target
- Mobile-first responsive: 320px min, breakpoints 480/768/1024px
- Container queries for responsive components (with media query fallback)
- Skeleton-first loading — never spinners or blank screens
- Bottom sheets on mobile (never centered modals)
- GPU animation only: transform + opacity (never width/height/top/left)
- prefers-reduced-motion support
- 48×48px minimum touch targets
- Skip links, focus trap, focus restoration, :focus-visible
- Screen reader ARIA compliance
- Low-literacy adaptations
- One-handed use optimization
- Nigeria-specific: RTL Hausa, AMOLED burn-in prevention, outdoor sunlight, battery/data saver, dual-SIM
- Device-specific performance fixes (Infinix Hot 30, Tecno Spark 10, iPhone SE)
- 15 custom components across 3 tiers
- Virtual scrolling (TanStack Virtual) for feed
- Offline draft persistence (IndexedDB via service worker)

**From Project Context:**

- No framework for Go (standard library net/http only)
- No ORM (sqlc + pgx only)
- React 19 Server Components default + TanStack Query
- BFF proxy pattern (no hardcoded backend URLs)
- Dependency freeze (no axios, lodash, moment)
- Conventional Commits + main/develop branching
- CI gates: golangci-lint, go-arch-lint, npm lint, tsc --noEmit
- Coverage gates: 60% overall, 80% new code, 90% domain, 80% service
- MSW for network mocking
- Table-driven Go tests with testify
- One component per file, no barrel exports
- RFC 7807 error format

---

### FR Coverage Map

| FR | Epic | Description |
| --- | --- | --- |
| FR1 | Epic 4 | Seller signup with OTP |
| FR2 | Epic 5 | Platform selection during onboarding |
| FR3 | Epic 5 | Brand Voice Onboarding (5 inputs min) |
| FR4 | Epic 5 | Baseline metrics capture at signup |
| FR5 | Epic 4 | Low-friction onboarding verification |
| FR6 | Epic 5 | Product category selection |
| FR7 | Epic 5 | Regulated category certifications |
| FR8 | Epic 5 | Incomplete onboarding detection |
| FR9 | Epic 5 | Instagram Business account connection |
| FR10 | Epic 5 | WhatsApp Business account connection |
| FR11 | Epic 5 | First post creation guide |
| FR12 | Epic 5 | Business Profile Form |
| FR13 | Epic 5 | Social platform data ingestion |
| FR14 | Epic 5 | Per-product quick form |
| FR15 | Epic 5 | Advisory gap indicator |
| FR16 | Epic 5 | Business Profile RAG pipeline |
| FR17 | Epic 6 | AI caption generation (Brand Voice) |
| FR18 | Epic 6 | AI content regeneration with feedback |
| FR19 | Epic 6 | Edit AI content before publishing |
| FR20 | Epic 6 | Payment link CTA in captions |
| FR21 | Epic 6 | Cross-tenant uniqueness checking |
| FR22 | Epic 6 | AI detection resistance |
| FR23 | Epic 6 | Batch content generation |
| FR24 | Epic 6 | Brand Voice fidelity scoring |
| FR25 | Epic 6 | Brand Voice recalibration |
| FR26 | Epic 6 | Nigerian market localization |
| FR27 | Epic 6 | Learning from seller corrections |
| FR28 | Epic 6 | Fallback content (templates/manual) |
| FR29 | Epic 7 | Instagram post publishing |
| FR30 | Epic 7 | AI-recommended scheduling |
| FR31 | Epic 7 | Scheduled post management |
| FR32 | Epic 9 | WhatsApp unified inbox |
| FR33 | Epic 9 | Payment links via WhatsApp |
| FR34 | Epic 7 | Rate limit detection + degradation |
| FR35 | Epic 7 | Business hours + auto-responses |
| FR36 | Epic 7 | Message delivery prioritization |
| FR37 | Epic 7 | WhatsApp catalog sync |
| FR38 | Epic 7 | Segmented list messaging |
| FR39 | Epic 7 | Platform disconnection handling |
| FR40 | Epic 8 | Product catalog CRUD |
| FR41 | Epic 8 | Product media management |
| FR42 | Epic 10 | Payment link generation |
| FR43 | Epic 10 | Digital receipts |
| FR44 | Epic 10 | Verification Badge display |
| FR45 | Epic 10 | MarketBoss tracking URLs |
| FR46 | Epic 8 | Lead card tracking |
| FR47 | Epic 10 | Multi-stage deal management |
| FR48 | Epic 8 | Cross-platform journey tracking |
| FR49 | Epic 10 | Fallback payment method |
| FR50 | Epic 8 | Content Performance Score |
| FR51 | Epic 10 | Payment link management |
| FR52 | Epic 8 | Shareable product links |
| FR53 | Epic 8 | Customer progress updates |
| FR54 | Epic 10 | Payout history + settlement |
| FR55 | Epic 9 | Customer summary / priming card |
| FR56 | Epic 9 | Human handoff (one-tap) |
| FR57 | Epic 9 | Response templates |
| FR58 | Epic 9 | Team template access |
| FR59 | Epic 9 | Customer tagging + price tiers |
| FR60 | Epic 9 | Customer segmentation |
| FR61 | Epic 9 | Buyer messages never blocked |
| FR62 | Epic 9 | System vs human attribution |
| FR63 | Epic 8 | Buyer dispute initiation |
| FR64 | Epic 12 | Contextual MVP analytics |
| FR65 | Epic 12 | Engagement prompts |
| FR66 | Epic 12 | Baseline drop alerts |
| FR67 | Epic 12 | Baseline progress comparison |
| FR68 | Epic 12 | Content strategy suggestions |
| FR69 | Epic 12 | Usage limit warnings (80%) |
| FR70 | Epic 12 | Pending task summaries |
| FR71 | Epic 11 | Team member invitations |
| FR72 | Epic 11 | Granular RBAC permissions |
| FR73 | Epic 11 | Role-based UI |
| FR74 | Epic 11 | Team draft creation |
| FR75 | Epic 11 | Team draft scheduling |
| FR76 | Epic 11 | Owner draft approval/rejection |
| FR77 | Epic 11 | Team activity logging |
| FR78 | Epic 11 | Team performance metrics |
| FR79 | Epic 11 | Emergency Pause Auto-Replies |
| FR80 | Epic 11 | Catalog staleness warning |
| FR81 | Epic 11 | Revoke team access |
| FR82 | Epic 11 | Team → independent account upgrade |
| FR83 | Epic 11 | After-hours auto-response customization |
| FR84 | Epic 13 | Super Admin account management |
| FR85 | Epic 13 | Admin onboarding review |
| FR86 | Epic 13 | Admin role separation |
| FR87 | Epic 13 | Platform health metrics |
| FR88 | Epic 13 | Support ticket management |
| FR89 | Epic 13 | User-level analytics access |
| FR90 | Epic 13 | Admin Brand Voice recalibration |
| FR91 | Epic 13 | Dispute mediation |
| FR92 | Epic 13 | Immutable consent records |
| FR93 | Epic 13 | Data deletion (72h compliance) |
| FR94 | Epic 13 | Content moderation |
| FR95 | Epic 13 | Pre-publication screening |
| FR96 | Epic 13 | Multi-tenant data isolation |
| FR97 | Epic 13 | Customer data export |
| FR98 | Epic 13 | Voice note support |
| FR99 | Epic 13 | Tenant-level limits config |
| FR100 | Epic 13 | Platform-wide settings |
| FR101 | Epic 13 | Seller billing management |
| FR102 | Epic 13 | Content moderation appeals |
| FR103 | Epic 13 | Trust journey tracking |
| FR104 | Epic 10 | Notification preferences |
| FR105 | Epic 10 | Billing lifecycle notifications |
| FR106 | Epic 4 | Session management |
| FR107 | Epic 4 | Suspicious activity alerts |
| FR108 | Epic 13 | NDPA consent withdrawal |
| FR109 | Epic 10 | Subscription plan view |
| FR110 | Epic 10 | Tier upgrade/downgrade |
| FR111 | Epic 13 | Server-side tier limits |
| FR112 | Epic 10 | Invoice/receipt generation |
| FR113 | Epic 6 | Audio preview before publish |
| FR114 | Epic 6 | Mandatory "Sounds Like Me" publish trust gate |

---

