# Envelope — UI/UX Review v2
**Reviewer:** Senior UI/UX Audit (10+ years mobile)  
**Date:** 2026-06-10  
**Platform:** Flutter (iOS, Android, Web)  
**Previous review:** UI_UX_REVIEW.md (2026-06-09)

---

## What Was Fixed

Before new findings — confirming resolved issues from v1:

| Issue | Status |
|---|---|
| Navigation labels always hidden | ✅ Fixed — labels now show |
| Envelope card fixed 140px height | ✅ Fixed — 176px |
| Envelope footer 10px touch targets | ✅ Fixed — 32px min-height, 14px icons |
| No onboarding progress indicator | ✅ Fixed — LinearProgressIndicator |
| Allocation save TextButton easy to miss | ✅ Fixed — title dot indicator + conditional show |
| Generic semantic labels on envelope cards | ✅ Fixed — descriptive labels |
| FAB uses `more_vert` on budget page | ✅ Fixed — swap icon for transfer |
| Letter spacing 6px on titles | ✅ Fixed — 1.5px |
| Envelope name forced all-caps | ✅ Fixed — sentence case, 2-line max |
| No skeleton loading states | ✅ Fixed — DashboardSkeleton with ShimmerBox |
| No payee autocomplete | ✅ Fixed — autocomplete in transaction form |
| AnimatedCents | ✅ Kept |

The app has made meaningful improvements. What follows are the remaining issues — some carried over, some newly surfaced by the deeper audit.

---

## Severity Scale

| Level | Meaning |
|---|---|
| 🔴 Critical | Users will fail tasks or avoid the app |
| 🟠 High | Users will struggle, feel frustrated, or make errors |
| 🟡 Medium | Friction that degrades experience over time |
| 🟢 Low | Polish and delight opportunities |

---

## 1. Touch Targets (Remaining)

### 🔴 Period chevrons are still critically undersized
**File:** `lib/dashboard/view/home_page.dart`

```dart
SizedBox(height: 20, width: 28, ...)  // period prev/next buttons
```

The AppBar period chevrons (prev/next month) are **28×20px** — less than half the 44×44pt iOS minimum. These are the primary navigation control for the entire app's temporal context. On a physical device with a thumb, users will routinely miss these taps and accidentally trigger the title area or nothing at all.

**The impact is asymmetric:** getting stuck in the wrong month means all budget figures are wrong, but users may not notice for minutes. This is worse than a tap that does nothing.

**Recommendation:**
```dart
// Wrap each chevron in a fixed tap area
SizedBox(
  width: 44,
  height: 44,
  child: IconButton(
    padding: EdgeInsets.zero,
    icon: Icon(Icons.chevron_left, size: 20),
    onPressed: onPrev,
  ),
)
```
Increase leadingWidth from 116px to at least 160px to accommodate proper tap areas.

---

### 🟡 Category edit icon in envelope summary has no tap area expansion
**File:** `lib/dashboard/widgets/envelope_summary_card.dart`

The 18px edit icon in the section header (`Icons.edit`, size 18) sits in a row with no explicit tap area around it. The icon alone at 18px gives roughly 18×18 tap area — about 40% of the minimum.

**Recommendation:** Wrap in `IconButton` (minimum 48×48) or `InkWell` with `Padding(8px all)`.

---

### 🟡 Horizontal date picker items are borderline
**File:** `lib/transactions/widgets/horizontal_date_picker.dart:36`

```dart
// item width: 44px, but that includes 8px padding
```

44px item width includes padding. The actual circle (date bubble) is ~36px. That's acceptable but tight for users with larger fingers. Any accidental offset registers as "no tap."

**Recommendation:** Increase item width to 52px, keeping the circle at 36px for aesthetics.

---

## 2. Navigation & Information Architecture

### 🟠 "More options" in transaction sheet hides the payee field
**File:** `lib/transactions/view/quick_add_transaction_sheet.dart`

The transaction form collapses payee, notes, tags, date, and recurring under a "More options" toggle (AnimatedSize, collapsed by default). For new users entering their first transactions, **the payee field is invisible**. "Amazon", "Whole Foods", "Rent" — the most meaningful metadata on a transaction — requires an extra tap to reach.

This creates a class of users who never see the payee field, resulting in unlabeled transactions that are hard to review later. The autocomplete improvement (v1 fix) is wasted if the field is hidden.

**Recommendation:**
- Show payee field **above** the fold by default. It's one line; it doesn't add height meaningfully.
- Keep notes, tags, and recurring collapsed — those are legitimately advanced.
- Or: expand "More options" automatically when the user has typed an amount and tapped "next" (progressive disclosure that follows the natural flow).

---

### 🟠 Settings is still buried in overflow menu
**File:** `lib/dashboard/view/home_page.dart`

The v1 review flagged Settings being in an overflow popup. The current audit still shows Settings inside a `PopupMenuButton`. On the wide layout (NavigationRail), there's a trailing settings icon — good. But on mobile (bottom nav), Settings is still overflow-only.

Settings is where users: change currency, configure themes, manage subscriptions, and handle account security. It belongs in permanent navigation.

**Recommendation:**
- Add a gear icon to the bottom NavigationBar as a 6th item **or** replace the `bar_chart` Reports tab (if Reports is low-priority in early use) with a combined settings/profile destination.
- Alternatively: add a persistent gear icon to the AppBar `actions` row (not in overflow). It's one icon at ~48dp tap area, and it costs nothing in layout.

---

### 🟡 Expansion tile state is not persisted
**File:** `lib/envelopes/view/envelopes_page.dart`, `lib/dashboard/widgets/envelope_summary_card.dart`

Category group `ExpansionTile`s reset to expanded on every navigation. A user who carefully collapses all but their "Monthly Bills" group will see everything re-expand the moment they navigate to Transactions and back. Over weeks of daily use, this becomes a real friction point.

**Recommendation:** Persist expansion state per category ID in local storage (or at minimum in Bloc state that survives navigation). A `Map<String, bool>` keyed by category ID is sufficient.

---

### 🟡 5-tab bottom nav on narrow phones
**File:** `lib/app/view/app_shell.dart`

With labels now showing (v1 fix), 5 tabs on a 360px phone gives ~72px per tab. The label text for "Transactions" is 12 characters — at 11–12px font, it fits but barely. On 320px phones (still common), each tab is ~64px and "Transactions" will wrap or truncate.

**Recommendation:** Test explicitly on 320px width. If text wraps, use shorter labels: "Spend" (Transactions), "Budget", "Accounts", "Goals", "Reports" — or drop to 4 tabs and move the 5th into a secondary location.

---

### 🟡 "Goals" tab icon still ambiguous
**File:** `lib/app/view/app_shell.dart`

`Icons.flag` → "Goals". Labels now show (good), so the label teaches the icon over time. But on first launch, a flag icon still reads as "flag a problem" or "report" to many users, especially on Android where flag icons appear in Gmail and notification management.

**Recommendation:** Switch to `Icons.savings` or `Icons.track_changes` for Goals. Both are more semantically clear and less overloaded.

---

## 3. Transaction UX

### 🟠 Swipe direction conflicts with iOS native convention
**File:** `lib/transactions/widgets/transaction_list_tile.dart`, `lib/transactions/widgets/timeline_transaction_tile.dart`

Current swipe mapping:
- **Right swipe** → Edit (primaryContainer, edit icon left)
- **Left swipe** → Delete (errorContainer, delete icon right)

iOS native apps universally use **left swipe → delete** (red, right side) as the convention since iOS 7. Right swipe is either "mark as done" (Reminders, Mail) or secondary action. Android has less convention, but left-delete has become dominant cross-platform.

Users with iOS muscle memory will swipe right to delete and instead land in the Edit flow — a high-friction error in a financial app where accidental edits change real data.

**Recommendation:** Invert:
- **Left swipe** → Delete (errorContainer, delete icon, confirm dialog preserved)
- **Right swipe** → Edit (primaryContainer, edit icon)

Or match iOS fully: left swipe shows a partial red delete button (tap to confirm), right swipe dismisses/marks. This is a one-line swap in `Dismissible` direction mapping.

---

### 🟡 Copy icon on timeline tiles has no tooltip and no visual affordance
**File:** `lib/transactions/widgets/timeline_transaction_tile.dart`

The trailing copy icon (20px, outline color) on non-transfer transactions is not described. It has no tooltip, no label, and renders in muted outline color — it looks decorative. Users who don't discover it miss "duplicate transaction" functionality.

**Recommendation:**
- Add `Tooltip('Duplicate transaction')` wrapper.
- On long-press (mobile), show the tooltip text as a visual popup.
- Consider replacing with a popup menu (three-dot icon) that includes both "Duplicate" and any other secondary actions — more discoverable pattern.

---

### 🟡 Transaction date defaults to today — no visual confirmation
**File:** `lib/transactions/view/quick_add_transaction_sheet.dart`

The horizontal date picker defaults to today but only shows in "More options" (collapsed). Users entering a transaction from last week will submit it as today unless they expand options and change the date. In a budgeting context, wrong dates throw off budget period reports.

**Recommendation:**
- Surface date as a compact chip above the submit button, visible without expanding "More options."
- Example: `📅 Today` chip that taps open the date picker.
- This makes the date visible-but-not-in-the-way.

---

## 4. Budget & Allocation UX

### 🟠 Transfer FAB icon (swap) is ambiguous for new users
**File:** `lib/budget/view/budget_page.dart`

The budget page FAB now uses a swap/transfer icon — better than `more_vert`. But `Icons.swap_horiz` (or equivalent) means different things in different contexts: currency exchange, reorder, swap values. For users new to envelope budgeting, "transfer between envelopes" is not an obvious mapping.

**Recommendation:**
- Use a tooltip: `Tooltip('Transfer between envelopes', child: FAB(...))`
- Or combine the icon with a label using `FloatingActionButton.extended` with label "Transfer"
- `extended` FAB only needs ~140px, costs no layout on phones, and eliminates the ambiguity entirely.

---

### 🟡 Allocation "Add vs. Set To" mode toggle is a hidden power feature
**File:** `lib/dashboard/widgets/allocate_envelope_sheet.dart`

The `AllocateMode` enum (Add vs SetTo) toggle in the allocation sheet is a meaningful UX choice — "add $50" vs "set to $200" are different operations. But the toggle exists inside a sheet that most users will reach without understanding the modes exist.

**Recommendation:** 
- Label the toggle clearly: "Add to allocation" / "Set allocation to"
- Make the current mode visually active with filled/outlined style, not just a text toggle
- Show the resulting allocation calculation in real-time below the input (this may already exist via "Preview text" mentioned in audit — if so, make it more prominent)

---

### 🟡 Budget page unsaved changes lost on app force-quit
**File:** `lib/budget/view/budget_page.dart`

`PopScope` guards back navigation (good), but if the user backgrounds the app and Android kills it (low memory), or they force-quit on iOS, allocation changes in the `localAllocations` list are silently lost. The dirty state dot in the title communicates pending changes but doesn't survive app termination.

**Recommendation:** Write `localAllocations` to a local draft key in storage on every change event. Clear on explicit save or cancel. On re-open, restore the draft and show a "Resume unsaved changes?" banner. This is the pattern used by Notes.app and every solid data-entry form.

---

## 5. Dashboard & Cards

### 🟡 Ready-to-Assign progress bar is 5px — too thin to perceive
**File:** `lib/dashboard/widgets/dashboard_ready_to_assign_card.dart`

```dart
ClipRRect(
  child: LinearProgressIndicator(minHeight: 5, ...),
)
```

5px is the thinnest acceptable progress bar for sighted users, but on a physical phone behind glass at arm's length, a 5px bar reads as a decorative line, not a data-bearing element. Users won't register it as meaningful.

**Recommendation:** Increase to `minHeight: 8`. This keeps it compact on the card while being perceptible as a bar that communicates "how much of your budget is assigned." Also increases tap accuracy if you add a tap-to-details interaction later.

---

### 🟡 Dashboard accounts card shows top 3 with no indication of total count
**File:** `lib/dashboard/widgets/dashboard_accounts_card.dart`

The card shows 3 accounts with a "View All" link. If a user has 7 accounts, they see 3 with no indication that 4 are hidden. This is fine — but if the user's most important account happens to be 4th in the list (by whatever ordering is used), they'll have to tap "View All" every time to see their checking account balance.

**Recommendation:**
- Show the account count: "View All (7)" instead of just "View All"
- Sort by: most recently transacted, or let users pin 3 accounts to the dashboard
- At minimum, document the sort order somewhere the user can find it (Settings → Dashboard layout)

---

### 🟡 Period selector "leading" area is visually cluttered
**File:** `lib/dashboard/view/home_page.dart`

`leadingWidth: 116px` packs a period name (variable length) + two 28px chevrons. For months with longer names ("September 2026"), the name will be truncated or the chevrons will be pushed too close to the title. On smaller phones, the leading area competes with the AppBar title for horizontal space.

**Recommendation:**
- Move the period selector to a sticky chip bar below the AppBar, above the first card. This pattern is used by Google Calendar and most calendar-based apps.
- The chip reads as "Sep 2026 ⌄ ◂ ▸" — left/right arrows at 44dp, name as text in middle, larger tap targets.
- Removes leading crowding, makes the control the first thing users see on the dashboard.

---

## 6. Color, Typography & Accessibility

### 🟠 Envelope cards are still color-only for financial state
**File:** `lib/envelopes/widgets/envelope_card.dart`

The `FundingStatusBadge` widget exists and uses tooltips (good). But on the card body, the **available amount color** is still the sole indicator of financial health (green = healthy, red = overspent, amber = zero). The `FundingStatusBadge` may not be surfaced on every card state.

For ~8% of users with red-green color blindness, green (income, `#6B7F4A`) and red (overspent, `#C0392B`) are nearly indistinguishable against the terracotta card backgrounds.

**Recommendation:** Add a text prefix to the available amount on cards:
- `↑ $200` or `+$200` — healthy
- `↓ $0` — zero
- `! −$50` or `▼ −$50` — overspent  
This costs 1–2 characters and makes the state readable without color.

---

### 🟡 Secondary text contrast may fail WCAG AA
**File:** `lib/theme/app_colors.dart`

`secondaryText: #8A8478` on `background: #F5F0E8`:
- Background hex: `F5F0E8` → luminance ≈ 0.88
- SecondaryText hex: `8A8478` → luminance ≈ 0.26
- Contrast ratio: ~**3.5:1**

WCAG AA requires **4.5:1** for normal text (< 18pt) and **3:1** for large text (≥ 18pt bold). Secondary text is used at `bodySmall` (~12–14px) — this fails AA for normal text.

**Recommendation:** Darken secondaryText to `#736E64` or darker. Target contrast ≥ 4.5:1 against both light and dark backgrounds.

---

### 🟢 `+`/`−` prefixes on transaction list amounts are excellent
**File:** `lib/transactions/widgets/transaction_list_tile.dart`

`"+"` for income, `"−"` for expense on transaction amounts — this is the right pattern. It makes the list scannable without color, supports color-blind users, and matches financial app conventions. Keep this and extend it to envelope cards (see above).

---

## 7. Onboarding

### 🟡 Skip button visibility is undefined
**File:** `lib/onboarding/view/onboarding_page.dart`

The audit confirms Skip is "conditional on skippable steps" but the criteria for which steps are skippable isn't apparent from code review. If accounts and envelope setup are not skippable, new users who "just want to look around" hit a wall at step 3.

**Recommendation:**
- Make all steps after Welcome skippable
- Show "Skip for now" in muted text below the CTA button — not in AppBar (easy to miss)
- On skip, show "You can add this later in Settings" one-time tooltip
- On first post-onboarding launch, show a non-blocking banner: "Add your first envelope to start budgeting"

---

### 🟡 No starter template sets
The v1 review recommended 2–3 template sets (Simple/Detailed) for envelope creation during onboarding. No evidence of this in the current code. Creating envelopes from scratch at step 4 of onboarding is a cold-start problem — users don't know what envelopes to create.

**Recommendation:** Show 3 starter options before the "create your own" flow:
- **Simple** (6 envelopes): Housing, Food, Transport, Entertainment, Savings, Other
- **Detailed** (15 envelopes): Pre-filled with common categories
- **Start from scratch**

Templates can be hardcoded strings in localization. One-time implementation, high onboarding completion impact.

---

## 8. Forms & Data Entry

### 🟡 Allocation input has no currency symbol visual affordance
**File:** `lib/dashboard/widgets/allocate_envelope_sheet.dart`

Users may type "$200" (with dollar sign) instead of "200", getting a validation error or broken input. The field has a currency symbol prefix in the display, but if the input formatter doesn't strip "$", this causes silent errors.

**Recommendation:** Verify the input formatter explicitly strips non-numeric characters before validation. Add visible prefix text ("$" or the user's currency symbol) inside the `InputDecoration.prefix` property — makes it clear the field expects numeric-only.

---

### 🟡 Amount field in transaction form uses displaySmall at center-aligned
**File:** `lib/transactions/view/quick_add_transaction_sheet.dart`

`displaySmall` is ~28–32px, center-aligned, formatted as `$0.00`. This is a good pattern (used by Venmo, Cash App). However:
- On RTL languages (Arabic, Hebrew), center-align with "$" prefix will look incorrect
- The hint text `$0.00` disappears on first tap — there's no ongoing visual reminder of the format

**Recommendation:**
- Test with RTL locale
- Consider keeping `$0.00` as a placeholder that shows beneath the entered value until they start typing (or fades out gracefully)

---

## 9. Micro-interactions & Polish

### 🟡 Timeline vertical line doesn't connect to card edges cleanly
**File:** `lib/transactions/widgets/timeline_transaction_tile.dart`

The timeline uses a 2px vertical line (gray) with a 10px bullet at each transaction. At the top of a date group, the line appears to start mid-air. At the bottom, it ends before the card bottom. This disconnected line makes the timeline feel like a decoration rather than a navigation affordance.

**Recommendation:** Ensure the vertical line:
- Extends to the top edge of the first item in a group (or starts with a top cap)
- Has a visual end-cap or fades at the last item in a group
- Test the rendering at group boundaries with 1, 2, and 10+ items

---

### 🟡 No empty state for "no transactions in this period"
When a user navigates to a prior period with no transactions, the transaction list is empty. The empty state shows a generic "No transactions yet" icon and message. There's no contextual message that explains *why* — "No transactions in September 2025."

**Recommendation:** Pass the current period into the empty state message:
```dart
Text(l10n.noTransactionsInPeriod(periodLabel))
// "No transactions in September 2025"
```

---

### 🟡 Reorder mode uses text-only "Done Reordering" button
**File:** `lib/envelopes/view/envelopes_page.dart`

Reorder mode activates with a button that turns into "Done Reordering" text in the AppBar. This follows a common iOS-like pattern but:
- The state change (normal → reorder) isn't visually obvious to users who didn't tap the button
- Drag handles appear without announcement
- No visual cue that the list is now in a different mode (e.g., background change, haptic feedback)

**Recommendation:**
- On entering reorder mode, show a brief snackbar: "Drag to reorder. Tap Done when finished."
- Consider a subtle background tint on the page to visually signal "edit mode."

---

### 🟢 Allocate sheet preview text is an excellent pattern
**File:** `lib/dashboard/widgets/allocate_envelope_sheet.dart`

Showing the resulting allocation as real-time preview below the input field is the right UX — it answers "what will this do?" before committing. This is the same pattern used by YNAB and Copilot Money. Keep this and make the preview text more prominent (currently likely `bodySmall` — consider `bodyMedium` bold in the envelope's own color).

---

### 🟢 PopScope unsaved changes guard is the correct pattern
**File:** `lib/budget/view/budget_page.dart`

Intercepting back navigation with a "Discard changes?" dialog is the right call for allocation changes. This pattern is used correctly and prevents data loss from mis-taps. Keep this — it's a non-obvious but important detail that sets good apps apart from great ones.

---

## 10. Error & Edge Cases

### 🟡 No retry action on error snackbars
**File:** `lib/dashboard/view/home_page.dart`

The v1 review flagged this. The current audit shows two generic error messages with no retry action (`dashboardErrorAllocation`, `dashboardErrorLoad`). Users who hit an error have no path to recovery except manually refreshing — which requires knowing to pull-to-refresh.

**Recommendation:**
```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(l10n.dashboardErrorLoad),
    action: SnackBarAction(
      label: l10n.retry,
      onPressed: () => context.read<DashboardBloc>().add(const DashboardRefreshRequested()),
    ),
  ),
);
```
One `SnackBarAction` per error, pointing to the appropriate Bloc event.

---

### 🟡 Offline state has no persistent indicator
The sync status shows in the AppBar (syncing/synced/error/offline states via localization strings), but if the user is offline and navigates between tabs, does the offline indicator persist? Or does it disappear?

For a budgeting app where data accuracy matters, users should always know if they're looking at potentially stale data.

**Recommendation:** If the user is offline, show a persistent `MaterialBanner` (not snackbar — those auto-dismiss) with "Working offline — changes will sync when reconnected." Dismiss automatically when sync resumes.

---

## Priority Fix List (New Issues)

| # | Issue | Severity | File | Effort |
|---|---|---|---|---|
| 1 | Period chevrons 28×20px — critically small | 🔴 | `home_page.dart` | Small |
| 2 | Payee field hidden in "More options" | 🟠 | `quick_add_transaction_sheet.dart` | Small |
| 3 | Settings buried in mobile overflow | 🟠 | `home_page.dart` | Medium |
| 4 | Swipe directions conflict with iOS convention | 🟠 | `transaction_list_tile.dart`, `timeline_transaction_tile.dart` | Small |
| 5 | Envelope card color-only financial state | 🟠 | `envelope_card.dart` | Small |
| 6 | secondaryText fails WCAG AA contrast | 🟠 | `app_colors.dart` | 1 line |
| 7 | Transfer FAB icon ambiguous — no label | 🟡 | `budget_page.dart` | Small |
| 8 | No retry action on error snackbars | 🟡 | Multiple | Small |
| 9 | Expansion tile state not persisted | 🟡 | `envelopes_page.dart`, `envelope_summary_card.dart` | Medium |
| 10 | Transaction date invisible without expanding | 🟡 | `quick_add_transaction_sheet.dart` | Small |
| 11 | Period selector crowded in AppBar leading | 🟡 | `home_page.dart` | Medium |
| 12 | 5-tab labels narrow on 320px phones | 🟡 | `app_shell.dart` | Small |
| 13 | "Goals" flag icon semantically ambiguous | 🟡 | `app_shell.dart` | 1 line |
| 14 | Copy icon on timeline — no tooltip | 🟡 | `timeline_transaction_tile.dart` | 1 line |
| 15 | No onboarding starter templates | 🟡 | `onboarding_page.dart` | Large |
| 16 | RTA progress bar 5px too thin | 🟢 | `dashboard_ready_to_assign_card.dart` | 1 line |
| 17 | Timeline line has no end-caps | 🟢 | `timeline_transaction_tile.dart` | Small |
| 18 | Reorder mode has no visual mode indicator | 🟢 | `envelopes_page.dart` | Small |
| 19 | "No transactions" empty state isn't period-aware | 🟢 | Transactions | Small |
| 20 | Allocation preview text should be more prominent | 🟢 | `allocate_envelope_sheet.dart` | 1 line |

---

## Final Verdict

**Score: 8.5 / 10** (up from 7.5)

The v1 fixes were applied correctly and meaningfully — skeleton screens, onboarding progress, semantic labels, envelope card improvements, and the AllocationList save affordance all land well. The app now reads as a polished product in most flows.

The remaining gap is concentrated in three areas: **touch targets** (period chevrons are still broken), **transaction form discoverability** (payee hidden, date invisible), and **a11y contrast** (secondary text fails WCAG AA). Fix those three and this is a 9.0+ app. The rest are polish passes that will reward users who use the app daily.

The aesthetic direction — terracotta palette, envelope-shaped cards, AnimatedCents — remains a genuine differentiator in a category full of blue-gray fintech apps. Don't change it.
