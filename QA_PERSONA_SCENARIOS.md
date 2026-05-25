# Envelope App — Persona-Driven QA Scenarios

> Companion to `QA_TEST_PLAN.md`. The main plan covers each feature in isolation (TC-1 through TC-15). This document covers **cross-feature, multi-day, real-life user journeys** drawn from how 12 fictional users — diverse in income pattern, geography, life stage, and financial complexity — would actually use the app.
>
> Use this when feature-level QA is green and we need to prove the seams between features hold up under real usage.

## How to Use This Document

1. Each scenario is runnable as a `/qa-start TC-S-{persona}.{n}` session.
2. Mark each as PASS / FAIL / BLOCKED. For failures: note repro steps, expected vs actual, screenshot.
3. Where a step overlaps an existing feature TC, the Steps column references it (e.g. "see TC-6.1 for create-expense form details") — don't re-test the form, just exercise the journey.
4. **Capability bound**: scenarios stay strictly inside currently-shipped functionality. Investment tracking (stocks/MF/FD/crypto), bank sync, and CSV import are intentionally out — where a real user would naturally attempt these, the scenario uses a documented workaround (e.g. off-budget account with manual balance update) or stops at the boundary.

### Suggested Priority

- **P0 — must pass before launch**: P-01 (zero-literacy onboarding), P-02 (shared budget), P-07 (Mint refugee migration)
- **P1 — core differentiation**: P-06 (couples), P-09 (family), P-08 (debt focus), P-12 (newly-merged couple)
- **P2 — stress edges**: P-03 (irregular income), P-10 (6-CC churner), P-11 (multi-currency)
- **P3 — accessibility / niche**: P-04 (senior + remote helper), P-05 (small-business owner)

---

## Personas — At a Glance

| ID | Name | Age | Location | Income Pattern | Key Complexity |
|---|---|---|---|---|---|
| P-01 | Aarav Sharma | 24 | Bangalore IN | Monthly salaried ₹65K | First-time budgeter, UPI-heavy, 1 CC |
| P-02 | Priya & Karthik Iyer | 32, 35 | Mumbai IN | Dual monthly ₹3.7L + quarterly bonus | Shared budget, child, home loan, 3 CCs |
| P-03 | Rohan Mehta | 28 | Delhi IN | Freelance, ₹40K–₹2L/mo irregular | Multi-currency invoices, advance tax |
| P-04 | Lakshmi Nair | 58 | Kerala IN | Pension ₹35K + FD interest ₹15K | Senior, cash-heavy, son helps remotely |
| P-05 | Vikram Patel | 42 | Ahmedabad IN | Shop owner, mixed personal+business | Two budgets, GST, large CC inventory buys |
| P-06 | Tanvi & Arjun Reddy | 30, 32 | Hyderabad IN | Dual ₹5L/mo, no kids | CC rewards stacking, house savings goal |
| P-07 | Sarah & Mark Chen | 34, 32 | San Francisco US | Bi-weekly $4500 + freelance irregular | Mint refugee, mortgage, 3-paycheck months |
| P-08 | Marcus Johnson | 28 | Atlanta US | $58K salary + Uber side gig | $36K debt payoff focus, avalanche method |
| P-09 | Jennifer Walsh | 39 | Suburban OH US | Single-earner family $7800/mo | Family of 4, annual bills, cash envelopes |
| P-10 | David Kim | 45 | Seattle US | Steady $11K/mo | 6-CC churner, sign-up bonus tracking |
| P-11 | Maya Krishnan | 27 | Bangalore IN / nomad | $85K/yr USD remote, INR base | Multi-currency travel, Wise, FX |
| P-12 | Daniel & Aisha Brooks | 35, 33 | Brooklyn US | Dual $95K + $60K | Newly married, proportional split, mixed merge |

**Coverage rationale**: 6 India + 5 US + 1 cross-border. Income variety (monthly, bi-weekly, irregular, pension, business, dual-currency). Account variety (1-account simple → 6-CC complex). Life stages from fresher to retiree. Single-user, two-person shared, multi-stakeholder (couple + remote helper).

---

## P-01 — Aarav Sharma (Bangalore IT fresher)

**Bio**: 24, first job at TCS, lives with parents, sends ₹10K home monthly. SBI savings (₹15K), ICICI checking (salary credit), HDFC Millennia CC (₹50K limit, ₹5K current outstanding). Uses GPay/PhonePe for everything. Has never budgeted before — installed app after watching a Reddit thread.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-01.1 | First-time onboarding (zero financial literacy) | Install app → sign up email → onboarding wizard → pick INR → add SBI savings (starting ₹15K), ICICI checking (₹0), HDFC CC (limit ₹50K, balance ₹5K) → accept default category groups (Bills, Food, Transport, Personal) → skip allocation | Budget created with 3 accounts, 1 DebtAccount with `creditLimit`, default envelopes seeded, CC Payment envelope auto-linked to HDFC. RTA = ₹15K — on-budget starting balance is pushed into `totalIncome` via `addIncomeToCurrentPeriod` (`lib/accounts/cubit/account_form_cubit.dart:88`), so it is budgetable income, not a passive cushion |
| TC-S-01.2 | First salary credit + save Allocation Template | Day 1 of month: log income ₹65K to ICICI → allocate Rent ₹0 (parents), Food ₹8K, Transport ₹4K, Personal ₹6K, Family Support ₹10K, Savings Goal ₹15K, Buffer ₹22K → save current allocation as "Monthly Plan" template | After income: `totalIncome = ₹80K` (₹15K starting + ₹65K salary), allocations sum ₹65K, RTA = ₹15K. `AllocationTemplate` persisted with 7 `AllocationTemplateItem` rows storing **percentage** per envelope (not absolute amounts) — re-applying next month re-derives rupee amounts from then-current RTA |
| TC-S-01.3 | UPI grocery run + immediate dashboard refresh | Open app at supermarket → add expense ₹2400 → account ICICI → envelope Food → payee "More Hypermarket" → save → return to dashboard | Per recent commit `04222e4`, spentAmount increments optimistically before sync confirms; Food envelope shows ₹5600 available; ICICI balance drops |
| TC-S-01.4 | First CC swipe + understand CC Payment envelope | At restaurant: add expense ₹1200 → account HDFC CC → envelope Food → save → open dashboard CC Payment envelope | Food envelope drops by ₹1200 (allocation deducts); HDFC CC account balance increases to ₹6200 owed; CC Payment envelope shows ₹1200 needed; RTA unchanged (no double-deduction per `1e52944`) |
| TC-S-01.5 | Forgot to log expenses, bulk back-fill 5 days | Day 6: add 6 transactions back-dated to days 2–5 (groceries ₹450, auto ₹120, coffee ₹250 ×3, Zomato ₹680) | All 6 transactions accept past dates within current period; spentAmount aggregates correctly across envelopes; period totalIncome unchanged |
| TC-S-01.6 | Refund / return — first encounter | Returns shirt to Myntra ₹1499 → user unsure how to log → adds income transaction "Myntra refund" to ICICI → categorizes against Personal envelope | Refund pattern: income transaction with `envelopeId = original expense envelope`. Envelope `spentAmount` decrements; ICICI balance increments. No dedicated refund UI in v1.0 — pattern works but is undocumented in-app; flag as UX gap for first-timers |
| TC-S-01.7 | CC payment from savings (transfer) | End of month: pays ₹6200 from ICICI checking → CC HDFC payment as a transfer | Transfer transaction with transferPairId; ICICI balance −₹6200; HDFC CC account balance ₹0; CC Payment envelope drains to ₹0 |
| TC-S-01.8 | First month-end dashboard review | Open Reports → spending by category → trend view | SpendingReport shows category totals; donut chart renders; user identifies biggest envelope (likely Food); experience reinforces continued use |

---

## P-02 — Priya & Karthik Iyer (Mumbai working couple, 1 child)

**Bio**: Priya 32 marketing manager ₹1.5L + quarterly bonus ₹1.5L. Karthik 35 software engineer ₹2.2L. Married 6 yrs, daughter Aanya 5 in private school. Joint Kotak (rent + groceries), individual Axis savings each, 3 CCs (HDFC Regalia, Amex Plat, SBI Card). Home loan EMI ₹65K/mo. Annual life insurance ₹35K, health insurance ₹28K. Daughter's school annual fee ₹1.2L. Priya runs the budget.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-02.1 | Shared budget setup + invite spouse | Priya creates "Iyer Household" budget → adds joint Kotak + 3 CCs → invites Karthik via email as Editor → Karthik accepts on his device | BudgetMember created; activity log entry "Karthik joined"; both can see same budget on respective devices via Supabase realtime |
| TC-S-02.2 | Annual bills broken into monthly funding | Set up Goals: Life Insurance ₹35K target Aug 15, monthly ₹3K from Sep onward; Health Insurance ₹28K target Mar 1, monthly ₹2.5K; School Fee ₹1.2L target Apr 1, monthly ₹10K | 3 Goals created with targetDate + monthlyContribution; envelopes accumulate via monthly allocation; Goals view shows progress bars |
| TC-S-02.3 | Quarterly bonus arrives — windfall allocation | Priya logs income ₹1.5L bonus → RTA spikes → allocates: ₹60K home loan prepay envelope, ₹45K daughter education FD (envelope dump → manual transfer to off-budget account), ₹30K vacation goal contribution, ₹15K spread across discretionary | RTA = 0 after allocation; Vacation goal currentAmount += ₹30K; envelopes reflect; activity log shows allocation changes |
| TC-S-02.4 | Concurrent edit conflict — both editing dashboard | Priya allocates ₹2K to Dining at the same instant Karthik allocates ₹3K to the same envelope from his phone | Supabase Realtime resolves with **last-write-wins** semantics (no explicit conflict UI in v1.0). Final allocation reflects whichever write reached the server last (₹2K or ₹3K, not the sum). Activity log records both attempts; no data corruption |
| TC-S-02.5 | Husband uses joint CC, wife sees in real-time | Karthik buys furniture ₹8K on HDFC Regalia (joint CC) → on his device, logs expense to Home envelope | Priya's dashboard updates within sync interval; Home envelope shows new spent; CC Payment envelope grows; collaborator snackbar shown to Priya (suppressed for Karthik) |
| TC-S-02.6 | Bill reminder fires for life insurance premium | 7 days before Aug 15: open app → in-app bill reminder surfaces "Life Insurance ₹35K due in 7 days" → Priya confirms Goal funded → marks paid | Detection via `RecurringCheckCubit._isBillUpcoming` (`reminderDaysBefore=7`) fires on app open. **Push delivery is not client-dispatched** — requires Supabase Edge Function / Cloud Function (verify backend cron shipped before relying on push). Goal `currentAmount ≥ targetAmount`; payment transaction posted; `isCompleted=true` |
| TC-S-02.7 | Diwali festival overspend + move-money | Diwali month: Priya allocates ₹25K to Festival envelope but spends ₹38K (gifts ₹20K + clothes ₹12K + sweets ₹6K) → envelope goes negative ₹13K | Festival envelope shows red overspent state; Priya uses move-money to reallocate ₹13K from Vacation envelope; Festival back to ₹0; Vacation drops |
| TC-S-02.8 | Maid + cook cash payments | Withdraws ₹20K from Kotak ATM → adds to "Cash" cash account → daily expenses ₹15K total to Maid Salary envelope across 30 entries | Cash account decrements per expense; reconciles to ₹5K end-of-month |
| TC-S-02.9 | Year-end review with spouse | Both open Reports → BudgetVsActual for the year → SpendingReport top categories → NetWorthSnapshot trend | Charts render with full year data; both see same numbers via realtime. Export CSV/PDF via `lib/reports/view/export_report_page.dart` — platform impls stubbed in places, verify per platform (iOS/Android/Web) |

---

## P-03 — Rohan Mehta (Delhi freelance designer)

**Bio**: 28, freelance designer, 4–6 clients/month. Income ranges ₹40K–₹2L wildly. Some USD invoices via Wise/Razorpay. HDFC current account (business), HDFC savings (personal), 1 CC. Quarterly advance tax due. Buffer-fund obsessed.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-03.1 | Zero income week — RTA = 0 | Start month with ₹50K Buffer envelope already funded → no income arrives week 1 → bills due (rent ₹18K) | RTA=0 prevents new allocation; user pays rent from Bills envelope (already funded last month via rollover); Buffer untouched |
| TC-S-03.2 | Two clients pay same week — re-allocation flow | Day 10: client A pays ₹85K, client B pays ₹40K → RTA=₹1.25L → allocates ₹30K Tax (toward quarterly), ₹35K Bills, ₹20K Buffer top-up, ₹40K spread | RTA=0; Tax envelope progressing toward goal; Buffer envelope at ₹70K |
| TC-S-03.3 | USD invoice payment with FX | Client in US pays $1200 → Wise lands in HDFC current at ₹84.50/USD = ₹1,01,400 → log income with currency=USD, exchangeRate=84.50 | Transaction stored with USD currency + exchangeRate; budget RTA increases by ₹1,01,400 (converted to base INR); displayed with original USD reference |
| TC-S-03.4 | Quarterly advance tax payment | Day 15 of Q-end month: pays ₹45K from HDFC current → Tax envelope drains; Goal "Q2 Advance Tax" hits target | Tax envelope spentAmount=allocatedAmount; Goal isCompleted=true; activity log entry |
| TC-S-03.5 | Late client payment causes mid-month reallocation | Day 20: expected ₹60K from client X delayed → Bills envelope insufficient for ISP+power ₹8K → uses move-money from Vacation envelope to Bills | Vacation envelope reduces; Bills envelope covers payment; activity log records move |
| TC-S-03.6 | TDS reconciliation | Invoice ₹50K but Razorpay payout ₹47K (10% TDS deducted) → user logs ₹50K as income, then ₹3K expense to "TDS Receivable" envelope | Total income shown ₹50K; TDS Receivable envelope tracks ₹3K cumulative for year-end refund; mismatch with bank balance reconciled |
| TC-S-03.7 | Year-end TrendReport for tax filing | Open Reports → TrendReport full FY (Apr–Mar) → filter income transactions only | TrendReport sums income per month; total annual gross visible; user exports for CA |

---

## P-04 — Lakshmi Nair (Kerala retired teacher)

**Bio**: 58, retired schoolteacher. Lives with husband Ramesh (60). Pension ₹35K credits 5th. FD interest ₹15K credits 15th (FDs themselves are not tracked in app — only the resulting cash payouts). Children abroad send ₹50K Onam + ₹50K Diwali. Heavy cash use. Son Arjun helps remotely with the app.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-04.1 | Son sets up app remotely via shared budget | Arjun creates "Amma Budget" → invites Lakshmi as Editor → configures envelopes + accounts (SBI savings, cash) → Lakshmi installs on her phone, accepts | Both have access; activity log shows Arjun's setup actions; Lakshmi can edit |
| TC-S-04.2 | Two recurring incomes on different days | Set up RecurringRule: Pension ₹35K on day 5 monthly autoPost=true; FD Interest ₹15K on day 15 monthly autoPost=true | `autoPost` fires via `RecurringCheckCubit.check()` when the app is opened/foregrounded on or after the due date — **not a background scheduler**. Verify by launching app on/after day 5 and day 15. Transaction posts, `addIncomeToCurrentPeriod` increments RTA, `nextOccurrence` advances atomically |
| TC-S-04.3 | Hospital bill with later insurance reimbursement | Day 10: ₹18K hospital bill expense to Healthcare envelope → Day 25: insurance reimburses ₹15K to SBI savings → log as income to Healthcare envelope | Healthcare spent shows ₹18K; reimbursement reduces spent by ₹15K (or shows as separate income); net Healthcare spent = ₹3K |
| TC-S-04.4 | Festival gift from children abroad | Onam month: ₹50K transfer arrives from son in US → income to SBI savings → categorize as "Family Gift" envelope → allocate ₹30K Travel + ₹20K Buffer | RTA spikes; allocation flow works; Family Gift envelope shows allocated; activity log entry |
| TC-S-04.5 | Daily cash spending discipline | Withdraws ₹5K from SBI to "Cash Jar" cash account → spends ₹100–₹500/day for 30 days for groceries, milk, vegetables | Each cash transaction reduces Cash account; reconciles to expected ~₹0 by month-end |
| TC-S-04.6 | Senior-friendly UX — large text + simple flows | Open settings → look for larger text option; otherwise rely on OS-level text scaling (iOS Dynamic Type / Android font size) | **No in-app accessibility settings shipped in v1.0** — no Semantics overrides or explicit `textScaleFactor` handling found. App inherits whatever Material defaults provide for system text scaling. Flag as launch gap (senior-targeted UX) |
| TC-S-04.7 | Net worth snapshot includes cash + savings | Open Reports → NetWorthSnapshot | Displays SBI balance + Cash account; if FD principal is manually entered as off-budget account starting balance, it's included; trend chart over 3 months |

---

## P-05 — Vikram Patel (Ahmedabad textile shop owner)

**Bio**: 42, owns small textile shop, married to Anika (38). Personal: ₹2L/mo owner draw. Shop revenue: ₹80K–₹3L variable. Cash-heavy. GST ₹45K quarterly. Shop EMI ₹35K. 2 CCs (one personal, one business). Anika manages household budget only — no access to shop.

> ⚠️ **v1.0 BLOCKER for P-05**: Multi-budget per user is **NOT shipped in v1.0** — the app assumes a single active budget per session, with no budget-switcher UI. P-05 scenarios cannot run as written. Workarounds: (a) use two separate user accounts (one for personal, one for shop) and treat as two installs, or (b) collapse personal + shop into one budget using Tag-based separation. Mark all P-05 scenarios BLOCKED on the v1.0 launch matrix; promote to v1.1+ when multi-budget switching ships.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-05.1 | Two separate budgets under one user | Create "Patel Personal" budget + "Vikram Shop" budget under same login | **BLOCKED in v1.0** — no multi-budget UI. Test once feature ships: both budgets exist independently; switcher in app shell; each has own RTA + envelopes |
| TC-S-05.2 | Owner draw — manual inter-budget transfer | Shop budget: log expense ₹2L "Owner Draw" → switch to Personal budget → log income ₹2L "From Shop" | Two transactions; shop expense reduces shop RTA, personal income increases personal RTA; user manually keeps in sync (no auto inter-budget transfer) |
| TC-S-05.3 | Mixed expense categorization via Tags | Vendor dinner ₹3K — log under Shop budget Marketing envelope with tag `personal-mix` | Tag system captures intent; reportable later via Tag filter for tax review |
| TC-S-05.4 | Cash drawer reconciliation | Shop budget Cash account: ₹50K opening → 30 sales transactions ₹2K avg → 5 vendor cash payments ₹3K avg → end-of-week balance check | Cash account = ₹50K + ₹60K - ₹15K = ₹95K; user counts physical drawer ₹93K → adjustment transaction ₹2K to Reconciliation envelope |
| TC-S-05.5 | Large CC inventory purchase nears limit | Shop budget: ₹3L inventory purchase on business CC (limit ₹4L, current ₹50K outstanding) → after purchase outstanding ₹3.5L | CC account balance ₹3.5L; available credit ₹50K shown; CC Payment envelope grows; verify near-limit warning per `b3f3df1` |
| TC-S-05.6 | Quarterly GST payment | Shop Tax envelope target ₹45K via monthly ₹15K allocation hits → Day 20 of quarter-end: pay ₹45K from current account | Tax envelope drains to 0; Goal completed; activity log entry |
| TC-S-05.7 | Anika has limited access | Anika invited as Editor on Personal budget only → cannot see Shop budget on her account | BudgetMember scoped per budget; Anika's app shows only Personal; activity log clean separation |

---

## P-06 — Tanvi & Arjun Reddy (Hyderabad dual-IT couple)

**Bio**: Tanvi 30, Arjun 32, both IT, both ₹2.5L/mo. Married 2 yrs, no kids. House down payment goal ₹50L by Dec 2028. CC rewards stackers — Axis Magnus + HDFC Infinia, hitting milestone spends. Joint vacation goal ₹3L by Dec 2026.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-06.1 | Both onboard simultaneously | Tanvi creates "Reddy Joint" budget → invites Arjun → Arjun accepts on his device | Both see same budget; activity log shows both onboarding events |
| TC-S-06.2 | Long-term house goal | Goal "House Down Payment" ₹50L target Dec 2028, monthly contribution ₹1.4L combined | Goal created with future targetDate; current progress = 0; monthly progress visible |
| TC-S-06.3 | Dual income — combined RTA | Both salaries credit on 1st: Tanvi ₹2.5L to her Axis, Arjun ₹2.5L to his ICICI → both log as income → joint RTA = ₹5L | RTA reflects sum across both individual accounts within the same budget; allocate from joint pool |
| TC-S-06.4 | CC milestone tracking via Tags | Axis Magnus needs ₹5L spend in 6 months for milestone → tag every Magnus expense with `magnus-milestone-2026` → Reports filter by tag | Tag persists on transactions; Reports filter sums tagged expenses; user sees ₹2.3L of ₹5L progress |
| TC-S-06.5 | Vacation goal hit, plan trip | Vacation goal ₹3L hits Dec 2026 → Goal isCompleted=true → user creates Vacation Spend envelope and "withdraws" goal funds via move-money | Goal marked complete; new envelope or transfer via move-money; pre-funded ready to spend |
| TC-S-06.6 | Disagreement workflow — Arjun overspends Dining | Arjun spends ₹6K dining out, envelope only had ₹4K → goes negative ₹2K → Tanvi sees in dashboard | Dining shows red −₹2K; Tanvi initiates move-money from "Personal Arjun" envelope ₹2K → Dining; activity log captures |
| TC-S-06.7 | Concurrent same-envelope edit | Tanvi and Arjun simultaneously add expense to Groceries from different devices | Both transactions persist (additive, no last-write contention — each is a distinct row); envelope `spentAmount` reflects sum; no race condition. Verify pending-sync count drains to 0 via the `getPendingSyncMetadata()` DAO query (no `pendingChangesCount` field on `SyncMetadata` — count is derived) |
| TC-S-06.8 | Year-end report — savings rate calculation | Reports → BudgetVsActual + TrendReport full year | App computes total income vs total spent; displays surplus and savings rate; both view same data |

---

## P-07 — Sarah & Mark Chen (San Francisco Mint refugee couple)

**Bio**: Sarah 34 SWE bi-weekly $4500 net (26 paychecks/yr). Mark 32 freelance writer, $0–$5500 irregular. Joint Chase checking + individual checkings. Mortgage $3200/mo, car payment $450/mo, Chase Sapphire + Amex Gold + Discover. 401k off-budget account workaround. Migrated from Mint after shutdown.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-07.1 | Migration from Mint — manual setup (or CSV import if shipped) | **Pre-check**: confirm whether CSV import has shipped (`MVP_RELEASE_STRATEGY.md` lists it as Week 0–1 pre-launch work — status as of 2026-05-18 must be re-verified). If shipped, run CSV import path; otherwise: Sarah manually creates accounts with current balances + transcribes last month's recurring transactions as RecurringRules | If CSV import shipped: importer parses Mint CSV, maps to accounts + envelopes + transactions. If not: all accounts created manually; recurring rules for mortgage, car payment, utilities, Netflix, gym; user notes lack of CSV import as friction |
| TC-S-07.2 | Bi-weekly paycheck — recurring rule | RecurringRule: Income $4500 every 14 days starting Friday Apr 4 autoPost=true → next 26 occurrences computed | Rule created with frequency='bi-weekly'; nextOccurrence = Apr 18; income posts on Fridays |
| TC-S-07.3 | "3-paycheck month" planning | In months Sarah gets 3 paychecks (twice yearly), RTA is +$4500 vs typical → allocate windfall: $2000 emergency fund, $1500 vacation, $1000 home repair | RTA correctly reflects extra paycheck; allocation lands; goals advance |
| TC-S-07.4 | Husband's irregular income | Mark gets $3500 freelance → log to joint Chase as income → leave unallocated until next budget meeting | RTA increments; couple discusses allocation later; activity log shows Mark's income entry |
| TC-S-07.5 | Costco split transaction | Costco purchase $340 → split: Groceries $220, Household $80, Personal Care $40 across 3 envelopes in one transaction | TransactionSplits stores 3 rows; each envelope's spent increments per split; total transaction = $340 |
| TC-S-07.6 | Unexpected car repair drains envelope | Auto Maintenance had $400 → repair $1200 → envelope goes −$800 → move from Vacation envelope $800 | Auto Maintenance back to $0; Vacation reduces by $800; Goal "Vacation 2026" currentAmount adjusted (verify Goal-vs-envelope linkage behavior) |
| TC-S-07.7 | Retail return reverses Clothing | Sarah returns $250 jacket → log as income transaction with envelopeId=Clothing | Refund pattern (see TC-S-01.6): Clothing envelope `spentAmount` decrements; Chase checking refunded; net impact correct |
| TC-S-07.8 | Buffer-days / Cushion Score | Open Reports → look for buffer-days metric | **NOT shipped in v1.0** — confirmed deferred per `YNAB_COMPARISON_AND_LAUNCH_STRATEGY.md` §3.5. Document gap; do not run as a pass/fail test until v1.1 |

---

## P-08 — Marcus Johnson (Atlanta debt-payoff focus)

**Bio**: 28, recent grad. $58K salary, $36K total debt: $32K student loans (6.8% APR, $400 min/mo), $4K Chase Freedom CC (24% APR, $150 min). Side hustle Uber $200–$800/mo. Roommate Bryan splits $1200 rent. Avalanche method — high-interest CC first.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-08.1 | Set up DebtAccounts with interest + minimums | Add student loan as DebtAccount: $32K balance, 6.8% APR, $400 min, originalBalance $32K → Chase CC $4K, 24% APR, $150 min, creditLimit $5000 | Both DebtAccounts created with interestRate, minimumPayment, creditLimit; visible on dashboard with payoff progress |
| TC-S-08.2 | Avalanche payoff goals | Goal "CC Debt $0" target Dec 2026, monthlyContribution $400 (above min) → Goal "Student Loan $0" target Dec 2032, monthly $500 | Two Goals tied to debt accounts; payoff timeline visible; monthly extra above-minimum tracked |
| TC-S-08.3 | Side gig income variable allocation | Uber payout $620 → income to Checking → all $620 allocated to CC Payoff envelope (extra above $400 baseline) | RTA spike of $620; envelope allocation; CC Goal currentAmount += contribution post-payment |
| TC-S-08.4 | Roommate Venmo for rent | Bryan sends $600 via Venmo to Marcus checking → user logs as income against Rent envelope (negative-expense pattern) | Rent envelope effectively reduces by $600; total Rent paid out = $1200 - $600 = $600 net; flag if this UX is confusing for first-timers |
| TC-S-08.5 | CC payment day | Day 28: pay $550 from Checking to Chase CC | Transfer transaction with `transferPairId`; CC account balance reduces; CC Payment envelope drains. **Interest accrual is manual** in v1.0 — user must log a separate expense transaction to capture monthly interest charges (no auto-accrual on DebtAccount) |
| TC-S-08.6 | Approaching CC limit during big purchase | Spends $400 emergency car tire on Chase CC (current $4000 of $5000 limit) → balance now $4400, available $600 | Available-credit display shipped per commit `b3f3df1` (`lib/accounts/widgets/credit_card_float_warning.dart`). Dashboard CC card shows headroom = `creditLimit − outstanding`; warning surfaces when CC Payment envelope doesn't fully cover outstanding balance |
| TC-S-08.7 | Debt payoff progress visualization | Open Goals view → CC Debt goal progress bar | Shows current $4000 → $0 timeline at $400/mo = ~10 months; visual progress; motivating |

---

## P-09 — Jennifer Walsh (Ohio family of 4)

**Bio**: 39, stay-at-home, manages family budget. Husband salary $7800 monthly. Kids 7 & 11. Annual: property tax $4800 (Jan), home insurance $1400 (Mar), car insurance $1000 (Jul), life insurance $300 ×2 (Sep). Cash envelope literal — withdraws $400/wk for groceries. Christmas $1500, vacation $3000.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-09.1 | Annual bills broken into monthly funding | Setup 5 Goals: Property Tax $4800 by Jan 31 ($400/mo), Home Ins $1400 by Mar ($120/mo), Auto Ins $1000 by Jul ($85/mo), Life Ins $300 by Sep ($25/mo), Christmas $1500 by Dec ($125/mo) | 5 Goals with proper schedules; envelopes accumulate monthly; dashboard shows progress bars |
| TC-S-09.2 | Cash envelope literal withdrawal | Withdraws $400 from Checking → adds to "Cash" cash account → spends Mon $80, Tue $45, Wed $60, Thu $90, Fri $75 across week at grocery + farmers market | Cash account tracks each transaction; reconciles to $50 remaining end-of-week |
| TC-S-09.3 | Kids' allowance recurring | RecurringRule: $20/wk to "Allowance Kid 1" envelope, $20/wk "Allowance Kid 2" envelope | Two recurring expenses; envelopes drain weekly; bill reminder if missed |
| TC-S-09.4 | Property tax bill reminder fires | Jan 17 (14 days before Jan 31): open app → in-app reminder surfaces "Property tax $4800 due Jan 31" → Goal already at $4800 → Jennifer pays from Checking | Detection via `RecurringCheckCubit` at `reminderDaysBefore=14` fires on app open. Push delivery requires backend cron (verify separately). Goal `currentAmount=targetAmount`; payment posted; `isCompleted=true` |
| TC-S-09.5 | Kid breaks tablet — unexpected $300 | No envelope for this → Jennifer creates "Misc Family" envelope on the fly → moves $300 from Vacation envelope (had $1800 saved of $3000 goal) | New envelope created; move-money executes; Vacation goal currentAmount drops by $300; user notes goal will hit later than July |
| TC-S-09.6 | Husband's $5000 bonus arrives | Income $5000 → RTA jump → Jennifer allocates: $2000 Christmas top-up (early), $1500 emergency fund, $1000 home repair, $500 spread | RTA→0; Goals advance early; envelopes top up |
| TC-S-09.7 | Costco bulk + split | Costco $480 → split Groceries $300, Household $100, Pharmacy $80 | TransactionSplits stored; envelopes update |
| TC-S-09.8 | Year-end family budget review | Reports → BudgetVsActual full year + spending donut | Categories summed; identifies over-budget categories (likely Auto + Misc); under-budget Dining |

---

## P-10 — David Kim (Seattle CC churner)

**Bio**: 45, steady $11K/mo. 6 active CCs cycling sign-up bonuses: Chase Sapphire Preferred ($4K spend / 3mo for 60K pts), Amex Gold ($6K/6mo for 90K), Citi Premier ($4K/3mo), Capital One Venture ($4K/3mo), Bilt, Discover. Pays in full every month. Float window strategy.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-10.1 | 6 CCs each with own CC Payment envelope | Add 6 DebtAccounts each with creditLimit | 6 DebtAccounts created; 6 CC Payment envelopes auto-spawned per `1e52944` flow; dashboard CC section shows 6 cards |
| TC-S-10.2 | Sign-up bonus tracking via Tag | Tag every Chase Sapphire transaction `chase-sp-2026q2` for 90 days → Reports filter by tag | Tag persists; filter sums expenses over period; user sees $2300 of $4000 toward bonus |
| TC-S-10.3 | Big planned purchase routes to specific CC | $2400 home appliance → user picks Capital One Venture (currently $1100 spent of $4000 bonus target) → balance now $3500 | Transaction posts to CV account; CC Payment envelope grows; user closer to bonus |
| TC-S-10.4 | Pay all 6 cards in full on same day | Bills day: 6 transfers from Checking to each CC paying full statement balance | 6 transactions same date; each CC Payment envelope drains; CC account balances → $0 |
| TC-S-10.5 | Statement-cycle float window | Card closes Apr 5, due May 25 → user has $1800 spent on it → between Apr 5 and May 25, CC account balance = $1800 but CC Payment envelope already covers it | Verify CC Payment envelope tracks correctly across periods; available credit shows correct float; no double-counting |
| TC-S-10.6 | Close CC after bonus earned | Bonus posted, user closes Discover → archive Account | `Account.isArchived=true`; historical data preserved; dashboard shows 5 active cards. **Verify cascade**: does archiving the DebtAccount also archive its linked CC Payment envelope, or does the envelope linger in pickers? Flag if cascade not implemented |
| TC-S-10.7 | Reports: total CC spend across all 6 | Reports → filter by accountType=CC OR sum across all DebtAccounts | Aggregate spend by card; tag-based bonus progress; net rewards earned (manual entry of pts→$$ if user wants) |

---

## P-11 — Maya Krishnan (cross-border remote worker)

**Bio**: 27, Indian, remote SWE for SF startup. Salary $85K/yr paid monthly via Wise into NRE account ($7000/mo) → INR converted as needed. Travels EU/SEA quarterly. Holds: Wise USD account, NRE savings (USD), HDFC savings (INR), Revolut (EUR). Base currency INR.

> ⚠️ **Build prerequisite for P-11**: Multi-currency UI is feature-flagged **OFF in default v1.0 builds** (commit `b5213af`, flag `kMultiCurrencyEnabled` in `lib/shared/feature_flags.dart`). Per-account currency picker, FX rate on transactions, and EUR/USD account types do not appear in the UI unless the build is started with `--dart-define=ENABLE_MULTI_CURRENCY=true`. Skip P-11 in the default v1.0 QA pass; run only on the multi-currency build, or defer entire persona to v1.1 launch matrix.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-11.1 | Multi-currency account setup | Budget baseCurrency INR. Add: Wise USD account (USD), NRE savings (USD), HDFC savings (INR), Revolut (EUR) | All 4 accounts created; each with its own currency field; budget computes net worth in INR via exchangeRate |
| TC-S-11.2 | Monthly USD salary income | Day 1: $7000 salary credits Wise USD → log income in USD with exchangeRate=84.20 | Income stored with currency=USD, amount=$7000, exchangeRate; converts to ₹5,89,400 for RTA |
| TC-S-11.3 | USD→INR conversion via Wise | Maya converts $5000 → ₹4,21,000 in HDFC at rate 84.20 → log as transfer with transferPairId, currencies different | Two paired transactions: Wise USD −$5000, HDFC INR +₹4,21,000; FX captured; balances update both currencies |
| TC-S-11.4 | Travel to Bangkok — THB spending | Withdraws ₹50,000 worth THB from ATM in Bangkok → spends 30,000 THB across 8 days on food, transit, hotel → 8 expense transactions in THB or INR-equivalent | Each expense logged with exchangeRate at time, OR logged in INR after manual conversion (verify which UX is supported); envelope spent reflects |
| TC-S-11.5 | EUR refund on cancelled hotel | Refund €120 to Revolut → log as income in EUR with exchange rate | Revolut balance increments €120; envelope spent reduces |
| TC-S-11.6 | Quarterly tax filing — USD income to INR | Reports → TrendReport filter by income only, full quarter | App sums USD income converted to INR per transaction's exchangeRate; total INR equivalent visible; export for CA |
| TC-S-11.7 | Net worth across 3 currencies | Reports → NetWorthSnapshot | Aggregates all accounts converted to INR base; EUR + USD + THB cash + INR all summed; flag if FX rate is stale |
| TC-S-11.8 | Mid-trip lost wallet — Cash account adjustment | Loses physical wallet with ~₹8000 INR + €40 → reconciliation transaction "Lost wallet" expense to Misc envelope, deducts from Cash account | Cash account decrements; envelope spent increments; activity log captures |

---

## P-12 — Daniel & Aisha Brooks (Brooklyn newly merged)

**Bio**: Daniel 35 finance $95K, Aisha 33 designer $60K. Married 2 months ago. Each had separate finances 3+ yrs. Want shared visibility on household expenses but keep individual discretionary private. Aisha has $18K student loan. Renting, no kids. Splitting bills proportionally (61% Daniel / 39% Aisha based on income).

> ⚠️ **v1.0 caveat for P-12**: Multi-budget per user is **NOT shipped** (see P-05 caveat). The "three-budget" privacy model (Daniel personal + Aisha personal + shared Household) cannot be tested as written. Use the v1.0 fallback below; promote to full three-budget scenarios when multi-budget switching ships.

| # | Test Case | Steps | Expected |
|---|---|---|---|
| TC-S-12.1 | Shared Household budget only (v1.0 fallback) | Daniel creates "Brooks Household" → invites Aisha as Editor → set up envelopes for rent, groceries, utilities, joint streaming, plus discretionary envelopes per person ("Daniel Personal", "Aisha Personal") within the same budget | One shared budget, both users co-edit. **Privacy caveat**: in-budget envelopes are visible to both members — discretionary spending is *not* hidden in v1.0. True private-budget split deferred until multi-budget ships. Document gap on launch matrix |
| TC-S-12.2 | Proportional split contribution | Daniel funds Household $3050/mo (61%), Aisha funds $1950/mo (39%) → both log income transfers from individual checking to shared Joint Chase | Two recurring transfers monthly; Household RTA = $5000; activity log shows both contributions |
| TC-S-12.3 | Aisha's student loan tracking (v1.0 fallback) | Add DebtAccount $18K within the shared Household budget, Goal $0 by 2030, monthly $300 | DebtAccount + Goal track payoff. **v1.0 caveat**: Daniel sees this too (no per-account privacy). Mark as gap until multi-budget unlocks true privacy |
| TC-S-12.4 | Daniel buys Aisha birthday gift "secretly" (v1.0 fallback) | Daniel logs $200 expense in shared Household → uses "Daniel Personal" envelope | **Privacy NOT enforced** in v1.0: Aisha can see the transaction in activity log + dashboard. Document gap; true secret-gift workflow blocked on multi-budget |
| TC-S-12.5 | Joint emergency fund goal | Shared Household: Goal "Emergency Fund" $15K target Dec 2027, monthly $625 combined | Goal created in Household; both contribute via monthly funding; Goal currentAmount progresses |
| TC-S-12.6 | Household grocery — split by who paid | Aisha pays $180 groceries on her CC → expense logged to Household Groceries envelope from Aisha account | Household envelope spent +$180; Aisha's CC tracks debt. **No Settle-Up flow shipped in v1.0** — per-transaction split-by-payer / proportional reconciliation must be done outside the app (Splitwise, manual Venmo). Document gap; do not gate launch on this |
| TC-S-12.7 | Monthly review meeting | Both open Household budget Reports → BudgetVsActual + Goals progress | Both see same numbers via realtime sync; relationship-positive UX |
| TC-S-12.8 | Same email signup confusion | Aisha attempts signup with shared email already on Daniel's account | Validation prevents duplicate; clear error; flag if unclear UX |

---

## Coverage Matrix

Legend: ● = primary stress · ○ = touched · `·` = not applicable · ⚠ = feature blocked/gated in v1.0 (see persona caveat)

| Feature | P-01 | P-02 | P-03 | P-04 | P-05 | P-06 | P-07 | P-08 | P-09 | P-10 | P-11 | P-12 |
|---|---|---|---|---|---|---|---|---|---|---|---|---|
| Onboarding | ● | ○ | ○ | ● | ● | ○ | ● | ○ | ○ | ○ | ● | ● |
| Multi-account | ○ | ● | ● | ○ | ● | ● | ● | ○ | ● | ● | ● | ● |
| Multi-budget (BLOCKED v1.0) | · | · | · | · | ●⚠ | · | · | · | · | · | · | ●⚠ |
| Envelopes / categories | ● | ● | ● | ● | ● | ● | ● | ● | ● | ● | ● | ● |
| RTA / income flow | ● | ● | ● | ● | ● | ● | ● | ○ | ● | ○ | ● | ● |
| Allocation Templates | ● | ○ | ● | · | · | · | · | · | · | · | · | · |
| Move-money / re-allocate | ○ | ● | ● | ○ | · | ● | ● | ○ | ● | · | · | · |
| Overspending | · | ● | ○ | · | · | ● | ● | ○ | ● | · | · | · |
| Refund / negative expense | ● | · | ○ | ● | · | · | ● | ● | · | · | ● | · |
| Recurring rules | ● | ● | ○ | ● | ○ | ○ | ● | ○ | ● | · | ● | ● |
| Bill Reminders | · | ● | · | · | · | · | ○ | · | ● | · | · | · |
| Goals (savings) | ● | ● | ○ | · | · | ● | ● | · | ● | ○ | · | ● |
| Goals (debt payoff) | · | · | · | · | · | · | · | ● | · | · | · | ● |
| CC tracking + Payment envelope | ● | ● | · | · | ● | ● | ● | ● | · | ● | · | ○ |
| CC limit / available credit | · | · | · | · | ● | · | · | ● | · | ● | · | · |
| Multi-currency / FX (FLAG-GATED) | · | · | ●⚠ | · | · | · | · | · | · | · | ●⚠ | · |
| Cash account | · | ● | · | ● | ● | · | · | · | ● | · | ● | · |
| Split transactions | · | · | · | · | · | · | ● | · | ● | · | · | · |
| Tags | · | · | · | · | ● | ● | · | · | · | ● | · | · |
| Transfers (account ↔ account) | ● | · | · | · | ● | · | · | ● | · | ● | ● | ● |
| Shared budget invite | · | ● | · | ● | ● | ● | · | · | · | · | · | ● |
| Shared budget realtime / concurrent | · | ● | · | · | · | ● | · | · | · | · | · | ● |
| Activity log | · | ● | · | ● | ● | ● | · | · | · | · | · | ● |
| Soft delete (envelope/transaction) | · | · | · | · | ○ | · | · | · | · | ● | · | · |
| Reports — spending | ● | ● | ● | · | · | ● | ○ | ● | ● | ● | ● | ● |
| Reports — trends | ○ | ● | ● | · | · | ● | ○ | ● | ● | · | ● | · |
| Reports — net worth | · | ● | · | ● | · | · | ● | ● | ○ | · | ● | · |
| Reports — budget vs actual | · | ● | · | · | · | ● | ○ | · | ● | ○ | · | ● |
| Notifications — in-app reminders | ○ | ● | · | · | · | · | ○ | · | ● | · | · | · |
| Notifications — push (server-side, verify) | · | ○ | · | · | · | · | · | · | ○ | · | · | · |
| Notifications — email (v1.1, NOT shipped) | · | · | · | · | · | · | · | · | · | · | · | · |

---

## Out-of-Capability Notes (intentionally excluded)

Real personas would naturally do these things; they are documented here so QA testers don't waste time and so product/launch backlog can capture demand:

- **Investments / FD / MF / stocks / crypto / gold** — no per-asset model. Workaround per scenarios: off-budget Account with manually-updated balance. Affects Lakshmi (FDs), Priya (SIP/FD), Tanvi & Arjun (mutual funds), Sarah (401k), Maya (any).
- **Bank sync (Plaid / OFX / account aggregation)** — manual entry only, deferred to v1.2 (~90 days post-launch per `MVP_RELEASE_STRATEGY.md`). Affects everyone but most painfully Sarah (Mint refugee), David (6 cards), Jennifer (multi-account family).
- **CSV import / migration tooling** — flagged for pre-launch (Week 0–1) but **ship status must be re-verified on 2026-05-18+**. Affects Sarah's onboarding from Mint.
- **Multi-budget per user (budget switcher)** — single-budget per session in v1.0. Blocks P-05 entirely, partially blocks P-12 privacy model. No workaround inside one user account beyond Tag-based separation.
- **Per-transaction settle-up between two users** — Daniel/Aisha proportional splits require manual reconciliation (Splitwise, Venmo).
- **Auto-interest accrual on DebtAccounts** — Marcus needs to manually log interest charges; no scheduled APR application.
- **Buffer days / Cushion Score / Age-of-Money equivalent** — **NOT in v1.0**, deferred to v1.1+ per YNAB strategy doc §3.5.
- **Multi-currency UI** — built but feature-flagged OFF in v1.0 (commit `b5213af`, `--dart-define=ENABLE_MULTI_CURRENCY=true` to enable). Affects entire P-11; partially Rohan (USD invoices).
- **Email notifications** — NOT shipped in v1.0, deferred to v1.1 per MVP strategy. Preferences toggle exists but no delivery path.
- **Push notification dispatch** — FCM client wired (`lib/notifications/services/fcm_service.dart`), but server-side cron / Edge Function for bill reminders must be verified before relying on push in QA. Detection logic runs only on app open.
- **In-app accessibility (large text / Semantics / Dynamic Type override)** — NOT shipped. App relies on OS-level scaling only. Senior-targeted UX gap.
- **PDF / CSV export of reports** — UI exists at `lib/reports/view/export_report_page.dart`, platform-specific impls partially stubbed — verify per platform.
- **Cascade archive (CC Payment envelope when DebtAccount archived)** — verify behavior; flag if envelope lingers in picker after CC account closed.

If any of the above are actually shipped during QA execution, promote the corresponding scenario step from "flag if missing" to a passing assertion.

---

## Execution Checklist (per persona QA session)

- [ ] Reset to clean install before each persona session
- [ ] Use sample data matching persona bio (income, accounts, balances)
- [ ] Run scenarios in order — they often build on prior state
- [ ] Cross-reference any TC-X.Y from `QA_TEST_PLAN.md` for low-level form testing
- [ ] Capture screenshot evidence on every FAIL
- [ ] File issues with `persona/` label and link to TC-S-XX.X
