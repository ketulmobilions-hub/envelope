# Envelope App — Project Timeline & Deadlines

## Progress

| Phase | Name | Issues | Status | Completed |
|-------|------|--------|--------|-----------|
| 1 | Project Foundation | #1–#5 | Done | Mar 10 |
| 2 | Authentication | #6–#8 | Done | Mar 11 |
| 3 | Sync Engine | #9–#10 | Done | Mar 11 |
| 4 | Onboarding & Accounts | #11–#13 | Done | Mar 12 |

## Pace Analysis

From Phases 1–4 (git history March 10–12):

| Phase | Issues | Complexity | Actual Time |
|-------|--------|------------|-------------|
| 1 — Foundation | 5 | Low (scaffolding) | ~1 day |
| 2 — Auth | 3 | Medium (Supabase + UI) | ~1 day |
| 3 — Sync | 2 | Medium-High (engine) | ~0.5 day |
| 4 — Onboarding & Accounts | 3 | Medium (wizard + CRUD) | ~1.5 days |

**Average throughput: ~3 issues/day** for repo+bloc+UI pattern.

### Complexity Adjustment for Remaining Phases

Early phases were faster because:
- Scaffolding (Phase 1) is boilerplate
- Auth/Sync followed well-known patterns
- Account CRUD is straightforward

Remaining phases are harder because:
- **Transactions** (Phase 6): splits, transfers, paired entries, recurring rules — most complex feature
- **Shared Budgets** (Phase 9): Realtime subscriptions, role-based access, Edge Functions
- **Subscriptions** (Phase 13): RevenueCat + Stripe integration, 3rd party SDKs
- **Reports** (Phase 10): Chart libraries, aggregation queries, export formats

Estimated throughput drops to **~1.5–2 issues/day** for complex phases.

---

## Detailed Timeline

**Start date: Thursday, March 12, 2026**
**Working days: Monday–Friday only (full-time, 7-8+ hrs/day)**

### Week 1: March 12–14 (3 days) — Phase 5 Start

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| 1 | Thu Mar 12 | #14 | envelope_repository package |
| 2 | Fri Mar 13 | #15 | budget_repository package |
| 3 | Mon Mar 16 | #16 | Envelopes feature (Bloc + UI) |

### Week 2: March 17–21 (5 days) — Phase 5 Finish + Phase 6

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| 4 | Tue Mar 17 | #17 | Budget allocation feature (Bloc + UI) |
| 5 | Wed Mar 18 | — | **Phase 5 complete → merge dev to main** |
| 5 | Wed Mar 18 | #18 | transaction_repository package |
| 6-7 | Thu-Fri Mar 19-20 | #19 | Transactions feature (Bloc + UI) — complex |

### Week 3: March 24–28 (5 days) — Phase 6 Finish + Phase 7 + Phase 8

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| 8 | Mon Mar 24 | #20 | Recurring transactions & bill reminders |
| 9 | Tue Mar 25 | — | **Phase 6 complete → merge dev to main** |
| 9 | Tue Mar 25 | #21 | Dashboard feature (Bloc + UI) |
| 10 | Wed Mar 26 | #22 | Overspend handling flow |
| — | Wed Mar 26 | — | **Phase 7 complete → merge dev to main** |
| 11 | Thu Mar 27 | #23 | goal_repository package |
| 12 | Fri Mar 28 | #24 | Goals & debt tracking feature |

### Week 4: March 31–April 4 (5 days) — Phase 8 Finish + Phase 9

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| 13 | Mon Mar 31 | — | **Phase 8 complete → merge dev to main** |
| 13 | Mon Mar 31 | #25 | sharing_repository package |
| 14-15 | Tue-Wed Apr 1-2 | #26 | Shared budget feature (Bloc + UI) |
| 16-17 | Thu-Fri Apr 3-4 | #27 | Supabase Realtime integration |

### Week 5: April 7–11 (5 days) — Phase 9 Finish + Phase 10 + Phase 11

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| 18 | Mon Apr 7 | — | **Phase 9 complete → merge dev to main** |
| 18 | Mon Apr 7 | #28 | report_repository package |
| 19-20 | Tue-Wed Apr 8-9 | #29 | Reports & analytics feature (charts, export) |
| — | Wed Apr 9 | — | **Phase 10 complete → merge dev to main** |
| 21 | Thu Apr 10 | #30 | FCM push notifications setup |
| 22 | Fri Apr 11 | #31 | Email notifications (Edge Functions) |

### Week 6: April 14–18 (5 days) — Phase 11 Finish + Phase 12

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| 23 | Mon Apr 14 | #32 | Notification preferences UI |
| — | Mon Apr 14 | — | **Phase 11 complete → merge dev to main** |
| 24 | Tue Apr 15 | #33 | Settings feature |
| 25 | Wed Apr 16 | #34 | GDPR & privacy compliance |
| 26 | Thu Apr 17 | #35 | Undo & confirmation dialogs |
| 27 | Fri Apr 18 | #36 | Platform polish (Android/iOS/Web) |

### Week 7: April 21–25 (5 days) — Phase 13

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| — | Mon Apr 21 | — | **Phase 12 complete → merge dev to main** |
| 28 | Mon Apr 21 | #37 | RevenueCat setup & products |
| 29 | Tue Apr 22 | #38 | subscription_repository package |
| 30-31 | Wed-Thu Apr 23-24 | #39 | Subscription feature (paywall + premium gates) |
| 32 | Fri Apr 25 | #40 | Web subscriptions (Stripe) |

### Week 8: April 28–May 1 (4 days) — Phase 14 (Testing & Launch)

| Day | Date | Issues | Deliverable |
|-----|------|--------|-------------|
| — | Mon Apr 28 | — | **Phase 13 complete → merge dev to main** |
| 33 | Mon Apr 28 | #41 | Unit tests for all packages/blocs |
| 34 | Tue Apr 29 | #42 | Widget & integration tests |
| 35 | Wed Apr 30 | #43 | CI/CD finalization |
| 36 | Thu May 1 | #44 | Launch checklist & store submissions |
| — | Fri May 2 | — | **Phase 14 complete → final merge to main** |

---

## Milestone Summary

| Milestone | Target Date | Status |
|-----------|------------|--------|
| Phase 1 — Foundation | Mar 10 | Done |
| Phase 2 — Auth | Mar 11 | Done |
| Phase 3 — Sync | Mar 11 | Done |
| Phase 4 — Onboarding & Accounts | Mar 12 | Done |
| Phase 5 — Envelopes & Budget | Wed Mar 18 | Pending |
| Phase 6 — Transactions | Tue Mar 25 | Pending |
| Phase 7 — Dashboard | Wed Mar 26 | Pending |
| Phase 8 — Goals & Debt | Mon Mar 31 | Pending |
| Phase 9 — Shared Budgets | Mon Apr 7 | Pending |
| Phase 10 — Reports | Wed Apr 9 | Pending |
| Phase 11 — Notifications | Mon Apr 14 | Pending |
| Phase 12 — Settings & Polish | Mon Apr 21 | Pending |
| Phase 13 — Subscriptions | Mon Apr 28 | Pending |
| Phase 14 — Testing & Launch | **Fri May 1** | Pending |

**Original plan: 31 weeks (Aug 2026)**
**With Claude Code: ~7.5 weeks (May 1, 2026)**
**Speedup: ~4x faster**

### Buffer

- 2 buffer days already embedded in complex phases (Transactions, Shared Budgets, Subscriptions)
- If a phase runs over by a day, the May 1 target has ~3 days slack
- If you hit a blocker (3rd party SDK issues, App Store review delays), May 2nd week is fallback

### Weekly Rhythm

Each Monday:
1. Review what was completed last week
2. Confirm this week's target issues
3. Adjust timeline if needed

Each phase completion:
1. Merge `dev` → `main`
2. Mark milestone as complete
3. Quick sanity check (run full test suite)
