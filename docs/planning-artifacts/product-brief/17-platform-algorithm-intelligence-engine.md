# 17. Platform Algorithm Intelligence Engine

> [!TIP]
> This is MarketBoss's competitive moat. No Nigerian competitor offers AI-powered algorithm-aware posting optimization. We analyze WHAT works, WHEN it works, and WHY — then auto-optimize.

### 17.1 Architecture

```text
┌─────────────────────────────────────────────────────────────────┐
│                  Algorithm Intelligence Engine                    │
├──────────────────┬──────────────────┬───────────────────────────┤
│   Data Layer     │  Analysis Layer  │  Recommendation Layer     │
├──────────────────┼──────────────────┼───────────────────────────┤
│ Platform API     │ Statistical      │ Optimal Posting Time      │
│ Engagement Data  │ Analysis         │ Calculator                │
│ (likes, shares,  │ (correlation,    │                           │
│  saves, reach,   │  regression)     │ Content Type              │
│  impressions)    │                  │ Recommender               │
│                  │ Pattern          │ ("Reels outperform        │
│ Webhook Event    │ Recognition      │  images by 2.3x")         │
│ Collection       │ (time-of-day,    │                           │
│                  │  day-of-week,    │ Hashtag Effectiveness     │
│ Historical       │  content type)   │ Tracker                   │
│ Performance      │                  │                           │
│ Archive          │ Trend Detection  │ Caption Length &           │
│                  │ (viral patterns, │ Format Optimizer           │
│ Competitor       │  seasonal)       │                           │
│ Benchmarks       │                  │ A/B Test Engine           │
│ (optional)       │ ML Models        │ (auto-variant generation) │
│                  │ (Phase 3+)       │                           │
└──────────────────┴──────────────────┴───────────────────────────┘
```

### 17.2 Per-Platform Algorithm Signal Mapping (2026)

| Signal | Instagram | TikTok | Facebook |
| -------- | ----------- | -------- | ---------- |
| **Primary Ranking Factor** | Interest score (predicted engagement) | Watch-through rate (% watched) | Meaningful interactions (comments, shares) |
| **Content Priority** | Reels > Carousels > Single Image > Text | Short-form video only | Video > Photo > Link posts |
| **Optimal Content Length** | Reels: 7-15s; Carousels: 5-7 slides | 15-60s (sweet spot: 21-34s) | Video: 1-3 min; Posts: 100-250 chars |
| **Best Posting Times (Nigeria)** | 8-9am, 12pm, 5-7pm WAT | 7-9am, 12-3pm, 7-11pm WAT | 1-3pm weekdays WAT |
| **Critical Engagement Window** | First 30 minutes | First 1 hour | First 2 hours |
| **Key Engagement Metric** | Saves + Shares (weighted 3x likes) | Shares + Replays (completion rate) | Comments + Shares |
| **Hashtag Strategy** | 3-5 targeted (quality > quantity) | 3-5 trending + niche mix | 1-2 or none (less important) |
| **AI Content Disclosure** | Recommended (label coming 2026) | **MANDATORY** (enforced) | Recommended |
| **Algorithm Penalty Signals** | Watermarks, recycled Reels, engagement bait | Low completion rate, spam behavior | Engagement bait, clickbait headlines |
| **Boost Signals** | Original audio, Collab posts, Trending audio | Trending sounds, duets, stitches | Live video, Groups content, events |

### 17.3 Engagement Data Collection

```go
type EngagementCollector struct {
    db       *pgxpool.Pool
    meta     *MetaAPIClient
    tiktok   *TikTokAPIClient
}

type PostEngagement struct {
    PostID          string
    TenantID        string
    Platform        string
    ContentType     string    // "reel", "carousel", "image", "video", "story"
    PostedAt        time.Time
    PostedHourLocal int       // 0-23 in tenant's timezone
    PostedDayOfWeek int       // 0=Sunday

    // Platform engagement metrics
    Likes           int
    Comments        int
    Shares          int
    Saves           int       // Instagram only
    Reach           int
    Impressions     int
    VideoViews      int       // For video/reel content
    CompletionRate  float64   // TikTok: % of video watched

    // Content attributes (for pattern analysis)
    CaptionLength   int
    HashtagCount    int
    HasCTA          bool
    HasAudio        bool      // Trending audio?
    AIGenerated     bool

    // Calculated
    EngagementRate  float64   // (likes+comments+shares+saves) / reach * 100
}

// Collect engagement data periodically (every 4 hours for 48 hours after posting)
func (ec *EngagementCollector) CollectMetrics(ctx context.Context, postID, platform string) error {
    var engagement *PostEngagement
    var err error

    switch platform {
    case "instagram":
        engagement, err = ec.meta.GetPostInsights(ctx, postID)
    case "tiktok":
        engagement, err = ec.tiktok.GetVideoAnalytics(ctx, postID)
    case "facebook":
        engagement, err = ec.meta.GetFBPostInsights(ctx, postID)
    }

    if err != nil {
        return fmt.Errorf("collecting metrics for %s:%s: %w", platform, postID, err)
    }

    // Calculate engagement rate
    if engagement.Reach > 0 {
        engagement.EngagementRate = float64(
            engagement.Likes+engagement.Comments+engagement.Shares+engagement.Saves,
        ) / float64(engagement.Reach) * 100
    }

    return ec.db.Insert(ctx, "post_engagements", engagement)
}
```

### 17.4 Posting Time Optimizer

```go
type PostingTimeOptimizer struct {
    db *pgxpool.Pool
}

type TimeSlotPerformance struct {
    HourLocal      int
    DayOfWeek      int
    AvgEngagement  float64
    PostCount      int
    ConfidenceScore float64 // Higher with more data points
}

func (pto *PostingTimeOptimizer) GetOptimalTimes(ctx context.Context, tenantID, platform string) ([]TimeSlotPerformance, error) {
    // Query last 90 days of tenant's posting data
    query := `
        SELECT 
            posted_hour_local,
            posted_day_of_week,
            AVG(engagement_rate) as avg_engagement,
            COUNT(*) as post_count
        FROM post_engagements 
        WHERE tenant_id = $1 AND platform = $2 
          AND posted_at > NOW() - INTERVAL '90 days'
        GROUP BY posted_hour_local, posted_day_of_week
        HAVING COUNT(*) >= 3  -- Minimum 3 data points for confidence
        ORDER BY avg_engagement DESC
        LIMIT 10
    `

    rows, err := pto.db.Query(ctx, query, tenantID, platform)
    if err != nil {
        return nil, err
    }
    defer rows.Close()

    var slots []TimeSlotPerformance
    for rows.Next() {
        var slot TimeSlotPerformance
        rows.Scan(&slot.HourLocal, &slot.DayOfWeek, &slot.AvgEngagement, &slot.PostCount)
        slot.ConfidenceScore = math.Min(1.0, float64(slot.PostCount)/20.0) // Max confidence at 20+ posts
        slots = append(slots, slot)
    }

    // If insufficient tenant data, fall back to platform defaults
    if len(slots) < 3 {
        return pto.getPlatformDefaults(platform), nil
    }

    return slots, nil
}
```

### 17.5 A/B Testing Framework

```go
type ABTestEngine struct {
    db        *pgxpool.Pool
    aiRouter  *AIRouter
    scheduler *Scheduler
}

type ABTest struct {
    ID          string
    TenantID    string
    Platform    string
    TestType    string    // "caption", "posting_time", "hashtags", "content_type"
    VariantA    string    // Control
    VariantB    string    // Treatment
    Status      string    // "running", "completed", "significant"
    StartedAt   time.Time
    Duration    time.Duration // Typically 48 hours
}

func (ab *ABTestEngine) CreateCaptionTest(ctx context.Context, tenantID, originalCaption string) (*ABTest, error) {
    // AI generates a variant caption optimized for different engagement signals
    variant, err := ab.aiRouter.Generate(ctx, AIRequest{
        TaskType: "caption_variant",
        Prompt:   fmt.Sprintf(
            "Create an alternative caption optimized for engagement. Original: %q. "+
            "Requirements: different hook, same product info, include CTA, front-load keywords.",
            originalCaption,
        ),
        TenantID: tenantID,
    })
    if err != nil {
        return nil, err
    }

    test := &ABTest{
        ID:       uuid.New().String(),
        TenantID: tenantID,
        TestType: "caption",
        VariantA: originalCaption,
        VariantB: variant.Text,
        Status:   "running",
        Duration: 48 * time.Hour,
    }

    // Schedule: Post variant A now, variant B at next optimal time slot
    ab.scheduler.SchedulePost(ctx, tenantID, test.VariantA, time.Now())
    nextSlot := ab.getNextOptimalSlot(ctx, tenantID)
    ab.scheduler.SchedulePost(ctx, tenantID, test.VariantB, nextSlot)

    return test, ab.db.Insert(ctx, "ab_tests", test)
}

func (ab *ABTestEngine) EvaluateTest(ctx context.Context, testID string) (*ABTestResult, error) {
    test, _ := ab.db.GetABTest(ctx, testID)

    engA := ab.getEngagement(ctx, test.VariantA)
    engB := ab.getEngagement(ctx, test.VariantB)

    // Chi-squared test for statistical significance (p < 0.05)
    isSignificant := ab.chiSquaredTest(engA, engB, 0.05)

    winner := "A"
    if engB.EngagementRate > engA.EngagementRate && isSignificant {
        winner = "B"
    }

    return &ABTestResult{
        TestID:        testID,
        Winner:        winner,
        EngagementA:   engA.EngagementRate,
        EngagementB:   engB.EngagementRate,
        Improvement:   ((engB.EngagementRate - engA.EngagementRate) / engA.EngagementRate) * 100,
        IsSignificant: isSignificant,
    }, nil
}
```

### 17.6 Implementation Phases

| Phase | Feature | When | Effort |
| ------- | --------- | ------ | -------- |
| **Phase 1 (MVP)** | Basic analytics: engagement rates, simple posting time suggestions based on platform defaults | Months 1-3 | Low |
| **Phase 2 (Trust + Scale Engine)** | Data collection pipeline. Per-tenant posting time optimization from historical data. Content type performance comparisons | Months 4-6 | Medium |
| **Phase 3 (Market Expansion Engine)** | Hashtag effectiveness tracking. A/B testing framework. ML-powered content recommendations. SEO score per post | Months 7-12 | High |
| **Phase 4 (Market Leadership)** | Predictive trend detection. Competitor benchmarking. Automated strategy adjustment. Cross-platform optimization | Year 2+ | High |

### 17.7 Dashboard UI — Algorithm Insights

The tenant dashboard will display:

- **Engagement Heat Map:** 7×24 grid showing best posting times
- **Content Type Leaderboard:** Reels vs Carousel vs Image performance
- **Hashtag Performance:** Top/bottom performing hashtags with recommendations
- **A/B Test Results:** History of tests with winning variants highlighted
- **Algorithm Health Score:** Composite score (0-100) indicating how well the tenant's content aligns with platform algorithm preferences
- **Trend Alerts:** Notifications when new trending sounds/hashtags match the tenant's industry

---
