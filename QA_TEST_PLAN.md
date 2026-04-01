# Envelope App — QA Test Plan

## How to Test

### Setup
1. Run the app: `flutter run --flavor development --target lib/main_development.dart`
2. Use a real device or emulator (iOS Simulator / Android Emulator)
3. For web testing: `flutter run -d chrome --flavor development --target lib/main_development.dart`
4. For shared budget testing, use a second device/browser
5. Supabase local: `supabase start` (or use hosted project)

### Testing Approach
- Test each section sequentially (auth first, then onboarding, etc.)
- Mark each test case as PASS / FAIL / BLOCKED
- For failures: note steps to reproduce, expected vs actual, screenshot

### Priority Order
1. **P0 (Critical path)**: TC-1 (Auth), TC-2 (Onboarding), TC-6.1-6.3 (basic transactions), TC-8.1 (dashboard loads)
2. **P1 (Core features)**: TC-3 (Accounts), TC-4 (Envelopes), TC-5 (Allocation), TC-6 (full transactions), TC-7 (Recurring)
3. **P2 (Advanced)**: TC-9 (Goals), TC-10 (Shared budgets), TC-11 (Reports)
4. **P3 (Polish)**: TC-12 (Notifications), TC-13 (Settings), TC-14 (Platform), TC-15 (Cross-cutting)

---

## TC-1: Authentication

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 1.1 | Sign up with valid data | Enter name, email, password (8+ chars), confirm, check consent, tap Sign Up | Account created, redirected to onboarding |
| 1.2 | Sign up without consent | Fill all fields, leave consent unchecked | Sign Up button is disabled |
| 1.3 | Sign up with short password | Enter password < 8 chars | Validation error shown |
| 1.4 | Sign up with mismatched passwords | Enter different confirm password | "Passwords do not match" error |
| 1.5 | Sign up with invalid email | Enter "notanemail" | Validation error |
| 1.6 | Sign up with existing email | Use an already-registered email | Error snackbar |
| 1.7 | Sign in with valid credentials | Enter registered email + password | Redirected to home (or onboarding if first time) |
| 1.8 | Sign in with wrong password | Enter wrong password | Error snackbar |
| 1.9 | Sign in with non-existent email | Enter unregistered email | Error snackbar |
| 1.10 | Forgot password | Enter registered email, tap Send | Success message, check email |
| 1.11 | Google sign in | Tap Google button | Google auth flow opens, signs in on success |
| 1.12 | Apple sign in | Tap Apple button (iOS only) | Apple auth flow opens, signs in |
| 1.13 | Sign out | Settings > Sign Out > Confirm | Redirected to login page |
| 1.14 | Auth persistence | Sign in, force-close app, reopen | Still signed in |
| 1.15 | Keyboard Done without consent | Fill all fields, leave consent unchecked, press Done on keyboard | Nothing happens (submit blocked) |

---

## TC-2: Onboarding

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 2.1 | Complete full wizard | Welcome > Currency > Accounts > Income > Envelopes > Allocations | Budget created, redirected to home |
| 2.2 | Select currency | Search "EUR", select Euro | Currency shown as selected |
| 2.3 | Add account | Tap Add, enter "Checking", type=Checking, balance=1000 | Account appears in list |
| 2.4 | Add multiple accounts | Add Checking + Savings + Credit Card | All 3 shown in list |
| 2.5 | Remove account | Swipe or tap delete on an account | Account removed from list |
| 2.6 | Skip without account | Try to proceed with 0 accounts | Cannot proceed (validation) |
| 2.7 | Enter income | Enter 5000 as monthly income | Amount accepted, can proceed |
| 2.8 | Edit default envelopes | Rename "Rent" to "Mortgage" | Name updated |
| 2.9 | Set allocations | Enter amounts for each envelope | Amounts saved |
| 2.10 | Back navigation | Tap back on each step | Returns to previous step |
| 2.11 | On-budget vs off-budget | Add credit card (should default to off-budget) | On-budget toggle is OFF |
| 2.12 | New user after sign-out | Sign out User A, sign up User B | User B sees onboarding, not User A's data |
| 2.13 | Existing user sign-in | Sign out, sign back in as existing user | Goes directly to home, not onboarding |

---

## TC-3: Accounts

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 3.1 | View accounts list | Navigate to Accounts tab | All accounts shown with balances |
| 3.2 | Create account | Tap +, fill form, save | Account appears in list |
| 3.3 | Edit account | Tap account > edit | Form pre-filled, changes saved |
| 3.4 | Delete account | Edit > delete > confirm | Account removed |
| 3.5 | Account types | Create each type (checking, savings, creditCard, cash, investment, other) | Each shows correct icon/badge |
| 3.6 | Starting balance | Create with balance $500 | Balance shown on account card |
| 3.7 | On-budget toggle | Create checking (on-budget), verify Ready to Assign updates | Ready to Assign increases by starting balance |
| 3.8 | Total balance card | View accounts page | Total across all accounts shown at top |

---

## TC-4: Envelopes & Categories

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 4.1 | View envelope list | Navigate to Envelopes tab | Groups shown with envelopes |
| 4.2 | Create category group | Tap + group button, enter name | Group appears in list |
| 4.3 | Create envelope | Tap + on a group, enter name | Envelope appears under group |
| 4.4 | Edit envelope | Tap envelope > edit | Name/color editable |
| 4.5 | Assign color | Edit envelope > pick color | Color shown on envelope card |
| 4.6 | Delete envelope | Long press > delete > confirm | Confirmation dialog, then undo snackbar |
| 4.7 | Undo delete envelope | Delete > tap Undo in snackbar within 5s | Envelope restored |
| 4.8 | Archive envelope | Toggle archive on envelope | Envelope hidden from active list, undo snackbar |
| 4.9 | Undo archive | Archive > tap Undo in snackbar | Envelope unarchived |
| 4.10 | View archived | Toggle "show archived" | Archived envelopes visible |
| 4.11 | Delete category group | Delete group > confirm | Group + envelopes removed |
| 4.12 | Reorder envelopes | Enter reorder mode > drag | Order persists after save |
| 4.13 | Envelope detail | Tap envelope | Shows allocated, spent, remaining, transactions |

---

## TC-5: Budget Allocation

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 5.1 | View budget page | Navigate to Budget | Current period shown with envelopes |
| 5.2 | Allocate to envelope | Enter amount for an envelope | Amount shown, "Ready to Assign" decreases |
| 5.3 | Save allocations | Make changes > tap Save | Changes persisted to server |
| 5.4 | Ready to Assign | View after income transaction | Shows unallocated amount |
| 5.5 | Over-allocate | Allocate more than Ready to Assign | Ready to Assign goes negative (warning) |
| 5.6 | Transfer between envelopes | Budget > Transfer > select from/to/amount | From decreases, To increases |
| 5.7 | Navigate periods | Tap prev/next month arrows | Shows that period's allocations |
| 5.8 | Duplicate from previous | Tap "Duplicate" button | Current period gets previous period's amounts |
| 5.9 | Create allocation template | Save current allocations as template, enter name | Template saved |
| 5.10 | Apply template | Select template > apply | Allocations set to template values |
| 5.11 | Delete template | Delete template > confirm | Template removed |

---

## TC-6: Transactions

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 6.1 | Create expense | Tap +, type=Expense, amount=50, account=Checking, envelope=Groceries | Transaction created, account balance decreases |
| 6.2 | Create income | type=Income, amount=3000, account=Checking | Account balance increases, Ready to Assign updates |
| 6.3 | Create transfer | type=Transfer, from=Checking, to=Savings, amount=500 | Checking -500, Savings +500 |
| 6.4 | Edit transaction | Tap transaction > edit > change amount | Updated in list |
| 6.5 | Delete transaction | Swipe left > confirm > undo available | Soft-deleted, undo restores |
| 6.6 | Undo delete | Delete > tap Undo within 5s | Transaction restored |
| 6.7 | Add payee/notes | Create with payee="Store", notes="Weekly shop" | Shown in transaction detail |
| 6.8 | Add tags | Create transaction > add tags | Tags shown on transaction |
| 6.9 | Create new tag | In tag selector, type new name | Tag created and selected |
| 6.10 | Split transaction | Toggle split > add 2 envelopes with amounts | Splits total = transaction amount |
| 6.11 | Overspend warning | Create expense > exceeds envelope allocation | Warning dialog shown |
| 6.12 | Cover overspend | Accept overspend warning | Ready to Assign reduced |
| 6.13 | Date picker | Change date to yesterday | Transaction dated correctly |
| 6.14 | Transaction timeline | View transactions list | Grouped by date headers |

---

## TC-7: Recurring Rules & Bill Reminders

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 7.1 | Create recurring expense | Recurring > +Rule, monthly, $100, Rent envelope | Rule created in list |
| 7.2 | Create recurring income | Monthly income rule, $5000 | Rule in list |
| 7.3 | Create bill reminder | +Reminder, name=Electric, due day=15, remind 3 days before | Reminder created |
| 7.4 | Edit recurring rule | Tap rule > edit | Form pre-filled |
| 7.5 | Delete rule with undo | Delete > confirm > undo snackbar | Undo restores rule |
| 7.6 | Pause/resume rule | Toggle pause on a rule | Rule shows paused state |
| 7.7 | Auto-post transaction | Create auto-post rule, advance date past trigger | Transaction auto-created |
| 7.8 | Custom frequency | Create rule with custom: every 2 weeks | Displays "Every 2 weeks" |

---

## TC-8: Dashboard

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 8.1 | Dashboard loads | Open app (authenticated) | Shows Ready to Assign, accounts, recent transactions |
| 8.2 | Ready to Assign card | Tap card | Navigates to Budget page |
| 8.3 | Envelope summary | View envelope cards | Shows allocated/spent/remaining |
| 8.4 | Recent transactions | View bottom section | Last transactions with dates |
| 8.5 | Quick allocate | Tap envelope card > enter amount | Allocation updated |
| 8.6 | Pull to refresh | Pull down on dashboard | All data refreshed |
| 8.7 | Sync indicator | Make change on another device | Sync dot appears, data updates |
| 8.8 | Navigate to reports | Tap reports icon in app bar | Reports page opens |
| 8.9 | Navigate to shared budget | Tap group icon in app bar | Shared budget page opens |
| 8.10 | Navigate to settings | Tap menu > Settings | Settings page opens |
| 8.11 | Delete budget | Menu > Delete Budget > confirm | Budget deleted, navigate home |

---

## TC-9: Goals & Debt

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 9.1 | Create savings goal | Goals > +, name="Vacation", target=$5000 | Goal shown with progress bar |
| 9.2 | Create debt payoff goal | Goals > +, type=Debt, target=Credit Card balance | Goal tracks debt paydown |
| 9.3 | Edit goal | Tap goal > edit | Form pre-filled |
| 9.4 | Delete goal | Delete > confirm | Goal removed |
| 9.5 | Goal progress | Add contribution | Progress bar updates |
| 9.6 | Goal with deadline | Set target date | Shows time remaining |
| 9.7 | Goal detail page | Tap goal | Shows full details + progress |

---

## TC-10: Shared Budgets

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 10.1 | Invite by email | Enter email + role > Send | Invite sent, member appears as pending |
| 10.2 | Invalid email | Enter "notanemail" > Send | Validation error |
| 10.3 | Generate invite link | Select role > Generate | Link appears with share button |
| 10.4 | Share invite link | Tap share button | System share sheet opens |
| 10.5 | View pending invites | After generating links | Shows pending invites with expiry |
| 10.6 | Revoke invite | Tap Revoke on pending invite | Invite removed from list |
| 10.7 | Redeem invite (2nd user) | Open invite link while signed in | Redeem page shown, Accept button |
| 10.8 | Accept invite | Tap Accept on redeem page | Joined budget, success message |
| 10.9 | Redeem expired invite | Try to redeem after 7 days | Error: "Invite has expired" |
| 10.10 | Redeem already-used invite | Second user tries same link | Error: "Already redeemed" |
| 10.11 | Change member role | Tap member > change role | Role updated |
| 10.12 | Remove member | Tap remove > confirm | Member removed |
| 10.13 | Member limit | Try to invite when at limit (2 free) | Error: limit reached |
| 10.14 | Real-time updates | User A adds transaction, User B sees it | Data syncs within seconds |
| 10.15 | Activity log | View activity log | Shows all member actions |

---

## TC-11: Reports & Export

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 11.1 | Spending report | Reports > Spending | Donut chart + category breakdown |
| 11.2 | Budget vs Actual | Reports > Budget vs Actual | Bar chart comparing allocation to spent |
| 11.3 | Net worth report | Reports > Net Worth | Line chart of account balances over time |
| 11.4 | Trends report | Reports > Trends | Bar chart showing month-over-month |
| 11.5 | Change period | Use period selector | Report updates for selected period |
| 11.6 | Export CSV | Export > CSV > share | CSV file shared via system sheet |
| 11.7 | Export PDF | Export > PDF > share | PDF file shared |
| 11.8 | Empty report | View report for period with no data | Empty state message |

---

## TC-12: Notifications

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 12.1 | Toggle push notifications | Settings > Notifications > Push toggle | Saved, sub-toggles appear/hide |
| 12.2 | Toggle email notifications | Email toggle | Saved, sub-toggles appear/hide |
| 12.3 | Toggle individual types | Toggle overspend, bills, reminders, etc. | Each persists independently |
| 12.4 | Toggle weekly summary | Email > Weekly Summary toggle | Saved |
| 12.5 | Preference persistence | Toggle off > close > reopen | Toggle still off |
| 12.6 | Error rollback | Toggle while offline | Reverts to previous state |

---

## TC-13: Settings

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 13.1 | Edit display name | Settings > Display Name > change > save | Name updated across app |
| 13.2 | Change theme to dark | Settings > Theme > Dark | App immediately switches to dark theme |
| 13.3 | System theme | Settings > Theme > System | Follows device setting |
| 13.4 | Change currency | Settings > Currency > EUR > confirm warning | Currency label updated |
| 13.5 | Change password | Settings > Change Password > enter new | Success snackbar |
| 13.6 | Password too short | Enter < 6 chars | Error message |
| 13.7 | Password mismatch | Enter mismatched passwords | Error message |
| 13.8 | Export all data (JSON) | Settings > Export All Data | JSON file shared via system sheet |
| 13.9 | Delete account | Settings > Delete > type DELETE > confirm | Account deleted, local DB cleared, redirect to login |
| 13.10 | Delete cancel | Type wrong text > tap Delete | Nothing happens |
| 13.11 | App version | Scroll to bottom of settings | Version number displayed |
| 13.12 | Privacy/ToS links | Tap Privacy Policy or ToS | Opens browser |
| 13.13 | Sign out | Settings > Sign Out > confirm | Logged out, redirected to login |

---

## TC-14: Platform & Polish

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 14.1 | Bottom nav (mobile) | Run on phone (<900px) | Bottom NavigationBar with 5 tabs |
| 14.2 | Side rail (web/tablet) | Run on wide screen (>=900px) | NavigationRail on left side |
| 14.3 | Keyboard shortcut Ctrl+N | Press Ctrl+N on web | Transaction form opens |
| 14.4 | Keyboard shortcut Ctrl+1-4 | Press Ctrl+1 through Ctrl+4 | Switches between tabs |
| 14.5 | Keyboard shortcut Ctrl+, | Press Ctrl+comma | Settings page opens |
| 14.6 | Adaptive dialog (iOS) | Trigger delete confirmation on iOS | Cupertino-style dialog |
| 14.7 | Adaptive dialog (Android) | Same on Android | Material AlertDialog |
| 14.8 | Edge-to-edge (Android) | Check system nav bar | Transparent, content behind |
| 14.9 | Undo snackbar timing | Delete envelope | 5-second snackbar with Undo button |
| 14.10 | Confirmation dialog | Delete budget | Dialog with warning + destructive red button |

---

## TC-15: Cross-Cutting Concerns

| # | Test Case | Steps | Expected |
|---|-----------|-------|----------|
| 15.1 | Offline mode | Disable network > browse app | Cached data shown |
| 15.2 | Reconnect sync | Re-enable network after offline changes | Changes sync to server |
| 15.3 | Auth expiry redirect | Let session expire | Redirected to login |
| 15.4 | Deep link invite | Open envelope.app/invite/UUID in browser | Redeem page shown (or login first) |
| 15.5 | Data isolation | Sign in as User B | Cannot see User A's data |
| 15.6 | Concurrent edits | Two users edit same envelope | Last write wins, both see update |
| 15.7 | Large dataset | Create 100+ transactions | App remains responsive |
| 15.8 | App restart | Force close + reopen | Resumes where left off (auth persisted) |
| 15.9 | Consent recorded | Sign up > check DB | privacy_accepted_at and terms_accepted_at set |
| 15.10 | Multi-user switch | Sign out User A > sign up User B > sign out > sign in User A | Each user sees only their own data |
