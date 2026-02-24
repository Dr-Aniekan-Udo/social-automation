# Project Scoping & Phased Development

*Enhanced via Advanced Elicitation: Devil's Advocate, Red Team vs Blue Team, Dependency Mapping, Product Brief ↔ PRD Alignment, Jobs-to-be-Done Prioritization*

### MVP Philosophy

**Approach:** Problem-Solving MVP — launch fast, solve the core problem, iterate.

##### Unified MVP Thesis

> **MarketBoss AI creates your IG/WhatsApp content WITH embedded payment links — every post is a sales opportunity.**

This thesis resolves the product brief ↔ PRD alignment gap: the product brief emphasized payment automation ("Trust Engine"), while earlier PRD drafts emphasized content AI. The unified thesis treats content and payments as **one integrated workflow**, not separate features. The AI generates the caption + the price + the payment CTA + the MarketBoss tracking link. The content IS the commerce.

##### JTBD Validation — Top 3 Seller Jobs

| Rank | Job | Score | MVP Feature |
|------|-----|-------|-------------|
| 🥇 | "Create pro captions that sound like ME without 2hrs writing" | 9.5 | Brand Voice Engine |
| 🥈 | "Send a payment link buyers can click instead of dictating my account number" | 9.0 | Paystack Payment Links |
| 🥉 | "See all customer conversations in one place" | 8.5 | WhatsApp Unified Inbox |

### Phase 1: MVP — "AI Commerce Engine" (~8 Weeks)

**Goal:** AI-powered content creation with integrated payment links on an Instagram-first baseline, plus WhatsApp inbox/payment-link support when API approval clears during the MVP build window.

**Pre-Sprint Requirement (Week -2):** Submit WhatsApp Business API application. If approval is delayed beyond Week 4 of dev, ship IG-only MVP and add WhatsApp when approved.

#### Sprint Plan

| Sprint | Weeks | Focus | Deliverables |
|--------|-------|-------|-------------|
| Sprint 1 | W1–W2 | Foundation | Auth (email/phone OTP), Revenue Command Feed shell, Paystack subaccount integration, basic KYC (Dojah NIN verification) |
| Sprint 2 | W3–W4 | Content AI | Brand Voice Engine (onboarding questionnaire → voice profile), IG Graph API posting, AI-generated captions with payment link CTAs, Content Performance Score |
| Sprint 3 | W5–W6 | Messaging + Links | If WhatsApp approval is granted in-window: WhatsApp Cloud API (unified inbox), conversation priming (customer summary card), and payment-link embedding in WhatsApp messages. If approval is delayed: ship IG-first MVP baseline and complete link-router + messaging foundations for immediate WhatsApp activation post-approval. |
| Sprint 4 | W7–W8 | Admin + Polish | Marketplace Admin dashboard (2-role separation: onboarding vs operations), Digital Receipt page for buyers, Seller Verification Badge, Beta onboarding flow, Load testing |

#### Phase 1 Feature Set

| Feature | Scope | Notes |
|---------|-------|-------|
| **Brand Voice Engine** | Onboarding questionnaire → voice profile → AI captions | Core differentiator |
| **IG Posting** | Graph API: single image + carousel (max 5 products) | Caption + payment link CTA |
| **WhatsApp Messaging** | Cloud API: unified inbox, inbound + outbound, payment links | NO broadcasts (Phase 2) |
| **Conversation Priming** | Push notification + customer summary card on new DM | Simplified from full context dashboard |
| **Paystack Payment Links** | Subaccount model (direct settlement, no escrow) | Architecture supports Phase 2 escrow |
| **Link Router** | MarketBoss URL generation + click logging | No attribution logic yet — pipe only |
| **Digital Receipt** | Buyer-facing page with seller name, product, amount, support contact | Trust signal without escrow |
| **Seller Verification Badge** | Visual badge on receipts/links for KYC-verified sellers | Day 1 buyer trust |
| **Content Performance Score** | Basic engagement metric per post (likes, comments, DM inquiries) | Directional, not full attribution |
| **KYC (Basic)** | Dojah NIN verification, progressive (Tier 1 on signup, Tier 2 for payments) | Smile ID backup |
| **Admin Dashboard** | RBAC with 2-admin-role separation (onboarding ≠ operations) | MVP: immutable core compliance/admin events. Growth: expanded full-retention audit coverage |
| **Notifications** | Email + SMS (single provider) | Dual SMS → Phase 2 |
| **Accounts** | Normal accounts + basic team delegation | Enterprise (dedicated DB + advanced RBAC) → Phase 3 |

#### Phase 1 Pricing

**Beta (first 100 users):** Flat **₦10,000/month** after a 7-day free trial — no feature gating, no tiers. All features available. This defers feature gating infrastructure from MVP sprint (~1 week saved).

**Public launch (post-beta):** Transition to Starter (Free) + Professional (₦5,000/mo) tiers with server-side feature gating enforcement.

#### Phase 1 NOT Included

| Feature | Why Deferred | Phase |
|---------|-------------|-------|
| Escrow | Requires complex dispute flow + fund holding. Direct settlement + digital receipt provides Day 1 trust. | Phase 2 |
| Flutterwave | Paystack has 99.9% uptime. Degraded mode (auto-generated bank transfer) covers outages. | Phase 2 |
| Cross-platform attribution | Depends on link-router data accumulation. Phase 1 builds the pipe; Phase 2 adds the logic. | Phase 2 |
| WhatsApp broadcasts | Phase 1 WhatsApp = inbox + priming + payment links. Outbound campaigns require template approval workflows. | Phase 2 |
| Full audit log retention tiers | MVP keeps immutable core compliance/admin events. Full multi-tier retention and expanded audit scope deferred. | Phase 2 |
| Feature gating | Not needed at 100 beta users with flat pricing. Built when tiered pricing launches. | Public Launch |
| Facebook posting | IG + WhatsApp are sufficient for MVP. Same Graph API — easy to add later. | Phase 2 |
| Content diversification scoring | Needs baseline content data from Phase 1 usage. | Phase 2 |
| Business/Enterprise tiers | Early adopters are content-poor SMBs, not power users. JTBD score for feature gating = 3.0. | Phase 2/3 |

### Phase 2: Growth — "Trust + Scale Engine" (Months 4–6)

**Goal:** Add buyer protection, payment resilience, and advanced analytics.

| Feature | Description |
|---------|-------------|
| **Escrow** | Paystack subaccount hold → delivery confirmation → settlement. Dispute flow with admin arbitration. |
| **Flutterwave Failover** | Dual payment gateway. Auto-switch on Paystack errors. |
| **Cross-Platform Attribution** | Link-router data → "which post drove which sale." UTM parameter tracking + conversion funnel. |
| **Full KYC** | Smile ID SmartSelfie™ biometric. Tier 2 (NIN/BVN + photo match) and Tier 3 (address + biometric). |
| **Business Tier** | ₦15,000/mo. 20 daily posts, 500 messages, 500 products, 10 IG accounts. |
| **Feature Gating Infra** | Server-side tier enforcement, 80% usage upgrade prompts. |
| **WhatsApp Broadcasts** | Template message campaigns, audience segmentation. |
| **Facebook Posting** | Extend IG adapter to FB Pages via same Graph API. |
| **Advanced Fraud Detection** | Content-to-payment ratio tracking, commission evasion signals. |
| **Content Diversification Scoring** | AI suggests varied content types based on audience engagement patterns. |
| **Dual SMS Provider** | Primary + failover for notification resilience. |
| **Full Audit Log** | Immutable audit trail for all admin and seller state-changing actions. |

### Phase 3: Scale — "Market Expansion Engine" (Months 7–12)

**Goal:** Enterprise features, API ecosystem, and regional expansion.

| Feature | Description |
|---------|-------------|
| **Enterprise Accounts** | Dedicated databases, team members, granular RBAC, custom pricing (commission floor: 2%). |
| **Open API** | Developer API for custom integrations. |
| **CRM/Logistics Plugins** | Third-party integration marketplace. |
| **Advanced Analytics** | ML-powered predictive analytics, custom reports. |
| **Dedicated Enterprise DBs** | Physical DB separation, read replica + 30s auto-failover. |
| **TikTok Integration** | Sandbox development → audit submission → direct post. |
| **Telegram + RCS/SMS Fallback** | Channel agnosticism — Meta risk mitigation. |
| **International Expansion** | Ghana, Kenya. Multi-currency support. |

### Critical Architecture Prerequisites (Phase 1)

> [!IMPORTANT]
> These infrastructure components MUST exist in Phase 1 because Phase 2 features directly depend on them. Omitting them forces expensive refactoring later.

#### 1. Link Router Infrastructure

**Phase 2 dependency:** Cross-Platform Attribution (innovation score 4.05)

Phase 1 builds a basic link shortener that:

- Generates MarketBoss URLs for seller bios and payment links (e.g., `mboss.ng/p/{shortcode}`)
- Logs click events (timestamp, referrer, user agent)
- Does NOT perform attribution logic — just captures the data

Phase 2 adds attribution analysis on top of the accumulated click data.

#### 2. Paystack Subaccount Model

**Phase 2 dependency:** Escrow

Phase 1 uses Paystack subaccounts with **immediate settlement** (no hold). This is functionally identical to simple payment links from the seller's perspective, but the underlying architecture supports Phase 2 escrow by:

- Enabling fund holding via subaccount `settlement_schedule` parameter
- Supporting split payments (commission deduction at transaction time)
- Providing per-seller transaction tracking via subaccount IDs

### Paystack-Down Degraded Mode

When Paystack is unreachable (health check fails 3 consecutive times over 30 seconds):

1. Payment link buttons change to "Payment Temporarily Unavailable"
2. Auto-generate seller's bank transfer details (from onboarding data)
3. Show buyer: "Transfer ₦{amount} to {bank} {account_number} ({seller_name}). Send screenshot to seller via WhatsApp."
4. Log degraded-mode events for reconciliation when Paystack recovers
5. Auto-switch back when health check passes

### Risk Mitigation Matrix

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| **Brand Voice quality disappoints** | HIGH | Medium | 3-iteration minimum during onboarding. Seller can regenerate. Fallback to templates. |
| **WhatsApp API approval delayed** | HIGH | Medium | Start application Week -2. If delayed → ship IG-only MVP. WhatsApp added when approved. |
| **Admin dashboard timeline pressure** | MEDIUM | Medium | Admin UI can be minimal (table views, not dashboards). Polish in Phase 2. |
| **Seller willingness to pay ₦10K/mo** | MEDIUM | Medium | 7-day free trial. ROI calculator in onboarding ("you spend 2hrs/day on captions = ₦X of your time"). |
| **Seller overwhelm (too many features)** | MEDIUM | Low | Progressive disclosure. Day 1 = connect IG + create first post. Advanced features unlock gradually. |
| **8-week estimate too aggressive** | MEDIUM | Medium | Sprint 4 is buffer. Core value (Sprints 1–3) ships in 6 weeks. Polish/admin can extend 1–2 weeks. |
| **Link-router adds scope** | LOW | Low | Minimal implementation: URL generation + click logging. No attribution logic. ~2 days of dev. |
| **Paystack subaccount vs simple links** | LOW | Low | Same integration effort. Subaccount model is Paystack's recommended approach. |

### Phase 1 Resource Estimate

| Role | Count | Allocation |
|------|-------|------------|
| Full-stack Engineer (Go + Next.js) | 2 | 100% |
| AI/ML Engineer | 1 | 80% (Brand Voice + content generation) |
| Designer | 1 | 50% (dashboard + buyer receipt UI) |
| **Total budget** | | **₦7,500,000 (~$4,800)** |

### Scoping Decision Log

*14 improvements accepted from Advanced Elicitation (Devil's Advocate, Red vs Blue, Dependency Mapping, Brief ↔ PRD Alignment, JTBD):*

| # | Improvement | Source Method | Impact |
|---|-------------|--------------|--------|
| 1 | Unified MVP thesis: content + payments integrated | Brief ↔ PRD Alignment | Resolves strategic conflict |
| 2 | Beta pricing: flat ₦10,000/mo | Brief ↔ PRD Alignment | Saves ~1 week (no feature gating) |
| 3 | Feature gating deferred to public launch | JTBD (score 3.0) | Reduces MVP scope |
| 4 | Digital Receipt + Seller Badge for buyers | Devil's Advocate | Day 1 trust signal |
| 5 | Paystack-down degraded mode | Devil's Advocate | Payment resilience |
| 6 | Link router infrastructure | Dependency Mapping | Phase 2 attribution dependency |
| 7 | Paystack subaccount model Day 1 | Dependency Mapping | Phase 2 escrow dependency |
| 8 | WhatsApp = inbox + priming + payment links only | Devil's Advocate | Scope clarity |
| 9 | WhatsApp API application Week -2 | Red vs Blue Team | Risk mitigation |
| 10 | Admin: separation YES, immutable core audit events in MVP, full retention model in Phase 2 | Devil's Advocate | Right-sized scope |
| 11 | Conversation priming simplified | JTBD (score 6.5) | Reduces complexity |
| 12 | Content Performance Score added | Devil's Advocate | Directional analytics |
| 13 | Facebook dropped from MVP | Brief ↔ PRD Alignment | Focus on IG + WhatsApp |
| 14 | Sprint plan: 4×2-week sprints | Red vs Blue Team | Feasibility validation |
