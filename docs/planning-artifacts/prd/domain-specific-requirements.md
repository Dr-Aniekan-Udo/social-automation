# Domain-Specific Requirements

**Domain:** Fintech × Social Commerce | **Complexity:** HIGH | **Region:** Nigeria

*Enhanced via Advanced Elicitation: Red Team vs Blue Team, Security Audit Personas, Pre-mortem Analysis, Chaos Monkey Scenarios*

### Payment Architecture

##### Model: Paystack Subaccount First, Escrow + Dual-Gateway in Growth

MarketBoss acts as a marketplace facilitator using payment provider subaccounts. In MVP, payments use direct settlement through Paystack. In Growth, optional escrow and Flutterwave failover are added. MarketBoss never directly holds customer funds, avoiding CBN money transmission licensing.

| Component | Specification |
|-----------|---------------|
| **Integration model** | MVP: Paystack subaccount + split payment API with direct settlement. Growth: optional escrow/manual settlement + Flutterwave failover |
| **Dual provider** | Growth phase enables Paystack + Flutterwave dual-provider mode; auto-failover target ≤ 30 seconds once enabled |
| **Payment health monitoring** | Real-time provider status checks; alerts at T+24h settlement delay |
| **Seller onboarding** | MarketBoss creates subaccount linked to seller's bank account; bank account name MUST match NIN/BVN name before activation |
| **Payment page branding** | Displays seller's business name (not MarketBoss) |
| **Escrow flow (Growth, optional)** | Buyer pays → funds held by payment provider → buyer confirms delivery → funds released to seller (auto-release after 72h if no dispute) |
| **Commission rate** | 3% MarketBoss commission + ~1.5% payment gateway fee = ~4.5% total seller cost; commission is admin-configurable and adjustable per product category |
| **Settlement** | MVP: immediate settlement to seller. Growth (escrow ON): held until buyer confirmation or 72h auto-release, then settled |
| **Fee transparency** | All fees (3% commission + gateway fee) clearly displayed at signup, on payment pages, and in seller dashboard |
| **Invoice/receipt** | Generated with seller's business name and branding |
| **Stamp duty** | ₦50 CBN fee on transactions ≥ ₦10,000 (Flutterwave); passed through transparently |
| **Dispute resolution** | Platform mediates buyer-seller disputes during escrow hold; Paystack/Flutterwave handle chargebacks post-settlement |
| **Reconciliation** | Webhook-based transaction matching + daily settlement reports |
| **Payment link security** | Links tied to specific lead/inquiry; 72h expiry; product details visible to buyer; cannot be reused for unrelated transactions |

> **Key Decisions:**
>
> - MarketBoss never holds funds directly — payment providers settle directly in MVP and hold escrow in Growth when escrow is ON.
> - Commission (3%) + gateway fee (~1.5%) = ~4.5% total cost to seller, transparently disclosed.
> - Buyer protection (Growth): escrow holds funds until delivery confirmation or 72h auto-release.
> - Dual payment provider is introduced in Growth; MVP keeps a Phase-2-ready integration path.

### Tiered KYC (Know Your Customer)

**Approach:** Optional at signup with progressive access. Limits applied to reduce risk for unverified users.

| Tier | Verification Required | Posting | Sales Cap | Withdrawal Limit | Provider |
|------|----------------------|---------|-----------|-----------------|----------|
| **Unverified** | Email + phone only | ≤ 3 posts/day | ≤ ₦50,000 total | 20% of daily sales, max ₦10,000/day | None |
| **Basic** | NIN or BVN | Unlimited | ≤ ₦1,000,000 total | ≤ ₦100,000/day | Smile ID / Dojah |
| **Full** | NIN + BVN + bank account + CAC (optional) | Unlimited | Unlimited | Unlimited | Smile ID / Dojah / Prembly |

##### Upgrade triggers

- Approaching sales cap → in-app prompt: "Verify to unlock unlimited sales"
- Approaching withdrawal limit → in-app prompt with verification link
- After 30 days unverified → reminder nudge (non-blocking)

### Fraud Detection & Prevention

*Source: Red Team vs Blue Team + Chaos Monkey*

| Threat | Detection | Response |
|--------|-----------|----------|
| **Multi-account abuse** | Device fingerprinting + IP clustering + phone number velocity checks | Auto-freeze at 3+ accounts from same device/IP; manual review queue |
| **Behavioral similarity** | Cross-account analysis: same product photos, caption style, or bank BVN | Flag for review; block subaccount creation pending investigation |
| **Commission evasion** | Lead-to-payment conversion ratio monitoring (50 leads, 2 payments = flag) | Advisory notification; no punitive action (business model risk) |
| **Counterfeit/prohibited content** | Pre-publication content screening; reverse image search on product photos | Auto-hold for review; community reporting with 24h takedown SLA |
| **Payment link abuse** | Links scoped to specific inquiry; 72h expiry; product details locked | Expired/orphan links cannot process payment |
| **Money laundering** | Cross-account velocity monitoring; SAR (Suspicious Activity Report) filing capability | Automated freeze; compliance team escalation |

### Compliance & Regulatory

#### NDPA (Nigeria Data Protection Act 2023)

| Requirement | Implementation |
|------------|----------------|
| **Consent infrastructure** | Purpose-specific consent system (not just privacy policy text); immutable timestamped consent logs; auditable records |
| **Right to deletion** | 72-hour SLA for data deletion requests; automated pipeline |
| **Breach notification** | 72-hour notification to NDPC; incident response plan; annual breach notification drill |
| **Data retention** | Purpose-limited retention; auto-archival of inactive accounts (90 days); deletion on request |
| **DPO appointment** | Required when classified as data controller of major importance (likely at ~500 users) |
| **Annual audit** | NDPC compliance audit report submitted annually |
| **Cross-border transfer** | Data stored in Nigeria-based or adequate-protection hosting; explicit consent for any transfers |
| **Privacy policy** | Clear, accessible, user-friendly; Pidgin English version recommended |

#### CBN (Central Bank of Nigeria)

- MarketBoss does NOT hold customer funds → no money transmission license required
- Escrow held by Paystack/Flutterwave (both CBN-licensed), not MarketBoss
- Subaccount model delegates payment compliance to licensed providers
- Stamp duty handling: platform passes through ₦50 fee transparently on applicable transactions

#### FCCPC (Federal Competition & Consumer Protection Commission)

- No deceptive automated marketing: all posts must be user-approved (human-in-the-loop)
- Transparent pricing: all fees (commission + gateway) disclosed upfront; no hidden fees in payment links
- AI content disclosure: user's choice (not platform-mandated)

### Data Ownership & Processing

*Source: Security Audit Personas + Red Team*

| Aspect | Specification |
|--------|---------------|
| **Data Processing Agreement (DPA)** | Required at seller signup; defines MarketBoss as joint data controller with seller |
| **Seller data rights** | Sellers own customer relationships; can export data but exports are anonymized (no phone numbers/PII without customer opt-in) |
| **Brand voice classification** | Treated as sensitive PII; encrypted separately (AES-256); not included in analytics aggregation |
| **Customer data rights** | Customers can request deletion from specific seller AND platform-wide; 72h SLA |
| **Seller liability** | ToS defines MarketBoss as facilitator; seller is responsible for product quality, delivery, and regulatory compliance for their category |
| **Platform insurance** | Professional indemnity insurance recommended at scale (500+ sellers) |

### Industry Restrictions

#### Prohibited Categories (Cannot Use MarketBoss)

- ❌ Pharmaceuticals (prescription and OTC drugs — requires PCN licensing)
- ❌ Regulated/controlled substances
- ❌ Weapons, ammunition, explosives
- ❌ Financial products (investment schemes, crypto without SEC registration)
- ❌ Counterfeit or pirated goods
- ❌ Adult content

#### Categories Requiring Documentation

| Category | Requirement | Verification Method |
|----------|------------|---------------------|
| **Food (packaged/processed)** | NAFDAC registration number (mandatory) | Upload cert; verify number against NAFDAC public registry before first sale |
| **Food (unpackaged/local herbs)** | Exempt from NAFDAC; food handler cert in some states | Self-declaration + optional CAC |
| **Cosmetics/beauty (manufactured)** | NAFDAC registration (mandatory) | Upload cert; verify against NAFDAC registry before first sale |
| **Electronics (imported)** | SON certification | Self-declaration |
| **Fashion/textiles** | None | None |
| **Art/custom goods** | None | None |
| **Services** | None | None |

#### Enforcement Pipeline

1. **Onboarding:** Category selection with prohibited list prominently displayed; restricted categories blocked
2. **Verification gate:** Food/cosmetics sellers MUST upload NAFDAC cert and pass registry verification before first sale (not self-declaration)
3. **Pre-publication screening:** AI-assisted prohibited content detection on product listings before posting
4. **Monitoring:** Random quarterly audits for food/cosmetics sellers
5. **Community reporting:** Users can flag sellers in restricted categories; 24h takedown SLA
6. **Enforcement:** Warning → 72h remediation → temporary suspension → permanent ban

### Security & Privacy

| Requirement | Specification |
|------------|---------------|
| **Multi-tenant isolation** | Zero cross-tenant data leakage (brand voice, analytics, customer data, content); mandatory penetration testing before launch |
| **Encryption** | AES-256 at rest; TLS 1.3 in transit; brand voice data encrypted separately as sensitive PII |
| **Session management** | Device-aware sessions; concurrent session limits; forced logout on suspicious activity |
| **Shared device considerations** | Auto-logout after 15 min inactivity; no "remember me" on shared devices |
| **Consent infrastructure** | Timestamped, purpose-specific, immutable consent records (actual logging system, not just policy text) |
| **API key security** | Hashed storage; rotation policy; rate limiting per key; PII fields never returned by default in API responses (Growth phase) |
| **Audit trail** | MVP: immutable core compliance/admin events. Growth+: expanded immutable log of data access, modifications, and deletions with full retention tiers |
| **Content moderation** | Pre-publication prohibited content screening; community reporting; 24h takedown SLA |
| **Brand voice backup** | Nightly automated backups; version history (seller can revert to previous calibration); integrity checksums; 4-hour recovery SLA |

### Platform API Dependency Risks

| Risk | Mitigation |
|------|------------|
| **Meta API rate limits** | Usage monitoring at ≤ 60% of limits; request queuing; graceful degradation |
| **Meta policy changes / API revocation** | Pipeline supports multiple providers; ≤ 60% revenue from single platform; "Manual mode" fallback — content generated but seller posts manually if API is revoked |
| **Meta mass-account restriction** | Content pattern diversification scoring across tenants; posting time randomization per tenant; mandatory content variation scoring to prevent similar patterns |
| **WhatsApp Business API pricing** | Per-conversation billing tracked per tenant; cost passed through or absorbed per tier |
| **WhatsApp broadcast rate limits** | Fair queuing: round-robin per tenant (not FIFO); priority tiers: live DMs > scheduled broadcasts > bulk campaigns; real-time queue position visibility |
| **WhatsApp template approval** | Pre-approved template library; custom template submission with 24-48h buffer |
| **API deprecation** | Version monitoring; 60-day migration window; automated upgrade testing |
| **Payment provider downtime** | Dual-provider architecture (Growth+); auto-failover target ≤ 30 seconds once enabled; dead payment link detection in auto-replies |

> **Elicitation Insight:** Four adversarial methods identified 20 new/sharpened requirements. The most significant architectural change was introducing an escrow model (buyer confirms delivery before seller receives funds), which provides buyer protection while maintaining the subaccount model where MarketBoss never directly holds funds. Dual payment provider support (Paystack + Flutterwave) is validated as critical for reliability and is planned for Growth, with MVP architecture prepared for the switch.
