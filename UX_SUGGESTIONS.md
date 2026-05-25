# UX Improvement Suggestions — Envelope

Grounded in the current codebase. Each item names the existing files it builds on, the smallest viable scope, and a measurable success signal. Items are ordered for delivery in the "Implementation Order" section at the bottom — not by section number.

---

## 1. Floating Quick-Add Transaction Bubble

**Problem:** Adding a transaction takes too many taps — nav bar → full form page. Highest-frequency action in any budgeting app.

**Idea:** Persistent FAB → bottom sheet with 4 fields: type chip, amount (big, centered, autofocused), account, envelope. "More options" expands the rest. Covers ~80% of transactions in under 5s.

**Build on:** `lib/transactions/cubit/transaction_form_cubit.dart`, `lib/transactions/view/transaction_form_page.dart`. Same cubit, new compact view.

**Success signal:** Median time from FAB tap → transaction saved < 6s.

---

## 2. Dashboard "Budget Pulse" Card

**Problem:** Dashboard shows raw numbers (ready-to-assign, envelopes, accounts). No glanceable read on how the month is going.

**Idea:** Hero card with one human sentence:
- 🟢 "On track. 12 days left, $340 to spare."
- 🟡 "A little tight. 3 envelopes running low."
- 🔴 "Overspent in 2 places. Ready to assign can help."

Tap → relevant page (budget or cover-overspend flow).

**Build on:** `lib/dashboard/widgets/`. Derive state from existing dashboard bloc — no new data.

**Success signal:** Card tap-through > 20% of dashboard sessions.

---

## 3. Animated Amount Transitions

**Problem:** Balances swap silently after a transaction or sync. Feels static.

**Idea:** Odometer-style count animation on the Ready to Assign card and envelope tiles when their value changes. ~400ms with easing.

**Build on:** `dashboard_ready_to_assign_card.dart`, `envelope_summary_card.dart`, `envelope_list_tile.dart`. Wrap the existing `Text` with an `AnimatedSwitcher` + `TweenAnimationBuilder<int>`. Pure cosmetic.

**Success signal:** No perf regression on dashboard frame budget.

---

## 4. Envelope Spending Momentum Arrows

**Problem:** "$120 available" tells you where you are, not where you're headed.

**Idea:** Small directional indicator next to available amount:
- ↑ Trending under budget
- → On pace
- ↓ Trending over

Formula: `(spent_so_far / days_elapsed) * total_days` vs `allocated`. Threshold ±5% for the flat arrow.

**Build on:** `envelope_card.dart`, `envelope_summary_card.dart`. Period dates already available from budget bloc.

**Depends on:** None. Pairs well with #9 (spark line).

**Success signal:** Users investigate envelopes with ↓ arrows at 2× the rate of others (tap-through tracking).

---

## 5. Envelope Color + Icon System

**Problem:** All envelopes look near-identical in lists. Color dot alone forces label-reading every time.

**Idea:** Icon + color circle per envelope. Show on list tiles, detail page, transaction form dropdown.

**Build on:** `EnvelopeDto` already has `color`. **New work:** add `icon` field (string key) to `EnvelopeDto`, migration, and `IconPicker` widget on envelope create/edit. Use a curated set (~40 icons) to avoid bloating bundle.

**Depends on:** Schema migration. Co-ordinate with sync layer.

**Success signal:** > 60% of envelopes created post-launch have a non-default icon.

---

## 6. "Assign All" One-Tap on Ready to Assign

**Problem:** With money to assign, user must navigate to budget page and fill in amounts per envelope.

**Idea:** Long-press (or secondary button on) the Ready to Assign card opens a quick-assign sheet:
- List of envelopes with last-period allocations
- "Fill all to last period" pre-fills every row
- Confirm

**Build on:** `dashboard_ready_to_assign_card.dart`, `lib/budget/bloc/` already has `duplicatePreviousPeriod`. Surface it on the dashboard.

**Success signal:** > 30% of new periods are allocated via this path within 14 days of launch.

---

## 7. Visual Budget Allocation — Drag-to-Allocate

**Problem:** Allocation page = spreadsheet typing. Feels like work.

**Idea:** Thin scrubber bar under each envelope row. Drag right/left to nudge allocation; Ready to Assign updates live. Tap field for precise input.

**Build on:** `lib/budget/view/`. Allocation logic already reactive — drag is just an input method.

**Risk:** Accidental drags. Mitigation: require an initial vertical resistance threshold before the bar activates.

**Success signal:** Drag used in > 25% of allocation sessions after 30 days.

---

## 8. Transaction Form — Payee Autocomplete from History

**Problem:** Payee field is a plain text input. Users re-type "Starbucks" 40 times a year.

**Idea:** Suggestions from prior payees as the user types. Selecting a suggestion pre-fills envelope and amount from the last matching transaction. User can clear or override.

**Build on:** `transaction_form_page.dart` + `transaction_form_cubit.dart`. New repository query: `distinctPayees(budgetId)` + `lastTransactionForPayee(payee)`. Wrap existing `TextFormField` in `Autocomplete`.

**Success signal:** > 40% of transactions submitted use an autocompleted payee.

---

## 9. Envelope Detail — Spending Spark Line

**Problem:** Detail page is a flat transaction list. No visual pattern.

**Idea:** ~40px spark line at top of `envelope_detail_page.dart` — daily spend across the current period with a dashed reference line at `allocation / days_in_period`.

**Build on:** Existing transactions list for the envelope. Use `fl_chart` (already in pubspec) or a minimal `CustomPainter`.

**Depends on:** None.

**Success signal:** Detail-page scroll-past rate decreases (spark line read above the fold).

---

## 10. Month Heatmap on Transactions Page

**Problem:** Chronological scroll. Patterns ("weekend overspend") invisible.

**Idea:** Toggle between list and a compact calendar heatmap. Each day is a colored square — intensity = spend. Tap a day → scrolls list to that date.

**Build on:** `transactions_page.dart`. Reuse existing filter bar slot for the toggle.

**Risk:** Heatmap needs aggregation by day across visible filter set. Cache per filter hash.

**Success signal:** Toggle used at least once by > 25% of MAU.

---

## 11. Bill Reminder — "Paid This Month" Tracking

**Problem:** After paying a bill, the reminder stays in the list with no change. No sense of completion.

**Idea:** "Paid" badge on the reminder for the rest of the current billing cycle. Move to bottom. Auto-clears at next cycle.

**Build on:** `BillReminderDto` in `packages/envelope_api_client/lib/src/models/bill_reminder_dto.dart`. **New work:** add `last_paid_date` column + DTO field, expose in repository. UI compares it to the current cycle window derived from `dueDay` + `frequency`.

**Depends on:** Schema migration on `bill_reminders` table. Coordinate with sync (Supabase).

**Success signal:** Reduced "is this bill paid?" support questions; less than 5% of paid bills marked paid manually within the same cycle (i.e., system catches them automatically when posted via Pay form).

---

## 12. Overspend Recovery — Guided Bottom Sheet

**Problem:** `cover_overspend_dialog.dart` drops the user on a dropdown. If "covering" is unfamiliar, the screen is opaque.

**Idea:** Replace dialog with a bottom sheet:
1. One-sentence explanation: "Food envelope is $12 short."
2. Cards per funding source (Ready to Assign first, then envelopes with available funds), each with available amount and a single "Use this" button.
3. Tap → cover, dismiss.

**Build on:** `lib/transactions/widgets/cover_overspend_dialog.dart`. Logic stays; presentation changes.

**Success signal:** Time-to-cover under 10s; first-time users complete the flow without backing out.

---

## 13. Onboarding — Pre-Built Budget Templates

**Problem:** Wizard asks new users to create category groups and envelopes from scratch. Hardest part of budgeting is knowing *what* to budget.

**Idea:** On the envelope setup step, offer templates:
- **Essentials:** Rent, Food, Transport, Utilities, Savings
- **Young Professional:** Coffee, Dining, Subscriptions, Gym, Travel, Savings
- **Family:** Groceries, Kids, School, Healthcare, Entertainment, Savings
- **Custom:** Start from scratch

Pick → envelopes pre-populated, editable.

**Build on:** `lib/onboarding/`. Template = static map of `{groupName: [envelopeName, defaultIcon, defaultColor]}`.

**Depends on:** #5 (icon system) if templates ship with icons. Otherwise color-only.

**Success signal:** Onboarding completion rate +10pp; median time on envelope step -50%.

---

## 14. Home — Adaptive Layout by Time of Month

**Problem:** Dashboard looks identical on day 1 (need to allocate) and day 25 (need to track spend).

**Idea:** Re-order existing cards conditionally:
- **Days 1–5:** Ready to Assign card prominent + nudge if unallocated funds exist.
- **Days 6–20:** Envelope spending cards rise; momentum arrows visible.
- **Days 21+:** Recent transactions + overspent envelopes highlighted.
- **Bill due within 3 days:** Bills banner auto-expands.

**Build on:** Dashboard composition. No new data — pure layout logic keyed off `DateTime.now()` vs current period.

**Depends on:** #2 (Budget Pulse) shares the same dashboard real estate — decide ordering between them.

**Success signal:** Increased dashboard dwell time without increased nav-back rate.

---

## 15. Satisfying Micro-Interactions

**Problem:** App works but doesn't reward use. Budgeting is emotionally taxing.

**Ideas (small, individually shippable):**
- Haptic on allocation save, transaction submit, envelope hits zero (`HapticFeedback.lightImpact`).
- Tasteful confetti when Ready to Assign hits $0 (gated to once per period to avoid annoyance).
- "Envelope full" lock animation at 100% spend.
- Streak counter: "Logged transactions for 7 days in a row."

**Build on:** Flutter `HapticFeedback` + a small particle package. Streak = a `DateTime?` field on user settings + derived count.

**Risk:** Over-rewarding. Each micro-interaction lands behind a feature flag so we can A/B and pull individually.

**Success signal:** D7 retention +2pp on cohorts exposed to micro-interactions.

---

## 16. Goals — Auto-Sync Progress from Linked Envelope

**Problem:** Goals exist independently from envelopes. A "Vacation" envelope and a "Vacation" goal are two parallel ledgers.

**Idea:** When a goal is linked to an envelope, `currentAmount` is computed from the envelope's accumulated balance instead of being manually maintained. Goal detail shows allocation history as a contribution timeline.

**Build on:** `GoalDto` **already has `envelopeId`** (`packages/envelope_api_client/lib/src/models/goal_dto.dart:18`). The schema is in place. **New work:** repository read path that prefers envelope-derived progress when `envelopeId != null`; UI to set the link on goal create/edit.

**Depends on:** None — schema ready.

**Success signal:** > 30% of new goals created with an envelope link.

---

## Implementation Order

Grouped into shippable sprints. Within a sprint, items can ship in any order — they don't depend on each other.

### Sprint 1 — Quick wins, low risk, no schema change
- **#3** Animated amounts
- **#6** Assign All on Ready to Assign
- **#8** Payee autocomplete
- **#12** Guided overspend bottom sheet
- **#15** Micro-interactions (behind flags)

### Sprint 2 — Higher impact, still no schema change
- **#2** Budget Pulse card
- **#4** Momentum arrows
- **#9** Spark line on envelope detail
- **#14** Adaptive home layout
- **#16** Goal ↔ envelope auto-sync (schema already in place)

### Sprint 3 — Requires schema migration
- **#5** Envelope icon field
- **#11** Bill `last_paid_date` field
- **#13** Onboarding templates (uses #5 icons)

### Sprint 4 — Larger UI investments
- **#1** Quick-add bottom sheet
- **#7** Drag-to-allocate
- **#10** Month heatmap

---

## Priority Reference

| # | Suggestion | Effort | Impact | Notes |
|---|-----------|--------|--------|-------|
| 3 | Animated amounts | Low | High | Cosmetic, pure win |
| 6 | Assign All | Low | High | Reuses existing bloc method |
| 8 | Payee autocomplete | Low | High | Add 2 repo queries |
| 12 | Guided overspend | Low | High | Dialog → bottom sheet swap |
| 2 | Budget Pulse | Low | High | Derived state only |
| 16 | Goal↔envelope sync | Low | High | Schema ready, UI + read path |
| 15 | Micro-interactions | Low | Medium | Ship behind flags |
| 4 | Momentum arrows | Medium | High | Forecast adds real value |
| 9 | Spark line | Medium | Medium | `fl_chart` already available |
| 11 | Bill "Paid" badge | Medium | High | Needs migration |
| 5 | Envelope icons | Medium | High | Needs migration + picker |
| 13 | Onboarding templates | Medium | High | Friction killer |
| 14 | Adaptive home | Medium | Medium | Coordinate with #2 |
| 1 | Quick-add sheet | Medium | High | Reuses form cubit |
| 7 | Drag-to-allocate | High | Medium | Gesture tuning risk |
| 10 | Month heatmap | High | Medium | Aggregation + UI work |
