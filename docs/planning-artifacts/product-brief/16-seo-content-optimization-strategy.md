# 16. SEO Content Optimization Strategy

> [!NOTE]
> All AI-generated content must be optimized for search and discovery on each platform. SEO is not an afterthought — it's built into the content generation pipeline.

### 16.1 Content SEO Pipeline

```text
AI Content Generation Request
    │
    ├─→ Step 1: Keyword Research (per-tenant, per-industry)
    │   └── Trending keywords, competitor analysis, search volume
    │
    ├─→ Step 2: Content Generation (AI Router §4.3)
    │   └── Include primary keyword in first 125 chars (Instagram preview cutoff)
    │   └── Natural keyword density (2-3% for target terms)
    │   └── Call-to-action in every caption
    │
    ├─→ Step 3: SEO Metadata Injection
    │   └── Alt text for all images (accessibility + SEO)
    │   └── Hashtag optimization (platform-specific)
    │   └── Description/caption optimization
    │
    └─→ Step 4: Quality Validation
        └── Check keyword presence, hashtag count, caption length
        └── Reject if SEO score < threshold
```

### 16.2 Platform-Specific SEO Rules

| Platform | SEO Element | Strategy |
| ---------- | ------------ | ---------- |
| **Instagram** | Alt text | Auto-generated from image analysis; include business keywords |
| **Instagram** | Hashtags | 3-5 targeted (NOT 30). Mix: 2 high-volume + 2 medium + 1 niche. Banned hashtag detection to prevent shadow-banning |
| **Instagram** | Captions | Primary keyword in first 125 chars. Engagement hook in first line |
| **Instagram** | Reels SEO | Keywords in audio description, on-screen text, and caption |
| **TikTok** | Description | Front-load keywords. Use 3-5 hashtags including trending challenges |
| **TikTok** | Closed Captions | Auto-generate for search indexing (TikTok indexes caption text) |
| **TikTok** | Sounds | Recommend trending sounds aligned with content theme |
| **Facebook** | Open Graph | `og:title`, `og:description`, `og:image` optimized for link previews |
| **Facebook** | Video | Captions/subtitles for autoplay-muted environment |
| **WhatsApp** | Link Previews | Optimized `og:title` + `og:image` for shared links |

### 16.3 Hashtag Intelligence Engine

```go
type HashtagEngine struct {
    db        *pgxpool.Pool
    analytics *AnalyticsService
}

type HashtagRecommendation struct {
    Tag         string
    Volume      int       // Monthly search/usage volume
    Competition float64   // 0.0 (low) to 1.0 (high)
    Category    string    // "high_volume", "medium", "niche"
    IsBanned    bool      // Instagram shadow-ban list
    Performance float64   // Historical engagement rate for this tenant
}

func (h *HashtagEngine) Recommend(ctx context.Context, tenantID string, industry string, count int) ([]HashtagRecommendation, error) {
    // 1. Get industry-relevant hashtags
    candidates := h.getIndustryHashtags(ctx, industry)

    // 2. Filter out banned/shadow-banned hashtags
    candidates = h.filterBanned(candidates)

    // 3. Score by tenant's historical performance
    scored := h.scoreByPerformance(ctx, tenantID, candidates)

    // 4. Mix strategy: 40% high-volume + 40% medium + 20% niche
    return h.mixStrategy(scored, count), nil
}
```

### 16.4 Web Dashboard SEO (Next.js)

| Element | Implementation |
| --------- | --------------- |
| Server-Side Rendering | All public pages use Next.js SSR for search engine crawlability |
| Meta Tags | Dynamic `<title>` and `<meta name="description">` per page via Next.js Metadata API (`metadata` / `generateMetadata`) |
| Structured Data | JSON-LD for business profiles (`@type: LocalBusiness`) |
| Sitemap | Auto-generated `sitemap.xml` for public SMB profiles/storefronts |
| Core Web Vitals | LCP <2.5s, INP <200ms, CLS <0.1 — monitored via SigNoz |
| Image Optimization | Next.js `<Image>` component with WebP, lazy loading, `alt` text |
| URL Structure | Clean, descriptive slugs: `/store/amakas-fashion/products` |

_Core Web Vitals thresholds align with web.dev guidance (LCP, INP, CLS) as of February 14, 2026._

### 16.5 SEO Measurement & Analytics Tools

> [!IMPORTANT]
> You can't optimize what you don't measure. These tools provide the data pipeline for validating that AI-generated content is actually performing in search and discovery.

#### Primary SEO Measurement Stack

| Tool | Purpose | What We Measure | Integration |
| ------ | --------- | ----------------- | ------------- |
| **Google Search Console** | Web dashboard SEO performance | Impressions, clicks, CTR, average position, indexing status, Core Web Vitals | Free — API integration via `googleapis/google-api-go-client` |
| **Google Analytics 4** (GA4) | Traffic attribution & user behavior | Social referral traffic, bounce rate, session duration, conversion paths | Free — GA4 Measurement Protocol for server-side events |
| **Semrush** | Keyword tracking & competitor analysis | Keyword rankings, search volume, content gaps, competitor visibility, AI search brand mentions | API — `semrush.com/api/` (paid, $129+/mo) |
| **Ahrefs** | Backlink monitoring & content performance | Domain rating, referring domains, top-performing content, keyword opportunities | API — `ahrefs.com/api` (paid, $129+/mo) |
| **BuzzSumo** | Content performance analysis | Most shared content, trending topics, engagement metrics, competitor content performance | API — `api.buzzsumo.com/` (paid, $199+/mo) |
| **Keyhole** | Real-time social media tracking | Brand mentions, hashtag performance, influencer impact, competitor activity (TikTok, IG, FB, X) | API (paid, $89+/mo) |

#### Platform-Native Analytics (Free / Built-in)

| Platform | Analytics Source | Key Metrics |
| ---------- | ----------------- | ------------- |
| **Instagram** | Instagram Insights API (via Meta Graph API) | Reach, impressions, engagement rate, follower growth, content interactions, story views |
| **TikTok** | TikTok Analytics API | Video views, watch time, completion rate, shares, follower growth, traffic source |
| **Facebook** | Meta Graph API / Page Insights | Post reach, engagement, page views, CTA clicks, audience demographics |
| **WhatsApp** | WhatsApp Business API metrics | Message delivery rate, read rate, response rate |

#### SEO KPI Dashboard (Built into MarketBoss Admin)

| KPI | Target | How We Measure | Frequency |
| ----- | -------- | ---------------- | ----------- |
| **Content Reach Growth** | +15% MoM | Platform Insights API (reach/impressions) | Weekly |
| **Engagement Rate** | > 3% average | (likes + comments + shares + saves) ÷ reach | Per post |
| **Hashtag Discovery Rate** | > 20% reach from hashtags | Platform Insights → impression sources | Weekly |
| **Web Dashboard Organic Traffic** | +25% QoQ | Google Search Console + GA4 | Monthly |
| **Core Web Vitals** | All "Good" | Google Search Console → CWV report | Weekly |
| **Keyword Rankings** | Top 20 for 10+ target terms | Semrush / Ahrefs rank tracking | Monthly |
| **Click-Through Rate (CTR)** | > 3% on search results | Google Search Console | Monthly |
| **Content Freshness Score** | > 80% posts optimized | Internal AI validator (§14.5) | Per post |
| **Social → Web Conversion** | > 2% referral conversion | GA4 → social referral → goal completion | Monthly |

#### Cost-Effective Approach for MVP Phase

> [!TIP]
> Start with **free tools** (Google Search Console, GA4, platform-native analytics) during MVP. Add paid tools (Semrush or Ahrefs, not both) in Growth Phase when ROI justifies the cost.

| Phase | Tools | Monthly Cost |
| ------- | ------- | ------------- |
| **MVP (Months 1-3)** | Google Search Console + GA4 + Platform Analytics | $0 |
| **Growth (Months 4-6)** | Add Semrush OR Ahrefs + Keyhole | ~$200-250/mo |
| **Scale (Months 7-12)** | Full stack: Semrush + Ahrefs + BuzzSumo + Keyhole | ~$500-600/mo |

---
