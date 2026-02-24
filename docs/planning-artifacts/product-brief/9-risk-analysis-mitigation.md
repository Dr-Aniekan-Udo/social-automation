# 9. Risk Analysis & Mitigation

### 9.1 Existential & Geopolitical Risks

| Risk | Impact | Probability | Mitigation |
| ------ | -------- | ------------- | ------------ |
| **Meta exits Nigeria** (FB/IG shutdown) | CRITICAL | Medium | Channel-agnostic adapter pattern. Telegram + RCS + SMS fallback. WhatsApp likely safe (not named in court filings). |
| **NDPA enforcement escalation** | CRITICAL | High | Privacy-Preserving Proxy from Day 1. DPO hired. Annual audits. GAID compliance. |

### 9.2 Technical & Platform Risks

| Risk | Impact | Probability | Mitigation |
| ------ | -------- | ------------- | ------------ |
| **Meta API policy changes** (rate limits, AI restrictions) | HIGH | Medium | Multi-platform strategy, compliance monitoring, policy abstraction layer |
| **WhatsApp BSUID migration breaks identity resolution** | HIGH | High | Social Identity table with multi-identifier support. Phone fallback during migration period. |
| **TikTok audit rejection** | MEDIUM | Medium | Sandbox development, Figma mockups, conservative usage estimates, professional audit artifacts |
| **AI cost volatility** | MEDIUM | Medium | Multi-provider routing, semantic caching, prompt optimization |
| **AI content quality** (hallucinations, brand damage) | HIGH | Medium | Content moderation pipeline, NeMo Guardrails, quality filters, user feedback loops |
| **Data breach** | HIGH | Low | Encryption at rest + transit, Semgrep SAST, security audits, DPO, breach notification process |

### 9.3 Market & Operational Risks

| Risk | Impact | Probability | Mitigation |
| ------ | -------- | ------------- | ------------ |
| **International competitors** entering Nigeria | MEDIUM | High | Local knowledge advantage, Naira pricing, payment integration moat |
| **Naira devaluation / recession** | MEDIUM | Medium | USD pricing option, regional expansion |
| **Low market adoption** | MEDIUM | Medium | Freemium tier, educational content, ROI demos, competitive pricing |
| **Key person dependency** | HIGH | High | Documentation, cross-training, competitive compensation |
| **Cashflow issues** | CRITICAL | Medium | 6-month runway, disciplined spending, monthly reviews |

---
