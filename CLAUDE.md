# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Envelope is a zero-based budgeting app built with Flutter (Android, iOS, Web). Uses VGV layered architecture with Bloc for state management.

## Commands

```bash
# Run (3 flavors)
flutter run --flavor development --target lib/main_development.dart
flutter run --flavor staging --target lib/main_staging.dart
flutter run --flavor production --target lib/main_production.dart

# Tests
very_good test --coverage --test-randomize-ordering-seed random
flutter test test/app/view/app_test.dart        # single test file

# Lint & analyze
very_good analyze
dart run bloc_tools:bloc lint .

# Code generation (localization)
flutter gen-l10n
```

## Architecture

**VGV Layered Architecture** (4 layers):

1. **Data Layer** — API clients and local storage (separate packages under `packages/`)
2. **Domain Layer** — Repositories with domain models (separate packages under `packages/`)
3. **Business Logic Layer** — Blocs/Cubits in `lib/<feature>/bloc/` or `lib/<feature>/cubit/`
4. **Presentation Layer** — Views and widgets in `lib/<feature>/view/` and `lib/<feature>/widgets/`

No DI framework. Repositories provided via `RepositoryProvider` from `flutter_bloc`.

### Feature structure

```
lib/<feature>/
├── bloc/ (or cubit/)    # State management
├── view/
│   └── view.dart        # Barrel file
├── widgets/
│   └── widgets.dart     # Barrel file
└── <feature>.dart       # Barrel: exports view/view.dart
```

**Bloc** for complex multi-event features (auth, transactions, dashboard). **Cubit** for simpler state (settings, notifications, onboarding).

### Entry points

- `lib/main_development.dart`, `lib/main_staging.dart`, `lib/main_production.dart` all call `bootstrap()` from `lib/bootstrap.dart`
- `bootstrap.dart` sets up `AppBlocObserver` and runs the app

## Localization

ARB files in `lib/l10n/arb/`. English only, architecture ready for i18n. Generated files in `lib/l10n/gen/` (excluded from linting). Use `context.l10n.keyName` in widgets.

## Linting

Uses `very_good_analysis` + `bloc_lint`. Config in `analysis_options.yaml`. Generated localization files are excluded from analysis.

## Code Review Display (STRICT RULE)

When displaying code review results, **always include the file name and line numbers** for every issue found. Use the format `file_path:line_number` so issues can be easily located in the source code.

## Git Workflow (STRICT RULE)

**NEVER work directly on `main` or `dev`. Always create a feature branch.**

- **main**: Production branch. Only merged into from `dev` after ALL issues in a phase are completed.
- **dev**: Integration branch. Only merged into from feature branches.
- **feature branches**: Created from `dev` for every GitHub issue. Format: `feature/issue-<number>-<short-description>`.

**Flow**: `feature/* → dev → main`

**Steps for every issue:**
1. **Move issue to "In Progress"**: `gh issue edit <number> --remove-project-status "Todo" --add-project-status "In Progress"` (or equivalent `gh` command to update project board status)
2. `git checkout dev && git pull`
3. `git checkout -b feature/issue-<number>-<short-description>`
4. Do all work on the feature branch
5. **Run code review**: Launch a code-reviewer agent to analyze all changes. Present the issues found to the user. Fix only the issues the user asks to fix.
6. **Present review summary** to the user listing:
   - All changes made (files created/modified)
   - Data flow explanation (how data moves through the layers)
   - Key decisions and patterns used
7. **Wait for user approval** before committing. Do NOT commit until the user explicitly clears it.
8. **Pull latest `dev` before merging**: `git checkout dev && git pull && git checkout - && git merge dev`. If there are merge conflicts, resolve them on the feature branch first, test that everything works, then proceed.
9. After approval, commit and merge feature branch into `dev` with `--no-ff`
10. **Move issue to "Done"**: `gh issue close <number>` and update project board status to "Done"
11. Only after an entire phase is complete, merge `dev` into `main`

## QA Testing Workflow

During QA testing (using `QA_TEST_PLAN.md`), use `fix/tc-<number>-<description>` branches instead of feature branches:

- **Start**: `/qa-start <tc-number>` — creates the branch from `dev` and shows test cases.
- **Fix bugs**: Commit all fixes for that test case to the same branch (multiple commits OK). Follow the same code review + user approval rules as feature branches.
- **Finish**: `/qa-finish` — merges the fix branch into `dev` with `--no-ff` and cleans up.

## Testing

Test helpers in `test/helpers/pump_app.dart` provide `tester.pumpApp(widget)` extension that wraps widgets with MaterialApp + localization delegates. Target 80%+ coverage on business logic.

## Key Dependencies

- `flutter_bloc` / `bloc` — state management
- `very_good_analysis` — linting
- `bloc_lint` / `bloc_tools` — bloc-specific linting
- `mocktail` — test mocking
- `bloc_test` — bloc testing utilities

## Implementation Plan

See `IMPLEMENTATION_PLAN.md` for the full 31-week, 14-phase development roadmap. GitHub project board at https://github.com/users/ketulmobilions-hub/projects/3.
