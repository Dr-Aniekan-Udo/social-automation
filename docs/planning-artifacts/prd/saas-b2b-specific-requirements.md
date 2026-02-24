# SaaS B2B Specific Requirements

*Enhanced via Advanced Elicitation: Threat Modeling, Pricing Stress Test, Chaos Monkey SaaS, Feature Gating Edge Cases*

### Project-Type Overview

MarketBoss is a **multi-tenant SaaS B2B platform** with marketplace characteristics. It serves Nigerian social commerce sellers through a subscription + commission revenue model, with enterprise accounts adding team collaboration and dedicated infrastructure.

### Tenant Model (Hybrid Isolation)

| Aspect | Normal Accounts | Enterprise Accounts |
|--------|----------------|-------------------|
| **Database** | Shared DB with tenant_id row-level isolation | Dedicated database instance |
| **Provisioning** | Instant self-service signup | Sales-led, admin-approved |
| **Tier upgrades** | Admin-reviewed via admin dashboard | Custom pricing discussion |
| **Data isolation** | Row-level + application-layer enforcement | Physical DB separation |
| **Failover** | Shared DB HA covers all normal tenants | Read replica + 30s auto-failover to replica. Degraded: temporary read-only via shared DB. |
| **Pentest** | Covered by shared infra pentests | Dedicated pentest per onboarding |

**Admin-Configurable Tenant Limits** (set via Admin Dashboard):

| Limit | Default | Admin Override |
|-------|---------|---------------|
| Max products per seller | Tier-based (see subscription) | ✅ Per-tenant |
| Max storage (images/media) | Tier-based | ✅ Per-tenant |
| Max team members | Tier-based (normal + enterprise) | ✅ Per-tenant |
| Daily post limit | Tier-based | ✅ Per-tenant |
| Daily message limit | Tier-based | ✅ Per-tenant |

##### Provisioning Pipeline Resilience

- Signup processing rate: **50/hour queue** (prevents KYC provider rate limit exhaustion)
- **Deferred KYC:** Users enter platform immediately; KYC verification runs async. Unverified users can operate under tier limits (posting, sales, withdrawals) and unlock higher limits as verification tiers are completed.
- DB: Pre-partitioned tenant_id ranges for shared DB
- Welcome notification batching to prevent SMS/email provider overload

### RBAC Matrix

| Role | Scope | Permissions | Security Controls |
|------|-------|-------------|------------------|
| **Super Admin** | Platform-wide | Create/remove admin accounts ONLY | ⚠️ NOT for daily ops. **MFA (hardware key required)**, IP whitelist, full audit log, 90-day credential rotation, max 2 admin creates/hour. **Break-glass recovery** via cloud IAM if compromised. |
| **Marketplace Admin** | Platform-wide | Seller onboarding review, compliance audits, dispute resolution, KYC tier approval, content moderation, platform config | **Separation of duties:** onboarding admin ≠ dispute admin. Approval workflow for high-risk KYC decisions. Action audit log. |
| **Seller (Owner)** | Own tenant | Full control: content, products, payments, settings, analytics. Can invite basic team members for delegation (approval workflow + scoped permissions). | Team and owner actions logged separately. Session logging + last-login alerts. |
| **Enterprise Owner** | Own tenant | Full control + create team members, assign roles, set permissions | Audit log of all permission changes. Session management (view/terminate team sessions). |
| **Enterprise Team Member** | Own tenant (restricted) | Permissions set by Enterprise Owner. Options: content management, DM handling, order processing, analytics view | Cannot modify owner settings or billing. Notification on PII access. |

##### Account Type Matrix

| Feature | Normal Account | Enterprise Account |
|---------|---------------|-------------------|
| Team members | ✅ Basic delegation (tier-limited) | ✅ Owner-defined roles |
| Role-based permissions | ✅ Basic scoped permissions | ✅ Granular |
| Dedicated database | ❌ | ✅ |
| Custom pricing | ❌ | ✅ (sales-negotiated) |
| Dedicated support | ❌ | ✅ |
| Session management | Basic (login alerts) | Full (view/terminate sessions) |

##### Security Requirements (All Roles)

- Immutable audit trail for all state-changing actions
- Session management dashboard (active sessions, device info, location)
- Suspicious activity alerts (login from new device/IP, bulk data access)

### Subscription Tiers

**Revenue Model:** Monthly subscription (marketing/content features) + 3% commission on successful sales + ~1.5% gateway fee

| Feature | Starter (Free) | Professional (₦5,000/mo) | Business (₦15,000/mo) | Enterprise (Custom) |
|---------|----------------|--------------------------|----------------------|--------------------|
| **Commission** | 3% + gateway | 3% + gateway | 3% + gateway | Negotiated (floor: 2%) |
| **Daily posts** | 2 | 8 | 20 | Unlimited (platform limit) |
| **Daily messages** (seller-initiated) | 20 | 100 | 500 | Unlimited (platform limit) |
| **Products** | 20 | 100 | 500 | Unlimited |
| **IG accounts** | 1 | 3 | 10 | Unlimited |
| **Brand voice profiles** | 1 | 3 | 10 | Unlimited |
| **Team members** | 0 | 1 | 3 | Admin-configured |
| **Analytics** | Basic (7-day) | Full (30-day) | Full + attribution | Full + custom reports |
| **Escrow (Growth+)** | ✅ | ✅ | ✅ | ✅ |
| **Storage** | 500MB | 2GB | 10GB | Custom |
| **Support** | Community | Email (48h) | Priority (24h) | Dedicated |

> ⚠️ **Pricing is placeholder** — exact ₦ amounts need market validation. Tier structure and feature gates are the architectural decisions.

##### Commission Rules

- Commission charged **only on COMPLETED transactions** (escrow confirmed / delivery confirmed)
- Refunded transactions = commission refunded to seller
- Enterprise commission floor: **minimum 2%** — never negotiated below this
- Content-to-payment ratio tracked as commission evasion signal (content generated but no MarketBoss payment processed)

##### Billing Resilience

- Monthly auto-renewal via Paystack recurring payments (Flutterwave billing fallback in Growth+)
- **Grace period:** 3-day billing retry → Day 4: auto-downgrade to Starter (content above Starter limit becomes read-only) → Day 7: account suspended (data preserved 30 days) → Day 37: data deletion with 7-day advance warning
- Never delete data without advance notification

### Feature Gating Rules

| Rule | Decision | Rationale |
|------|----------|----------|
| **Post counting** | 1 post = 1 published content piece. Carousel = 1 post, max 5 products per carousel. | Prevents gaming via mega-carousels |
| **Scheduled posts** | Count against the **PUBLISH day**, not the draft day | Otherwise daily limits are meaningless |
| **Drafts** | Unlimited. Daily limit = published posts only. | Don't punish content preparation |
| **Editing a post** | Does NOT consume a post slot | Encourage iteration, not one-shot pressure |
| **Failed posts** | Do NOT consume a slot. Auto-retry 3x before marking failed. | Fairness — don't penalize API errors |
| **Deleting and reposting** | Deletes do NOT free up slots | Prevents gaming (post-delete-repost cycle) |
| **Cross-platform counting** | Each platform counts independently. 1 IG + 1 WhatsApp = 2 slots. | Clear, predictable, fair |
| **Midnight reset** | Midnight WAT (UTC+1) for all Nigerian sellers | Consistent. Future: configurable per-tenant for international expansion |
| **Buyer-initiated messages** | 🔴 **NEVER blocked**, regardless of message limit | Message limit = seller-initiated only (broadcasts, proactive outreach). Incoming buyer inquiries always get through. Blocking buyer DMs = lost sales = seller churn. |
| **Limit approach warning** | Show upgrade prompt at 80% usage threshold | Proactive upsell, not surprise block |

### Integration Architecture

| Integration | Phase | Provider(s) | Architecture |
|-------------|-------|-------------|-------------|
| **Social Media** | MVP | Meta IG Graph API, WhatsApp Business API | Direct API |
| **Payments** | MVP + Growth | MVP: Paystack. Growth: Paystack + Flutterwave failover | Subaccount (direct settlement in MVP, optional escrow in Growth) |
| **KYC/Identity** | MVP | Smile ID, Dojah, Prembly | Adapter pattern |
| **Notifications** | MVP + Growth | MVP: Termii + SendGrid. Growth: add Africa's Talking SMS failover | Notification service layer |
| **AI/Content** | MVP | DeepSeek (primary), Google Gemini (secondary), OpenAI GPT-4o (tertiary) | Provider-agnostic wrapper with tiered routing |
| **CRM** | Growth | QuickBooks, Zoho (future) | 🔌 Plugin architecture from Day 1 |
| **Logistics** | Scale | GIG, Kwik, DHL (future) | 🔌 Plugin architecture from Day 1 |
| **Open API** | Scale | MarketBoss API for third-party devs | RESTful + webhook system |

**Extensibility Principle:** Integration layer built with adapter/plugin pattern from MVP. CRM, logistics, and third-party integration slots are defined interfaces but not implemented — new providers can be added without core architecture changes.

##### Notification Provider Resilience

- MVP: single SMS provider (Termii) with email fallback
- Growth: dual SMS provider (Termii primary, Africa's Talking fallback)
- SMS is notification channel, never blocking — fallback to email
- WhatsApp OTP as alternative to SMS OTP for verification

##### AI Provider Resilience

- Queue failed AI requests with retry logic
- Cached templates as immediate fallback (<5 min)
- Manual posting mode after 1 hour of AI downtime (text-only, seller writes)
- "AI is currently busy" banner with ETA

### Implementation Considerations

- **Database migration path:** Start all tenants on shared DB. Enterprise provisioning script creates dedicated instance and migrates tenant data with zero downtime.
- **Super Admin isolation:** Super Admin account has no access to tenant data, marketplace operations, or content. It ONLY manages admin accounts. Enforced at API layer, not just UI.
- **Credential sharing risk (Normal accounts):** Basic team delegation is available, but some sellers may still share credentials outside policy. Mitigate with session logging, last-login alerts, suspicious activity detection, and clear in-product delegation paths.
- **Subscription billing:** Monthly auto-renewal via Paystack recurring payments. Commission deducted at transaction time via subaccount split.
- **Feature gating enforcement:** Server-side enforcement of all tier limits. Client shows upgrade prompts when approaching limits (80% threshold). Never rely on client-side enforcement alone.
- **Post definition clarity:** "Post" = one call to the social media publishing API that creates new content. Re-shares, story reposts, and edits do not count. Platform-specific limits (e.g., Meta's own rate limits) serve as the ceiling for "unlimited" enterprise tiers.
