# Envelope — UI/UX Expert Review
**Reviewer:** Expert audit (10+ years mobile UI/UX)  
**Date:** 2026-06-09  
**Platform:** Flutter (iOS, Android, Web)

---

## Executive Summary

Envelope has a strong visual identity — the warm terracotta-on-cream palette is distinctive, human, and appropriate for personal finance. The custom envelope-shaped cards are a rare, delightful on-brand detail that most apps wouldn't bother with. The architecture is clean, the component system is coherent, and dark theme is handled.

That said, several UX patterns work against the app's goals. The most critical issues are around **discoverability, touch target sizing, and information hierarchy** — specifically on the dashboard and the navigation bar. These are fixable without redesign.

---

## Severity Scale

| Level | Meaning |
|---|---|
| 🔴 Critical | Users will fail tasks or avoid the app |
| 🟠 High | Users will struggle, feel frustrated, or make errors |
| 🟡 Medium | Friction that degrades experience over time |
| 🟢 Low | Polish and delight opportunities |

---

## 1. Navigation

### 🔴 Bottom nav labels are permanently hidden
**File:** `lib/app/view/app_shell.dart:286`  
```dart
labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
```
Labels are hidden on all 5 bottom nav destinations. The icons chosen — `home`, `receipt_long`, `account_balance`, `flag`, `bar_chart` — are not universally understood without labels. Specifically:
- `flag` → "Goals" is a non-obvious mapping. Flags mean "report" or "flag a problem" to many users.
- `bar_chart` → "Reports" is reasonable but shares the icon space with finance dashboards everywhere.
- Users new to the app cannot discover what tabs do without tapping each one.

**Material Design 3 guideline** explicitly recommends labels for navigation bar items because icons alone are ambiguous. Hiding labels only works when icons are already conventions (like tab bar in Instagram/TikTok).

**Recommendation:** Use `NavigationDestinationLabelBehavior.onlyShowSelected` at minimum. It shows only the active label, adds no real height, but confirms what you tapped and teaches the icon meaning over time.

---

### 🟠 Settings and Recurring buried in overflow menu
**File:** `lib/dashboard/view/home_page.dart:137-184`

Settings and Recurring Transactions are hidden inside a `PopupMenuButton` on the home AppBar. Users have no way to discover these unless they try the overflow icon. Settings especially is a core app section that belongs in persistent navigation.

**Recommendation:**
- Add Settings to the `NavigationRail` (wide layout) and at minimum as a gear icon in the AppBar (not buried in overflow).
- Recurring Transactions deserves a tab or a card-level shortcut on the dashboard, not overflow-only access.
- The overflow menu currently mixes utility items (Settings, Recurring) with a destructive item (Delete Budget). Dangerous actions should never share a menu with common navigation.

---

### 🟡 FAB uses `more_vert` icon on Budget page
**File:** `lib/budget/view/budget_page.dart:91`

```dart
floatingActionButton: FloatingActionButton(
  onPressed: () => unawaited(showBudgetActionsMenu(context)),
  child: const Icon(Icons.more_vert),
),
```

FABs signal "create" or "primary action." A `more_vert` (overflow/menu) icon on a FAB breaks this universal pattern. Users expect FAB to do something positive and direct, not open yet another menu. This causes hesitation — "do I tap this or is there something else?"

**Recommendation:** Inline the most common budget action (e.g., transfer funds, add period) as the FAB action. Secondary actions can remain in an AppBar overflow.

---

### 🟡 Group icon unclear in home AppBar
**File:** `lib/dashboard/view/home_page.dart:92-96`

```dart
IconButton(
  icon: const Icon(Icons.group),
  onPressed: () => context.push('${AppRoutes.sharedBudget}?budgetId=$budgetId'),
)
```

`Icons.group` with no label navigates to Shared Budget — a multi-person collaboration feature. First-time users or solo users have no idea what this does. There's no tooltip visible in the code.

**Recommendation:** Add a `tooltip: l10n.sharedBudgetTitle` to this `IconButton`. Consider only showing it when the user has collaborators (otherwise the feature doesn't apply and the icon adds visual noise).

---

## 2. Touch Targets

### 🔴 Envelope card footer actions are critically undersized
**File:** `lib/envelopes/widgets/envelope_card.dart:159-224`

The "of allocated / edit" row, "Fix Overspend" link, and "Pay" CC button are `GestureDetector` wraps on text + icon rows where:
- Icon size: **10px** (`size: 10`)
- Text size: **11px**
- No explicit tap area expansion

The minimum recommended touch target is **44×44pt (iOS HIG)** / **48×48dp (Material)**. A 10px icon on a 11px text row is roughly **4–6× too small**. On a physical phone these are nearly impossible to hit reliably, especially for users with larger fingers or accessibility needs.

**Recommendation:** Wrap these in a `InkWell` or `GestureDetector` with a minimum `ConstrainedBox(constraints: BoxConstraints(minHeight: 32, minWidth: 44))`. Increase icon size to at least `14px` and text to `12px`. Alternatively, move allocation editing to a long-press on the card body to avoid the cramped footer entirely.

---

### 🟠 Envelope card content area is tight at fixed 140px height
**File:** `lib/envelopes/widgets/envelope_card.dart:62`

```dart
SizedBox(height: 140, ...)
```

140px fixed height with 44px taken by the envelope flap (via `EnvelopeShapePainter`) leaves ~96px for: envelope name, amount, divider, and footer action. With 11px name text, 20px amount, divider, and 11px footer — there's basically no breathing room. When `primaryLabel` is set (CC payment mode) with a secondary `limitLabel`, these labels at 10px on an already tight card are difficult to read.

**Recommendation:** Consider `minHeight: 140` instead of fixed `height`. Allow the card to grow for content-heavy states (CC payment, overspent with long names).

---

## 3. Dashboard Information Architecture

### 🟠 Dashboard is a flat, undifferentiated scroll
**File:** `lib/dashboard/view/home_page.dart:244-337`

The dashboard ListView stacks four cards vertically with no explicit visual grouping:
1. Ready to Assign
2. Envelope Summary (with tab bar)
3. Accounts
4. Recent Transactions

For a budgeting app, the most important signal is "am I on track this month?" — but to answer that, users have to scroll through all envelopes before they can see accounts or recent transactions. There's no at-a-glance summary of budget health.

**Recommendation:**
- Surface a **spending progress bar** or **budget health score** above the fold, before the envelope grid.
- Consider a collapsible envelope section (collapsed to show group totals only, expandable for detail).
- Move the period navigation header to a sticky position so it stays visible while scrolling the envelope list.

---

### 🟡 No quick-actions row visible in code
The agent's initial report mentioned a "Quick Actions Row" with three chips (Add, Budget, Accounts) — but this widget isn't present in the `home_page.dart` build method. If it was removed, consider bringing it back: a row of tappable chips for the most common tasks (Add Transaction, Allocate, View Accounts) would significantly reduce navigation depth for frequent actions.

---

### 🟡 Period navigation discoverability
**File:** `lib/dashboard/widgets/dashboard_ready_to_assign_card.dart:78-103`

Period navigation (prev/next month chevrons) is embedded inside the Ready to Assign card. Users who've never used envelope budgeting apps may not realize they can navigate between budget periods here. The chevrons are `VisualDensity.compact` and visually subtle.

**Recommendation:** On first launch, consider a brief tooltip or coach mark pointing to the period nav. Alternatively, surface a period chip above the main content so it reads as "context for this page" rather than a card-level control.

---

## 4. Typography & Readability

### 🟡 Letter spacing too wide on buttons and titles
**File:** `lib/theme/app_text_theme.dart` (inferred from agent report)

- Title letter spacing: 6.0px
- Label/button letter spacing: 1.5px

6.0px letter spacing on display/headline text is aggressive. For a financial app where numbers and labels appear in tight spaces (envelope cards, allocation rows, transaction amounts), wide letter-spacing at heading sizes makes text feel spread thin and harder to scan. Most premium apps use 0–1.5px for display text.

**Recommendation:** Reduce title letter spacing to 1.0–2.0px. Keep 1.5px for small-caps labels and buttons (where it works well for legibility).

---

### 🟡 Envelope name forced to all-caps at 11px
**File:** `lib/envelopes/widgets/envelope_card.dart:96-105`

```dart
name.toUpperCase(),
style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.8),
```

All-caps + 11px + letter-spacing on a colored envelope card against white text (`onPrimary @ 0.9 alpha`). For short names ("Rent", "Food") this works. For longer names ("Medical Expenses", "Car Insurance") it overflows with `maxLines: 1 / ellipsis`, creating truncated all-caps labels like "MEDICAL EXP…" which lose meaning.

**Recommendation:** Use sentence case instead of `toUpperCase()`. Or keep all-caps but increase font size to 12px and set a 2-line max with smaller text to allow wrapping.

---

### 🟢 AnimatedCents is a standout UX detail
`lib/shared/widgets/animated_cents.dart` — animating currency amounts as they change is a small but memorable touch. It reinforces that numbers are live and responding to user actions. Keep this.

---

## 5. Onboarding

### 🟠 No progress indicator in onboarding flow
**File:** `lib/onboarding/view/onboarding_page.dart`

The onboarding has ~5 steps (Welcome → Currency → Accounts → Envelopes → Complete), but there's no step counter, progress bar, or visual indication of how many steps remain. Users don't know if they're halfway through or almost done — leading to abandonment when they hit step 4 after expecting 2 steps.

**Recommendation:** Add a `LinearProgressIndicator` or step dots (e.g., `●●○○`) in the AppBar or above the content area. Even a simple "Step 3 of 5" text label helps significantly with completion rates.

---

### 🟡 Accounts and Envelopes setup steps may overwhelm new users
Creating bank accounts and budget envelopes as mandatory onboarding steps is a high-friction entry point for users who just downloaded the app to "see what it does." First-time budgeters especially may not know how many or what type of envelopes to create.

**Recommendation:** Make these steps optional ("Skip for now — you can add these later"). Provide 2–3 template starter sets (e.g., "Simple (10 envelopes)", "Detailed (20 envelopes)") so users can start with sensible defaults instead of creating everything from scratch.

---

## 6. Forms & Data Entry

### 🟠 Allocation save is a TextButton in AppBar — easy to miss
**File:** `lib/budget/view/budget_page.dart:71-88`

```dart
if (state.localAllocations.isEmpty) return const SizedBox.shrink();
return TextButton(
  onPressed: ...,
  child: Text(l10n.budgetSaveAllocations),
);
```

When the user adjusts allocations, a TextButton labeled "Save Allocations" appears in the AppBar. Problems:
1. TextButton in AppBar is visually de-emphasized — it looks like a nav label, not a call to action.
2. Users who made changes and navigate away may not realize they're losing unsaved work.
3. There's no "unsaved changes" indicator on the card itself while editing.

**Recommendation:** Replace with a `FilledButton` in the AppBar (more prominent). Add a subtle dirty indicator (dot on the allocation row, or pulsing save icon) so users know changes are pending. Ideally, add a `WillPopScope` / `PopScope` guard that warns before navigating away with unsaved allocations.

---

### 🟡 No autocomplete on payee field
Recurring transactions (same payees over and over) would benefit from autocomplete on the payee field in the transaction form. Users shouldn't have to type "Amazon" or "Whole Foods" every time.

**Recommendation:** Build a payee frequency list from existing transactions and offer autocomplete suggestions in the payee input field.

---

## 7. Semantic Accessibility

### 🟠 Envelope card has a single generic semantic label
**File:** `lib/envelopes/widgets/envelope_card.dart:266-269`

```dart
Semantics(
  label: onEditTap != null ? 'Edit envelope allocation' : null,
  child: card,
)
```

Every envelope card gets the same `'Edit envelope allocation'` label. Screen reader users navigating through multiple envelope cards will hear "Edit envelope allocation, Edit envelope allocation, Edit envelope allocation…" with no way to distinguish between them.

**Recommendation:**
```dart
label: 'Envelope: $name. Available: ${formatCents(availableCents)}. Tap to edit.',
```

---

### 🟡 Color is sole indicator for financial amounts
The app uses color alone to convey critical financial states:
- Green = income / available
- Red = expense / overspent
- Amber = zero / warning

For the ~8% of users with red-green color blindness (deuteranopia/protanopia), the green income and red expense distinction is lost. Both will appear as brownish/yellow tones against the warm cream background.

**Recommendation:** Add secondary indicators alongside color:
- Expense amounts: `-` prefix or `↓` icon
- Income amounts: `+` prefix or `↑` icon  
- Overspent state: add a small `!` badge or strikethrough on the amount

---

## 8. Micro-interactions & Polish

### 🟢 Speed dial animation is well-executed
`lib/app/view/quick_add_speed_dial.dart` — 45° FAB rotation, EaseOutCubic child expansion, full-screen scrim tap-to-close. This is polished. The long-press to template picker is an excellent power-user feature.

### 🟢 Hero animation on envelope cards is delightful
The `EnvelopeShapePainter` → detail page hero transition with custom `flightShuttleBuilder` (morphing border radius during flight) is a high-quality detail that makes the app feel premium.

### 🟡 Slide transition always slides from right, never from left
**File:** `lib/app/view/app_shell.dart:100-108`

```dart
final isForward = index > _selectedIndex(context);
_slideTween.begin = isForward ? const Offset(1, 0) : const Offset(-1, 0);
```

Good — directional slide based on tab index. But `value: 1` initial controller state means no animation on the very first tab load. This is a minor issue but worth noting: the first time you open the app and tap a tab, there's no transition.

### 🟡 Loading state is a bare `CircularProgressIndicator`
**File:** `lib/dashboard/view/home_page.dart:233-236`

```dart
if (state.status == DashboardStatus.loading) {
  return const Center(child: CircularProgressIndicator());
}
```

Every screen shows a spinner in the center while loading. For a data-rich dashboard, skeleton screens (shimmer placeholders shaped like the cards) would dramatically improve perceived performance and polish.

**Recommendation:** Add skeleton screens for at minimum the dashboard and transactions list — these are the highest-traffic screens.

---

## 9. Error Handling

### 🟡 Error messages are generic
**File:** `lib/dashboard/view/home_page.dart:199-203`

```dart
final message = state.error == DashboardError.allocationFailed
    ? l10n.dashboardErrorAllocation
    : l10n.dashboardErrorLoad;
```

Two error messages cover all dashboard failures. Users who get `dashboardErrorLoad` don't know if it's a network issue, an auth issue, or a data problem — and have no actionable recovery path.

**Recommendation:** Add a "Retry" action to error snackbars. For network errors specifically, surface a more helpful message: "Couldn't load your budget. Check your connection and try again." with a retry button.

---

## 10. What's Working Well (Keep These)

| Pattern | Why It Works |
|---|---|
| Warm terracotta palette | Unique, human, appropriate for personal finance |
| Custom envelope-shaped cards | On-brand, memorable, differentiating |
| AnimatedCents widget | Makes the app feel alive and responsive |
| Hero animation on envelope cards | Premium feel, high polish |
| Speed dial FAB with type selection | Reduces entry friction for most common action |
| Swipe-to-delete with undo snackbar | Safe destructive pattern, forgiving UX |
| Responsive breakpoint at 900px | Correct nav rail switchover point |
| Keyboard shortcuts for web/desktop | Power user love, thoughtful cross-platform |
| Color-coded amounts throughout | Clear income/expense/warning signal |
| Period navigation on dashboard | Powerful feature, surface needs work but existence is right |

---

## Priority Fix List

| # | Issue | Severity | File | Effort |
|---|---|---|---|---|
| 1 | Navigation labels always hidden | 🔴 | `app_shell.dart:286` | 1 line |
| 2 | Envelope footer touch targets too small (10px icon) | 🔴 | `envelope_card.dart:159–224` | Medium |
| 3 | Settings buried in overflow, not in navigation | 🟠 | `home_page.dart:150–154` | Medium |
| 4 | No onboarding progress indicator | 🟠 | `onboarding_page.dart` | Small |
| 5 | Allocation save TextButton easy to miss | 🟠 | `budget_page.dart:71–88` | Small |
| 6 | Semantic labels on envelope cards are generic | 🟠 | `envelope_card.dart:266` | Small |
| 7 | Color-only financial indicators (a11y) | 🟠 | Multiple | Medium |
| 8 | FAB uses `more_vert` on budget page | 🟡 | `budget_page.dart:91` | Small |
| 9 | Letter spacing too wide (6px on titles) | 🟡 | `app_text_theme.dart` | Small |
| 10 | Envelope name forced all-caps at 11px | 🟡 | `envelope_card.dart:96` | Small |
| 11 | Loading state is bare spinner everywhere | 🟡 | Multiple | Large |
| 12 | No payee autocomplete in transaction form | 🟡 | Transaction form | Large |
| 13 | Group icon in AppBar has no tooltip | 🟡 | `home_page.dart:93` | 1 line |
| 14 | Error snackbars have no retry action | 🟡 | Multiple | Medium |

---

## Final Verdict

**Score: 7.5 / 10**

Envelope is a well-built app with a genuinely strong aesthetic direction and solid engineering. The issues aren't fundamental — they're UX debt accumulated during feature development. The top three fixes (navigation labels, touch targets, settings accessibility) would meaningfully increase usability for real users. The rest are polish passes that elevate an already good app toward great.
