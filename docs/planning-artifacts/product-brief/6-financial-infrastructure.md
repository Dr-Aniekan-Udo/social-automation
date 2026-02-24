# 6. Financial Infrastructure

### 6.1 Payment Gateways — Phased Dual Gateway Strategy

| Gateway | Local Fee | International | Settlement | Key Strength |
| --------- | ----------- | --------------- | ------------ | -------------- |
| **Paystack** ✅ Primary (MVP) | 1.5% + ₦100 (cap ₦2K) | 3.9% + ₦100 | T+1 | Best developer UX, Stripe-owned trust |
| **Flutterwave** ✅ Backup (Growth) | 1.4% (no flat fee) | 3.8% | T+1 | Pan-African, 30+ currencies, virtual accounts |
| **Monnify** | 1.5% cap ₦2K or ₦500 flat | — | T+1 | Virtual accounts, B2B focus |

> Activation policy (aligned with PRD): MVP runs Paystack subaccount direct settlement. Growth adds Flutterwave failover and optional escrow flow.

### 6.2 Automated Payment Reconciliation (Key Differentiator)

##### The "Pay-by-Transfer" Workflow

```text
1. AI sales agent closes deal on WhatsApp
2. System generates provider-backed payment rails (Paystack in MVP; Flutterwave virtual account support in Growth)
3. Agent sends: "Please transfer ₦15,000 to Account 12345 (Wema Bank)"
4. Customer transfers from any bank
5. Provider webhook fires → System matches account to order
6. Order marked "Paid" → AI agent sends instant receipt
```

This automates the **most painful part of Nigerian social commerce** — manual payment confirmation via screenshots.

### 6.3 Bank API Integration

- **Mono / Okra** — Access bank statements and transaction history
- **Use Case:** For SMBs receiving payments to corporate accounts, listen to bank feed, match credits by Amount + Reference, auto-reconcile

---
