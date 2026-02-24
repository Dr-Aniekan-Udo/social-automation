# 7. Legal & Compliance

### 7.1 Nigeria Data Protection Act (NDPA) 2023 + GAID

> [!CAUTION]
> The NDPA 2023 is now enforced via the **General Application and Implementation Directive (GAID)**, effective September 19, 2025. Non-compliance can result in fines up to **₦10 million or 2% of annual gross revenue** (whichever is higher) for DCMIs.

| Requirement | Action | Status |
| ------------- | -------- | -------- |
| **NDPC Registration** | Register as DCMI within 6 months | **Mandatory** |
| **DPO Appointment** | Hire/designate qualified DPO (₦300K–500K/yr) | **Mandatory** |
| **Annual Audit** | Submit audit returns to NDPC by March 15 each year | **Mandatory** |
| **DPIA** | Conduct for all high-risk processing (AI, PII) | **Mandatory** |
| **Cross-Border Transfers** | SCCs for US-hosted AI APIs | **Critical** |
| **Privacy-Preserving Proxy** | Strip PII before sending to AI models | **Architecture** |
| **Consent Engineering** | Explicit opt-in, no pre-ticked boxes | **UX Requirement** |
| **Breach Notification** | Report within 72 hours | **Process** |

### 7.2 Privacy-Preserving Proxy (NDPA Cross-Border Compliance)

```go
type PrivacyProxy struct {
    aiProvider  AIProvider
    piiDetector *PIIDetector  // Local NER model running in Nigeria
}

func (pp *PrivacyProxy) Generate(ctx context.Context, prompt string) (string, error) {
    // Step 1: Detect PII using local NER (never leaves Nigeria)
    tokens, pii := pp.piiDetector.ExtractPII(prompt)

    // Step 2: Replace PII with reversible tokens
    // e.g., "My BVN is 12345" → "My BVN is <BVN_1>"
    sanitized := pp.replacePII(prompt, pii)

    // Step 3: Send SANITIZED prompt to AI provider (US-hosted)
    response, err := pp.aiProvider.Complete(ctx, sanitized)
    if err != nil {
        return "", err
    }

    // Step 4: Rehydrate response with actual PII (stays in Nigeria)
    // "Hello <PERSON_1>" → "Hello Chioma"
    final := pp.restorePII(response, pii)

    return final, nil
}
```

### 7.3 Consent Management

```go
type ConsentManager struct {
    db *sql.DB
}

type Consent struct {
    UserID      string
    Purpose     string    // "marketing", "analytics", "ai_processing"
    Granted     bool
    GrantedAt   time.Time
    RevokedAt   *time.Time
    ConsentText string    // Exact text shown to user (NDPA requirement)
}

func (cm *ConsentManager) RequestConsent(ctx context.Context, userID, purpose, text string) error {
    return cm.db.ExecContext(ctx,
        "INSERT INTO consents (user_id, purpose, consent_text, granted, granted_at) VALUES ($1, $2, $3, TRUE, NOW())",
        userID, purpose, text,
    )
}

func (cm *ConsentManager) CheckConsent(ctx context.Context, userID, purpose string) (bool, error) {
    var granted bool
    err := cm.db.QueryRowContext(ctx,
        "SELECT granted FROM consents WHERE user_id=$1 AND purpose=$2 AND revoked_at IS NULL ORDER BY granted_at DESC LIMIT 1",
        userID, purpose,
    ).Scan(&granted)
    return granted, err
}
```

### 7.4 Data Subject Rights (DSAR Handler)

```go
type DSARHandler struct {
    db *sql.DB
}

// Right to Access — export all user data as JSON
func (h *DSARHandler) ExportUserData(ctx context.Context, userID string) ([]byte, error) {
    userData := h.collectUserData(userID) // Collects across all tables
    return json.Marshal(userData)
}

// Right to Erasure — pseudonymize (retain for legal/financial audit)
func (h *DSARHandler) DeleteUserData(ctx context.Context, userID string) error {
    return h.db.ExecContext(ctx,
        "UPDATE users SET name='[DELETED]', email='deleted_'+id, phone=NULL, deleted_at=NOW() WHERE id=$1",
        userID,
    )
}
```

### 7.5 Platform Compliance Matrix

| Platform | Key Rule | Implementation |
| ---------- | ---------- | ---------------- |
| **WhatsApp** | 24-hour window, Template Messages, BSUID migration | Session Timer + Identity Resolution service |
| **Instagram/FB** | Business Account required, 200 req/hr, 200 DM/hr | Readiness Check wizard + Leaky Bucket rate limiter |
| **TikTok** | AI disclosure, Commercial Content flag, Audit wall | Forced toggles + Safety-by-Design |
| **X** | Content used for Grok training | Disclose in Privacy Policy |

### 7.6 Business Registration

- **CAC** registration (Corporate Affairs Commission)
- **TIN** (Tax Identification Number)
- **VAT** registration upon reaching ₦25M annual turnover
- **PCI-DSS** compliance via certified gateways (no card data stored)
- Timeline: 4–6 weeks setup

### 7.7 KYC / Identity Verification

> [!IMPORTANT]
> **CBN-aligned KYC posture (aligned with PRD):** MarketBoss uses progressive tiered verification. Signup starts with low-friction onboarding, while payment and withdrawal limits are enforced by verification tier. Higher transaction limits require stronger KYC.

#### Regulatory Framework — MarketBoss Operational KYC Tiers (CBN-aligned)

| Tier | Requirements | Transaction Limits | MarketBoss Mapping |
| ------ | ------------- | ------------------- | --------------------- |
| **Unverified** | Email + phone | Sales cap: ≤ ₦50,000 total; withdrawal cap: max ₦10,000/day (20% of daily sales) | Explore + limited commerce |
| **Basic** | NIN or BVN | Sales cap: ≤ ₦1,000,000 total; withdrawal cap: ≤ ₦100,000/day | Standard payment-enabled usage |
| **Full** | NIN + BVN + bank account (+ CAC optional) | Unlimited (with monitoring) | High-volume sellers and enterprise accounts |

#### KYC Provider Strategy — Tiered Approach

> [!TIP]
> Do NOT build KYC in-house. Nigerian identity databases (NIMC, NIBSS, FRSC) require direct licensed access. Use verified aggregator APIs that maintain compliance certifications.

##### Primary Provider: Dojah

| Aspect | Details |
| -------- | --------- |
| **Coverage** | Nigeria + 10 African countries (pan-African expansion ready) |
| **Accuracy** | 99.8% biometric match rate (SmartSelfie™ technology) |
| **ID Types** | NIN, BVN, Voter's Card, Driver's License, Passport, CAC |
| **Liveness Detection** | SmartSelfie™ — passive liveness (no head turns, blinks) |
| **AML Screening** | Built-in watchlist, PEP, and sanctions screening |
| **Pricing** | Pay-per-verification (~$0.10–0.50 per check depending on type) |
| **SDK** | Android, iOS, React Native, Web (JavaScript) |
| **API Latency** | 2–5 seconds for NIN/BVN lookup; 5–10 seconds for biometric |

##### Backup Provider: Smile ID

| Aspect | Details |
| -------- | --------- |
| **Coverage** | Nigeria-focused, 132M+ Nigerian ID records indexed |
| **Unique Strengths** | No-code widget, address verification via utility bill API |
| **Pricing** | Competitive (~$0.05–0.30 per check), startup-friendly |
| **Failover Use** | Secondary — auto-switch if Smile ID returns errors/timeouts |

##### Additional Providers (Evaluated)

| Provider | Best For | Notes |
| ---------- | ---------- | ------- |
| **Prembly (Identitypass)** | Business/CAC verification | Strong for enterprise tier merchant validation |
| **VerifyMe (now QoreID)** | Address verification, biometric | Good for Tier 3 enhanced due diligence |
| **Mono / Okra** | Bank account ownership verification | Already integrated for payment reconciliation |

#### KYC Verification Flow — User Onboarding

```text
┌──────────────────────────────────────────────────────────────────────┐
│                    MarketBoss KYC Onboarding Flow                    │
├──────────────┬──────────────────┬──────────────────┬─────────────────┤
│  Step 1:     │  Step 2:         │  Step 3:         │  Step 4:        │
│  Basic Info  │  ID Verification │  Biometric       │  Status         │
├──────────────┼──────────────────┼──────────────────┼─────────────────┤
│ Full name    │ NIN or BVN       │ SmartSelfie™     │ ✅ Verified     │
│ Phone (OTP)  │ submitted via    │ liveness check   │ ⏳ Pending      │
│ Email        │ Smile ID API     │ (face matches    │ ❌ Rejected     │
│ Date of birth│ → real-time      │  ID photo)       │ 🔄 Retry        │
│              │ validation       │                  │ (with guidance) │
└──────────────┴──────────────────┴──────────────────┴─────────────────┘
```

##### Key Design Decisions

1. **Progressive KYC:** Don't demand everything upfront. Allow unverified users (email + phone) to explore under strict limits. Require Basic KYC (NIN/BVN) for expanded payment activity and Full KYC for unlimited operation.
2. **NIN Preferred over BVN:** NIN is the national standard (all Nigerians) vs. BVN (only bank account holders). Accept both, prefer NIN.
3. **Liveness over Document Scan:** SmartSelfie™ passive liveness is faster and more fraud-resistant than asking users to hold up physical ID cards to a camera. The face is matched against the NIN/BVN photo on file.
4. **Discrepancy Handling:** When NIN name doesn't match user-submitted name (common: "Chukwuemeka" vs. "Emeka"), use fuzzy matching (Levenshtein distance ≤ 3) + flag for manual review if threshold exceeded.

#### KYC Implementation (Go)

```go
// Domain layer — provider-agnostic KYC interface
type KYCProvider interface {
    VerifyIdentity(ctx context.Context, req IdentityVerificationRequest) (*VerificationResult, error)
    VerifyBiometric(ctx context.Context, req BiometricRequest) (*BiometricResult, error)
    ScreenAML(ctx context.Context, req AMLScreenRequest) (*AMLResult, error)
}

type IdentityVerificationRequest struct {
    TenantID     string
    UserID       string
    IDType       string // "nin", "bvn", "drivers_license", "voters_card"
    IDNumber     string
    FirstName    string
    LastName     string
    DateOfBirth  time.Time
    PhoneNumber  string
}

type VerificationResult struct {
    Status       string // "verified", "pending", "failed", "mismatch"
    MatchScore   float64 // 0.0 - 1.0 (name/DoB match confidence)
    IDPhotoURL   string  // Photo from national database (for biometric step)
    Flags        []string // ["name_mismatch", "dob_mismatch", "expired_id"]
    RawResponse  json.RawMessage // Full provider response for audit trail
}

// Usecase layer — orchestrates tiered KYC flow
type KYCService struct {
    primary    KYCProvider // Smile ID
    fallback   KYCProvider // Dojah
    db         KYCRepository
    notifier   NotificationService
}

func (s *KYCService) VerifyVendor(ctx context.Context, req IdentityVerificationRequest) (*VerificationResult, error) {
    // Step 1: Check if already verified (idempotency)
    existing, err := s.db.GetVerification(ctx, req.TenantID, req.UserID)
    if err == nil && existing.Status == "verified" {
        return existing, nil
    }

    // Step 2: Try primary provider (Smile ID)
    result, err := s.primary.VerifyIdentity(ctx, req)
    if err != nil {
        // Auto-failover to Dojah
        log.Warn("Primary KYC provider failed, using fallback",
            "provider", "smile_id", "error", err)
        result, err = s.fallback.VerifyIdentity(ctx, req)
        if err != nil {
            return nil, fmt.Errorf("all KYC providers failed: %w", err)
        }
    }

    // Step 3: Handle name discrepancies with fuzzy matching
    if result.MatchScore < 0.85 {
        result.Status = "pending_review"
        result.Flags = append(result.Flags, "name_mismatch_fuzzy")
        s.notifier.AlertHumanReview(ctx, "KYC name mismatch",
            fmt.Sprintf("Score: %.2f for user %s", result.MatchScore, req.UserID))
    }

    // Step 4: Persist verification result (audit trail — NDPA requirement)
    s.db.SaveVerification(ctx, req.TenantID, req.UserID, result)

    return result, nil
}

// Biometric verification (Step 2 of progressive KYC)
func (s *KYCService) VerifyBiometric(ctx context.Context, userID string, selfieData []byte) (*BiometricResult, error) {
    req := BiometricRequest{
        UserID:    userID,
        SelfieImg: selfieData,
        CheckType: "smart_selfie", // Passive liveness — no awkward head turns
    }

    result, err := s.primary.VerifyBiometric(ctx, req)
    if err != nil {
        return nil, err
    }

    // Update KYC tier if biometric passes
    if result.Confidence > 0.90 {
        s.db.UpdateKYCTier(ctx, userID, "tier_2") // Payment-enabled
    }

    return result, nil
}
```

##### Adapter Layer (Smile ID)

```go
// adapter/smileid/client.go
type SmileIDClient struct {
    partnerID string
    apiKey    string
    baseURL   string
    httpClient *http.Client
}

func (c *SmileIDClient) VerifyIdentity(ctx context.Context, req IdentityVerificationRequest) (*VerificationResult, error) {
    payload := map[string]interface{}{
        "partner_id":   c.partnerID,
        "id_type":      mapIDType(req.IDType), // "NIN_V2", "BVN_MFA"
        "id_number":    req.IDNumber,
        "first_name":   req.FirstName,
        "last_name":    req.LastName,
        "dob":          req.DateOfBirth.Format("1976-01-02"),
        "phone_number": req.PhoneNumber,
    }

    resp, err := c.post(ctx, "/v2/verify", payload)
    if err != nil {
        return nil, err
    }

    return &VerificationResult{
        Status:     mapSmileStatus(resp.ResultCode), // "0810" → "verified"
        MatchScore: resp.ConfidenceValue,
        IDPhotoURL: resp.Photo, // Base64 photo from NIMC/NIBSS database
        Flags:      extractFlags(resp.Actions),
        RawResponse: resp.Raw,
    }, nil
}
```

#### KYC Data Storage (PostgreSQL)

```sql
-- KYC verifications with full audit trail (NDPA compliance)
CREATE TABLE kyc_verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    user_id UUID NOT NULL REFERENCES users(id),
    kyc_tier VARCHAR(20) NOT NULL DEFAULT 'tier_0', -- tier_0, tier_1, tier_2, tier_3
    id_type VARCHAR(50) NOT NULL, -- 'nin', 'bvn', 'drivers_license'
    id_number_hash VARCHAR(255) NOT NULL, -- SHA-256 hash (never store raw NIN/BVN)
    verification_status VARCHAR(30) NOT NULL, -- 'verified', 'pending_review', 'failed'
    match_score DECIMAL(5,4),
    provider VARCHAR(50) NOT NULL, -- 'smile_id', 'dojah'
    provider_response JSONB, -- Full response for audit (encrypted at rest)
    flags TEXT[], -- {'name_mismatch', 'expired_id'}
    reviewed_by UUID REFERENCES admin_users(id), -- If manually reviewed
    review_notes TEXT,
    verified_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(tenant_id, user_id, id_type)
);

-- Index for quick KYC status checks
CREATE INDEX idx_kyc_user_status ON kyc_verifications(user_id, verification_status);

-- RLS policy (tenant isolation)
ALTER TABLE kyc_verifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_kyc_isolation ON kyc_verifications
    USING (tenant_id = current_setting('app.tenant_id')::UUID);
```

> [!CAUTION]
> **Never store raw NIN or BVN numbers in the database.** Always hash with SHA-256 + salt. The verification status and match score are sufficient for access control. Raw ID numbers are only held in memory during the verification API call and discarded immediately after.

#### KYC Cost Estimates

| Phase | Verifications/Month | Est. Cost | Provider |
| ------- | --------------------- | ----------- | ---------- |
| **MVP (0–500 users)** | ~600 (1.2x for retries) | ~$60–180/mo | Smile ID |
| **Growth (500–5K users)** | ~6,000 | ~$600–1,800/mo | Smile ID + Dojah failover |
| **Scale (5K+ users)** | ~10,000+ | Negotiate volume pricing | Volume contract |

### 7.8 Product Verification (Anti-Fraud)

> [!WARNING]
> **The #1 fraud pattern in Nigerian social commerce is "ghost selling"** — posting items you don't actually possess, collecting payment, then either shipping substandard goods or disappearing. MarketBoss must actively prevent this to maintain platform trust.

#### Why Product Verification Matters

| Problem | Impact | Our Solution |
| --------- | -------- | ------------- |
| Ghost selling (no actual product) | Buyer loses money, platform loses trust | **Video/photo proof of possession** before listing |
| Counterfeit goods | Legal liability, brand damage | **AI image analysis** — flags known counterfeit patterns |
| Misleading photos (stock images) | Customer complaints, chargebacks | **Reverse image search** — detects stock/stolen photos |
| Drop-shipping fraud | Delayed delivery, quality issues | **Fulfillment tracking** with delivery confirmation |

#### Product Verification Flow

```text
┌─────────────────────────────────────────────────────────────────────────────┐
│                   Product Verification Pipeline                              │
├────────────┬────────────────┬─────────────────┬─────────────────────────────┤
│  Step 1:   │  Step 2:       │  Step 3:        │  Step 4:                    │
│  Evidence  │  AI Analysis   │  Trust Score    │  Decision                   │
│  Upload    │                │  Calculation    │                             │
├────────────┼────────────────┼─────────────────┼─────────────────────────────┤
│ Vendor     │ Computer vision│ Combine signals:│ Score ≥ 80: ✅ Auto-approve │
│ uploads:   │ checks:        │ • AI confidence │ Score 50–79: ⏳ Queue for   │
│ • 10-sec   │ • Object       │ • Vendor KYC    │   human review              │
│   video    │   detection    │   tier          │ Score < 50: ❌ Reject       │
│   showing  │ • Background   │ • Account age   │   (with reason + retry)     │
│   product  │   consistency  │ • Past approvals│                             │
│ • 3+ photos│ • Reverse image│ • Category risk │ Fraud flag: 🚨 Suspend      │
│   (angles) │   search       │   weighting     │   account + alert           │
│ • Optional │ • Metadata     │                 │                             │
│   receipt  │   (EXIF/GPS)   │                 │                             │
└────────────┴────────────────┴─────────────────┴─────────────────────────────┘
```

#### Evidence Requirements (Per Listing)

| Evidence Type | Required? | Purpose | Acceptance Criteria |
| --------------- | ----------- | --------- | --------------------- |
| **Video (10–30 sec)** | ✅ Yes (first listing of product) | Proves physical possession | Shows product from 2+ angles, no cuts, recorded within 48hrs (EXIF check) |
| **Photos (3+ angles)** | ✅ Yes | Visual verification + listing images | At least 1 must show product with a unique identifier (e.g., vendor's hand, their shop) |
| **Purchase Receipt** | ⚠️ Optional (boosts trust score) | Proves legitimate sourcing | Receipt image or PDF, AI extracts vendor name + date |
| **Packaging/Label** | ⚠️ For branded goods | Anti-counterfeit check | AI checks brand logo placement, spelling, packaging quality |

#### AI-Powered Analysis (Computer Vision)

##### Model Routing for Product Verification

| Task | Model | Cost | Latency |
| ------ | ------- | ------ | --------- |
| Object detection (product present?) | GPT-4o (vision) | ~$0.01/image | 2–4 sec |
| Reverse image search | Google Vision API + TinEye | ~$0.003/image | 1–2 sec |
| Video frame extraction + analysis | FFmpeg + GPT-4o (sampled frames) | ~$0.05/video | 5–10 sec |
| EXIF metadata extraction | Local Go library (`rwcarlsen/goexif`) | Free | <100ms |
| Text extraction from receipts | GPT-4o Mini (OCR) | ~$0.002/image | 1–2 sec |

```go
// Domain layer — product verification interface
type ProductVerifier interface {
    AnalyzeProductEvidence(ctx context.Context, req ProductEvidenceRequest) (*VerificationAnalysis, error)
}

type ProductEvidenceRequest struct {
    TenantID     string
    VendorID     string
    ProductID    string
    VideoURL     string   // Uploaded to object storage + CDN (Cloudflare R2 optional)
    PhotoURLs    []string // 3+ angles
    ReceiptURL   string   // Optional
    Category     string   // "electronics", "fashion", "food", etc.
    ClaimedPrice float64
}

type VerificationAnalysis struct {
    TrustScore        int     // 0–100
    ObjectDetected    bool    // Is the claimed product visible?
    IsStockImage      bool    // Reverse image search result
    IsOriginalVideo   bool    // Not screen-recorded or downloaded
    EXIFValid         bool    // Timestamp within 48hrs, GPS plausible
    CounterfeitRisk   string  // "low", "medium", "high"
    Decision          string  // "approved", "review", "rejected"
    Flags             []string
    AIConfidence      float64 // 0.0 – 1.0
    ReviewRequired    bool
    ReviewReason      string
}

// Usecase layer — orchestrates product verification pipeline
type ProductVerificationService struct {
    vision       ProductVerifier    // GPT-4o Vision
    imageSearch  ReverseImageSearch // Google Vision + TinEye
    exifParser   EXIFParser
    videoProc    VideoProcessor     // FFmpeg frame extraction
    db           ProductVerificationRepository
    reviewQueue  ReviewQueueService
    notifier     NotificationService
}

func (s *ProductVerificationService) VerifyProduct(ctx context.Context, req ProductEvidenceRequest) (*VerificationAnalysis, error) {
    analysis := &VerificationAnalysis{}

    // Step 1: EXIF metadata check (fastest — filter obvious fakes early)
    for _, photoURL := range req.PhotoURLs {
        exif, err := s.exifParser.Extract(ctx, photoURL)
        if err == nil {
            if time.Since(exif.DateTime) > 48*time.Hour {
                analysis.Flags = append(analysis.Flags, "photo_older_than_48hrs")
            }
            analysis.EXIFValid = exif.IsValid()
        }
    }

    // Step 2: Reverse image search (detect stock/stolen images)
    for _, photoURL := range req.PhotoURLs {
        isStock, sources := s.imageSearch.Search(ctx, photoURL)
        if isStock {
            analysis.IsStockImage = true
            analysis.Flags = append(analysis.Flags,
                fmt.Sprintf("stock_image_found: %d sources", len(sources)))
        }
    }

    // Step 3: AI vision analysis on photos (object detection + quality)
    visionResult, err := s.vision.AnalyzeProductEvidence(ctx, req)
    if err != nil {
        log.Error("Vision analysis failed", "error", err)
        // If AI fails, force human review instead of blocking
        analysis.ReviewRequired = true
        analysis.ReviewReason = "ai_analysis_failed"
    } else {
        analysis.ObjectDetected = visionResult.ObjectDetected
        analysis.CounterfeitRisk = visionResult.CounterfeitRisk
        analysis.AIConfidence = visionResult.AIConfidence
    }

    // Step 4: Video analysis (extract frames, check for continuity)
    if req.VideoURL != "" {
        frames, err := s.videoProc.ExtractKeyFrames(ctx, req.VideoURL, 5) // 5 frames
        if err == nil {
            videoAnalysis := s.vision.AnalyzeFrames(ctx, frames, req.Category)
            analysis.IsOriginalVideo = videoAnalysis.IsOriginal
            if !videoAnalysis.ProductConsistent {
                analysis.Flags = append(analysis.Flags, "video_product_mismatch")
            }
        }
    }

    // Step 5: Calculate trust score
    analysis.TrustScore = s.calculateTrustScore(ctx, req, analysis)

    // Step 6: Make decision based on trust score
    switch {
    case analysis.TrustScore >= 80:
        analysis.Decision = "approved"
    case analysis.TrustScore >= 50:
        analysis.Decision = "review"
        analysis.ReviewRequired = true
        analysis.ReviewReason = "moderate_trust_score"
    default:
        analysis.Decision = "rejected"
        analysis.Flags = append(analysis.Flags, "low_trust_score")
    }

    // Step 7: Route to human review queue if needed
    if analysis.ReviewRequired {
        s.reviewQueue.Enqueue(ctx, ReviewItem{
            Type:       "product_verification",
            TenantID:   req.TenantID,
            VendorID:   req.VendorID,
            ProductID:  req.ProductID,
            Evidence:   req,
            AIAnalysis: analysis,
            Priority:   s.calculateReviewPriority(analysis),
        })
        s.notifier.AlertReviewTeam(ctx, "Product verification needs review",
            fmt.Sprintf("Product %s — Trust Score: %d, Flags: %v",
                req.ProductID, analysis.TrustScore, analysis.Flags))
    }

    // Step 8: Persist result (audit trail)
    s.db.SaveVerification(ctx, req, analysis)

    return analysis, nil
}

// Trust score combines multiple signals
func (s *ProductVerificationService) calculateTrustScore(ctx context.Context, req ProductEvidenceRequest, analysis *VerificationAnalysis) int {
    score := 50 // Base score

    // Positive signals
    if analysis.ObjectDetected { score += 15 }
    if analysis.EXIFValid { score += 10 }
    if analysis.IsOriginalVideo { score += 10 }
    if !analysis.IsStockImage { score += 10 }

    // Vendor reputation (historical trust)
    vendor, _ := s.db.GetVendorStats(ctx, req.VendorID)
    if vendor.VerifiedListings > 10 { score += 5 }
    if vendor.AccountAgeDays > 90 { score += 5 }
    if vendor.FraudReports == 0 { score += 5 }

    // Negative signals
    if analysis.IsStockImage { score -= 30 }
    if analysis.CounterfeitRisk == "high" { score -= 25 }
    if len(analysis.Flags) > 3 { score -= 10 }

    // Category risk weighting (electronics are higher fraud risk)
    categoryRisk := map[string]int{
        "electronics": -10, "phones": -15, "luxury": -10,
        "fashion": 0, "food": 5, "handmade": 5,
    }
    if adj, ok := categoryRisk[req.Category]; ok {
        score += adj
    }

    // Clamp to 0–100
    if score < 0 { score = 0 }
    if score > 100 { score = 100 }

    return score
}
```

#### Human Review Queue (Admin Dashboard)

> [!NOTE]
> Not every listing can be verified by AI alone. The human-in-the-loop review system handles edge cases — suspicious patterns, borderline trust scores, and high-value items. The goal is **80% auto-approval, 15% human review, 5% auto-rejection**.

```go
type ReviewItem struct {
    ID         UUID
    Type       string         // "product_verification", "kyc_review"
    TenantID   string
    VendorID   string
    ProductID  string
    Evidence   ProductEvidenceRequest
    AIAnalysis *VerificationAnalysis
    Priority   string         // "critical", "high", "normal"
    Status     string         // "pending", "in_review", "approved", "rejected"
    AssignedTo *UUID          // Admin reviewer
    ReviewedAt *time.Time
    Notes      string
    CreatedAt  time.Time
}

type ReviewQueueService struct {
    db       ReviewRepository
    notifier NotificationService
}

func (s *ReviewQueueService) Enqueue(ctx context.Context, item ReviewItem) error {
    item.Status = "pending"
    item.CreatedAt = time.Now()

    // Set SLA based on priority
    // Critical: 1 hour, High: 4 hours, Normal: 24 hours
    sla := s.getSLA(item.Priority)
    s.db.Save(ctx, item)
    s.notifier.NotifyReviewers(ctx, item, sla)
    return nil
}

func (s *ReviewQueueService) CompleteReview(ctx context.Context, itemID UUID, decision string, notes string, reviewerID UUID) error {
    item, err := s.db.Get(ctx, itemID)
    if err != nil { return err }

    item.Status = decision // "approved" or "rejected"
    item.Notes = notes
    item.AssignedTo = &reviewerID
    now := time.Now()
    item.ReviewedAt = &now

    s.db.Update(ctx, item)

    // Notify vendor of decision
    if decision == "approved" {
        s.notifier.NotifyVendor(ctx, item.VendorID, "Your product listing has been approved!")
    } else {
        s.notifier.NotifyVendor(ctx, item.VendorID,
            fmt.Sprintf("Your listing was not approved. Reason: %s. You may re-submit with updated evidence.", notes))
    }

    return nil
}
```

#### Product Verification Data Model

```sql
-- Product verification evidence and results
CREATE TABLE product_verifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    vendor_id UUID NOT NULL REFERENCES users(id),
    product_id UUID NOT NULL,
    video_url TEXT,
    photo_urls TEXT[] NOT NULL, -- Array of CDN URLs
    receipt_url TEXT,
    trust_score INTEGER NOT NULL CHECK (trust_score BETWEEN 0 AND 100),
    decision VARCHAR(20) NOT NULL, -- 'approved', 'review', 'rejected'
    ai_analysis JSONB NOT NULL, -- Full AI analysis result
    flags TEXT[],
    review_status VARCHAR(20) DEFAULT 'none', -- 'none', 'pending', 'completed'
    reviewed_by UUID REFERENCES admin_users(id),
    review_notes TEXT,
    reviewed_at TIMESTAMPTZ,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Human review queue
CREATE TABLE review_queue (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    review_type VARCHAR(50) NOT NULL, -- 'product_verification', 'kyc_review', 'fraud_report'
    reference_id UUID NOT NULL, -- Links to product_verifications.id or kyc_verifications.id
    tenant_id UUID NOT NULL REFERENCES tenants(id),
    priority VARCHAR(20) NOT NULL DEFAULT 'normal', -- 'critical', 'high', 'normal'
    status VARCHAR(20) NOT NULL DEFAULT 'pending',
    assigned_to UUID REFERENCES admin_users(id),
    sla_deadline TIMESTAMPTZ NOT NULL,
    decision VARCHAR(20),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    completed_at TIMESTAMPTZ
);

-- Indexes for review dashboard
CREATE INDEX idx_review_queue_status ON review_queue(status, priority, created_at);
CREATE INDEX idx_review_queue_assigned ON review_queue(assigned_to, status);

-- RLS policies
ALTER TABLE product_verifications ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_product_verification ON product_verifications
    USING (tenant_id = current_setting('app.tenant_id')::UUID);
```

#### Product Verification Cost Estimates

| Component | Monthly Cost (1K Users) | Notes |
| ----------- | ------------------------ | ------- |
| GPT-4o Vision (images) | ~$10–30 | ~3 images/listing × avg 2 listings/user |
| GPT-4o Vision (video frames) | ~$25–50 | ~5 frames/video |
| Google Vision API | ~$5–15 | Reverse image search |
| FFmpeg (video processing) | $0 (self-hosted) | CPU cost only |
| Human reviewer (part-time) | ~$200–400 | ~15% of listings need review |
| **Total** | **~$240–495/mo** | Scales linearly with listings |

> [!TIP]
> **Progressive trust:** As vendors accumulate verified listings with 0 fraud reports, reduce verification requirements. Vendors with 50+ approved listings and 6+ months history can skip video evidence for similar product categories.

---
