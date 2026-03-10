# Envelope — Implementation Plan

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter (Android, iOS, Web) |
| State Management | Bloc / Cubit |
| Local Database | Drift (SQLite) |
| Backend | Supabase (Postgres, Auth, Realtime, Edge Functions, Storage) |
| Subscriptions | RevenueCat |
| CI/CD | GitHub Actions |
| Notifications | Firebase Cloud Messaging (push) + Supabase Edge Functions (email) |
| Architecture | VGV Layered Architecture (Data → Domain → Business Logic → Presentation) |

---

## Architecture: VGV Layered Architecture

Following [Very Good Ventures' recommended architecture](https://www.verygood.ventures/blog/very-good-flutter-architecture), the app uses a **four-layer architecture** with data and domain layers isolated into separate packages.

### The Four Layers

1. **Data Layer** — Interacts directly with APIs (Supabase, Drift, device APIs). Lives in separate Dart packages. Contains API clients, data transfer objects, and raw data retrieval logic.

2. **Domain Layer** — Transforms and manipulates raw data. Lives in separate Dart packages alongside (or above) the data layer. Contains repository implementations, domain models, and data transformation logic. Provides a clean, simple API to the business logic layer.

3. **Business Logic Layer** — Manages state using `flutter_bloc`. Contains Blocs/Cubits that receive UI events, interact with repositories, and emit states. Lives in the main app under each feature.

4. **Presentation Layer** — Renders UI based on Bloc state. Contains pages, views, and widgets. No direct API calls or data logic — purely reactive to state.

### Data Flow

```
User Interaction
       ↓
[ Presentation Layer ]  →  triggers events
       ↓
[ Business Logic Layer (Bloc) ]  →  calls repository methods
       ↓
[ Domain Layer (Repository) ]  →  transforms/orchestrates data
       ↓
[ Data Layer (API Client) ]  →  talks to Supabase / Drift
       ↓
  Raw Data returned
       ↓
[ Domain Layer ]  →  transforms to domain models
       ↓
[ Business Logic Layer ]  →  emits new state
       ↓
[ Presentation Layer ]  →  rebuilds UI from state
```

---

## Project Structure

### Package-Based Architecture

Data and domain layers are isolated into **separate Dart packages** so they can be developed, tested, and versioned independently.

```
envelope/
├── packages/
│   ├── envelope_api_client/              # Data layer: Supabase API client
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/               # DTOs / serialization models
│   │   │   │   │   ├── user_dto.dart
│   │   │   │   │   ├── budget_dto.dart
│   │   │   │   │   ├── account_dto.dart
│   │   │   │   │   ├── envelope_dto.dart
│   │   │   │   │   ├── transaction_dto.dart
│   │   │   │   │   └── ...
│   │   │   │   └── envelope_api_client.dart
│   │   │   └── envelope_api_client.dart   # barrel file
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── envelope_local_storage/            # Data layer: Drift local database
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── database/
│   │   │   │   │   ├── app_database.dart
│   │   │   │   │   ├── tables/
│   │   │   │   │   │   ├── users_table.dart
│   │   │   │   │   │   ├── budgets_table.dart
│   │   │   │   │   │   ├── accounts_table.dart
│   │   │   │   │   │   ├── category_groups_table.dart
│   │   │   │   │   │   ├── envelopes_table.dart
│   │   │   │   │   │   ├── transactions_table.dart
│   │   │   │   │   │   ├── goals_table.dart
│   │   │   │   │   │   └── ...
│   │   │   │   │   └── daos/
│   │   │   │   │       ├── users_dao.dart
│   │   │   │   │       ├── budgets_dao.dart
│   │   │   │   │       ├── accounts_dao.dart
│   │   │   │   │       ├── envelopes_dao.dart
│   │   │   │   │       ├── transactions_dao.dart
│   │   │   │   │       └── ...
│   │   │   │   └── envelope_local_storage.dart
│   │   │   └── envelope_local_storage.dart  # barrel file
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── auth_repository/                   # Domain layer: Auth
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   └── user.dart
│   │   │   │   └── auth_repository.dart
│   │   │   └── auth_repository.dart       # barrel file
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── budget_repository/                 # Domain layer: Budgets & Periods
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   ├── budget.dart
│   │   │   │   │   ├── budget_period.dart
│   │   │   │   │   └── allocation_template.dart
│   │   │   │   └── budget_repository.dart
│   │   │   └── budget_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── account_repository/                # Domain layer: Accounts
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   ├── account.dart
│   │   │   │   │   └── debt_account.dart
│   │   │   │   └── account_repository.dart
│   │   │   └── account_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── envelope_repository/               # Domain layer: Envelopes & Categories
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   ├── category_group.dart
│   │   │   │   │   ├── envelope.dart
│   │   │   │   │   └── envelope_allocation.dart
│   │   │   │   └── envelope_repository.dart
│   │   │   └── envelope_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── transaction_repository/            # Domain layer: Transactions
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   ├── transaction.dart
│   │   │   │   │   ├── transaction_split.dart
│   │   │   │   │   ├── recurring_rule.dart
│   │   │   │   │   └── bill_reminder.dart
│   │   │   │   └── transaction_repository.dart
│   │   │   └── transaction_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── goal_repository/                   # Domain layer: Goals & Debt
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   └── goal.dart
│   │   │   │   └── goal_repository.dart
│   │   │   └── goal_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── sharing_repository/                # Domain layer: Shared Budgets
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   ├── budget_member.dart
│   │   │   │   │   └── activity_log_entry.dart
│   │   │   │   └── sharing_repository.dart
│   │   │   └── sharing_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── notification_repository/           # Domain layer: Notifications
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   └── notification_preferences.dart
│   │   │   │   └── notification_repository.dart
│   │   │   └── notification_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── report_repository/                 # Domain layer: Reports & Analytics
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   ├── spending_report.dart
│   │   │   │   │   ├── trend_report.dart
│   │   │   │   │   └── net_worth_snapshot.dart
│   │   │   │   └── report_repository.dart
│   │   │   └── report_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   ├── sync_repository/                   # Domain layer: Offline Sync
│   │   ├── lib/
│   │   │   ├── src/
│   │   │   │   ├── models/
│   │   │   │   │   └── sync_status.dart
│   │   │   │   └── sync_repository.dart
│   │   │   └── sync_repository.dart
│   │   ├── test/
│   │   └── pubspec.yaml
│   │
│   └── subscription_repository/           # Domain layer: Subscriptions
│       ├── lib/
│       │   ├── src/
│       │   │   ├── models/
│       │   │   │   └── subscription.dart
│       │   │   └── subscription_repository.dart
│       │   └── subscription_repository.dart
│       ├── test/
│       └── pubspec.yaml
│
├── lib/                                    # Main app (Business Logic + Presentation)
│   ├── app/
│   │   ├── app.dart                        # App widget, MaterialApp.router
│   │   ├── router.dart                     # GoRouter configuration
│   │   └── app_bloc_observer.dart          # Bloc observer for logging
│   │
│   ├── auth/                               # Feature: Authentication
│   │   ├── bloc/
│   │   │   ├── auth_bloc.dart
│   │   │   ├── auth_event.dart
│   │   │   └── auth_state.dart
│   │   ├── view/
│   │   │   ├── login_page.dart
│   │   │   ├── register_page.dart
│   │   │   ├── forgot_password_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   ├── social_login_buttons.dart
│   │   │   └── widgets.dart
│   │   └── auth.dart                       # barrel file
│   │
│   ├── onboarding/                         # Feature: Setup Wizard
│   │   ├── cubit/
│   │   │   ├── onboarding_cubit.dart
│   │   │   └── onboarding_state.dart
│   │   ├── view/
│   │   │   ├── onboarding_page.dart
│   │   │   ├── currency_step.dart
│   │   │   ├── accounts_step.dart
│   │   │   ├── income_step.dart
│   │   │   ├── envelopes_step.dart
│   │   │   ├── allocation_step.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── onboarding.dart
│   │
│   ├── dashboard/                          # Feature: Home Dashboard
│   │   ├── bloc/
│   │   │   ├── dashboard_bloc.dart
│   │   │   ├── dashboard_event.dart
│   │   │   └── dashboard_state.dart
│   │   ├── view/
│   │   │   ├── dashboard_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   ├── ready_to_assign_card.dart
│   │   │   ├── envelope_grid.dart
│   │   │   ├── envelope_card.dart
│   │   │   └── widgets.dart
│   │   └── dashboard.dart
│   │
│   ├── accounts/                           # Feature: Account Management
│   │   ├── bloc/
│   │   │   ├── accounts_bloc.dart
│   │   │   ├── accounts_event.dart
│   │   │   └── accounts_state.dart
│   │   ├── view/
│   │   │   ├── accounts_page.dart
│   │   │   ├── account_detail_page.dart
│   │   │   ├── account_form_page.dart
│   │   │   ├── reconciliation_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── accounts.dart
│   │
│   ├── envelopes/                          # Feature: Envelope & Category Management
│   │   ├── bloc/
│   │   │   ├── envelopes_bloc.dart
│   │   │   ├── envelopes_event.dart
│   │   │   └── envelopes_state.dart
│   │   ├── view/
│   │   │   ├── envelopes_page.dart
│   │   │   ├── envelope_detail_page.dart
│   │   │   ├── category_group_form_page.dart
│   │   │   ├── envelope_form_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── envelopes.dart
│   │
│   ├── budget/                             # Feature: Budget Allocation
│   │   ├── bloc/
│   │   │   ├── budget_bloc.dart
│   │   │   ├── budget_event.dart
│   │   │   └── budget_state.dart
│   │   ├── view/
│   │   │   ├── budget_page.dart
│   │   │   ├── allocation_page.dart
│   │   │   ├── template_page.dart
│   │   │   ├── envelope_transfer_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── budget.dart
│   │
│   ├── transactions/                       # Feature: Transactions
│   │   ├── bloc/
│   │   │   ├── transactions_bloc.dart
│   │   │   ├── transactions_event.dart
│   │   │   └── transactions_state.dart
│   │   ├── view/
│   │   │   ├── transactions_page.dart
│   │   │   ├── transaction_form_page.dart
│   │   │   ├── transaction_detail_page.dart
│   │   │   ├── search_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   ├── transaction_list_item.dart
│   │   │   ├── split_transaction_form.dart
│   │   │   └── widgets.dart
│   │   └── transactions.dart
│   │
│   ├── recurring/                          # Feature: Recurring Transactions & Bills
│   │   ├── bloc/
│   │   │   ├── recurring_bloc.dart
│   │   │   ├── recurring_event.dart
│   │   │   └── recurring_state.dart
│   │   ├── view/
│   │   │   ├── recurring_rules_page.dart
│   │   │   ├── recurring_rule_form_page.dart
│   │   │   ├── bill_reminders_page.dart
│   │   │   ├── bill_reminder_form_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── recurring.dart
│   │
│   ├── goals/                              # Feature: Goals & Debt
│   │   ├── bloc/
│   │   │   ├── goals_bloc.dart
│   │   │   ├── goals_event.dart
│   │   │   └── goals_state.dart
│   │   ├── view/
│   │   │   ├── goals_page.dart
│   │   │   ├── goal_form_page.dart
│   │   │   ├── goal_detail_page.dart
│   │   │   ├── debt_payoff_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   ├── goal_progress_card.dart
│   │   │   ├── debt_strategy_comparison.dart
│   │   │   └── widgets.dart
│   │   └── goals.dart
│   │
│   ├── shared_budget/                      # Feature: Shared Budgets
│   │   ├── bloc/
│   │   │   ├── shared_budget_bloc.dart
│   │   │   ├── shared_budget_event.dart
│   │   │   └── shared_budget_state.dart
│   │   ├── view/
│   │   │   ├── members_page.dart
│   │   │   ├── invite_page.dart
│   │   │   ├── activity_log_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── shared_budget.dart
│   │
│   ├── reports/                            # Feature: Reports & Analytics
│   │   ├── bloc/
│   │   │   ├── reports_bloc.dart
│   │   │   ├── reports_event.dart
│   │   │   └── reports_state.dart
│   │   ├── view/
│   │   │   ├── reports_page.dart
│   │   │   ├── spending_by_category_page.dart
│   │   │   ├── income_vs_expense_page.dart
│   │   │   ├── budget_vs_actual_page.dart
│   │   │   ├── net_worth_page.dart
│   │   │   ├── export_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── reports.dart
│   │
│   ├── notifications/                      # Feature: Notification Preferences
│   │   ├── cubit/
│   │   │   ├── notifications_cubit.dart
│   │   │   └── notifications_state.dart
│   │   ├── view/
│   │   │   ├── notifications_settings_page.dart
│   │   │   └── view.dart
│   │   └── notifications.dart
│   │
│   ├── settings/                           # Feature: App Settings
│   │   ├── cubit/
│   │   │   ├── settings_cubit.dart
│   │   │   └── settings_state.dart
│   │   ├── view/
│   │   │   ├── settings_page.dart
│   │   │   ├── profile_page.dart
│   │   │   ├── privacy_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── settings.dart
│   │
│   ├── subscription/                       # Feature: Subscription & Paywall
│   │   ├── bloc/
│   │   │   ├── subscription_bloc.dart
│   │   │   ├── subscription_event.dart
│   │   │   └── subscription_state.dart
│   │   ├── view/
│   │   │   ├── paywall_page.dart
│   │   │   └── view.dart
│   │   ├── widgets/
│   │   │   └── widgets.dart
│   │   └── subscription.dart
│   │
│   ├── theme/
│   │   ├── app_theme.dart                  # Light & dark ThemeData
│   │   └── app_colors.dart                 # Color constants
│   │
│   ├── l10n/
│   │   ├── arb/
│   │   │   └── app_en.arb                  # English strings
│   │   └── l10n.dart
│   │
│   └── main.dart                           # Entry point
│
├── test/                                   # App-level tests
├── integration_test/                       # Integration tests
├── supabase/                               # Supabase project files
│   ├── migrations/                         # SQL migrations
│   ├── functions/                          # Edge functions
│   └── config.toml
├── .github/
│   └── workflows/
│       ├── ci.yml                          # PR: lint, test, build
│       ├── deploy_staging.yml              # Staging deployment
│       └── deploy_production.yml           # Production release
├── pubspec.yaml
└── README.md
```

### Key Architectural Decisions

- **Repositories are packages**: Each repository package depends on `envelope_api_client` and/or `envelope_local_storage` for data access. The main app only depends on repository packages — never directly on the data layer packages.
- **No DI framework**: Following VGV convention, repositories are provided via `RepositoryProvider` (from `flutter_bloc`) at the top of the widget tree. Blocs receive repositories via constructor injection.
- **Feature-first in the app**: Each feature folder contains its own `bloc/`, `view/`, and `widgets/` directories. A barrel file at the root of each feature exports the public API.
- **Barrel files everywhere**: Each folder has a barrel file for clean imports.

---

## Database Schema

### Core Tables (Drift local + Supabase remote mirror)

```sql
-- USERS
users (
  id            UUID PRIMARY KEY,
  email         TEXT NOT NULL,
  display_name  TEXT NOT NULL,
  base_currency TEXT NOT NULL DEFAULT 'USD',
  theme_mode    TEXT NOT NULL DEFAULT 'system', -- light/dark/system
  accent_color  TEXT,                           -- hex, premium only
  created_at    TIMESTAMP NOT NULL,
  updated_at    TIMESTAMP NOT NULL
)

-- BUDGETS
budgets (
  id               UUID PRIMARY KEY,
  owner_id         UUID REFERENCES users(id),
  name             TEXT NOT NULL,
  period_type      TEXT NOT NULL DEFAULT 'monthly', -- monthly/weekly/bi-weekly/custom
  period_start_day INTEGER NOT NULL DEFAULT 1,
  base_currency    TEXT NOT NULL,
  is_archived      BOOLEAN NOT NULL DEFAULT FALSE,
  created_at       TIMESTAMP NOT NULL,
  updated_at       TIMESTAMP NOT NULL
)

-- BUDGET MEMBERS (shared budgets)
budget_members (
  id          UUID PRIMARY KEY,
  budget_id   UUID REFERENCES budgets(id),
  user_id     UUID REFERENCES users(id),
  role        TEXT NOT NULL DEFAULT 'viewer', -- owner/editor/viewer
  invited_via TEXT NOT NULL,                  -- email/link
  accepted_at TIMESTAMP,
  created_at  TIMESTAMP NOT NULL
)

-- BUDGET PERIODS
budget_periods (
  id              UUID PRIMARY KEY,
  budget_id       UUID REFERENCES budgets(id),
  start_date      DATE NOT NULL,
  end_date        DATE NOT NULL,
  total_income    REAL NOT NULL DEFAULT 0,
  total_allocated REAL NOT NULL DEFAULT 0,
  is_closed       BOOLEAN NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMP NOT NULL
)

-- ACCOUNTS
accounts (
  id               UUID PRIMARY KEY,
  budget_id        UUID REFERENCES budgets(id),
  name             TEXT NOT NULL,
  type             TEXT NOT NULL, -- checking/savings/credit_card/cash/loan/investment
  starting_balance REAL NOT NULL DEFAULT 0,
  current_balance  REAL NOT NULL DEFAULT 0,
  currency         TEXT NOT NULL,
  is_archived      BOOLEAN NOT NULL DEFAULT FALSE,
  created_at       TIMESTAMP NOT NULL,
  updated_at       TIMESTAMP NOT NULL
)

-- CATEGORY GROUPS
category_groups (
  id          UUID PRIMARY KEY,
  budget_id   UUID REFERENCES budgets(id),
  name        TEXT NOT NULL,
  sort_order  INTEGER NOT NULL DEFAULT 0,
  is_default  BOOLEAN NOT NULL DEFAULT FALSE,
  is_archived BOOLEAN NOT NULL DEFAULT FALSE,
  created_at  TIMESTAMP NOT NULL
)

-- ENVELOPES
envelopes (
  id                UUID PRIMARY KEY,
  category_group_id UUID REFERENCES category_groups(id),
  budget_id         UUID REFERENCES budgets(id),
  name              TEXT NOT NULL,
  sort_order        INTEGER NOT NULL DEFAULT 0,
  is_archived       BOOLEAN NOT NULL DEFAULT FALSE,
  created_at        TIMESTAMP NOT NULL
)

-- ENVELOPE ALLOCATIONS (per period)
envelope_allocations (
  id               UUID PRIMARY KEY,
  envelope_id      UUID REFERENCES envelopes(id),
  budget_period_id UUID REFERENCES budget_periods(id),
  allocated_amount REAL NOT NULL DEFAULT 0,
  spent_amount     REAL NOT NULL DEFAULT 0,
  rollover_amount  REAL NOT NULL DEFAULT 0,
  created_at       TIMESTAMP NOT NULL
)

-- TRANSACTIONS
transactions (
  id                UUID PRIMARY KEY,
  budget_id         UUID REFERENCES budgets(id),
  account_id        UUID REFERENCES accounts(id),
  envelope_id       UUID REFERENCES envelopes(id),  -- nullable for transfers/income
  type              TEXT NOT NULL,                   -- income/expense/transfer
  amount            REAL NOT NULL,
  currency          TEXT NOT NULL,
  exchange_rate     REAL NOT NULL DEFAULT 1.0,
  payee             TEXT,
  notes             TEXT,
  date              DATE NOT NULL,
  is_reconciled     BOOLEAN NOT NULL DEFAULT FALSE,
  recurring_rule_id UUID REFERENCES recurring_rules(id),
  transfer_pair_id  UUID,                            -- links two sides of a transfer
  created_by        UUID REFERENCES users(id),
  created_at        TIMESTAMP NOT NULL,
  updated_at        TIMESTAMP NOT NULL
)

-- TRANSACTION SPLITS
transaction_splits (
  id             UUID PRIMARY KEY,
  transaction_id UUID REFERENCES transactions(id),
  envelope_id    UUID REFERENCES envelopes(id),
  amount         REAL NOT NULL
)

-- TAGS
tags (
  id        UUID PRIMARY KEY,
  budget_id UUID REFERENCES budgets(id),
  name      TEXT NOT NULL
)

-- TRANSACTION TAGS (join table)
transaction_tags (
  transaction_id UUID REFERENCES transactions(id),
  tag_id         UUID REFERENCES tags(id),
  PRIMARY KEY (transaction_id, tag_id)
)

-- RECURRING RULES
recurring_rules (
  id              UUID PRIMARY KEY,
  budget_id       UUID REFERENCES budgets(id),
  account_id      UUID REFERENCES accounts(id),
  envelope_id     UUID REFERENCES envelopes(id),
  type            TEXT NOT NULL,            -- income/expense/transfer
  amount          REAL NOT NULL,
  currency        TEXT NOT NULL,
  payee           TEXT,
  notes           TEXT,
  frequency       TEXT NOT NULL,            -- daily/weekly/bi-weekly/monthly/yearly/custom
  custom_interval INTEGER,                  -- e.g., every 3 (used with custom_unit)
  custom_unit     TEXT,                     -- days/weeks/months
  start_date      DATE NOT NULL,
  end_date        DATE,
  next_occurrence DATE NOT NULL,
  auto_post       BOOLEAN NOT NULL DEFAULT FALSE,
  is_paused       BOOLEAN NOT NULL DEFAULT FALSE,
  created_at      TIMESTAMP NOT NULL
)

-- BILL REMINDERS
bill_reminders (
  id                   UUID PRIMARY KEY,
  budget_id            UUID REFERENCES budgets(id),
  name                 TEXT NOT NULL,
  estimated_amount     REAL NOT NULL,
  due_day              INTEGER NOT NULL,
  frequency            TEXT NOT NULL,        -- monthly/yearly/custom
  envelope_id          UUID REFERENCES envelopes(id),
  reminder_days_before INTEGER NOT NULL DEFAULT 3,
  created_at           TIMESTAMP NOT NULL
)

-- ALLOCATION TEMPLATES
allocation_templates (
  id        UUID PRIMARY KEY,
  budget_id UUID REFERENCES budgets(id),
  name      TEXT NOT NULL,
  created_at TIMESTAMP NOT NULL
)

-- ALLOCATION TEMPLATE ITEMS
allocation_template_items (
  id          UUID PRIMARY KEY,
  template_id UUID REFERENCES allocation_templates(id),
  envelope_id UUID REFERENCES envelopes(id),
  percentage  REAL NOT NULL
)

-- GOALS
goals (
  id                   UUID PRIMARY KEY,
  budget_id            UUID REFERENCES budgets(id),
  envelope_id          UUID REFERENCES envelopes(id),
  account_id           UUID REFERENCES accounts(id),  -- for debt payoff goals
  type                 TEXT NOT NULL,                  -- savings_target/monthly_contribution/debt_payoff
  name                 TEXT NOT NULL,
  target_amount        REAL,
  target_date          DATE,
  monthly_contribution REAL,
  current_amount       REAL NOT NULL DEFAULT 0,
  is_completed         BOOLEAN NOT NULL DEFAULT FALSE,
  created_at           TIMESTAMP NOT NULL,
  updated_at           TIMESTAMP NOT NULL
)

-- DEBT ACCOUNT DETAILS
debt_accounts (
  account_id       UUID PRIMARY KEY REFERENCES accounts(id),
  interest_rate    REAL NOT NULL,
  minimum_payment  REAL NOT NULL,
  original_balance REAL NOT NULL,
  payoff_strategy  TEXT  -- snowball/avalanche
)

-- ACTIVITY LOG (shared budgets)
activity_log (
  id          UUID PRIMARY KEY,
  budget_id   UUID REFERENCES budgets(id),
  user_id     UUID REFERENCES users(id),
  action      TEXT NOT NULL,
  entity_type TEXT NOT NULL,
  entity_id   UUID NOT NULL,
  details     TEXT,  -- JSON string
  created_at  TIMESTAMP NOT NULL
)

-- NOTIFICATION PREFERENCES
notification_preferences (
  user_id                      UUID PRIMARY KEY REFERENCES users(id),
  push_enabled                 BOOLEAN NOT NULL DEFAULT TRUE,
  email_enabled                BOOLEAN NOT NULL DEFAULT TRUE,
  overspend_alerts             BOOLEAN NOT NULL DEFAULT TRUE,
  bill_reminders               BOOLEAN NOT NULL DEFAULT TRUE,
  daily_logging_reminder       BOOLEAN NOT NULL DEFAULT TRUE,
  recurring_transaction_alerts BOOLEAN NOT NULL DEFAULT TRUE,
  shared_budget_activity       BOOLEAN NOT NULL DEFAULT TRUE
)

-- NET WORTH SNAPSHOTS (for historical tracking)
net_worth_snapshots (
  id         UUID PRIMARY KEY,
  budget_id  UUID REFERENCES budgets(id),
  date       DATE NOT NULL,
  assets     REAL NOT NULL,
  liabilities REAL NOT NULL,
  net_worth  REAL NOT NULL,
  created_at TIMESTAMP NOT NULL
)

-- SYNC METADATA (offline-first)
sync_metadata (
  id            UUID PRIMARY KEY,
  table_name    TEXT NOT NULL,
  record_id     UUID NOT NULL,
  last_modified TIMESTAMP NOT NULL,
  is_deleted    BOOLEAN NOT NULL DEFAULT FALSE,
  device_id     TEXT NOT NULL,
  sync_status   TEXT NOT NULL DEFAULT 'pending'  -- pending/synced/conflict
)
```

---

## Implementation Phases

### Phase 1: Project Foundation (Week 1–2)

**1.1 Project Setup**
- Initialize Flutter project: `flutter create envelope --org com.envelope --platforms android,ios,web`
- Configure folder structure as defined above
- Set up `very_good_analysis` for linting
- Configure flavors/environments (dev, staging, prod) using `--dart-define`
- Initialize Git repository with `.gitignore`

**1.2 Core Packages — Data Layer**
- Create `packages/envelope_api_client` — Supabase client wrapper
  - Initialize Supabase client
  - Define all DTO classes with `json_serializable`
  - Implement CRUD methods for each entity
- Create `packages/envelope_local_storage` — Drift database
  - Define all Drift tables matching the schema
  - Implement DAOs for each entity group
  - Set up versioned migration strategy
  - Platform-specific database initialization (native SQLite for mobile, sql.js for web)

**1.3 Core Packages — Domain Layer (Stubs)**
- Create all repository packages with interfaces and models
- Use `freezed` for immutable domain models
- Each repository depends on `envelope_api_client` and `envelope_local_storage`
- Implement `auth_repository` first (needed for Phase 2)

**1.4 App Shell**
- Set up `main.dart` with `RepositoryProvider` tree
- Configure `GoRouter` with initial routes (splash, auth, home)
- Implement light/dark/system theme with Material 3
- Set up `flutter_localizations` with ARB for English
- Create `AppBlocObserver` for debug logging

**1.5 CI Setup**
- GitHub Actions workflow: lint → analyze → test → build on every PR
- Separate workflows for each package (run tests only for changed packages)

---

### Phase 2: Authentication (Week 3–4)

**2.1 Supabase Setup**
- Create Supabase project
- Define full Postgres schema with SQL migrations
- Configure Row Level Security (RLS) policies
- Enable email/password auth
- Configure Google and Apple OAuth providers

**2.2 Auth Repository Implementation**
- `auth_repository` package: full implementation
  - Sign up with email/password
  - Sign in with email/password
  - Sign in with Google
  - Sign in with Apple
  - Sign out
  - Password reset (send email, confirm)
  - Email verification
  - Session stream (listen for auth state changes)
  - Get/update user profile

**2.3 Auth Feature (Business Logic + Presentation)**
- `AuthBloc`: manages auth state (`unauthenticated` / `authenticated` / `loading`)
- Login page with email/password form + social login buttons
- Registration page with validation
- Forgot password page
- Auto-login from persisted session
- Router guard: redirect to login if unauthenticated

---

### Phase 3: Sync Engine (Week 5–6)

**3.1 Sync Repository Implementation**
- `sync_repository` package: offline-first sync engine
- **Write path**: all writes go to Drift first → queued for sync → pushed to Supabase when online
- **Read path**: read from Drift always (single source of truth locally)
- **Sync on connect**: when app comes online, push pending changes then pull remote changes
- **Conflict resolution**: last-write-wins per field, using `updated_at` timestamps
- **Soft deletes**: `is_deleted` flag in sync_metadata, purge after confirmed sync
- **Device tracking**: `device_id` to identify change origin

**3.2 Connectivity Monitoring**
- Listen to connectivity changes
- Auto-trigger sync when going from offline → online
- Periodic background sync when online (configurable interval)
- `SyncBloc`: states — `idle` / `syncing` / `synced` / `error`
- Sync status indicator in app bar

---

### Phase 4: Onboarding & Accounts (Week 7–9)

**4.1 Onboarding Wizard**
- `OnboardingCubit`: tracks wizard step and collected data
- Step 1: Welcome screen — brief explanation of envelope budgeting
- Step 2: Select base currency (searchable currency picker)
- Step 3: Add accounts (at least one required) — name, type, starting balance, currency
- Step 4: Enter expected income for first budget period
- Step 5: Review default category groups and envelopes:
  - **Needs**: Rent/Mortgage, Utilities, Groceries, Transportation, Insurance, Healthcare
  - **Wants**: Dining Out, Entertainment, Shopping, Subscriptions
  - **Savings/Investments**: Emergency Fund, Retirement, Vacation
  - User can add/remove/rename before continuing
- Step 6: Allocate income to envelopes (first budget allocation)
- Completion → navigate to dashboard

**4.2 Account Repository Implementation**
- Full CRUD for accounts
- Starting balance tracking
- Running balance computation (starting balance + sum of transactions)
- Archive account (hide from active list, preserve data)

**4.3 Account Feature (Business Logic + Presentation)**
- `AccountsBloc`: manages account list state
- Account list page grouped by type (checking, savings, credit card, etc.)
- Add/edit account form (name, type, starting balance, currency)
- Account detail page (filtered transaction list, running balance)
- Reconciliation flow:
  - User enters actual balance
  - App shows difference from computed balance
  - User creates adjustment transaction to match

---

### Phase 5: Envelopes & Budget Allocation (Week 10–12)

**5.1 Envelope Repository Implementation**
- CRUD for category groups and envelopes
- Reorder support (update `sort_order`)
- Archive envelope (not delete)
- Envelope allocation per budget period
- Rollover calculation

**5.2 Budget Repository Implementation**
- Budget period management (auto-create, close, navigate)
- Allocation CRUD (allocate amounts to envelopes)
- "Ready to Assign" calculation: `total_income - total_allocated + total_rollovers`
- Allocation template CRUD (save/apply percentage-based templates)
- Duplicate previous period's allocations
- Envelope-to-envelope money transfer within a period

**5.3 Envelopes Feature (Business Logic + Presentation)**
- `EnvelopesBloc`: manages category groups and envelopes
- Category group list with expandable envelopes
- Add/edit/archive category group
- Add/edit/archive envelope
- Drag-to-reorder (groups and envelopes within groups)
- Envelope detail page: allocation history, transactions, goal progress

**5.4 Budget Feature (Business Logic + Presentation)**
- `BudgetBloc`: manages budget period and allocation state
- Budget period selector (previous/current/next period)
- Allocation page:
  - "Ready to Assign" prominently displayed at top
  - List of all envelopes with amount input fields
  - Real-time update of "Ready to Assign" as user types
  - Warning when over-allocated
- Template management: create, edit, delete, apply
- Envelope transfer dialog: from → to → amount

---

### Phase 6: Transactions (Week 13–15)

**6.1 Transaction Repository Implementation**
- Full CRUD for transactions
- Split transaction support (multiple envelopes per transaction)
- Transfer handling (create paired transactions between accounts)
- Credit card YNAB-style handling:
  - Expense on CC: reduces envelope balance, tracks amount owed on CC
  - Payment to CC: transfer from checking → CC, reduces owed amount
- Auto-update envelope `spent_amount` and account `current_balance` on transaction save/delete
- Tag management (create, assign, remove)
- Global search (payee, notes, tags, amount — full text search in Drift)
- Filtered queries (by account, envelope, type, date range, tags)

**6.2 Transactions Feature (Business Logic + Presentation)**
- `TransactionsBloc`: manages transaction list and filters
- Transaction list page:
  - Grouped by date
  - Filter bar (account, envelope, type, date range, tags)
  - Swipe actions: edit, delete
- Add/edit transaction page:
  - Type selector: income / expense / transfer
  - Fields: date, account, envelope, amount, currency, exchange rate, payee, notes
  - Tag picker (multi-select, create new inline)
  - Split mode toggle: add multiple envelope+amount rows, validate sum
- Transfer page: from account → to account → amount
- Delete confirmation dialog + undo snackbar (5 second window)
- Global search page: search across all transactions

**6.3 Recurring Transactions & Bill Reminders**
- `RecurringBloc`: manages recurring rules and bill reminders
- Recurring rule CRUD:
  - Same fields as transaction + frequency + auto-post toggle
  - Frequency options: daily, weekly, bi-weekly, monthly, yearly, custom
  - Auto-post: system creates transaction automatically on schedule
  - Manual: notification shown, user confirms/skips/edits
  - Pause/resume/delete rules
- Bill reminder CRUD:
  - Name, estimated amount, due day, frequency, linked envelope
  - Reminder X days before due date
  - Quick-create transaction from reminder
- Background job: check for due recurring transactions and bill reminders on app open

---

### Phase 7: Dashboard (Week 16–17)

**7.1 Dashboard Feature (Business Logic + Presentation)**
- `DashboardBloc`: aggregates data from multiple repositories
- Dashboard page layout:
  - **Top section**: "Ready to Assign" card
    - Green: $0 (fully allocated)
    - Yellow: positive (money still to assign)
    - Red: negative (over-allocated)
  - **Envelope grid**: responsive grid of envelope cards
    - Each card: envelope name, allocated, spent, remaining
    - Color coding: green (<75% spent), yellow (75-100% spent), red (overspent)
    - Tap → navigate to envelope detail
  - **FAB**: Quick-add transaction

**7.2 Overspend Handling**
- When a transaction would make an envelope balance negative:
  - Show warning dialog explaining the overspend
  - "Cover Overspending" flow: present list of envelopes with positive balances
  - User selects source envelope and amount to move
  - Execute envelope transfer to cover the deficit
- Overspent envelopes highlighted in red throughout the app

---

### Phase 8: Goals & Debt Tracking (Week 18–19)

**8.1 Goal Repository Implementation**
- CRUD for goals (savings target, monthly contribution, debt payoff)
- Progress tracking and calculation
- Debt payoff calculations:
  - Snowball strategy: order debts smallest to largest balance
  - Avalanche strategy: order debts highest to lowest interest rate
  - Calculate total interest paid and payoff date for each strategy
  - Monthly payment schedule generation

**8.2 Goals Feature (Business Logic + Presentation)**
- `GoalsBloc`: manages goal list and progress
- Goals list page (grouped by type)
- Add/edit goal form:
  - Savings target: name, target amount, target date, linked envelope
  - Monthly contribution: name, amount, linked envelope
  - Debt payoff: linked loan/CC account, interest rate, minimum payment
- Goal detail page:
  - Progress bar with percentage
  - Monthly contribution needed to meet target
  - Historical progress chart
- Debt payoff page:
  - Snowball vs avalanche comparison table (total interest, payoff date, monthly payment)
  - Recommended strategy highlighted
  - Payoff timeline visualization

---

### Phase 9: Shared Budgets (Week 20–22)

**9.1 Sharing Repository Implementation**
- Invite by email: create invitation record, trigger email via Supabase Edge Function
- Invite by link: generate shareable deep link with expiry token
- Accept/decline invitation
- Role management (owner can change roles, remove members)
- Activity log: log all mutations with user, action, entity, timestamp
- Real-time subscriptions via Supabase Realtime (listen for changes from other members)

**9.2 Shared Budget Feature (Business Logic + Presentation)**
- `SharedBudgetBloc`: manages members, invitations, activity
- Members page:
  - List of members with roles
  - Owner actions: change role, remove member
  - Invite button
- Invite page:
  - Email invite: enter email → send invitation
  - Link invite: generate link → share via system share sheet
- Activity log page:
  - Chronological feed of all changes
  - Filter by member, action type
  - Show: who did what, when, to which entity
- Permission enforcement:
  - UI: hide/disable actions based on role
  - Backend: RLS policies enforce role-based access
- Free tier: max 2 members per budget
- Real-time sync: live updates when another member makes changes

**9.3 Supabase Realtime Integration**
- Subscribe to budget-specific channels
- Handle real-time inserts, updates, deletes
- Update local Drift database from remote changes
- Show subtle indicator when remote changes arrive

---

### Phase 10: Reports & Analytics (Week 23–24)

**10.1 Report Repository Implementation**
- Spending by category: aggregate transaction amounts per category group and envelope
- Income vs expense trends: aggregate per period
- Budget vs actual: compare allocation vs spent per envelope
- Net worth: calculate assets minus liabilities, store monthly snapshots
- Export: generate CSV and PDF from query results

**10.2 Reports Feature (Business Logic + Presentation)**
- `ReportsBloc`: manages report data and filters
- Reports hub page with navigation to each report type
- **Spending by Category**:
  - Donut chart (category groups) with drill-down to envelopes
  - Period selector
- **Income vs Expense Trends**:
  - Grouped bar chart (income vs expense per period)
  - Line chart overlay for net savings
- **Budget vs Actual**:
  - Horizontal bar chart per envelope (allocated vs spent)
  - Over/under indicators
- **Net Worth**:
  - Line chart over time
  - Breakdown: total assets, total liabilities
- **Export**:
  - Format selector: CSV / PDF
  - Date range picker
  - Entity selector (transactions, envelope summary, account balances)
  - Share via system share sheet

---

### Phase 11: Notifications (Week 25)

**11.1 Push Notifications**
- Firebase Cloud Messaging setup (Android, iOS, Web)
- FCM token registration in Supabase (per device)
- Notification types:
  - Overspend alert: triggered when envelope goes negative
  - Bill reminder: triggered X days before due date
  - Recurring transaction pending: when non-auto-post rule is due
  - Daily logging reminder: configurable time (default 8 PM)
  - Shared budget activity: when another member makes changes

**11.2 Email Notifications**
- Supabase Edge Functions for email delivery
- Weekly budget summary email
- Bill reminder emails
- Invitation emails for shared budgets

**11.3 Notification Preferences Feature**
- `NotificationsCubit`: manages preference state
- Settings page:
  - Global push toggle
  - Global email toggle
  - Individual type toggles (overspend, bills, daily reminder, recurring, shared activity)

---

### Phase 12: Settings & Polish (Week 26–27)

**12.1 Settings Feature**
- `SettingsCubit`: manages settings state
- Settings page:
  - Profile: edit name, email, password
  - Base currency change (with warning about recomputation)
  - Theme: light / dark / system toggle
  - Notification preferences (link to notifications settings)
  - Data export (link to export page)
  - Delete account (GDPR compliance)
  - Privacy policy & Terms of Service links
  - App version

**12.2 GDPR & Privacy Compliance**
- Account deletion: cascade delete all user data from Supabase + clear local Drift DB
- Data export: generate complete JSON dump of all user data (GDPR data portability)
- Consent tracking: record when user accepted privacy policy
- Privacy policy and ToS: hosted web pages, linked from app

**12.3 Undo & Confirmation**
- Confirmation dialogs: delete transaction, archive envelope, remove member, delete budget
- Undo snackbar (5 seconds): delete transaction, archive envelope
- Soft-delete in database: mark as deleted, purge after sync confirmed

**12.4 Platform Polish**
- Android: Material 3, edge-to-edge, adaptive icons
- iOS: Cupertino-style adaptive dialogs, safe area handling
- Web: Responsive layout
  - Wide (>900px): sidebar navigation + content area
  - Narrow (<900px): bottom navigation bar
  - Keyboard shortcuts for power users

---

### Phase 13: Subscription & RevenueCat (Week 28–29) *(Last Feature)*

**13.1 RevenueCat Setup**
- Create RevenueCat project
- Configure App Store Connect and Google Play Console products
- Define entitlement: `premium`
- Define offerings: monthly subscription, yearly subscription
- Configure 1-month free trial on both platforms

**13.2 Subscription Repository Implementation**
- `subscription_repository` package
- RevenueCat SDK integration
- Check entitlement status
- Purchase flow
- Restore purchases
- Listen for subscription status changes
- Sync subscription status to Supabase (via RevenueCat webhooks → Edge Function)

**13.3 Subscription Feature (Business Logic + Presentation)**
- `SubscriptionBloc`: manages subscription state (free / trial / premium / expired)
- Paywall page:
  - Free vs Premium comparison table
  - Monthly and yearly pricing
  - "Start Free Trial" CTA
  - Restore purchases link
- Premium gates (trigger paywall when user attempts):
  - Creating a 2nd budget
  - Adding a 3rd shared budget member
  - Setting custom accent color
  - Exporting data (CSV/PDF)
  - Viewing debt payoff strategies
  - Accessing full reports

**13.4 Web Subscriptions**
- RevenueCat + Stripe integration for web payments
- Web pricing page
- Stripe Checkout redirect flow
- Webhook: Stripe → RevenueCat → Supabase for status sync

---

### Phase 14: Testing & Launch (Week 30–31)

**14.1 Testing Strategy**
- **Unit tests** (per package):
  - All repository methods
  - All Bloc/Cubit: event → state transitions
  - Domain model serialization
  - Sync engine conflict resolution
  - Debt payoff calculations
- **Widget tests** (main app):
  - Critical UI flows: onboarding, add transaction, allocation, search
  - Form validation
  - Permission-based UI (shared budget roles, free vs premium)
- **Integration tests**:
  - Full flow: signup → onboard → create budget → add transaction → view report
  - Offline → online sync flow
  - Shared budget: invite → accept → collaborate
- **Target**: 80%+ code coverage on business logic (repositories + blocs)

**14.2 CI/CD Finalization**
- GitHub Actions workflows:
  - **PR**: lint → analyze → test (per package + app) → build
  - **Merge to main**: build → deploy to TestFlight + Play Internal Testing + staging web
  - **Release tag**: build → deploy to App Store + Play Store + production web
- Web hosting: Firebase Hosting or Supabase Hosting
- Environment variables management via GitHub Secrets

**14.3 Launch Checklist**
- App Store listing: screenshots, description, keywords, privacy nutrition labels
- Play Store listing: screenshots, description, content rating, data safety form
- Privacy Policy hosted at `https://envelope.app/privacy`
- Terms of Service hosted at `https://envelope.app/terms`
- Supabase production environment:
  - Database backups enabled (daily)
  - Rate limiting configured
  - RLS policies reviewed and tested
- Error tracking: Sentry integration
- Analytics: Firebase Analytics or PostHog
- Performance monitoring: Firebase Performance
- App review submission

---

## Phase Summary

| Phase | Feature | Weeks | Duration |
|-------|---------|-------|----------|
| 1 | Project foundation, packages, theme, database | 1–2 | 2 weeks |
| 2 | Authentication (Supabase + Auth UI) | 3–4 | 2 weeks |
| 3 | Sync engine (offline-first) | 5–6 | 2 weeks |
| 4 | Onboarding wizard & accounts | 7–9 | 3 weeks |
| 5 | Envelopes & budget allocation | 10–12 | 3 weeks |
| 6 | Transactions (CRUD, splits, recurring, bills) | 13–15 | 3 weeks |
| 7 | Dashboard | 16–17 | 2 weeks |
| 8 | Goals & debt tracking | 18–19 | 2 weeks |
| 9 | Shared budgets, roles, realtime | 20–22 | 3 weeks |
| 10 | Reports & analytics, export | 23–24 | 2 weeks |
| 11 | Notifications (push + email) | 25 | 1 week |
| 12 | Settings, privacy, polish | 26–27 | 2 weeks |
| 13 | Subscription & RevenueCat | 28–29 | 2 weeks |
| 14 | Testing & launch prep | 30–31 | 2 weeks |
| | **Total** | | **31 weeks** |
