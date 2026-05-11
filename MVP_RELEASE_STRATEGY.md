# Envelope — MVP Release Strategy

**Author:** Strategy document for shipping out of the polish trap
**Date:** 2026-05-11
**Target ship date:** 2026-06-22 (6 weeks, hard deadline)
**Status:** Living document — review weekly until launch

---

## TL;DR

You are not stuck building. You are stuck *polishing*. The app is ~85% done with all 13 features built. The remaining 15% is dragging because there is no hard ship date, no "done" definition, and the scope keeps expanding to match new bugs. This document fixes that.

**Three decisions encoded here:**

1. **Hard ship date 2026-06-22** — public commitment, no extension allowed for non-blockers.
2. **MVP scope freeze today** — only 7 of 14 features are launch-critical; the other 7 ship "as-is" or get hidden behind a "Beta" flag.
3. **Bug triage by ship-blocker rule** — fix only if it causes data loss, crash, payment failure, or blocks the core flow. Everything else moves to v1.0.1 (patch within 14 days post-launch).

---

## 1. The Polish Trap — Why You Are Stuck

### Symptoms you already have

- 19 open `fix/tc-*` branches (each one feels urgent; none are blocking first-time use).
- "Just one more fix" loop: each fix uncovers an edge case, which uncovers another.
- Scope keeps growing because every QA pass adds tests for features you could have cut.
- No external pressure to ship — no beta users waiting, no announced date, no investor deadline.
- You measure progress in commits, not in users.

### Why this is happening

Indie founders ship when external pain exceeds internal pain. Right now your internal pain (perfectionism) is higher than external pain (no one is waiting). That ratio must flip. Reid Hoffman: *"If you are not embarrassed by the first version of your product, you've launched too late."* Your v1 should slightly embarrass you. If it doesn't, you over-built.

### Escape mechanics — pick all of these

| Mechanism | Why it works | Do this week |
|-----------|-------------|--------------|
| **Public deadline** | Reputational stake creates external pressure | Tweet/post: "Envelope ships June 22, 2026. Beta opens June 1." Don't delete it. |
| **Beta waitlist with date** | Real users waiting > imagined users you'll never satisfy | Spin a Carrd/landing page with email capture and "Launching June 22" |
| **Tell 3 people the date** | Social accountability beats willpower | DM them today, ask them to ping you on June 22 |
| **Feature freeze NOW** | Stops scope creep at the source | Today: delete or stash any half-built feature branch not in MVP scope |
| **Daily polish cap** | Caps the time-sink | Max 90 min/day on "polish" tasks; rest goes to launch prep |
| **Ship-blocker rule** | Removes 80% of fixes from the critical path | See section 4 |
| **Pre-order or paid beta** | Money = ultimate commitment device | Offer $20 lifetime to first 100 beta users via the landing page |

### Mental reframe

Stop thinking "v1 = the app." Think "v1 = a learning instrument." The goal of v1 is not perfection — it's:

1. Will anyone pay for this? (signal in 30 days)
2. What do real users break that QA didn't catch? (signal in 7 days)
3. What 3 things do users beg for? (signal in 14 days)

You cannot answer any of those questions while polishing. Only shipping answers them.

---

## 2. Competitor Landscape — Where Envelope Fits

### The market today (mid-2026)

| App | Pricing | Method | Bank sync | Shared | Platforms | Weakness |
|-----|---------|--------|-----------|--------|-----------|----------|
| **YNAB** | $109/yr | Zero-based | Yes (Plaid) | Family flat | iOS, Android, Web, Watch | Expensive; online-first; couples access has no roles |
| **Monarch** | $99.99/yr | Cash flow | Yes | Yes | iOS, Android, Web | Not strict ZBB; complex |
| **EveryDollar** | $79.99/yr (Premium) | Zero-based | Premium only | Free tier | iOS, Android, Web | Free tier is bare; Ramsey brand |
| **Copilot** | $95/yr | Cash flow | Yes | No | **iOS only** | No Android (huge gap) |
| **Goodbudget** | $80/yr Plus | Envelope | No | Yes (sync) | iOS, Android, Web | Dated UX; manual only |
| **PocketGuard** | $74.99/yr | ZBB-ish | Yes | No | iOS, Android | Less budgeting depth |
| **Simplifi** | $47.88/yr | ZBB-ish | Yes | Limited | iOS, Android, Web | Quicken brand baggage |
| **Mint** | Dead (Mar 2024) | — | — | — | — | 3.6M displaced users still hunting |

### Envelope's defensible moats

1. **Offline-first local DB (Drift) with sync** — only Goodbudget is comparable; everyone else fails without internet.
2. **Real-time shared budgets with roles + activity log** — YNAB family is flat access; this is genuinely better.
3. **Cross-platform parity via Flutter** — Copilot has no Android. That's a $0 acquisition cost gap to exploit.
4. **Cheaper** — undercut YNAB by 30–50%; meaningful free tier.
5. **Privacy-first positioning** — no Plaid means no third-party data sharing; pitch as feature not bug.
6. **India-friendly pricing & flavors** — almost no competitor takes India seriously; rupee pricing + multi-currency.

### Envelope's real gaps (don't pretend these don't exist)

| Gap | Honest answer for launch | Fix by |
|-----|-------------------------|--------|
| No bank sync | Position as "manual = mindful budgeting"; promise Plaid in 90 days | v1.2 (Aug–Sept) |
| No CSV import | **Ship this pre-launch** — 1 week of work, critical for Mint refugees | v1.0 |
| No iOS widgets | Acceptable for launch; ship in 30 days | v1.1 |
| No community | Spin a Discord on launch day | Launch week |
| No methodology brand | Don't try to out-YNAB YNAB on rules. Pitch envelope as *"YNAB for people who don't want to be lectured"* | Positioning |

---

## 3. MVP Scope Lock — What Ships v1.0 vs Later

**Rule:** A feature ships in v1.0 only if (a) it's required for the core zero-based loop, OR (b) it's a moat from section 2 that requires near-zero additional QA effort.

### v1.0 — Ships June 22 (lock today)

| Feature | Why in scope | Test depth |
|---------|-------------|------------|
| **Auth** (email, Google, Apple) | Required | Full P0/P1 |
| **Onboarding** (currency, accounts, income, envelopes, allocations) | Required for first-run | Full P0/P1 |
| **Accounts** (CRUD, types, manual reconcile) | Required | P0 only |
| **Envelopes** (groups, CRUD, color) | Core ZBB primitive | Full P0/P1 |
| **Budget** (period nav, allocate, Ready to Assign) | Core ZBB loop | Full P0/P1 |
| **Transactions** (CRUD, splits, transfers) | Core ZBB loop | Full P0/P1 |
| **Dashboard** (envelope grid, RTA card, overspend) | Primary screen | Full P0/P1 |
| **Settings** (profile, theme, base currency, export, delete account) | Required for store compliance | P0 only |
| **Subscription** (RevenueCat paywall + 2 premium gates) | Required for monetization | Full P0/P1 — non-negotiable |
| **CSV import** (transactions) | Mint-refugee moat, 1 week build | P0 happy path only |

### v1.1 — Ships within 30 days post-launch (July 22)

Ship these "behind a Beta tag" in v1.0 if already built. Don't hide them, but don't market them. Set user expectation correctly.

- **Recurring transactions** — already built. Ship as "Beta", fix bugs in v1.1.
- **Goals** (basic savings target only) — ship simplest type as Beta; cut "monthly contribution" and "debt payoff comparison" to v1.1.
- **Reports** (spending + income/expense only) — cut Budget vs Actual, Net Worth, Trends to v1.1.
- **Notifications** (push only; cut email) — already built; ship push, defer email Edge Functions.
- **Multi-currency per account** — ship single-currency-per-budget for v1.0; multi-currency in v1.1. Reduces 70% of FX QA surface immediately.

### v1.2 — Ships within 90 days post-launch (mid-September)

- **Shared budgets** (real-time, roles, activity log)
- **Bank sync** (Plaid) — paid add-on, your top differentiator gap-closer
- **Debt strategies** (snowball + avalanche comparison)
- **Net worth tracking**
- **Full reports suite**
- **iOS widgets, Android widgets**

### Cut entirely (or move to v2)

- Apple Watch app
- Browser extension
- AI receipt OCR
- Email weekly summary
- Heatmap on transactions
- Bill reminder badges
- Advanced goal types ("Refill Up To", "Plan Your Spending")

### Hard rule

**No feature added to v1.0 scope after today (2026-05-11).** If you find yourself wanting to add one, write it on a v1.1 list and walk away.

---

## 4. Essential QA Scope — Test Only What Blocks Ship

### Ship-blocker definition

A bug is a ship-blocker if and only if it causes one of:

1. **Data loss** — user's transactions/envelopes/allocations get corrupted or deleted.
2. **Crash on first launch or onboarding** — first impression failure.
3. **Auth failure** — user can't log in or sign up.
4. **Payment failure** — RevenueCat purchase fails or doesn't unlock premium.
5. **Core loop broken** — user cannot: create envelope → assign money → log transaction → see updated balance.
6. **Store rejection** — Apple/Google compliance failure (privacy disclosure, account deletion, etc.).

**If a bug is not in this list, it ships. Period.** File it in a `KNOWN_ISSUES_V1.md` doc and fix in v1.0.1.

### Test scope for v1.0 (the only QA work that matters now)

Run only these test sets. Skip the rest.

| Test set | Scope | Est. effort |
|----------|-------|-------------|
| **Smoke test** | Full happy-path: signup → onboarding → assign → log txn → see balance → log out → log back in → data persisted | 1 day |
| **TC-1 Auth (P0)** | Email signup, Google, Apple, password reset, logout | 1 day |
| **TC-2 Onboarding (P0)** | All 6 steps complete end-to-end on iOS + Android | 1 day |
| **TC-3 Accounts (P0 only)** | Create account, edit, delete, balance updates with transactions | 0.5 day |
| **TC-4 Envelopes (P0+P1)** | Create group, create envelope, color, archive | 0.5 day |
| **TC-5 Budget (P0+P1)** | Period nav, allocate, Ready to Assign math correct, overspend handling | 1 day |
| **TC-6 Transactions (P0+P1)** | CRUD, split, transfer, search, soft-delete undo | 1.5 days |
| **TC-7 Dashboard (P0)** | Grid renders, RTA correct, overspend visual | 0.5 day |
| **TC-13 Subscription (P0+P1)** | Purchase, restore, gate enforcement, cancellation, sandbox + prod | 2 days |
| **TC-15 Settings (P0)** | Theme switch, export data works, delete account works | 0.5 day |
| **App-store compliance** | Privacy policy URL, account deletion, data disclosure, crash-free first launch | 1 day |
| **Persona scenario** | Run 1 full persona end-to-end on real device (iOS + Android) | 1 day |

**Total: ~11 working days of QA.** That fits inside 3 weeks with buffer.

### Tests to defer to v1.1 cycle

- TC-8 Recurring (advanced rules, custom cadence) — only test simple monthly recurring for v1.0.
- TC-9 Shared Budgets — feature deferred entirely.
- TC-10 Goals — only test simple savings target P0; defer rest.
- TC-11 Reports — only test spending report renders; defer export edge cases.
- TC-12 Notifications — only test push notification on bill reminder; defer email.
- TC-14 Multi-currency / FX — feature deferred to v1.1.

### Open `fix/tc-*` branches — triage in one sitting

Tomorrow morning, sit down for 60 min and apply the ship-blocker rule to all 19 open fix branches:

1. **Ship-blocker** → merge this week.
2. **Not blocker but already fixed** → merge anyway (it's free progress).
3. **Not blocker, not fully fixed** → close the branch, add to `KNOWN_ISSUES_V1.md`, move on.

Stop opening new `fix/tc-*` branches unless the bug meets the ship-blocker rule.

---

## 5. Six-Week Launch Roadmap

**Today:** 2026-05-11 (Mon, Week 0)
**Ship:** 2026-06-22 (Mon, Week 6)

### Week 0 (May 11–17) — Lock and commit

- [ ] Read this doc; commit to the dates.
- [ ] Public deadline announcement (Twitter/X + LinkedIn + IndieHackers).
- [ ] Spin landing page with beta waitlist (Carrd or framer.com — 2 hours, not 2 days).
- [ ] DM 3 people the date.
- [ ] Triage all 19 `fix/tc-*` branches with ship-blocker rule.
- [ ] Cut deferred features behind a "Beta" tag in code (1 day of refactor).
- [ ] Build CSV import for transactions (start; finish in week 1).

### Week 1 (May 18–24) — Subscription + CSV import

- [ ] Finish RevenueCat paywall UI and premium gates (Phase 13 → 100%).
- [ ] Finish CSV import.
- [ ] Internal sandbox purchase testing (StoreKit + Play Billing).
- [ ] Landing page live; start collecting beta emails.

### Week 2 (May 25–31) — Focused QA pass 1

- [ ] Run all 11 test sets above on iOS.
- [ ] Run same on Android.
- [ ] File only ship-blocker bugs.
- [ ] Daily polish-cap: 90 min/day.

### Week 3 (June 1–7) — Beta launch

- [ ] **Open beta on June 1** — TestFlight + Play Store internal track.
- [ ] Email beta waitlist; aim for 50–100 testers.
- [ ] Recruit from r/personalfinance, r/ynab, r/povertyfinance (one disclosed post each).
- [ ] Set up Discord/Slack for beta feedback.
- [ ] Daily bug triage: ship-blocker only.

### Week 4 (June 8–14) — Beta fixes + store assets

- [ ] Fix only ship-blockers reported by beta.
- [ ] App Store screenshots (6 per platform — use real beta data, not Lorem Ipsum).
- [ ] App Store/Play Store copy.
- [ ] Privacy policy, terms of service, support email.
- [ ] Submit to App Store + Play Store **by June 15** (allow 7 days for review).

### Week 5 (June 15–21) — Pre-launch marketing prep

- [ ] Product Hunt page drafted, hunter lined up.
- [ ] HackerNews "Show HN" post drafted.
- [ ] Reddit posts drafted (r/ynab, r/personalfinance, r/povertyfinance, r/budgeting, r/India personal finance subs).
- [ ] IndieHackers post drafted.
- [ ] Email blast to waitlist drafted.
- [ ] 3 micro-influencer pitches sent (personal finance TikTok/YouTube).
- [ ] Launch-day tracker dashboard ready (downloads, signups, conversions).

### Week 6 (June 22) — Public launch

- [ ] **Monday June 22, 6 AM PT**: Product Hunt goes live.
- [ ] Same morning: HN Show HN, Reddit posts, IndieHackers, email blast, Twitter thread.
- [ ] Spend the day responding to every comment within 30 min.
- [ ] Daily standup with yourself: what broke, what to fix tonight, what to fix in v1.0.1.

### Week 7+ — Post-launch loop

- See section 8.

---

## 6. Launch Strategy

### Soft launch (June 1, beta)

**Goal:** Get 50–100 real users using the app daily for 3 weeks to surface ship-blockers QA missed.

**Channels:**

- Landing page waitlist (started week 0).
- Reddit: one disclosed post in r/ynab, r/personalfinance, r/povertyfinance, r/budgeting — "I built a YNAB alternative; looking for 50 beta testers." Be upfront that you built it.
- IndieHackers: "Built a YNAB alternative in Flutter — looking for beta testers."
- Twitter/X: thread with screenshots, ask for RTs.
- Personal network: every person who knows you uses money. Ask 20 friends.

**Incentive:** Lifetime free Premium for the first 100 beta users who file at least 3 bug reports or feedback notes. Cheap to give; high commitment from them.

### Public launch (June 22)

**Channels (in priority order):**

1. **Product Hunt** — biggest single-day distribution channel for indie SaaS. Line up a hunter (someone with >500 followers) 2 weeks ahead. Launch Monday 12:01 AM PT. Respond to every comment within 30 min for first 12 hours. Realistic target: top 5 of the day = 1,000–3,000 visits, 100–300 signups.
2. **HackerNews Show HN** — same morning. Title: "Show HN: Envelope — offline-first zero-based budgeting (YNAB alternative for $39/yr)". Don't astroturf. Reply to every comment substantively.
3. **Reddit** — r/personalfinance (strict rules — read them), r/ynab (label clearly as alternative), r/povertyfinance, r/budgeting, r/IndiaInvestments, r/IndianStreetBets (India angle), r/AndroidApps. Stagger over 48 hours to avoid spam flags.
4. **IndieHackers** — "Launched my YNAB alternative today" post; include MRR transparency.
5. **Twitter/X** — long-form thread with the story: why you built it, what's different, screenshots, link.
6. **LinkedIn** — different audience; emphasize couples/family + small business owner angle.
7. **Email blast** — to the waitlist; one-line subject, one-paragraph body, one CTA.

### Geographic launch order

Launch in all stores globally Day 1, but **prioritize marketing in 5 markets** in this order:

1. **India** — your home market, almost no serious competitor takes India seriously, rupee pricing, Hindi support later. Pitch to YourStory, Inc42, FactorDaily, MoneyControl. Reach Indian personal finance YouTubers (Pranjal Kamra, Asset Yogi audiences).
2. **United States** — Mint refugees (3.6M+); Reddit-heavy.
3. **United Kingdom** — fewer ZBB competitors; high Android share.
4. **Canada** — overlapping audience with US Reddit communities.
5. **Australia** — strong YNAB user base; price-sensitive.

### Pricing (lock today)

| Tier | Price | Includes | Strategy |
|------|-------|----------|----------|
| **Free** | $0 | 1 budget, 1 device, up to 5 envelopes, manual entry, basic dashboard | Wide funnel; acquisition |
| **Premium Monthly** | $4.99/mo (₹399 India) | Unlimited envelopes, multi-device, CSV import, all goal types, all reports | Friction-free upgrade |
| **Premium Annual** | $39/yr (₹2,999 India) | Same as monthly, 35% discount | Default upsell after 14-day trial |
| **Lifetime (launch only)** | $99 one-time (₹4,999 India) | Premium forever | First 500 customers only, time-limited, AppSumo-style |

**Trial:** 34-day free trial (matches YNAB; longer than 30 = perceived as more generous; you'll see whether it pays back in 90 days).

**Lifetime cap:** Lifetime offer ends after 500 sales or 30 days, whichever first. Creates urgency, gives you a $50K cash injection if all 500 sell.

---

## 7. Marketing Strategy

### Pre-launch (now → June 22): Build the waitlist

**Target:** 1,500 emails on waitlist by launch day.

**Channels:**

| Channel | Effort | Expected emails |
|---------|--------|-----------------|
| Landing page + SEO (set up once) | 4 hrs | 100 organic |
| Twitter/X "build in public" — 3 posts/week | 30 min/day | 200 |
| LinkedIn — 1 post/week | 30 min/wk | 100 |
| Reddit — 1 disclosed post/wk in r/ynab, r/personalfinance, r/SideProject | 1 hr/wk | 400 |
| IndieHackers — weekly progress post | 1 hr/wk | 200 |
| Personal network DMs | 2 hrs total | 100 |
| Beta tester referrals | passive | 200 |
| Press pitches (India) | 4 hrs | 200 |

### Launch day → +30 days: Convert waitlist + first paid users

**Target:** 5,000 downloads, 1,500 active users, 150 paying ($1,500–5,000 MRR depending on plan mix).

**Acquisition channels (ranked by expected ROI for indie SaaS in this category):**

1. **Reddit organic** — answer questions in r/personalfinance, r/budgeting, r/ynab. Don't spam. Disclose. Goal: become a known helpful voice over 90 days. Bend the funnel toward you organically. **Free; 30 min/day.**
2. **App Store / Play Store ASO** — bid on keywords: "YNAB alternative", "envelope budget", "zero based budget", "couples budget", "budget app offline", "mint replacement". Update title and subtitle weekly based on conversion data. **$0 if you don't run ads; $200/mo if you do.**
3. **Product Hunt afterglow** — submit to Product Hunt newsletter, Hunters Club, Sidebar.io. Cross-list to Beta List, AppSumo, Uneed, Toolify.
4. **YouTube personal finance creators** — pitch 10 micro-influencers (10K–100K subs) with free Premium accounts. Conversion is 1–3% but creators stay relevant for years. Indian creators are 1/5th the cost of US ones. **$500–2,000 total budget.**
5. **TikTok / Reels / Shorts** — your own account. 3 videos/week. Hooks: "Why YNAB is too expensive", "How my wife and I budget without fighting", "I built a budget app — first 1,000 users". Indian creators in personal finance space are cheap to partner with. **$0 time-cost only.**
6. **SEO content** — 5 cornerstone articles:
   - "YNAB Alternative: Why Envelope is $70 cheaper"
   - "Mint Shutdown: What to use in 2026"
   - "Best Budget App for Couples"
   - "Envelope Budgeting for Beginners"
   - "How to Budget Irregular Income"
   Rank in 3–6 months. **$0 if you write them; $500–2,000 if you hire.**
7. **Paid app install ads** — defer until you have a working paid funnel (CAC < LTV). Probably month +2.

### Messaging — pick ONE positioning, repeat it everywhere

**Top candidate:** *"Envelope: zero-based budgeting that respects your wallet, your privacy, and your partner."*

- "Your wallet" → cheaper than YNAB
- "Your privacy" → offline-first, no Plaid, no data selling
- "Your partner" → real-time shared budgets with roles

Secondary tagline (Indian market): *"Built for Indian families. Multi-currency. Rupee-priced. Real-time shared budgets."*

**Don't dilute.** Pick this or any other single positioning and use it on every screenshot, every Reddit reply, every store description, every landing page H1. Rule: if you can't recite your positioning in 8 seconds, no one else can either.

### What to avoid

- **Don't astroturf Reddit.** They will sniff it; you'll get permabanned from r/personalfinance.
- **Don't run paid ads pre-launch.** Acquisition is meaningless without retention data.
- **Don't write 10,000-word "we built X" Medium posts.** Nobody reads them. A 280-character tweet with 1 screenshot outperforms.
- **Don't price like YNAB.** You undercut on purpose. Don't apologize for it.
- **Don't promise bank sync at launch.** Promise it in 90 days. Set expectations honestly; over-deliver.

---

## 8. Post-Launch: First 90 Days

### Week 1 post-launch

- v1.0.1 patch ships within 7 days with top 10 ship-blocker bugs from real users.
- Daily monitoring: crashes, paywall conversion, signup-to-active rate.
- Reply to every App Store / Play Store review within 24 hrs.

### Days 8–30: v1.1 release

Ship the deferred features in priority order:

1. iOS widgets
2. Goals — all types
3. Reports — full suite
4. Recurring transactions — out of Beta
5. Multi-currency per account
6. Email notifications

### Days 31–90: v1.2 release

Top moat-fillers:

1. **Shared budgets** out of Beta (your couples differentiator).
2. **Bank sync (Plaid)** as paid add-on — your biggest gap-closer vs YNAB.
3. **Debt strategy comparison** (snowball + avalanche).
4. **Android widgets.**

### Decision gates (kill or persevere)

| Metric @ Day 30 | Threshold | If below, do this |
|----------------|-----------|-------------------|
| Total signups | 1,000 | Reassess positioning — message isn't landing |
| Day-7 retention | 30% | Investigate onboarding; ship dashboard polish |
| Free → paid conversion | 3% | Tighten paywall gates; reduce free tier features |
| Paying users | 100 | Reassess price, trial length, gate placement |
| MRR | $500 | Talk to 20 churned users; rebuild based on what they say |
| Day-30 retention | 15% | Stop adding features; fix the core loop |

If 3+ metrics are below threshold, do a 14-day pivot sprint based on user interviews. Don't add features; remove friction.

---

## 9. Risk Register

| Risk | Likelihood | Impact | Mitigation |
|------|-----------|--------|------------|
| Subscription paywall has a bug → no revenue | Medium | High | Spend 2 days in sandbox + 1 day in prod-test before launch |
| App Store rejection (privacy, account deletion) | Medium | High | Submit by June 15; have 7 days buffer for resubmit |
| User data corruption from sync bug | Low | Very High | Don't enable multi-device sync for free tier on Day 1; gate behind Premium for the first 14 days while you watch logs |
| Reddit backlash (perceived as spam) | Medium | Medium | Disclose every post; never use alt accounts; participate before promoting |
| No one cares (low launch traffic) | Medium | High | Have v1.0.1 ready; launch week 2 push to alternate channels |
| You re-enter polish loop after launch | High | Medium | Re-read this doc weekly; the rule "ship to learn" applies forever |
| Competitor copies your positioning | Low | Low | They won't move fast enough; ship faster |

---

## 10. Personal Commitments (sign here)

I, _________________, commit to:

1. Ship Envelope v1.0 on **June 22, 2026** even if it embarrasses me slightly.
2. Not add any feature to v1.0 scope after **May 11, 2026**.
3. Apply the ship-blocker rule to every bug — no exceptions.
4. Cap polish work at **90 minutes/day** from now until launch.
5. Announce the launch date publicly within 48 hours.
6. Re-read this doc every Monday morning until June 22.

Signed: _________________________ Date: _________________

---

## Appendix A — What goes in `KNOWN_ISSUES_V1.md`

Create this file before launch. Be honest in it. Link it from the in-app Help page and the App Store description. Format:

```
## Known issues in v1.0

- Multi-currency: FX rates update once daily. Live rates coming in v1.1.
- Shared budgets: In beta. Concurrent edits may need a refresh. v1.2 will GA this.
- Recurring transactions: Custom cadence may behave unexpectedly across DST. Use weekly/monthly for now.
- Reports: Only spending + income/expense available. Net worth, trends, budget-vs-actual coming in v1.1.
- iOS widgets: Coming in v1.1 (by July 22).
- Bank sync: Coming in v1.2 (by September 22).
```

Users respect transparency. They punish surprises.

---

## Appendix B — Reading list for the polish trap

- *The Lean Startup* — Eric Ries (Build → Measure → Learn)
- *Shape Up* — Ryan Singer (fixed time, variable scope; the opposite of what you're doing now)
- Paul Graham, "Do Things That Don't Scale"
- Reid Hoffman: *"If you are not embarrassed by the first version of your product, you've launched too late."*
- Jason Fried (Basecamp): *"You can always do more later."*

---

**End of strategy. Ship the app.**
