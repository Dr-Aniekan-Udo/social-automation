# 11. Monitoring & Observability Stack

### Recommended Stack (Cost-Optimized)

| Component | Tool | Monthly Cost | Purpose |
| ----------- | ------ | ------------- | --------- |
| **Error Tracking** | Sentry Team | $20/user | Exception tracking, stack traces, release tracking |
| **APM + Logs** | SigNoz Cloud | $49 | Metrics, traces, logs — unified OpenTelemetry |
| **Uptime** | UptimeRobot | Free | Simple uptime monitoring |
| **Security (SAST)** | Semgrep | Free tier | Pattern-based code scanning |
| **Supply Chain (SCA)** | GitHub Dependabot | Free | Dependency vulnerability scanning |
| **Secrets Scanning** | TruffleHog | Free | Detect hardcoded credentials in source/history |
| **Vulnerability Scanning** | Trivy | Free | Dependency/filesystem/image vulnerability scanning |
| **DAST (Phased)** | OWASP ZAP | Free | Nightly/pre-release dynamic scanning (non-PR-blocking in MVP) |
| **LLM Tracing & Prompts** | Langfuse (self-hosted) | ~$5–10 (DO Droplet) | Prompt/response traces, token cost per tenant, prompt versioning, evaluation — NDPA-compliant (data stays on-prem) |
| **LLM → OTel Bridge** | OpenLLMetry | Free (OSS library) | Emits OTel spans for AI calls; correlates LLM traces with SigNoz infra traces via shared `trace_id` |
| **AI Guardrails** | NeMo Guardrails / Custom | — | Filter toxic outputs, prevent PII leakage |
| **Total** | | **~$75–110/month** | |

> [!NOTE]
> **Deferred:** Arize Phoenix (RAG-focused LLM evaluation) is planned for Phase 3 when a retrieval-augmented pipeline is introduced. **LangSmith** (previously listed) is replaced by the open-source Langfuse — same capabilities, self-hosted, no proprietary lock-in.

##### OpenTelemetry Integration (Go)

```go
import (
    "go.opentelemetry.io/otel"
    "go.opentelemetry.io/otel/exporters/otlp/otlptrace/otlptracehttp"
    "go.opentelemetry.io/otel/sdk/trace"
)

func initTracing() {
    exporter, _ := otlptracehttp.New(context.Background(),
        otlptracehttp.WithEndpoint("signoz.marketboss.com"),
    )
    tp := trace.NewTracerProvider(
        trace.WithBatcher(exporter),
        trace.WithResource(/* service info */),
    )
    otel.SetTracerProvider(tp)
}
```

##### Structured Logging

```go
import "go.uber.org/zap"

logger, _ := zap.NewProduction()
logger.Info("user.login",
    zap.String("user_id", userID),
    zap.String("ip_address", ip),
    zap.String("tenant_id", tenantID),
)
```

##### Critical Metrics to Track

| Category | Metrics |
| ---------- | --------- |
| **Product** | DAU/MAU ratio (target >40%), posts/user/week, automation usage, feature adoption |
| **Business** | MRR, churn (target ≤5%; crisis ceiling ≤8%), CAC, LTV, LTV:CAC (target >3:1), gross margin (target ≥60%) |
| **Technical** | API p95 <500ms, error rate <0.5%, uptime 99.5% (platform) / 99.9% (payment endpoints), DB query p95 <100ms |
| **Compliance** | DSAR response <72hrs, breach detection <1hr, rate limit violations = 0 |
| **Platform Health** | `X-App-Usage` header tracking for Instagram, WhatsApp pacing status monitoring |

---
