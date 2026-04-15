# AGENTS.md

## Essential Commands

```bash
# Run (must use --flavor AND --target)
flutter run --flavor development --target lib/main_development.dart

# Test
very_good test --coverage --test-randomize-ordering-seed random
flutter test test/app/view/app_test.dart  # single file

# Lint & analyze
very_good analyze
dart run bloc_tools:bloc lint .  # bloc-specific linting

# Code gen
flutter gen-l10n
```

## Architecture

- **VGV layered architecture** with 4 layers: Data → Domain → Business Logic → Presentation
- **Packages** under `packages/` are the data layer (API clients, local storage)
- **Features** in `lib/<feature>/` with `bloc/`, `view/`, `widgets/` subdirectories
- No DI framework — repositories provided via `RepositoryProvider` from `flutter_bloc`
- Entry points: `lib/main_{development,staging,production}.dart` → `lib/bootstrap.dart`

## Git Workflow

- **NEVER commit directly to `main` or `dev`**
- Create feature branch: `git checkout -b feature/issue-<number>-<short-description>`
- Flow: `feature/* → dev → main`
- Use `--no-ff` when merging into dev
- During QA: use `fix/tc-<number>-<description>` branches (see CLAUDE.md:97-103)

## Testing

- Test helpers in `test/helpers/pump_app.dart` with `tester.pumpApp(widget)` extension
- Requires MaterialApp + localization delegates for widget tests

## Important Notes

- Generated localization files in `lib/l10n/gen/` are excluded from linting
- Bloc for complex multi-event features; Cubit for simpler state
- Coverage target: 80%+ on business logic
