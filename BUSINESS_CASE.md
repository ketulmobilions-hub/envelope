# Envelope — Business Case for App Store Launch
**Prepared for**: Engineering Manager Review  
**Date**: April 2026  
**Author**: Ketul Makwana  

---

## Executive Summary

**Envelope** is a production-grade, zero-based budgeting (ZBB) app built with Flutter, targeting iOS, Android, and Web. It was developed as a personal initiative and is now **~80% complete** — feature-parity with leading competitors like YNAB and EveryDollar, with several differentiators those apps do not offer.

The personal finance app market is in its most disrupted state in a decade. The forced shutdown of Mint (3.6 million displaced users, March 2024) created a lasting void that no single competitor has fully captured. The ZBB segment alone generates hundreds of millions in annual subscription revenue, with the broader market growing at a 15–21% CAGR through 2034.

**The ask**: Sponsor the remaining ~20% of development work and support the app through App Store submission and initial launch. The app is already architected for monetization (RevenueCat subscription management is partially integrated), and the codebase follows enterprise-grade standards — this is not a prototype.

---

## 1. The Market Opportunity

### 1.1 Market Size

The personal finance app market is large, growing, and actively losing its dominant free player.

| Market Segment | 2024 Size | 2034 Projection | Growth Rate |
|---|---|---|---|
| Personal Finance Mobile Apps | $2.9B | $12.58B | ~15.8% CAGR |
| Personal Finance Software (broad) | $1.35B | — | ~20.57% CAGR |
| Budgeting Apps (narrow ZBB focus) | ~$240M | ~$450M | High |

Sources: Fact.MR, Business Research Insights, Technavio (2024–2026)

### 1.2 The Mint Vacuum — A Once-in-a-Decade Window

Intuit shut down **Mint** on March 23, 2024. At closure, Mint had approximately **3.6 million active users** who needed a new home — overnight. This was the largest user migration event in personal finance app history.

- Monarch Money captured the most mindshare, growing 20x in subscribers and reaching $12.6M ARR
- Quicken Simplifi was named the #1 Mint replacement by most reviewers
- YNAB captured methodologically serious budgeters
- **Critically: No app fully captured the free, easy-entry tier that Mint occupied**

**12 months later, a large cohort of displaced Mint users are still dissatisfied** with their alternatives — citing high pricing, broken bank connections, and steep learning curves. This window is still open.

### 1.3 Target User Segments

| Segment | Size | Underserved By |
|---|---|---|
| Former Mint users seeking a free/affordable replacement | ~3.6M (US alone) | All current apps charge $80–110/year for full features |
| Couples / families wanting shared budgets | ~40M US households | Only Monarch Money addresses this seriously |
| Android ZBB users | ~50% of the smartphone market | Copilot (best-designed ZBB app) is iOS-only |
| Privacy-conscious users | Growing niche | Most apps sell data or depend on Plaid |
| First-time budgeters (25–35 age group) | Largest demographic of new finance app adopters | Apps with high learning curves fail this group |

---

## 2. Competitive Landscape

### 2.1 Head-to-Head Comparison

| Feature | **Envelope** | YNAB | EveryDollar | Goodbudget | Monarch Money | Copilot |
|---|---|---|---|---|---|---|
| **Zero-Based Budgeting** | ✅ Full | ✅ Full | ✅ Full | ✅ Full | ⚠️ Partial | ⚠️ Partial |
| **Envelope Methodology** | ✅ | ✅ | ✅ | ✅ | ❌ | ❌ |
| **iOS** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Android** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Web App** | ✅ | ✅ | ✅ | ✅ | ✅ | ❌ |
| **Shared / Family Budgets** | ✅ Real-time | ❌ | ❌ | ✅ Basic | ✅ | ❌ |
| **Offline-First / No Internet Required** | ✅ Full | ⚠️ Partial | ❌ | ❌ | ❌ | ❌ |
| **Recurring Transactions & Bills** | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| **Split Transactions** | ✅ | ✅ | ✅ | ❌ | ✅ | ✅ |
| **Debt Payoff (Snowball/Avalanche)** | ✅ Both | ✅ | ✅ Baby Steps | ❌ | ❌ | ❌ |
| **Goal Tracking** | ✅ 3 types | ✅ | ✅ | ❌ | ✅ | ❌ |
| **Reports & Analytics** | ✅ 5 types | ✅ | ⚠️ Limited | ⚠️ Limited | ✅ | ✅ |
| **Credit Card YNAB-Style Handling** | ✅ | ✅ | ❌ | ❌ | ❌ | ❌ |
| **Net Worth Tracking** | ✅ | ❌ | ❌ | ❌ | ✅ | ✅ |
| **Activity Log (who changed what)** | ✅ | ❌ | ❌ | ❌ | ❌ | ❌ |
| **Push + Email Notifications** | ✅ Both | ⚠️ Limited | ✅ | ❌ | ✅ | ✅ |
| **Free Tier** | ✅ (planned) | ❌ | ✅ | ✅ | ❌ | ❌ |
| **Price (annual)** | ~$60–80 (planned) | $109 | $80 | $80 | $100 | $95 |
| **Open-source / Self-hostable** | ❌ | ❌ | ❌ | ❌ | ❌ | ❌ |

### 2.2 Pricing Analysis

The most successful pricing tier in this market clusters around **$60–80/year**:

- Above $99/year: High churn risk. YNAB's 2024 price hike to $109 triggered a documented mass exodus.
- $80–99/year: Standard premium. Monarch ($100), EveryDollar ($80), Copilot ($95).
- $60–80/year: Value sweet spot. Simplifi ($72) is the fastest-growing post-Mint option in this tier.
- Free tier with meaningful functionality drives top-of-funnel volume (EveryDollar's free tier is their primary acquisition channel).

**Envelope's planned pricing (~$60–80/year with a meaningful free tier) positions it perfectly in the value sweet spot**, undercutting YNAB and Monarch while matching feature depth.

### 2.3 Key Competitive Vulnerabilities to Exploit

| Competitor | Their Weakness | Envelope's Advantage |
|---|---|---|
| YNAB | $109/year, no free tier, steep learning curve | Cheaper, free tier, better onboarding |
| EveryDollar | No offline mode, no shared budgets, tied to Ramsey doctrine | Offline-first, real-time shared budgets, methodology-neutral |
| Goodbudget | Weak Android app (3.4 stars on Play Store), limited features | Flutter ensures parity across platforms |
| Copilot | iOS and Mac only — entire Android market unserved | Cross-platform from day one |
| Monarch Money | 7-day trial (criticized as too short), no free tier | Meaningful free tier, better trial experience |
| Actual Budget | Self-hosted complexity, no mobile-first experience | Fully polished native apps |

---

## 3. The App — What We've Built

### 3.1 Completion Status

The app is **~80% complete** with the remaining 20% being subscription paywall UI, comprehensive QA testing, App Store submission prep, and final polish.

| Phase | Features | Status |
|---|---|---|
| 1 | Foundation, CI/CD, theming, 3 flavors | ✅ Complete |
| 2 | Authentication (email, Google, Apple Sign In) | ✅ Complete |
| 3 | Offline-First Sync Engine (Drift + Supabase) | ✅ Complete |
| 4 | Onboarding (6-step wizard), Account management | ✅ Complete |
| 5 | Envelopes, categories, budget allocation | ✅ Complete |
| 6 | Transactions (CRUD, split, transfers, tags, search) | ✅ Complete |
| 6.5 | Recurring transactions, bill reminders | ✅ Complete |
| 7 | Dashboard (responsive grid, overspend handling) | ✅ Complete |
| 7.5 | Overspend warnings and cover flows | ✅ Complete |
| 8 | Goals and Debt Payoff (snowball/avalanche) | ✅ Complete |
| 9 | Shared Budgets with real-time sync | ✅ ~95% Complete |
| 10 | Reports & Analytics (5 report types, CSV/PDF export) | ✅ Complete |
| 11 | Push & Email Notifications | ✅ Complete |
| 12 | Settings, profile, theme, data export | ✅ ~98% Complete |
| 13 | Subscription management (RevenueCat) | 🟡 ~60% Complete |
| 14 | QA Testing & App Store Launch | ⬜ Pending |

### 3.2 Tech Stack (Enterprise-Grade)

- **Framework**: Flutter 3.41+ — single codebase for iOS, Android, and Web
- **Architecture**: VGV Layered Architecture (industry standard for production Flutter apps)
- **State Management**: Bloc/Cubit — testable, predictable, well-documented pattern
- **Local Database**: Drift (SQLite) with WASM support for web — enables offline-first
- **Backend**: Supabase (Postgres, Auth, Realtime, Edge Functions) — scalable from 0 to millions of users
- **Subscriptions**: RevenueCat — handles App Store, Play Store, and Stripe billing
- **CI/CD**: GitHub Actions — automated builds, tests, and deployment
- **Notifications**: Firebase Cloud Messaging + Supabase Edge Functions (email)

The architecture is designed for scale. Supabase's infrastructure can handle significant user growth without re-architecture. The 13 domain repository packages are independently testable and maintainable.

### 3.3 Unique Differentiators

**1. True Offline-First Architecture**  
Every write operation hits the local Drift database first. The app works with zero internet connectivity. Changes sync automatically when connectivity is restored with per-field conflict resolution. This is technically complex and rare — most competitor apps require an internet connection for core functionality.

**2. Real-Time Shared Budgets**  
Envelope supports multi-user budgets with role-based access (owner/editor/viewer), real-time sync via Supabase Realtime subscriptions, a full activity log tracking every change by every user, and invite-by-email or shareable link. This is the feature most requested by couples, families, and roommates — and the most underserved in the market.

**3. YNAB-Style Credit Card Handling**  
This is a subtle but powerful feature that YNAB users know and value: when you swipe a credit card, the spending is deducted from your envelope (not when you pay the bill). This prevents the common trap of thinking you have money available that's actually owed. Only YNAB implements this correctly among ZBB apps. Envelope does too.

**4. Dual Debt Payoff Strategies (Snowball + Avalanche)**  
Both strategies are implemented with interest calculations, monthly payment schedules, and visual payoff timelines — and users can compare both approaches side by side. EveryDollar only does Baby Steps. YNAB only does basic debt tracking. No other ZBB app offers both strategies with comparison.

**5. Cross-Platform Parity**  
Flutter guarantees that the iOS app, Android app, and web app all have the same features, same design, and same reliability. Goodbudget's Android app has a 3.4-star rating vs their 4.7 iOS rating precisely because this parity is hard to achieve without Flutter.

**6. Clean, Methodology-Neutral Approach**  
YNAB requires you to follow YNAB's way. EveryDollar pushes Ramsey's Baby Steps. Envelope teaches zero-based budgeting through the app itself — without a cult of personality or a mandated methodology. Users can budget the way that works for them.

---

## 4. Business Model

### 4.1 Revenue Model

**Freemium SaaS subscription** with two tiers:

| Tier | Price | What's Included |
|---|---|---|
| **Free** | $0 | 1 budget, 2 shared members, core budgeting features, 90-day history |
| **Premium** | ~$6–7/month ($70–80/year) | Unlimited budgets, unlimited shared members, full reports, CSV/PDF export, advanced debt tools, longer history, custom envelope colors |

**Revenue infrastructure already in place**: RevenueCat handles iOS App Store billing, Google Play billing, and Stripe for web — all from a single integration. Free trial support is built in.

### 4.2 Revenue Projections (Conservative)

These projections are based on comparable apps' publicly disclosed growth rates and are intentionally conservative.

**Year 1 (Post-Launch)**

| Metric | Estimate | Basis |
|---|---|---|
| Total Downloads | 10,000–25,000 | Organic App Store discovery + social media; Goodbudget grew to 3M from zero |
| Free-to-Premium Conversion | 8–12% | Industry average for genuine freemium budgeting apps |
| Paying Users (Year 1) | 800–3,000 | |
| Average Revenue Per User | $70/year | |
| **Year 1 ARR** | **$56,000–$210,000** | |

**Year 3 (With Marketing)**

| Metric | Estimate | Basis |
|---|---|---|
| Total Downloads | 150,000–300,000 | |
| Paying Users | 12,000–36,000 | |
| **Year 3 ARR** | **$840,000–$2.5M** | Monarch reached $12.6M ARR; Envelope projects 1/5th to 1/10th of that |

> For reference: Monarch Money grew 20x after Mint's shutdown. At just 1% of that growth rate applied to Envelope's scenario, Year 3 ARR exceeds $1M.

### 4.3 Cost to Complete (Estimated)

Remaining work to reach App Store submission:

| Work Item | Estimate |
|---|---|
| Complete RevenueCat paywall UI (Phase 13) | 2–3 weeks dev |
| QA testing (50+ test cases per QA plan) | 3–4 weeks |
| App Store / Play Store asset creation | 1 week |
| App Store review submission & iterations | 1–2 weeks |
| **Total to launch** | **~7–10 weeks** |

The backend (Supabase) has a generous free tier for early users and a predictable cost model that scales with revenue. The app does not require expensive proprietary infrastructure.

---

## 5. Risks and Mitigations

| Risk | Severity | Mitigation |
|---|---|---|
| **Bank connection reliability** | High | Supabase direct integrations + open banking CFPB 1033 rule (finalized 2024) reducing Plaid dependency. Manual entry always works with offline-first arch. |
| **Market saturation** | Medium | Clear differentiation (shared budgets, offline-first, Android ZBB, pricing). Long-tail of unsatisfied users is large. |
| **User acquisition cost** | Medium | App Store organic discovery for finance apps is strong. Post-Mint migration traffic is still active in communities (Reddit r/personalfinance, r/ynab). |
| **YNAB / Monarch response** | Low | Incumbents cannot easily replicate offline-first architecture or meaningfully drop price points (they have investor/overhead obligations). |
| **Ongoing maintenance cost** | Low | Supabase scales cost-proportionally. Flutter reduces platform-specific maintenance. Single codebase for 3 platforms. |
| **App Store approval** | Low | Standard finance apps are approved routinely. Apple/Google guidelines followed throughout development. |

---

## 6. Strategic Framing for the Company

### Why This Benefits the Company

**1. Brand / Talent Signal**  
A successful consumer app in the App Store is a meaningful signal to technical recruits. "We build and ship our own products" is a differentiator in hiring. Engineers want to work at companies that create real products.

**2. Low Financial Risk, Real Upside**  
The app is already 80% built. The remaining investment is 7–10 weeks of dev time. The downside is capped (a finished app in the App Store that generates some revenue or doesn't). The upside is a subscription SaaS product owned by the company with growing ARR.

**3. Internal Tool Potential**  
A zero-based budgeting app used internally (for team expense tracking, project budget management, departmental allocation) has internal productivity value. The app already supports multiple shared budgets and role-based access.

**4. Supabase / Flutter Expertise**  
The codebase demonstrates deep expertise in Supabase, Flutter, Bloc architecture, offline-first sync, and RevenueCat. This expertise is directly transferable to client projects or internal products using the same stack.

**5. First-Mover Advantage Window Is Closing**  
The post-Mint migration window (March 2024) is still partially open, but will close as competitors solidify their user bases. Launching in the next 3–6 months captures residual migration traffic. Waiting 12–18 months significantly reduces this advantage.

---

## 7. Comparable Company Outcomes

| Company | App | Outcome |
|---|---|---|
| Ramsey Solutions | EveryDollar | 12M+ downloads, $3.7B tracked by users in 2025, targeting $20B/year by 2030 |
| Monarch Money | Monarch | $12.6M ARR (2025), raised $75M Series B at $850M valuation (May 2025) |
| You Need A Budget | YNAB | ~700K MAU, estimated $50M+ ARR, profitable and growing despite price increases |
| Goodbudget (Dayspring Technologies) | Goodbudget | 3M+ downloads, stable profitable indie product |
| Actual Budget | Actual | Open-source, self-sustaining; demonstrates pent-up demand for YNAB alternatives |

The ZBB personal finance app market has proven it can support multiple successful, profitable products simultaneously. This is not a winner-take-all market.

---

## 8. Recommendation

**Launch Envelope to the App Store within the next 2–3 months.**

The following minimum requirements are already met:
- Full feature set comparable to leading paid competitors
- Three unique differentiators no single competitor offers (offline-first + shared budgets + Android ZBB parity)
- Monetization infrastructure integrated (RevenueCat)
- CI/CD pipeline for automated releases
- 13 independent domain packages with clean separation of concerns
- Production-ready backend (Supabase) capable of scaling to millions of users

**Suggested next steps**:
1. Allocate ~8 weeks of dedicated dev time to complete Phase 13 (subscriptions) and Phase 14 (QA + launch)
2. Create App Store / Play Store listings and screenshots
3. Submit to TestFlight (iOS) and Internal Testing (Android) for internal validation
4. Submit to App Store and Google Play
5. Soft-launch with a landing page targeting r/personalfinance, r/ynab, and Mint migration communities

---

## Appendix A — Competitor Pricing Summary

| App | Monthly | Annual | Free Tier? | Trial |
|---|---|---|---|---|
| YNAB | $14.99 | $109 | No | 34 days |
| EveryDollar | $17.99 | $80 | Yes (manual only) | N/A |
| Monarch Money | $14.99 | $100 | No | 7 days |
| Copilot | $13 | $95 | No | 30 days |
| Quicken Simplifi | — | $72 | No | 30-day MBG |
| Goodbudget | $10 | $80 | Yes (10 envelopes) | N/A |
| Rocket Money | $6–12 | — | Yes (limited) | N/A |
| PocketGuard | $13 | $75 | Yes (limited) | N/A |
| **Envelope (planned)** | **~$7** | **~$70–80** | **Yes (meaningful)** | **TBD** |

---

## Appendix B — Market Trend Summary

1. **AI in personal finance**: Automatic categorization and spending anomaly detection are becoming expected. Integration opportunity in Phase 15+ roadmap.
2. **Open Banking (CFPB 1033)**: Direct bank APIs reduce reliance on Plaid, improving reliability — Envelope's #1 user trust factor.
3. **Subscription fatigue**: Users resist $100+/year apps. Envelope's $70–80 sweet spot positions well.
4. **Couples budgeting demand**: The most requested and underdelivered feature in the category. Envelope already has it.
5. **Android ZBB gap**: Copilot (the best-designed ZBB app) is iOS-only. The Android ZBB market is substantially open.

---

*Document prepared by Ketul Makwana | April 2026 | Envelope v1.0 Pre-Launch*
