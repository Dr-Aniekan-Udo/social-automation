# 8. Pricing Strategy

> [!IMPORTANT]
> **Phased pricing rollout (normalized with roadmap):**
>
> - **Phase 1 Beta (Months 1–3):** flat **₦10,000/month** for first 100 beta users, after a **7-day free trial**.
> - **Public Launch:** **Starter (Free)** + **Professional (₦5,000/mo)** with server-side feature gating.
> - **Growth/Scale:** add **Business (₦15,000/mo)** and **Enterprise (Custom)**.

### 8.1 Subscription Tiers

| Tier | Price/Month | Key Features | Rollout |
| ------ | ------------- | -------------- | --------- |
| **Starter** | **Free** | 2 daily posts, 20 seller-initiated messages/day, 20 products, 1 IG account, basic analytics | Public launch |
| **Professional** | **₦5,000** | 8 daily posts, 100 seller-initiated messages/day, 100 products, 3 IG accounts, 1 team member, full analytics (30-day) | Public launch |
| **Business** | **₦15,000** | 20 daily posts, 500 seller-initiated messages/day, 500 products, 10 IG accounts, 3 team members, attribution analytics | Growth |
| **Enterprise** | **Custom** | Dedicated infrastructure options, advanced RBAC, custom limits, custom support/SLA, Open API access (Scale) | Scale |

### 8.2 Feature Matrix

| Feature | Starter (Free) | Professional | Business | Enterprise |
| --------- | ---------------- | -------------- | ---------- | ------------ |
| Daily posts | 2 | 8 | 20 | Unlimited (platform limit) |
| Daily messages (seller-initiated) | 20 | 100 | 500 | Unlimited (platform limit) |
| Products | 20 | 100 | 500 | Unlimited |
| IG accounts | 1 | 3 | 10 | Unlimited |
| Brand voice profiles | 1 | 3 | 10 | Unlimited |
| Team members | 0 | 1 | 3 | Admin-configured |
| Analytics | Basic (7-day) | Full (30-day) | Full + attribution | Full + custom reports |
| Escrow | Growth+ | Growth+ | Growth+ | Growth+ |
| Storage | 500MB | 2GB | 10GB | Custom |
| API access | No | No | Partner API beta (invite-only, Growth) | Open API (Scale) |

### 8.3 Unit Economics (Per Paid User/Month — Professional Baseline)

| Cost Component | Low | High |
| ---------------- | ----- | ------ |
| Infrastructure (hosting, DB, storage) | ₦750 | ₦1,250 |
| AI API tokens (blended, includes burst + vision events) | ₦320 | ₦1,280 |
| WhatsApp API (50 messages) | ₦128 | ₦640 |
| Monitoring & Tools | ₦32 | ₦64 |
| **Total COGS** | **₦1,230** | **₦3,234** |

**Gross Margin:** 75–85% depending on usage

### 8.4 Revenue Milestones (PRD-Aligned Targets)

| Milestone | Users | MRR Target | Source |
| ---------- | ------- | ------------ | -------- |
| Month 6 | 550 | ₦2,750,000 | PRD Business Success |
| Month 12 | 1,150 | ₦10,100,000 | PRD Business Success |

### 8.5 Cost Structure (PRD-Aligned Cost Buckets)

| Category | Notes |
| ---------- | ------- |
| **Variable:** Infrastructure | Hosting, DB, storage, CDN scale with active tenant load |
| **Variable:** AI APIs | Controlled by model routing, caching, and prompt discipline |
| **Variable:** Messaging APIs | WhatsApp and notification traffic volume dependent |
| **Variable:** Payment Rails | Commission + gateway economics are transaction/GMV dependent |
| **Variable:** Monitoring/Tools | Scales with observability depth and retention windows |
| **Fixed:** Team | Engineering, product, support, operations |
| **Fixed:** Overhead | Admin, legal/compliance, tooling, workspace |
| **Fixed:** Marketing | Acquisition and lifecycle campaigns |

> Use PRD milestone targets (Month 6 and Month 12) as the primary financial checkpoints. Recompute this section per quarter using actual paid-tier mix and transaction volume.

### 8.6 Customer Acquisition & LTV

| Metric | Value |
| -------- | ------- |
| CAC (blended) | ₦5,000–7,000 per customer |
| Average paid subscription (planning baseline) | ₦8,000–12,000/month (blended) |
| Churn risk band (early stage assumption) | 8–12% monthly |
| PRD success target (steady state) | ≤5% monthly churn (≤8% crisis ceiling) |
| Average lifetime (planning range) | 8–12 months |
| **LTV (planning range)** | **Recompute quarterly using actual churn + ARPU** |
| **LTV:CAC Ratio** | **17:1** (benchmark: 3:1) |

### 8.7 Funding Requirements

| Phase | Amount | Breakdown |
| ------- | -------- | ----------- |
| **MVP (Months 1–3)** | ₦7,500,000 ($4,800) | Salaries ₦6M, Infrastructure ₦300K, Tools ₦200K, Legal ₦500K, Contingency ₦500K |
| **Growth (Months 4–12)** | ₦18,000,000 ($11,520) | Salaries (expanded) ₦12M, Marketing ₦3M, Infrastructure ₦1.5M, Operations ₦1.5M |
| **Total** | **₦25,500,000 (~$16,320)** | |

---
