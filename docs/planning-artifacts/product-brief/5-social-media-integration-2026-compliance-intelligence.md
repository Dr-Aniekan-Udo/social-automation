# 5. Social Media Integration — 2026 Compliance Intelligence

> [!CAUTION]
> The era of "permissionless innovation" on social platforms has ended. In 2026, **compliance complexity** has replaced technical complexity as the primary barrier. Platforms actively impose friction via Business-Scoped IDs, Portfolio Pacing, and Content Posting Audits.

### 5.1 WhatsApp Business API (2026 Updated)

| Aspect | Details |
| -------- | --------- |
| **Pricing Model** | Per-message (not per-conversation). Marketing ~$0.02/msg (Nigeria), Utility ~$0.004–0.046, Service: **FREE** (24hr window) |
| **BSP Required** | Yes — Twilio, Vonage, EngageLab ($50–200/month base) |
| **24-Hour Window** | Free-form replies only within 24hrs of user message; outside requires approved Templates |
| **BSUID Rollout** | Webhooks include BSUID starting March 31, 2026. Full migration by June 2026. |
| **Portfolio Pacing** | Marketing campaigns are batched. 500 sent initially → feedback check → remainder delivered or paused |
| **Free Allowance** | First 1,000 service messages/month free |

##### Session Timer Implementation (Critical for Cost Control)

```go
type WhatsAppSession struct {
    UserID       string
    LastMessage  time.Time
    WindowExpiry time.Time // LastMessage + 24 hours
}

func (s *WhatsAppService) SendMessage(ctx context.Context, msg Message) error {
    session := s.getSession(msg.UserID)

    if time.Now().Before(session.WindowExpiry) {
        // Within free window - send free-form message
        return s.sendFreeFormMessage(ctx, msg)
    }

    // Outside window - BLOCK free-form and force template selection
    // This prevents accidental charges for SMBs
    template := s.getApprovedTemplate(msg.Category)
    if template == nil {
        return errors.New("outside 24hr window: must use approved template message")
    }
    return s.sendTemplateMessage(ctx, msg, template)
}

// Redis-backed session tracking with 24hr TTL
func (s *WhatsAppService) UpdateSession(ctx context.Context, userID string) {
    key := fmt.Sprintf("wa:session:%s", userID)
    s.redis.SetEX(ctx, key, time.Now().String(), 24*time.Hour)
}
```

##### Portfolio Pacing UI Strategy

The UI must NOT show a simple "Sent" checkmark. Instead, implement a "Progress Ring" driven by real-time webhook updates:

```text
"Meta is pacing your campaign to ensure high delivery rates.
 ████████░░ 500 sent, 4,500 pending quality check."
```

This manages expectations and shifts "blame" for delays from MarketBoss to Meta's policy.

**Cost Estimate:** $1.00–2.00/user/month (50 messages avg)

### 5.2 Facebook & Instagram (Graph API — 2026 Updated)

| Aspect | Details |
| -------- | --------- |
| **API Cost** | **FREE** — no per-request fees |
| **Rate Limits** | 200 requests/hour/account |
| **DM Limits** | 200 automated DMs/hour per account |
| **Post Limits** | 25 posts per 24 hours via API (100 total per account) |
| **24-Hour DM Window** | Same as WhatsApp — free-form only within 24hrs |
| **Auto DM Limit** | Only 1 automated message per user per 24-hour period |
| **Auth** | OAuth 2.0. Long-lived tokens expire after 60 days — refresh every 50 days |
| **Basic Display API** | **DEAD** (deprecated Dec 2024). Must use Graph API. |
| **Account Requirement** | **Business/Creator Account linked to Facebook Page** (mandatory) |

> [!NOTE]
> As of July 2024, Instagram Professional accounts using "Instagram API with Instagram Login" **no longer need a linked Facebook Page** for messaging. However, content publishing still requires it.

##### Onboarding Readiness Check (Critical for Reducing Churn)

```go
// Before OAuth, run a "Readiness Check" wizard to prevent failed onboarding
type InstagramReadinessCheck struct {
    steps []ReadinessStep
}

type ReadinessStep struct {
    Name        string
    Description string
    VideoURL    string // In-app tutorial hosted on our CDN
    Required    bool
}

func (rc *InstagramReadinessCheck) GetSteps() []ReadinessStep {
    return []ReadinessStep{
        {
            Name:        "Business Account",
            Description: "Is your account a Business or Creator Account?",
            VideoURL:    "/tutorials/convert-to-business.mp4",
            Required:    true,
        },
        {
            Name:        "Facebook Page",
            Description: "Do you have a Facebook Page linked to your Instagram?",
            VideoURL:    "/tutorials/link-facebook-page.mp4",
            Required:    true,
        },
        {
            Name:        "Two-Factor Auth",
            Description: "Is two-factor authentication enabled?",
            VideoURL:    "/tutorials/enable-2fa.mp4",
            Required:    false,
        },
    }
}
```

##### OAuth 2.0 Flow

```go
type MetaOAuthService struct {
    clientID     string
    clientSecret string
    redirectURI  string
}

func (s *MetaOAuthService) GetAuthURL(tenantID string) string {
    state := generateSecureState(tenantID)
    scope := "instagram_basic,instagram_content_publish,instagram_manage_messages,pages_read_engagement,pages_manage_metadata"

    return fmt.Sprintf(
        "https://www.facebook.com/v21.0/dialog/oauth?client_id=%s&redirect_uri=%s&state=%s&scope=%s",
        s.clientID, s.redirectURI, state, scope,
    )
}

// Long-lived token refresh (expires after 60 days — refresh every 50)
func (s *MetaOAuthService) ScheduleTokenRefresh(ctx context.Context, tenantID string) {
    // Schedule automatic refresh every 50 days via Redis-backed job queue
    s.scheduler.Schedule("token_refresh", tenantID, 50*24*time.Hour)
}
```

##### Rate Limiter (Leaky Bucket — prevents account suspension)

```go
type RateLimiter struct {
    redis  *redis.Client
    limits map[string]RateLimit
}

type RateLimit struct {
    Platform      string
    MaxRequests   int
    WindowSeconds int
}

func (rl *RateLimiter) CheckLimit(ctx context.Context, platform, accountID string) error {
    key := fmt.Sprintf("ratelimit:%s:%s", platform, accountID)
    limit := rl.limits[platform]

    count, err := rl.redis.Incr(ctx, key).Result()
    if err != nil {
        return err
    }
    if count == 1 {
        rl.redis.Expire(ctx, key, time.Duration(limit.WindowSeconds)*time.Second)
    }
    if count > int64(limit.MaxRequests) {
        // Don't fail — queue for later (Leaky Bucket pattern)
        rl.queueForLater(ctx, platform, accountID)
        return fmt.Errorf("rate limit reached: %s (queued for retry)", platform)
    }
    return nil
}
```

### 5.3 X (Twitter) API

| Tier | Cost | Read | Write | Viability |
| ------ | ------ | ------ | ------- | ----------- |
| Free | $0 | 1,500/mo | 500/mo (write-only) | ❌ Unusable |
| Basic | $200/mo | 15,000/mo | 50,000/mo | ⚠️ Limited |
| Pro | $5,000/mo | 1M/mo | 300K/mo | ❌ Too expensive for MVP |

> [!WARNING]
> **Recommendation: Do NOT integrate X initially.** The cost gap between Basic ($200/mo) and Pro ($5,000/mo) is prohibitive. X also grants itself a royalty-free license to all content for Grok AI training. Focus on Meta platforms first; add X in Phase 3+ if warranted.

### 5.4 TikTok API — The "Audit Wall"

| Aspect | Details |
| -------- | --------- |
| **Access** | Application + approval required (not publicly available) |
| **Rate Limits** | 6 videos/minute, 15 videos/day per account |
| **Unaudited Apps** | `SELF_ONLY` viewership, max 5 users in 24hr window |
| **Audit Requirement** | Submit UX Mockups (PDFs) + Screen Recordings of app in action |
| **AI Content** | Must label ALL AI-generated content. Mandatory `commercial_content_compliance` flag |
| **Watermarks** | No brand logos/watermarks allowed on shared content |
| **Video Quality** | 1080p vertical (9:16) required for ads; penalties for lower quality |

> [!CAUTION]
> **The Audit "Catch-22":** You cannot build the full public feature until you pass the audit, but you need to show the feature to pass. Solution: develop in Sandbox Mode (private viewership), create audit artifacts in Figma, submit with conservative daily usage estimate.

##### TikTok Content Posting with Mandatory Compliance Toggles

```go
type TikTokPost struct {
    VideoURL             string
    Caption              string
    CommercialContent    bool // MANDATORY - cannot be false if promoting a product
    AIGenerated          bool // FORCED TRUE if MarketBoss's AI was used
    DisableComments      bool
    DailyUsageEstimate   int  // Submitted to TikTok during audit
}

func (s *TikTokService) PublishPost(ctx context.Context, post TikTokPost) error {
    // SAFETY BY DESIGN: Force AI label if our AI generated any part of the content
    if post.wasGeneratedByAI {
        post.AIGenerated = true // User cannot override this
    }

    // Validate commercial content flag
    if post.hasProductMention() && !post.CommercialContent {
        return errors.New("commercial_content must be true for product promotions")
    }

    // Check daily posting limit (15 videos/day)
    if s.getDailyPostCount(ctx) >= 15 {
        return errors.New("TikTok daily posting limit reached (15 videos/day)")
    }

    return s.client.DirectPost(ctx, post)
}
```

### 5.5 Advertising Cost Benchmarks (Nigeria)

| Platform | CPC | CPM | Min Budget |
| ---------- | ----- | ----- | ------------ |
| **Facebook** | ₦30–150 | ₦450–2,500 | ₦5,000–15,000/day |
| **Instagram** | ₦50–200 | ₦800–2,500 | Similar to FB |
| **TikTok (global)** | $0.17–1.00 | $4.20–9.00 | $500 campaign, $20–50/day |
| **X (Twitter)** | $0.18 avg | ~$2.09 | Varies |

---
