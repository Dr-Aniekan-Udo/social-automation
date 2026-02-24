# 4. Technical Architecture

### 4.1 Technology Stack — Final Decisions

> [!IMPORTANT]
> Where researchers disagreed, the decision below reflects the best option for our target market (Nigerian SMBs), team constraints, and cost profile. All versions verified as of February 13, 2026.

| Component | Decision | Version | Rationale |
| ----------- | ---------- | --------- | ----------- |
| **Backend Language** | **Go (Golang)** | 1.26 (released Feb 10, 2026) | "Green Tea" GC reduces overhead 10–40%. Best performance-to-cost ratio. Strong Nigerian talent pool (Paystack, Moniepoint). Static typing for financial safety. |
| **Architecture** | **Modular Monolith** (MVP) → Microservices (Phase 3+) | N/A | Lower operational complexity. Easier to develop, deploy, debug. Extract services later. |
| **Database** | **PostgreSQL** (Managed) | 18 | ACID compliance, native UUIDv7, Async I/O (AIO) for 2–3x scan performance, JSON flexibility. |
| **Multi-Tenancy** | **Shared Schema (Row-Level Security)** | N/A | Most cost-effective for SMB pricing. RLS provides adequate isolation. |
| **Caching & Queue** | **Redis** (Streams for queuing) | 7.4+ | Dual-purpose: caching + message queue. Cost-effective, simple. |
| **Frontend** | **React + Next.js** | React 19.x / Next.js 16.x | Largest ecosystem, best developer availability in Nigeria, SSR for SEO, PWA for mobile. |
| **Runtime** | **Node.js** (LTS) | 24 (Krypton LTS) | Required for Next.js. Active LTS with support until 2027. |
| **Cloud** | **DigitalOcean** (MVP/Growth) → GCP/AWS (Scale) | N/A | Predictable flat pricing prevents "cloud bill shock". |
| **Media Delivery** | **S3-compatible object storage + CDN capability** | N/A | Vendor-agnostic requirement for scalable media delivery; Cloudflare remains an optional implementation choice. |
| **AI Models** | **Tiered Model Routing** (see §4.3) | N/A | No single model — cheap models for 70% of tasks. |
| **Monitoring** | **SigNoz** (APM) + **Sentry** (Errors) | SigNoz 0.110.x / Sentry SDK 2.52.x | 80% cheaper than Datadog. OpenTelemetry native. |
| **Security** | **Semgrep + Dependabot + TruffleHog + Trivy** (PR gates) | N/A | Lean MVP security profile. OWASP ZAP runs nightly/pre-release and is non-PR-blocking in MVP. |
| **Payments** | **Paystack** (Primary) + **Flutterwave** (Backup) | N/A (API) | Dual gateway for redundancy and max payment success. |

### 4.2 Go Backend — Clean Architecture

Adopt **Clean Architecture** with **Domain-Driven Design** to enforce strict layer separation:

```text
/cmd
  /api              # Main entry point for REST server
  /worker            # Background job consumers (email, social posting)
/internal
  /domain            # Pure business logic (Entities & Interfaces)
    /user            # User & Tenant models
    /sales           # Lead & Order models
    /content         # Social media post models
    /payment         # Transaction models
    /identity        # Multi-channel identity (BSUID, phone, IG scoped ID)
  /service           # Application business rules (Interactors)
    /onboarding      # Tenant signup flows + Instagram readiness check
    /content_generation  # AI content creation with hybrid composition
    /social_posting      # Multi-platform scheduling + pacing awareness
    /payment_recon   # Logic for matching bank credits to orders
    /channel_routing # Channel-agnostic message dispatch
  /adapter           # Interface Adapters (outbound)
    /postgres        # Repository implementations
    /redis           # Caching implementation
    /paystack        # Payment gateway client
    /flutterwave     # Backup payment gateway client
    /deepseek        # Primary AI provider client
    /gemini          # Secondary AI provider client
    /openai          # Tertiary AI provider client
    /meta            # Facebook/Instagram Graph API client
    /whatsapp        # WhatsApp Cloud API client
    /tiktok          # TikTok Content Posting API client
    /telegram        # Telegram Bot API (fallback channel)
    /sms             # Termii/Africa's Talking (emergency fallback)
  /handler           # Inbound handlers (HTTP, SSE, webhooks)
    /http            # REST API handlers
    /sse             # Real-time feed stream updates
    /webhook         # Incoming webhook processors
/pkg                 # Shared libraries (Logger, Validator, Utils)
/config              # Configuration management
/migrations          # Database schema migration files
/scripts             # Build/deployment scripts
```

##### Key Principles

- Switching from Paystack → another provider only changes `/adapter` layer
- **Channel-Agnostic Adapter Pattern**: The `/adapter` layer isolates all platform-specific logic. If Meta exits Nigeria, swapping `whatsapp` → `telegram` adapter requires zero changes to domain or service layers
- Domain and service layers remain untouched by infrastructure changes
- Enforce with `go-arch-lint` in CI/CD pipeline to reject dependency-violating PRs
- SOLID principles throughout (Interface Segregation, Dependency Inversion)

##### Channel-Agnostic Messaging Interface

```go
// Domain layer - completely platform agnostic
type MessageChannel interface {
    SendMessage(ctx context.Context, msg OutboundMessage) error
    ReceiveWebhook(ctx context.Context, payload []byte) (*InboundMessage, error)
    GetSessionWindow(ctx context.Context, userID string) (*SessionWindow, error)
}

// Adapter layer - platform-specific implementations
type WhatsAppChannel struct {
    client    *WhatsAppCloudAPIClient
    sessionMgr *SessionManager  // Tracks 24-hour windows
}

type TelegramChannel struct {
    client *telegram.BotAPI
}

type SMSChannel struct {
    client *termii.Client  // Nigerian SMS provider
}

// Usecase layer - routes to appropriate channel
type ChannelRouter struct {
    channels map[string]MessageChannel
    primary  string // "whatsapp" by default
    fallback string // "telegram" or "sms"
}

func (r *ChannelRouter) Send(ctx context.Context, msg OutboundMessage) error {
    ch := r.channels[r.primary]
    if err := ch.SendMessage(ctx, msg); err != nil {
        // Automatic failover to fallback channel
        log.Warn("Primary channel failed, using fallback",
            "primary", r.primary, "fallback", r.fallback, "error", err)
        return r.channels[r.fallback].SendMessage(ctx, msg)
    }
    return nil
}
```

### 4.3 AI Orchestration — Model Routing Strategy

> [!TIP]
> Using premium models for every interaction can cost ~$800–2,000/month at 1,000 users (based on token volume). Model routing + caching reduces this to ~$120–450/month.

**Implement a "Smart Router" gateway** between the application and AI providers:

| Tier | Models | Use For | Cost |
| ------ | -------- | --------- | ------ |
| **Tier 1: Budget** (70%) | DeepSeek Lite/DeepSeek V3-class pricing | Routine WhatsApp replies, chat summaries, receipt extraction, simple drafts | ~$0.06–0.25/user/month |
| **Tier 2: Balanced** (25%) | Google Gemini Flash-class pricing | Marketing copy, product descriptions, comment-to-DM workflows | ~$0.04–0.15/user/month |
| **Tier 3: Premium** (5%) | OpenAI GPT-4o-class pricing | Complex sales sentiment, dispute handling, strategic plans | ~$0.02–0.08/user/month |

_Pricing benchmarks verified on February 14, 2026 from OpenAI, Anthropic, Google Gemini API, and DeepSeek official pricing pages._

##### AI Router Implementation

```go
// Domain layer - provider agnostic interface
type AIProvider interface {
    Complete(ctx context.Context, req AIRequest) (*AIResponse, error)
    StreamComplete(ctx context.Context, req AIRequest) (<-chan string, error)
}

// Smart Router in service layer
type AIRouter struct {
    budget   AIProvider  // DeepSeek Lite / DeepSeek V3
    balanced AIProvider  // Google Gemini Flash
    premium  AIProvider  // OpenAI GPT-4o
    cache    *SemanticCache
    tracker  *TokenTracker
}

func (r *AIRouter) Generate(ctx context.Context, req AIRequest) (*AIResponse, error) {
    // Step 1: Check semantic cache (30-50% cost reduction)
    if cached, ok := r.cache.Get(ctx, req.Prompt); ok {
        return &AIResponse{Text: cached, FromCache: true}, nil
    }

    // Step 2: Check tenant's token budget
    if !r.tracker.HasBudget(req.TenantID, req.EstimatedTokens) {
        return nil, errors.New("monthly token budget exceeded")
    }

    // Step 3: Route to appropriate tier based on task complexity
    provider := r.selectProvider(req.TaskType)
    resp, err := provider.Complete(ctx, req)
    if err != nil {
        // Automatic failover
        log.Warn("AI provider failed, trying fallback", "error", err)
        resp, err = r.budget.Complete(ctx, req)
        if err != nil {
            return nil, fmt.Errorf("all AI providers failed: %w", err)
        }
    }

    // Step 4: Cache response and track usage
    r.cache.Set(ctx, req.Prompt, resp.Text)
    r.tracker.RecordUsage(req.TenantID, resp.TokensUsed)

    return resp, nil
}

func (r *AIRouter) selectProvider(taskType string) AIProvider {
    switch taskType {
    case "chat_reply", "receipt_extract", "summary":
        return r.budget    // Tier 1
    case "marketing_copy", "product_desc", "comment_to_dm":
        return r.balanced  // Tier 2
    case "sentiment_analysis", "dispute", "strategy":
        return r.premium   // Tier 3
    default:
        return r.budget
    }
}
```

##### Semantic Cache Implementation

```go
type SemanticCache struct {
    redis      *redis.Client
    embeddings *EmbeddingService
}

func (sc *SemanticCache) Get(ctx context.Context, prompt string) (string, bool) {
    embedding := sc.embeddings.Embed(prompt)
    // Search for similar cached prompts (cosine similarity > 0.95)
    cachedResponse := sc.searchSimilar(embedding, 0.95)
    if cachedResponse != "" {
        return cachedResponse, true
    }
    return "", false
}

func (sc *SemanticCache) Set(ctx context.Context, prompt, response string) {
    embedding := sc.embeddings.Embed(prompt)
    // Store with 24-hour TTL
    sc.redis.SetEX(ctx, embedding.String(), response, 24*time.Hour)
}
```

##### Cost Optimization Strategies (Critical Priority)

1. **Semantic Caching** — 30–50% cost reduction via similar query detection
2. **Prompt Caching** — 90% savings on repeated system prompts (OpenAI batch: 50% discount)
3. **Max Token Limits** — Hard caps per task type to prevent runaway costs
4. **Multi-Provider Switching** — Automatic failover and cost-based routing
5. **Batch Processing** — Queue non-urgent content generation overnight (50% discount with OpenAI)

**Estimated AI cost per user/month:** $0.12–0.48 (blended, text-heavy workloads)

### 4.4 Multi-Tenancy Implementation

##### Pattern: Shared Schema with Row-Level Security

```sql
-- Every table includes tenant_id with UUIDv7 (PostgreSQL 18 native)
CREATE TABLE orders (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- Use UUIDv7 for time-ordered inserts
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  customer_name TEXT NOT NULL,
  amount DECIMAL(12,2) NOT NULL,
  status TEXT DEFAULT 'pending',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Row-Level Security Policy
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
CREATE POLICY tenant_isolation ON orders
  USING (tenant_id = current_setting('app.tenant_id')::UUID);

-- UUIDv7 for message IDs (time-ordered for faster "recent conversations" queries)
CREATE TABLE messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),  -- UUIDv7
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  channel VARCHAR(50) NOT NULL,  -- 'whatsapp', 'instagram', 'telegram'
  direction VARCHAR(10) NOT NULL, -- 'inbound', 'outbound'
  content TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  INDEX idx_tenant_messages (tenant_id, created_at DESC)
);
```

##### Tenant Middleware (Go)

```go
func TenantMiddleware(next http.Handler) http.Handler {
    return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
        tenantID := extractTenantID(r) // From JWT or subdomain
        ctx := context.WithValue(r.Context(), "tenantID", tenantID)

        // Set PostgreSQL session variable for RLS
        db.Exec("SET app.tenant_id = $1", tenantID)

        next.ServeHTTP(w, r.WithContext(ctx))
    })
}
```

### 4.5 Multi-Channel Identity Resolution

> [!IMPORTANT]
> **WhatsApp BSUID Migration (March 2026):** WhatsApp is deprecating phone numbers as the primary business identifier. BSUIDs will appear in webhooks starting March 31, 2026. Systems must support BSUID by June 2026.

```sql
-- One customer can have multiple social identities
CREATE TABLE social_identities (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL,
  customer_id UUID NOT NULL REFERENCES customers(id),
  channel VARCHAR(50) NOT NULL,        -- 'whatsapp', 'instagram', 'facebook'
  identifier VARCHAR(255) NOT NULL,     -- BSUID, IG Scoped ID, or phone number
  identifier_type VARCHAR(50) NOT NULL, -- 'bsuid', 'scoped_id', 'phone_legacy'
  is_primary BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(tenant_id, channel, identifier)
);

-- Legacy phone lookup (fallback during BSUID migration H2 2026)
CREATE INDEX idx_phone_lookup ON social_identities(identifier)
  WHERE identifier_type = 'phone_legacy';
```

```go
// Identity resolution service handles BSUID migration
type IdentityService struct {
    db *pgxpool.Pool
}

func (s *IdentityService) ResolveCustomer(ctx context.Context, tenantID, channel, identifier string) (*Customer, error) {
    // Try BSUID/Scoped ID first (new format)
    customer, err := s.findByIdentifier(ctx, tenantID, channel, identifier)
    if err == nil {
        return customer, nil
    }

    // During migration: try phone number fallback if BSUID not found
    if channel == "whatsapp" {
        return s.findByPhoneFallback(ctx, tenantID, identifier)
    }

    return nil, fmt.Errorf("customer not found for %s:%s", channel, identifier)
}
```

### 4.6 Programmatic Design Architecture (Hybrid Composition)

> [!IMPORTANT]
> **Do NOT use generative AI (e.g., DALL-E) for full image creation.** AI image generators consistently fail at rendering legible text — logos appear distorted, prices are garbled, and brand fonts are not respected. This is unacceptable for commercial social media posts.

**Approach: Hybrid Composition** — AI generates visual elements only; text and branding are composited programmatically.

```text
┌──────────────────────────────────────────────────────────┐
│                Content Image Pipeline                     │
├──────────────┬──────────────────┬────────────────────────┤
│  Step 1: AI  │  Step 2: Vector  │  Step 3: Brand Kit     │
│  Background  │  Composition     │  Injection             │
├──────────────┼──────────────────┼────────────────────────┤
│ Generate     │ Go graphics lib  │ Logo → Safe Zone       │
│ textures,    │ composites final │ Colors → hex codes     │
│ thematic     │ image layers:    │ Font → tenant TTF/OTF  │
│ elements     │ text, borders,   │ applied to all copy    │
│ (e.g. "gold  │ badges, pricing  │                        │
│ confetti     │ overlays         │ Ensures pixel-perfect  │
│ background") │                  │ branding per tenant    │
└──────────────┴──────────────────┴────────────────────────┘
```

##### Implementation Details

1. **Asset Generation (AI):** Use DALL-E 3 or Stable Diffusion to generate _only_ backgrounds and thematic elements. No text or logos.
2. **Vector Composition (Go):** Use `gogpu/gg` v0.14.0 (GPU-accelerated 2D graphics) to programmatically composite text, borders, price badges with exact coordinates.
3. **Brand Kit Injection (Per-Tenant):** Each SMB uploads brand assets during onboarding — logo, primary/secondary hex colors, TTF/OTF font file.
4. **Template System:** Pre-designed layout templates (product showcase, promotional banner, story format) define safe zones, text areas, compositional rules.

---
