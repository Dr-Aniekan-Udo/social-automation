---
stepsCompleted:
  - step-01-document-discovery
  - step-02-prd-analysis
  - step-03-epic-coverage-validation
  - step-04-ux-alignment
  - step-05-epic-quality-review
  - step-06-final-assessment
inputDocuments:
  - docs/planning-artifacts/prd/index.md
  - docs/planning-artifacts/architecture/index.md
  - docs/planning-artifacts/epics/index.md
  - docs/planning-artifacts/ux-design-specification/index.md
discovery:
  prd: sharded
  architecture: sharded
  epics: sharded
  ux: sharded
duplicateConflicts: []
missingDocuments: []
---

# Implementation Readiness Assessment Report

**Date:** 2026-02-24
**Project:** social-automation

## Step 1 - Document Discovery

### Selected Source Documents

- PRD: `docs/planning-artifacts/prd/` (sharded, `index.md` present)
- Architecture: `docs/planning-artifacts/architecture/` (sharded, `index.md` present)
- Epics & Stories: `docs/planning-artifacts/epics/` (sharded, `index.md` present)
- UX Design: `docs/planning-artifacts/ux-design-specification/` (sharded, `index.md` present)

### Discovery Findings

- No duplicate whole + sharded documents found.
- No required document set missing.


## PRD Analysis

### Functional Requirements

## Functional Requirements Extracted

FR1: Seller can sign up using email and phone with OTP verification
FR2: Seller can choose a primary social platform (Instagram or WhatsApp) during onboarding
FR3: Seller can complete Brand Voice Onboarding by submitting minimum 5 brand-voice training inputs (captions, product listings, or voice samples); seller is never dropped from onboarding, but AI post generation is blocked until the minimum input threshold is met
FR4: System captures the seller's pre-MarketBoss baseline metrics (reach, engagement, follower count) at signup
FR5: Seller can complete low-friction onboarding verification at signup; enhanced KYC is deferred and required for payment features and higher transaction limits
FR6: Seller can select their product category during onboarding, with prohibited categories blocked
FR7: Sellers in regulated categories (food, cosmetics) can upload required certifications for verification before first sale
FR8: System detects incomplete onboarding (insufficient brand-voice training input or incomplete Business Profile) and shows a persistent prompt to complete it; post generation remains blocked until requirements are met
FR9: Seller can connect their Instagram Business account to the platform
FR10: Seller can connect their WhatsApp Business account to the platform
FR11: System guides new sellers through first post creation step-by-step
FR12: Seller completes a Business Profile Form during onboarding capturing: business name, description, product categories, pricing ranges, shipping policy (delivery areas, costs, timelines), return/refund policy, accepted payment methods, operating hours, physical location (if applicable), contact channels, and common FAQs
FR13: System ingests product information from connected social platforms (Instagram product tags, WhatsApp catalog) and pre-fills Business Profile fields where possible
FR14: Seller fills a minimal per-product quick form when creating a post (product name, price, key features, availability) to give AI sufficient context for generating responses to buyer inquiries
FR15: AI analyzes the combined Business Profile + product data against a library of common buyer questions and displays an advisory gap indicator (e.g., "Your profile answers 12/18 common buyer questions — add shipping info to improve AI responses")
FR16: Business Profile and per-product data feed into the RAG pipeline, enabling AI to answer buyer DMs and generate content with accurate, seller-specific information
FR17: Seller can generate AI-powered captions calibrated to their Brand Voice profile
FR18: Seller can regenerate AI content with feedback to improve results
FR19: Seller can edit AI-generated content before publishing
FR20: System generates captions with embedded payment link calls-to-action
FR21: System performs cross-tenant uniqueness checking to prevent niche collision between sellers in the same category
FR22: System varies AI content patterns to resist AI detection by followers
FR23: Seller can generate content in batch for multiple products
FR24: System scores Brand Voice fidelity and warns when calibration data is insufficient
FR25: Seller can recalibrate their Brand Voice profile with additional captions
FR26: System generates contextually appropriate content for Nigerian market (including Pidgin English, local slang, cultural references)
FR27: System learns from seller content corrections to improve future AI output
FR28: System provides fallback content options (cached templates, manual mode) when AI is unavailable
FR29: Seller can publish single-image and carousel posts to Instagram
FR30: Seller can schedule posts for AI-recommended optimal times
FR31: Seller can view, reschedule, and cancel scheduled posts through a feed-native scheduled queue (MVP contextual surface), with full calendar views deferred to post-MVP/Growth
FR32: Seller can view and respond to WhatsApp messages through a unified inbox
FR33: Seller can send payment links via WhatsApp messages
FR34: System detects rate limits and gracefully degrades (prioritizing live DMs over queued messages)
FR35: Seller can configure business hours, with automated after-hours responses for incoming messages
FR36: System prioritizes message delivery: live DMs > scheduled messages > bulk communications
FR37: Seller can sync product catalog to WhatsApp Business
FR38: Seller can preview and confirm messages before sending to segmented lists
FR39: System detects social platform disconnection and guides seller through reconnection
FR40: Seller can manage product catalog (add, edit, remove products with pricing and stock levels)
FR41: Seller can upload and manage product media (photos/videos)
FR42: Seller can generate payment links tied to specific customer inquiries
FR43: Buyer receives a digital receipt with seller identity, product details, amount, and support contact after payment
FR44: Verified sellers display a Verification Badge on receipts and payment links
FR45: System generates and logs MarketBoss tracking URLs for seller bios and payment links
FR46: Seller can track customer inquiries as lead cards with status progression
FR47: Seller can manage multi-stage deals (e.g., deposit → work-in-progress → final payment)
FR48: System tracks cross-platform customer journeys (e.g., IG post → WhatsApp DM → payment → delivery)
FR49: System provides a fallback payment method (bank transfer details) when the primary payment provider is unavailable
FR50: Seller can view a Content Performance Score showing engagement metrics per post
FR51: Seller can view and manage active/expired payment links
FR52: Seller can generate shareable product links for any channel
FR53: Seller can share progress updates with customers during multi-stage deals
FR54: Seller can view payout history and settlement reports
FR55: Seller receives a customer summary card (conversation priming) when a new inquiry arrives
FR56: Seller can take over automated conversations with a one-tap human handoff
FR57: Seller can set up response templates for common inquiries
FR58: Team members can use response templates set up by the account owner
FR59: Seller can tag contacts with relationship types (e.g., regular, new, wholesale) and assign price tiers
FR60: Seller can segment customer lists for targeted communications
FR61: Buyer-initiated messages are never blocked, regardless of the seller's messaging limit
FR62: System logs system-generated vs human-generated responses for clear attribution
FR63: Buyer can initiate a dispute during escrow period
FR64: Seller can view contextual MVP analytics (post performance, engagement rate, follower growth) within feed/inbox/home surfaces; dedicated analytics dashboard is post-MVP/Growth
FR65: System provides engagement prompts suggesting actions to increase reach
FR66: System alerts the seller when their reach drops below their pre-MarketBoss baseline
FR67: System shows sellers their progress compared to their pre-MarketBoss baseline
FR68: System provides content strategy suggestions tailored to the seller's account type and niche
FR69: Seller receives a warning when approaching their tier usage limits (at 80% threshold)
FR70: Seller can view pending-task summaries (unresponded inquiries, scheduled posts, draft approvals) directly in home/feed/inbox contextual surfaces without requiring a dedicated MVP analytics dashboard
FR71: Seller (account owner) can invite team members via phone or email
FR72: Seller can assign granular permissions to team members (view inquiries, respond, create drafts, publish, view analytics, change settings)
FR73: Team members see a simplified role-based UI matching their permissions
FR74: Team members can create draft posts that require owner approval before publishing
FR75: Team members can schedule drafts pending owner approval
FR76: Account owner can review and approve/reject draft posts remotely
FR77: System logs all team member activity with clear system vs human attribution
FR78: Team members can view their performance metrics without seeing revenue figures
FR79: Team members can activate an emergency "Pause Auto-Replies" function
FR80: System warns when product catalog has not been updated for 6+ hours
FR81: Seller can revoke team member access
FR82: Team member can upgrade to an independent MarketBoss account
FR83: Seller can customize after-hours auto-response messages
FR84: Super Admin can create and remove marketplace admin accounts
FR85: Marketplace Admin can review and approve seller onboarding applications
FR86: Admin roles are separated: onboarding admin cannot perform dispute resolution, and vice versa
FR87: Admin can view platform health metrics (uptime, AI usage, active users, signups)
FR88: Admin can manage support tickets with urgency-based prioritization
FR89: Admin can access user-level analytics and content history for troubleshooting
FR90: Admin can initiate Brand Voice recalibration for a seller's account
FR91: Admin can mediate and resolve buyer-seller disputes
FR92: System maintains immutable consent records for data protection compliance (timestamped, purpose-specific)
FR93: System processes data deletion requests within the required compliance timeframe
FR94: Admin can moderate content (review flagged posts, process takedown requests)
FR95: System screens content pre-publication for prohibited categories and restricted content
FR96: System enforces multi-tenant data isolation (zero cross-tenant data leakage)
FR97: Sellers can export their customer data (with PII anonymized per policy)
FR98: System supports voice note submissions for support requests with transcription
FR99: Admin can configure tenant-level limits (post limits, message limits, products, storage)
FR100: Admin can configure platform-wide settings (commission rates, grace periods, feature gate defaults)
FR101: Admin can manage seller billing (view payment status, retry failed payments, manual adjustments)
FR102: Seller can appeal content moderation decisions
FR103: System tracks trust journey progression as an internal admin metric
FR104: Seller can configure notification preferences (channel: push, WhatsApp, SMS, email)
FR105: Seller receives notifications about billing lifecycle events (grace period, downgrade, suspension)
FR106: Seller can view and terminate their active sessions
FR107: System alerts users about suspicious account activity (new device, new IP, bulk data access)
FR108: Users can withdraw specific consent types (NDPA requirement)
FR109: Seller can view their current subscription plan and usage
FR110: Seller can upgrade or downgrade their subscription tier
FR111: System enforces tier-based limits server-side (daily posts, messages, products, connected accounts)
FR112: System generates invoices/receipts with seller's business branding

Total FRs: 112

### Non-Functional Requirements

## Non-Functional Requirements Extracted

NFR-P1: AI caption generation completes within 5 seconds (p95 target), 10 seconds hard ceiling (p99). UX shows progressive loading placeholder/skeleton after 2 seconds; full AI draft appears only when complete
NFR-P2: Page load time ≤ 3 seconds on 3G connection (Nigerian mobile baseline)
NFR-P3: WhatsApp message delivery (API submission) completes within 2 seconds
NFR-P4: Payment link generation completes within 3 seconds
NFR-P5: MVP contextual analytics surfaces (feed, inbox, home revenue card) render within 4 seconds with up to 90 days of data; dedicated analytics dashboard pages apply post-MVP/Growth
NFR-P6: Search and filter operations across products, contacts, and conversations return results within 2 seconds
NFR-P7: System supports 500 concurrent sellers with <10% performance degradation
NFR-P8: Instagram post publishing (API submission) completes within 5 seconds including image upload
NFR-P9: Scheduled-post queue/context surfaces load within 3 seconds while showing up to 30 days of scheduled posts; dedicated calendar pages are post-MVP/Growth
NFR-P10: Real-time notifications (new DM, payment received) delivered within 5 seconds of event
NFR-P11: Onboarding flow (signup → first post created) completable within 10 minutes end-to-end. Each onboarding step loads within 2 seconds
NFR-P12: Brand Voice profile updates (from seller corrections) are reflected in next generation request. No batch delay — corrections applied immediately to the seller's voice profile
NFR-P13: Voice note transcription completes within 10 seconds for messages up to 2 minutes. Transcription accuracy ≥ 85% for Nigerian English accents
NFR-P14: Invoice/receipt PDF generation completes within 3 seconds. Invoice accessible via unique URL for minimum 1 year
NFR-P15: MarketBoss tracking URL redirects (link router) complete within 500ms. Click logging is asynchronous — never delays redirect
NFR-S1: All data encrypted at rest (AES-256) and in transit (TLS 1.3)
NFR-S2: Social media tokens stored with application-level encryption; never exposed in API responses or logs
NFR-S3: Multi-tenant data isolation enforced at database layer (row-level security) AND application layer — tested with automated cross-tenant access tests
NFR-S4: KYC data (NIN, BVN, biometric hashes) stored in dedicated encrypted storage with access logging
NFR-S5: Payment processing complies with PCI-DSS Level 4 (delegated to Paystack/Flutterwave — no raw card data stored)
NFR-S6: Personal data processing complies with NDPA requirements including consent management, data export, and deletion within 72 hours of request
NFR-S7: Session timeout tiered by role: Sellers 72 hours inactivity, Marketplace Admin 8 hours inactivity, Super Admin 1 hour inactivity. All sessions terminate on password change
NFR-S8: Super Admin accounts require MFA (hardware key), IP whitelisting, and 90-day credential rotation
NFR-S9: All state-changing API endpoints require authentication and authorization. Rate limits tiered: read endpoints 200 req/min/user, state-changing endpoints 30 req/min/user, authentication endpoints 5 req/min/IP
NFR-S10: Audit logs for admin actions are immutable (append-only). MVP requires immutable core compliance/admin events with minimum 90-day hot retention. Growth+ expands to tiered retention: hot storage 90 days (instant query), warm storage 91 days–1 year (query within 1 hour), cold archive 1–3 years (query within 24 hours). Total retention: 3 years.
NFR-S11: Cross-tenant data leak triggers immediate: (1) affected tenant isolation within 60 seconds, (2) admin alert within 60 seconds, (3) affected data audit within 4 hours. Breach reporting to NDPC within 72 hours per NDPA Article 40
NFR-SC1: System architecture supports horizontal scaling from 100 users (beta) to 10,000 users without architecture changes
NFR-SC2: Database design supports seamless migration from shared multi-tenant to dedicated per-tenant instances for enterprise accounts
NFR-SC3: AI request queue handles burst traffic (10x normal) by queueing with priority (paid tier > free tier) and graceful degradation
NFR-SC4: Image/media storage scales independently of application servers, using object storage (S3-compatible) with CDN distribution
NFR-SC5: Background job processing (KYC verification, analytics aggregation, notification delivery) scales independently via worker pool
NFR-SC6: API design supports pagination, cursor-based navigation, and field filtering to prevent over-fetching as data grows
NFR-SC7: When concurrent user threshold is approached (80%), system activates request queuing. At 100%, new logins are queued with 'high demand' wait screen. System never crashes — always degrades gracefully
NFR-R1: Platform targets 99.5% uptime (~3.65 hours/month planned maintenance), measured monthly
NFR-R1a: Payment-related endpoints target 99.9% availability using Paystack/Flutterwave dual-gateway resilience (Phase 2+)
NFR-R2: Payment gateway failover triggers within 30 seconds of primary provider failure (3 consecutive health check failures, Phase 2+)
NFR-R3: SMS notification failover triggers within 60 seconds (Termii → Africa's Talking, Phase 2+)
NFR-R4: AI service degradation activates cached template fallback within 5 minutes; manual posting mode after 1 hour
NFR-R5: No data loss on any single infrastructure failure — all writes acknowledged by durable storage before confirming to user
NFR-R6: Enterprise tenant database failover completes within 30 seconds with automatic promotion of read replica
NFR-R7: System gracefully handles Nigerian network conditions: request timeouts ≤ 30 seconds, automatic retry with exponential backoff (max 3 retries)
NFR-R8: Scheduled posts execute within 5-minute window of scheduled time, even during partial system degradation
NFR-R9: Complete dual-gateway payment failure triggers degraded payment mode (bank transfer details) within 60 seconds. Seller notification within 120 seconds (Phase 2+)
NFR-R10: Content drafts auto-saved every 30 seconds. Unsaved work recoverable for 24 hours after last auto-save. Payment transactions are atomic — partial completion is impossible
NFR-R11: Scheduled posts that fail due to network timeout are automatically re-queued with 15-minute retry intervals for up to 6 hours. Seller notified after 3 failed attempts
NFR-R12: System monitors settlement SLAs from payment providers. If settlement exceeds 24-hour SLA, proactive seller notification sent with expected resolution date. Admin dashboard shows settlement health
NFR-R13: Dispute acknowledgment within 4 hours (automated). Admin mediation response within 48 hours. Dispute resolution (decision rendered) within 7 business days
NFR-R14: Critical notifications (payment received, security alert, billing event) have guaranteed delivery: primary channel + fallback within 5 minutes. Non-critical (engagement prompt) best-effort, single channel
NFR-I1: All third-party integrations use adapter/provider pattern — adding a new payment gateway, KYC provider, AI model, or messaging service requires implementing an interface, not modifying core logic
NFR-I2: Webhook endpoints process inbound events within 5 seconds and return HTTP 200; failed processing retried from dead letter queue
NFR-I3: Social media API rate limits monitored in real-time with automatic throttling at 80% of limit ceiling
NFR-I4: Integration health checks run from a centralized monitoring service (not per-instance). Critical services (payment, messaging) checked every 30 seconds; non-critical (analytics, KYC) every 5 minutes. Status broadcast via pub/sub to all application instances
NFR-I5: All API credentials stored in secrets manager (not environment variables or code) with automatic rotation support
NFR-I6: Open API (Phase 3) supports RESTful design, URL-based API versioning, and webhook event system
NFR-I7: If social API rate limit is hit (HTTP 429), system immediately pauses all queued posts for that seller, notifies seller with estimated resume time, and does not retry for minimum 15 minutes
NFR-I8: System monitors third-party API deprecation notices. Admin alerted 60 days before any API version end-of-life. Integration adapter supports running two API versions simultaneously during migration
NFR-M1: Mobile-first responsive design with minimum supported width of 320px (optimized for 360px+), using canonical breakpoints at 480px (large phones), 768px (tablets), and 1024px (desktop) — no layout-breaking on any viewport
NFR-M2: Application functions on minimum Android 10 / iOS 14 via mobile browser (Chrome, Safari)
NFR-M3: Critical workflows (create post, respond to DM, generate payment link) are completable with one thumb on mobile. Minimum touch target size 48×48px. No critical actions behind long-press or precision taps
NFR-M4: Application supports Pidgin English content generation and Nigerian English UI copy
NFR-M5: Initial page payload ≤ 500KB compressed. Subsequent page navigations ≤ 100KB. Service worker caching for offline-tolerant patterns
NFR-M6: Application supports offline-tolerant patterns: optimistic UI updates only for reversible actions (with undo), background sync when connectivity returns, and delivery-confirmed states (`sending` → `delivered`/`failed`) for irreversible sends
NFR-M7: Offline-to-online sync conflicts resolved via last-write-wins with conflict notification to all parties. Seller sees 'This was changed while you were offline' alert with option to keep their version or the current version
NFR-AI1: System supports pluggable AI provider pattern with 3 tiers: Tier 1 (self-hosted 7B model for simple tasks — classification, routing, tagging), Tier 2 (RAG-optimized API for knowledge grounding — customer summaries, Brand Voice calibration), Tier 3 (premium API for creative content — caption generation, content strategy). Models switchable per tier without application changes
NFR-AI2: AI request router classifies task complexity and routes to appropriate tier. Routing decision adds ≤ 100ms latency. Routing classifier itself runs on Tier 1 (self-hosted)
NFR-AI3: Per-tier latency targets: Tier 1 (self-hosted) ≤ 2 seconds for simple tasks, Tier 2 (RAG API) ≤ 4 seconds for grounded generation, Tier 3 (creative API) ≤ 5 seconds p95 / 10 seconds p99 for creative content. All tiers support fallback to next tier on failure

Total NFRs: 66

### Additional Requirements

- Document precedence constraint: when planning conflicts occur, follow architecture > ux spec > prd > ux html > product-brief.
- Phase-scope constraint: Phase 1 (MVP) is an 8-week, 4-sprint delivery with Instagram-first baseline and conditional WhatsApp inclusion based on API approval timing.
- Pre-sprint dependency: WhatsApp Business API application must be submitted by Week -2; if delayed beyond Week 4, ship IG-only baseline and activate WhatsApp post-approval.
- Architecture prerequisite constraint: Link router data pipeline (URL generation + click logging) must exist in Phase 1 to enable Phase 2 cross-platform attribution.
- Architecture prerequisite constraint: Paystack subaccount model must be in place in Phase 1 to allow Phase 2 escrow without major refactor.
- Degraded-mode business continuity requirement: when Paystack health checks fail, system must provide temporary bank-transfer flow and auto-recover when health returns.
- Compliance/legal constraints: NDPA consent logging, deletion SLA, and breach-notification readiness are required; CBN/FCCPC alignment constraints are explicitly defined in PRD domain requirements.
- Market-regulation constraint: prohibited categories must be blocked, and regulated categories (e.g., food/cosmetics) require verification before first sale.
- Tenant model constraint: hybrid multi-tenant isolation is required (shared-DB tenant isolation for normal accounts; dedicated DB path for enterprise accounts).
- Billing lifecycle constraint: grace-period/downgrade/suspension/deletion flow is explicitly defined and must preserve notification-before-deletion behavior.
- Feature-gating constraint: limits are server-enforced; buyer-initiated messages are never blocked even when seller-initiated quotas are exhausted.
- Assumption-gate constraint before scale: top assumptions (AI uplift, willingness to pay, platform API stability) require explicit validation gates before scaling beyond first 100 users.

### PRD Completeness Assessment

- Completeness: Strong and comprehensive for functional scope; FR catalog is explicit and contiguous (FR1 to FR112) with clear domain partitioning.
- Quality level: NFR set is measurable and testable, spanning performance, security, scalability, reliability, integration, mobile/localization, and AI architecture (NFR-P1 ... NFR-AI3).
- Traceability readiness: High, because FR/NFR identifiers are well-structured for requirement-to-epic mapping in subsequent steps.
- Risk note: PRD contains explicit untested assumptions and phased dependencies; these do not block analysis but must be validated and represented in epic/story coverage and implementation sequencing.


## Epic Coverage Validation

### Epic Coverage Extraction

## Epic FR Coverage Extracted
FR1: Covered in Epic 4
FR2: Covered in Epic 5
FR3: Covered in Epic 5
FR4: Covered in Epic 5
FR5: Covered in Epic 4
FR6: Covered in Epic 5
FR7: Covered in Epic 5
FR8: Covered in Epic 5
FR9: Covered in Epic 5
FR10: Covered in Epic 5
FR11: Covered in Epic 5
FR12: Covered in Epic 5
FR13: Covered in Epic 5
FR14: Covered in Epic 5
FR15: Covered in Epic 5
FR16: Covered in Epic 5
FR17: Covered in Epic 6
FR18: Covered in Epic 6
FR19: Covered in Epic 6
FR20: Covered in Epic 6
FR21: Covered in Epic 6
FR22: Covered in Epic 6
FR23: Covered in Epic 6
FR24: Covered in Epic 6
FR25: Covered in Epic 6
FR26: Covered in Epic 6
FR27: Covered in Epic 6
FR28: Covered in Epic 6
FR29: Covered in Epic 7
FR30: Covered in Epic 7
FR31: Covered in Epic 7
FR32: Covered in Epic 9
FR33: Covered in Epic 9
FR34: Covered in Epic 7
FR35: Covered in Epic 7
FR36: Covered in Epic 7
FR37: Covered in Epic 7
FR38: Covered in Epic 7
FR39: Covered in Epic 7
FR40: Covered in Epic 8
FR41: Covered in Epic 8
FR42: Covered in Epic 10
FR43: Covered in Epic 10
FR44: Covered in Epic 10
FR45: Covered in Epic 10
FR46: Covered in Epic 8
FR47: Covered in Epic 10
FR48: Covered in Epic 8
FR49: Covered in Epic 10
FR50: Covered in Epic 8
FR51: Covered in Epic 10
FR52: Covered in Epic 8
FR53: Covered in Epic 8
FR54: Covered in Epic 10
FR55: Covered in Epic 9
FR56: Covered in Epic 9
FR57: Covered in Epic 9
FR58: Covered in Epic 9
FR59: Covered in Epic 9
FR60: Covered in Epic 9
FR61: Covered in Epic 9
FR62: Covered in Epic 9
FR63: Covered in Epic 8
FR64: Covered in Epic 12
FR65: Covered in Epic 12
FR66: Covered in Epic 12
FR67: Covered in Epic 12
FR68: Covered in Epic 12
FR69: Covered in Epic 12
FR70: Covered in Epic 12
FR71: Covered in Epic 11
FR72: Covered in Epic 11
FR73: Covered in Epic 11
FR74: Covered in Epic 11
FR75: Covered in Epic 11
FR76: Covered in Epic 11
FR77: Covered in Epic 11
FR78: Covered in Epic 11
FR79: Covered in Epic 11
FR80: Covered in Epic 11
FR81: Covered in Epic 11
FR82: Covered in Epic 11
FR83: Covered in Epic 11
FR84: Covered in Epic 13
FR85: Covered in Epic 13
FR86: Covered in Epic 13
FR87: Covered in Epic 13
FR88: Covered in Epic 13
FR89: Covered in Epic 13
FR90: Covered in Epic 13
FR91: Covered in Epic 13
FR92: Covered in Epic 13
FR93: Covered in Epic 13
FR94: Covered in Epic 13
FR95: Covered in Epic 13
FR96: Covered in Epic 13
FR97: Covered in Epic 13
FR98: Covered in Epic 13
FR99: Covered in Epic 13
FR100: Covered in Epic 13
FR101: Covered in Epic 13
FR102: Covered in Epic 13
FR103: Covered in Epic 13
FR104: Covered in Epic 10
FR105: Covered in Epic 10
FR106: Covered in Epic 4
FR107: Covered in Epic 4
FR108: Covered in Epic 13
FR109: Covered in Epic 10
FR110: Covered in Epic 10
FR111: Covered in Epic 13
FR112: Covered in Epic 10
Total FRs in epics: 112

### Coverage Matrix

| FR Number | PRD Requirement | Epic Coverage | Status |
| --------- | --------------- | ------------- | ------ |
| FR1 | Seller can sign up using email and phone with OTP verification | Epic 4 (Seller signup with OTP) | Covered |
| FR2 | Seller can choose a primary social platform (Instagram or WhatsApp) during onboarding | Epic 5 (Platform selection during onboarding) | Covered |
| FR3 | Seller can complete Brand Voice Onboarding by submitting minimum 5 brand-voice training inputs (captions, product listings, or voice samples); seller is never dropped from onboarding, but AI post generation is blocked until the minimum input threshold is met | Epic 5 (Brand Voice Onboarding (5 inputs min)) | Covered |
| FR4 | System captures the seller's pre-MarketBoss baseline metrics (reach, engagement, follower count) at signup | Epic 5 (Baseline metrics capture at signup) | Covered |
| FR5 | Seller can complete low-friction onboarding verification at signup; enhanced KYC is deferred and required for payment features and higher transaction limits | Epic 4 (Low-friction onboarding verification) | Covered |
| FR6 | Seller can select their product category during onboarding, with prohibited categories blocked | Epic 5 (Product category selection) | Covered |
| FR7 | Sellers in regulated categories (food, cosmetics) can upload required certifications for verification before first sale | Epic 5 (Regulated category certifications) | Covered |
| FR8 | System detects incomplete onboarding (insufficient brand-voice training input or incomplete Business Profile) and shows a persistent prompt to complete it; post generation remains blocked until requirements are met | Epic 5 (Incomplete onboarding detection) | Covered |
| FR9 | Seller can connect their Instagram Business account to the platform | Epic 5 (Instagram Business account connection) | Covered |
| FR10 | Seller can connect their WhatsApp Business account to the platform | Epic 5 (WhatsApp Business account connection) | Covered |
| FR11 | System guides new sellers through first post creation step-by-step | Epic 5 (First post creation guide) | Covered |
| FR12 | Seller completes a Business Profile Form during onboarding capturing: business name, description, product categories, pricing ranges, shipping policy (delivery areas, costs, timelines), return/refund policy, accepted payment methods, operating hours, physical location (if applicable), contact channels, and common FAQs | Epic 5 (Business Profile Form) | Covered |
| FR13 | System ingests product information from connected social platforms (Instagram product tags, WhatsApp catalog) and pre-fills Business Profile fields where possible | Epic 5 (Social platform data ingestion) | Covered |
| FR14 | Seller fills a minimal per-product quick form when creating a post (product name, price, key features, availability) to give AI sufficient context for generating responses to buyer inquiries | Epic 5 (Per-product quick form) | Covered |
| FR15 | AI analyzes the combined Business Profile + product data against a library of common buyer questions and displays an advisory gap indicator (e.g., "Your profile answers 12/18 common buyer questions — add shipping info to improve AI responses") | Epic 5 (Advisory gap indicator) | Covered |
| FR16 | Business Profile and per-product data feed into the RAG pipeline, enabling AI to answer buyer DMs and generate content with accurate, seller-specific information | Epic 5 (Business Profile RAG pipeline) | Covered |
| FR17 | Seller can generate AI-powered captions calibrated to their Brand Voice profile | Epic 6 (AI caption generation (Brand Voice)) | Covered |
| FR18 | Seller can regenerate AI content with feedback to improve results | Epic 6 (AI content regeneration with feedback) | Covered |
| FR19 | Seller can edit AI-generated content before publishing | Epic 6 (Edit AI content before publishing) | Covered |
| FR20 | System generates captions with embedded payment link calls-to-action | Epic 6 (Payment link CTA in captions) | Covered |
| FR21 | System performs cross-tenant uniqueness checking to prevent niche collision between sellers in the same category | Epic 6 (Cross-tenant uniqueness checking) | Covered |
| FR22 | System varies AI content patterns to resist AI detection by followers | Epic 6 (AI detection resistance) | Covered |
| FR23 | Seller can generate content in batch for multiple products | Epic 6 (Batch content generation) | Covered |
| FR24 | System scores Brand Voice fidelity and warns when calibration data is insufficient | Epic 6 (Brand Voice fidelity scoring) | Covered |
| FR25 | Seller can recalibrate their Brand Voice profile with additional captions | Epic 6 (Brand Voice recalibration) | Covered |
| FR26 | System generates contextually appropriate content for Nigerian market (including Pidgin English, local slang, cultural references) | Epic 6 (Nigerian market localization) | Covered |
| FR27 | System learns from seller content corrections to improve future AI output | Epic 6 (Learning from seller corrections) | Covered |
| FR28 | System provides fallback content options (cached templates, manual mode) when AI is unavailable | Epic 6 (Fallback content (templates/manual)) | Covered |
| FR29 | Seller can publish single-image and carousel posts to Instagram | Epic 7 (Instagram post publishing) | Covered |
| FR30 | Seller can schedule posts for AI-recommended optimal times | Epic 7 (AI-recommended scheduling) | Covered |
| FR31 | Seller can view, reschedule, and cancel scheduled posts through a feed-native scheduled queue (MVP contextual surface), with full calendar views deferred to post-MVP/Growth | Epic 7 (Scheduled post management) | Covered |
| FR32 | Seller can view and respond to WhatsApp messages through a unified inbox | Epic 9 (WhatsApp unified inbox) | Covered |
| FR33 | Seller can send payment links via WhatsApp messages | Epic 9 (Payment links via WhatsApp) | Covered |
| FR34 | System detects rate limits and gracefully degrades (prioritizing live DMs over queued messages) | Epic 7 (Rate limit detection + degradation) | Covered |
| FR35 | Seller can configure business hours, with automated after-hours responses for incoming messages | Epic 7 (Business hours + auto-responses) | Covered |
| FR36 | System prioritizes message delivery: live DMs > scheduled messages > bulk communications | Epic 7 (Message delivery prioritization) | Covered |
| FR37 | Seller can sync product catalog to WhatsApp Business | Epic 7 (WhatsApp catalog sync) | Covered |
| FR38 | Seller can preview and confirm messages before sending to segmented lists | Epic 7 (Segmented list messaging) | Covered |
| FR39 | System detects social platform disconnection and guides seller through reconnection | Epic 7 (Platform disconnection handling) | Covered |
| FR40 | Seller can manage product catalog (add, edit, remove products with pricing and stock levels) | Epic 8 (Product catalog CRUD) | Covered |
| FR41 | Seller can upload and manage product media (photos/videos) | Epic 8 (Product media management) | Covered |
| FR42 | Seller can generate payment links tied to specific customer inquiries | Epic 10 (Payment link generation) | Covered |
| FR43 | Buyer receives a digital receipt with seller identity, product details, amount, and support contact after payment | Epic 10 (Digital receipts) | Covered |
| FR44 | Verified sellers display a Verification Badge on receipts and payment links | Epic 10 (Verification Badge display) | Covered |
| FR45 | System generates and logs MarketBoss tracking URLs for seller bios and payment links | Epic 10 (MarketBoss tracking URLs) | Covered |
| FR46 | Seller can track customer inquiries as lead cards with status progression | Epic 8 (Lead card tracking) | Covered |
| FR47 | Seller can manage multi-stage deals (e.g., deposit → work-in-progress → final payment) | Epic 10 (Multi-stage deal management) | Covered |
| FR48 | System tracks cross-platform customer journeys (e.g., IG post → WhatsApp DM → payment → delivery) | Epic 8 (Cross-platform journey tracking) | Covered |
| FR49 | System provides a fallback payment method (bank transfer details) when the primary payment provider is unavailable | Epic 10 (Fallback payment method) | Covered |
| FR50 | Seller can view a Content Performance Score showing engagement metrics per post | Epic 8 (Content Performance Score) | Covered |
| FR51 | Seller can view and manage active/expired payment links | Epic 10 (Payment link management) | Covered |
| FR52 | Seller can generate shareable product links for any channel | Epic 8 (Shareable product links) | Covered |
| FR53 | Seller can share progress updates with customers during multi-stage deals | Epic 8 (Customer progress updates) | Covered |
| FR54 | Seller can view payout history and settlement reports | Epic 10 (Payout history + settlement) | Covered |
| FR55 | Seller receives a customer summary card (conversation priming) when a new inquiry arrives | Epic 9 (Customer summary / priming card) | Covered |
| FR56 | Seller can take over automated conversations with a one-tap human handoff | Epic 9 (Human handoff (one-tap)) | Covered |
| FR57 | Seller can set up response templates for common inquiries | Epic 9 (Response templates) | Covered |
| FR58 | Team members can use response templates set up by the account owner | Epic 9 (Team template access) | Covered |
| FR59 | Seller can tag contacts with relationship types (e.g., regular, new, wholesale) and assign price tiers | Epic 9 (Customer tagging + price tiers) | Covered |
| FR60 | Seller can segment customer lists for targeted communications | Epic 9 (Customer segmentation) | Covered |
| FR61 | Buyer-initiated messages are never blocked, regardless of the seller's messaging limit | Epic 9 (Buyer messages never blocked) | Covered |
| FR62 | System logs system-generated vs human-generated responses for clear attribution | Epic 9 (System vs human attribution) | Covered |
| FR63 | Buyer can initiate a dispute during escrow period | Epic 8 (Buyer dispute initiation) | Covered |
| FR64 | Seller can view contextual MVP analytics (post performance, engagement rate, follower growth) within feed/inbox/home surfaces; dedicated analytics dashboard is post-MVP/Growth | Epic 12 (Contextual MVP analytics) | Covered |
| FR65 | System provides engagement prompts suggesting actions to increase reach | Epic 12 (Engagement prompts) | Covered |
| FR66 | System alerts the seller when their reach drops below their pre-MarketBoss baseline | Epic 12 (Baseline drop alerts) | Covered |
| FR67 | System shows sellers their progress compared to their pre-MarketBoss baseline | Epic 12 (Baseline progress comparison) | Covered |
| FR68 | System provides content strategy suggestions tailored to the seller's account type and niche | Epic 12 (Content strategy suggestions) | Covered |
| FR69 | Seller receives a warning when approaching their tier usage limits (at 80% threshold) | Epic 12 (Usage limit warnings (80%)) | Covered |
| FR70 | Seller can view pending-task summaries (unresponded inquiries, scheduled posts, draft approvals) directly in home/feed/inbox contextual surfaces without requiring a dedicated MVP analytics dashboard | Epic 12 (Pending task summaries) | Covered |
| FR71 | Seller (account owner) can invite team members via phone or email | Epic 11 (Team member invitations) | Covered |
| FR72 | Seller can assign granular permissions to team members (view inquiries, respond, create drafts, publish, view analytics, change settings) | Epic 11 (Granular RBAC permissions) | Covered |
| FR73 | Team members see a simplified role-based UI matching their permissions | Epic 11 (Role-based UI) | Covered |
| FR74 | Team members can create draft posts that require owner approval before publishing | Epic 11 (Team draft creation) | Covered |
| FR75 | Team members can schedule drafts pending owner approval | Epic 11 (Team draft scheduling) | Covered |
| FR76 | Account owner can review and approve/reject draft posts remotely | Epic 11 (Owner draft approval/rejection) | Covered |
| FR77 | System logs all team member activity with clear system vs human attribution | Epic 11 (Team activity logging) | Covered |
| FR78 | Team members can view their performance metrics without seeing revenue figures | Epic 11 (Team performance metrics) | Covered |
| FR79 | Team members can activate an emergency "Pause Auto-Replies" function | Epic 11 (Emergency Pause Auto-Replies) | Covered |
| FR80 | System warns when product catalog has not been updated for 6+ hours | Epic 11 (Catalog staleness warning) | Covered |
| FR81 | Seller can revoke team member access | Epic 11 (Revoke team access) | Covered |
| FR82 | Team member can upgrade to an independent MarketBoss account | Epic 11 (Team → independent account upgrade) | Covered |
| FR83 | Seller can customize after-hours auto-response messages | Epic 11 (After-hours auto-response customization) | Covered |
| FR84 | Super Admin can create and remove marketplace admin accounts | Epic 13 (Super Admin account management) | Covered |
| FR85 | Marketplace Admin can review and approve seller onboarding applications | Epic 13 (Admin onboarding review) | Covered |
| FR86 | Admin roles are separated: onboarding admin cannot perform dispute resolution, and vice versa | Epic 13 (Admin role separation) | Covered |
| FR87 | Admin can view platform health metrics (uptime, AI usage, active users, signups) | Epic 13 (Platform health metrics) | Covered |
| FR88 | Admin can manage support tickets with urgency-based prioritization | Epic 13 (Support ticket management) | Covered |
| FR89 | Admin can access user-level analytics and content history for troubleshooting | Epic 13 (User-level analytics access) | Covered |
| FR90 | Admin can initiate Brand Voice recalibration for a seller's account | Epic 13 (Admin Brand Voice recalibration) | Covered |
| FR91 | Admin can mediate and resolve buyer-seller disputes | Epic 13 (Dispute mediation) | Covered |
| FR92 | System maintains immutable consent records for data protection compliance (timestamped, purpose-specific) | Epic 13 (Immutable consent records) | Covered |
| FR93 | System processes data deletion requests within the required compliance timeframe | Epic 13 (Data deletion (72h compliance)) | Covered |
| FR94 | Admin can moderate content (review flagged posts, process takedown requests) | Epic 13 (Content moderation) | Covered |
| FR95 | System screens content pre-publication for prohibited categories and restricted content | Epic 13 (Pre-publication screening) | Covered |
| FR96 | System enforces multi-tenant data isolation (zero cross-tenant data leakage) | Epic 13 (Multi-tenant data isolation) | Covered |
| FR97 | Sellers can export their customer data (with PII anonymized per policy) | Epic 13 (Customer data export) | Covered |
| FR98 | System supports voice note submissions for support requests with transcription | Epic 13 (Voice note support) | Covered |
| FR99 | Admin can configure tenant-level limits (post limits, message limits, products, storage) | Epic 13 (Tenant-level limits config) | Covered |
| FR100 | Admin can configure platform-wide settings (commission rates, grace periods, feature gate defaults) | Epic 13 (Platform-wide settings) | Covered |
| FR101 | Admin can manage seller billing (view payment status, retry failed payments, manual adjustments) | Epic 13 (Seller billing management) | Covered |
| FR102 | Seller can appeal content moderation decisions | Epic 13 (Content moderation appeals) | Covered |
| FR103 | System tracks trust journey progression as an internal admin metric | Epic 13 (Trust journey tracking) | Covered |
| FR104 | Seller can configure notification preferences (channel: push, WhatsApp, SMS, email) | Epic 10 (Notification preferences) | Covered |
| FR105 | Seller receives notifications about billing lifecycle events (grace period, downgrade, suspension) | Epic 10 (Billing lifecycle notifications) | Covered |
| FR106 | Seller can view and terminate their active sessions | Epic 4 (Session management) | Covered |
| FR107 | System alerts users about suspicious account activity (new device, new IP, bulk data access) | Epic 4 (Suspicious activity alerts) | Covered |
| FR108 | Users can withdraw specific consent types (NDPA requirement) | Epic 13 (NDPA consent withdrawal) | Covered |
| FR109 | Seller can view their current subscription plan and usage | Epic 10 (Subscription plan view) | Covered |
| FR110 | Seller can upgrade or downgrade their subscription tier | Epic 10 (Tier upgrade/downgrade) | Covered |
| FR111 | System enforces tier-based limits server-side (daily posts, messages, products, connected accounts) | Epic 13 (Server-side tier limits) | Covered |
| FR112 | System generates invoices/receipts with seller's business branding | Epic 10 (Invoice/receipt generation) | Covered |

### Missing Requirements

- No PRD FR gaps detected in epic coverage mapping.

#### FRs In Epics But Not In PRD
- None detected.

### Coverage Statistics

- Total PRD FRs: 112
- FRs covered in epics: 112
- Coverage percentage: 100%


## UX Alignment Assessment

### UX Document Status

- Found: docs/planning-artifacts/ux-design-specification/index.md (sharded UX spec present with supporting UX files).

### Alignment Issues

- **Phase boundary tension (analytics UI):** PRD/UX specify contextual MVP metrics with dedicated analytics dashboards deferred to Growth, but architecture structure includes a dedicated (dashboard)/analytics/page.tsx route. Ensure this route is feature-gated or deferred from MVP release scope.
- **Phase boundary tension (scheduling UI):** PRD/UX defer full calendar views beyond MVP, but architecture references ContentCalendar.tsx in publishing coverage. Confirm MVP uses feed-native queue only and calendar capability is held for post-MVP.
- **UX requirement explicitness gap (voice-first/audio preview):** UX emphasizes voice-first content creation and audio preview as trust/accessibility-critical; PRD functional catalog does not explicitly define audio preview behavior as a functional requirement. Add explicit traceability in epics/stories to avoid omission.
- **UX requirement explicitness gap (publish trust gate):** UX proposes a per-post �Sounds Like Me� rating gate before publish, while PRD currently specifies Brand Voice scoring/warnings (FR24) without a strict publish gate requirement. Clarify if this is mandatory MVP behavior or optional enhancement.

### Warnings

- UX documentation exists and is detailed; no missing-UX warning applies.
- Several UX opportunities are marked as Growth/Scale innovations. Keep them out of MVP implementation planning unless they are explicitly tied to MVP FRs.
- Architecture largely supports UX non-functional needs (mobile-first, 3G performance, skeleton loading, offline tolerance), but enforcement should include testable acceptance criteria in stories so UX constraints are not lost during implementation.


## Epic Quality Review

### Validation Scope

- Epics reviewed: 13 (epic-list.md + full stories.md)
- Stories reviewed: 96
- Story template compliance (As a / I want / So that + AC header + Given/When/Then): 100%
- Forward story dependencies detected: 0

### ?? Critical Violations

1. **Technical epics used as primary product epics (no direct user value):** Epic 1, Epic 2, and Epic 3 are infrastructure milestones with FRs covered: None (Foundational/Additional).
   - Evidence: docs/planning-artifacts/epics/epic-list.md:3, :16, :26 and corresponding FR coverage lines :7, :20, :30.
   - Why this violates standards: create-epics-and-stories guidance requires user-value epics; technical setup should be treated as enablers/prerequisites, not user outcome epics.
   - Remediation: Move Epics 1-3 to a prerequisite track (or relabel as Enabler Epics) with explicit exit criteria and keep user-value epics as the primary delivery sequence.

2. **FR-to-story semantic mismatch (false coverage) for FR79 and FR80:**
   - PRD definitions:
     - FR79 = emergency Pause Auto-Replies
     - FR80 = stale product-catalog warning after 6+ hours
   - Evidence: docs/planning-artifacts/prd/functional-requirements.md:105-106
   - Story 11.5 is Workload-Based Auto-Assignment but claims FR79, FR80 coverage.
   - Evidence: docs/planning-artifacts/epics/stories.md:1808, :1814, :1821
   - Why this is critical: readiness report currently shows 100% FR coverage, but these two FRs are not implemented by matching story behavior.
   - Remediation: Create/adjust stories so FR79 and FR80 are implemented explicitly (pause auto-replies control + stale catalog warning), then remap Story 11.5 to additional scope or a different FR.

### ?? Major Issues

1. **Traceability dilution from high volume of non-FR stories:**
   - 37/96 stories are marked None (Foundational/Additional).
   - 14 of these occur inside feature epics (4+), increasing ambiguity in scope control and acceptance.
   - Examples: Story 4.3, 4.6, 4.7, 6.1, 6.2, 6.9, 6.10, 8.2, 8.3, 8.6, 9.2, 10.6.
   - Remediation: map each non-FR story to either (a) explicit NFR(s), (b) architecture decision ID, or (c) enabler tag with clear definition of done.

2. **Migration naming rule conflict between stories and architecture standards:**
   - Story 2.3 requires NNNN_description.up.sql naming.
   - Architecture standards require timestamp format YYYYMMDDHHMMSS.
   - Evidence: docs/planning-artifacts/epics/stories.md:199 vs docs/planning-artifacts/architecture/implementation-patterns-consistency-rules.md:327 and :341.
   - Remediation: normalize Story 2.3 acceptance criteria to architecture canonical migration naming.

3. **Scope creep risk in AI epic through unmapped advanced stories:**
   - Stories 6.9 and 6.10 add advanced image/layout capabilities but remain unmapped to PRD FRs.
   - Remediation: either map to approved requirements (or a planned Growth phase requirement) or move out of MVP implementation sequence.

### ?? Minor Concerns

1. **Cross-reference inconsistency in FR ownership:**
   - Story 6.8 references �FR69 mechanism from Epic 10,� but FR69 belongs to Growth Insights (Epic 12 mapping).
   - Evidence: docs/planning-artifacts/epics/stories.md:1018.
   - Remediation: correct reference text to avoid planning confusion.

2. **Dependency metadata is implicit in acceptance criteria text:**
   - Backward dependencies are present and valid, but mostly embedded in AC prose.
   - Remediation: add explicit Depends on: field per story for planning-tool friendliness and less ambiguity in sprint sequencing.

### Best-Practice Compliance Checklist (Step 5)

- [ ] Epic delivers user value (fails for Epics 1-3)
- [x] Epic independence from future epics (no forward epic dependency detected)
- [x] Stories are generally right-sized and structurally complete (template + BDD present)
- [x] No forward story dependencies detected
- [x] Database creation timing is mostly incremental (base schema + progressive additions)
- [ ] Traceability to requirements is fully reliable (fails due to FR79/FR80 semantic mismatch and high non-FR story volume)


## Summary and Recommendations

### Overall Readiness Status

NOT READY

### Critical Issues Requiring Immediate Action

- Convert foundational technical epics (Epics 1-3) into an explicit enabler/prerequisite track or refactor them into user-value epics before sprint execution.
- Correct FR79/FR80 semantic coverage: current Story 11.5 does not implement emergency Pause Auto-Replies or stale-catalog warning behavior despite claiming both FRs.
- Re-run FR traceability validation after remapping stories to ensure coverage is semantically accurate, not only numerically complete.

### Recommended Next Steps

1. Refactor epic taxonomy: separate product-value epics from enabling technical tracks, then re-sequence implementation order.
2. Add/adjust stories to explicitly implement FR79 and FR80, and remove incorrect FR tags from unrelated auto-assignment scope.
3. Normalize standards conflicts (e.g., migration naming convention) so stories and architecture rules are consistent before development begins.
4. Tag all None (Foundational/Additional) stories with explicit NFR/ADR/enabler references and acceptance evidence.
5. Re-run check-implementation-readiness after fixes and confirm readiness status before starting Sprint Planning.

### Final Note

This assessment identified 11 substantive issues across 3 severity categories (2 critical, 3 major, 2 minor, plus 4 UX/phase alignment issues). Address the critical issues before proceeding to implementation. The findings can be used to improve artifacts, or you may proceed with explicit risk acceptance.

### Assessment Metadata

- Assessment Date: 2026-02-24
- Assessor: Codex (PM/SM readiness validation)

