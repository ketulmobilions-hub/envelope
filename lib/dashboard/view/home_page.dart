import 'dart:async';

import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/dashboard/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/recurring/cubit/recurring_check_cubit.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/widgets/confirm_delete_dialog.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/sync/sync.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sharing_repository/sharing_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Home/dashboard page with aggregated budget summary.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final user = authState.user;

    // Guard: user should always be present on this page (auth redirect
    // handles unauthenticated state), but return empty scaffold if not.
    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final budgetId =
        context.read<SharedPreferences>().getString(activeBudgetIdKey) ?? '';
    final userId = user.id;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = RecurringCheckCubit(
              transactionRepository: context.read<TransactionRepository>(),
              budgetRepository: context.read<BudgetRepository>(),
              envelopeRepository: context.read<EnvelopeRepository>(),
              budgetId: budgetId,
              userId: userId,
              nowProvider: context.read<AppClock>().now,
            );
            unawaited(cubit.check());
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) => DashboardBloc(
            budgetRepository: context.read(),
            accountRepository: context.read(),
            envelopeRepository: context.read(),
            transactionRepository: context.read(),
            sharingRepository: context.read<SharingRepository>(),
            budgetId: budgetId,
            now: context.read<AppClock>().now,
          )..add(const DashboardStarted()),
        ),
      ],
      child: _HomeView(budgetId: budgetId),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.budgetId});

  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: [
          IconButton(
            onPressed: () => context.push(
              '${AppRoutes.reports}?budgetId=$budgetId',
            ),
            icon: const Icon(Icons.bar_chart),
          ),
          IconButton(
            onPressed: () => context.push(
              '${AppRoutes.sharedBudget}?budgetId=$budgetId',
            ),
            icon: const Icon(Icons.group),
          ),
          const SyncStatusIndicator(),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'delete_budget') {
                unawaited(_confirmDeleteBudget(context));
              } else if (value == 'settings') {
                unawaited(context.push(AppRoutes.settings));
              } else if (value == 'recurring') {
                unawaited(
                  context.push(
                    '${AppRoutes.recurring}?budgetId=$budgetId',
                  ),
                );
              } else if (value == 'debug_simulate_date') {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(
                    const Duration(days: 30),
                  ),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(
                    const Duration(days: 365),
                  ),
                );
                if (picked != null && context.mounted) {
                  await context.read<RecurringCheckCubit>().check(now: picked);
                  if (context.mounted) {
                    showAppSnackBar(
                      context,
                      SnackBar(
                        content: Text(
                          '[Debug] Simulated auto-post: '
                          '${picked.toIso8601String().substring(0, 10)}',
                        ),
                      ),
                    );
                  }
                }
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'recurring',
                child: ListTile(
                  leading: const Icon(Icons.repeat),
                  title: Text(l10n.recurringTitle),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: ListTile(
                  leading: const Icon(Icons.settings_outlined),
                  title: Text(l10n.settingsTitle),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              PopupMenuItem(
                value: 'delete_budget',
                child: ListTile(
                  leading: Icon(
                    Icons.delete_forever,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  title: Text(
                    l10n.budgetDeleteBudget,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              if (kDebugMode)
                const PopupMenuItem(
                  value: 'debug_simulate_date',
                  child: ListTile(
                    leading: Icon(Icons.science_outlined),
                    title: Text('[Debug] Simulate auto-post date'),
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
            ],
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (prev, curr) =>
                prev.status == AuthStatus.authenticated &&
                curr.status == AuthStatus.unauthenticated,
            listener: (context, _) =>
                context.read<DashboardBloc>().cancelRealtimeSubscriptions(),
          ),
          BlocListener<DashboardBloc, DashboardState>(
            listenWhen: (prev, curr) =>
                prev.error != curr.error && curr.error != null,
            listener: (context, state) {
              final message = state.error == DashboardError.allocationFailed
                  ? l10n.dashboardErrorAllocation
                  : l10n.dashboardErrorLoad;
              showAppSnackBar(context, SnackBar(content: Text(message)));
            },
          ),
          BlocListener<DashboardBloc, DashboardState>(
            listenWhen: (prev, curr) =>
                !prev.hasRemoteUpdate &&
                curr.hasRemoteUpdate &&
                curr.status != DashboardStatus.budgetDeleted,
            listener: (context, state) {
              context.read<SyncBloc>().add(const SyncRequested());
              showAppSnackBar(
                context,
                SnackBar(
                  content: Text(l10n.realtimeChangeReceived),
                  duration: const Duration(seconds: 3),
                ),
              );
            },
          ),
          BlocListener<DashboardBloc, DashboardState>(
            listenWhen: (prev, curr) =>
                curr.status == DashboardStatus.budgetDeleted,
            listener: (context, state) async {
              await context.read<SharedPreferences>().remove(activeBudgetIdKey);
              if (context.mounted) context.go(AppRoutes.onboarding);
            },
          ),
        ],
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.initial ||
                state.status == DashboardStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<DashboardBloc>().add(
                  const DashboardRefreshRequested(),
                );
              },
              child: ListView(
                children: [
                  // Recurring check banners
                  BlocBuilder<RecurringCheckCubit, RecurringCheckState>(
                    builder: (context, recurringState) {
                      if (!recurringState.hasPendingItems) {
                        return const SizedBox.shrink();
                      }
                      return Column(
                        children: [
                          if (recurringState.pendingRules.isNotEmpty)
                            MaterialBanner(
                              content: Text(l10n.recurringPendingBanner),
                              leading: const Icon(Icons.repeat),
                              actions: [
                                TextButton(
                                  onPressed: () => context.push(
                                    '${AppRoutes.recurring}?budgetId=$budgetId',
                                  ),
                                  child: Text(l10n.recurringTabRecurring),
                                ),
                              ],
                            ),
                          if (recurringState.upcomingBills.isNotEmpty)
                            MaterialBanner(
                              content: Text(l10n.recurringUpcomingBillsBanner),
                              leading: const Icon(Icons.receipt_outlined),
                              actions: [
                                TextButton(
                                  onPressed: () => context.push(
                                    '${AppRoutes.recurring}'
                                    '?budgetId=$budgetId&initialTab=1',
                                  ),
                                  child: Text(l10n.recurringTabBills),
                                ),
                              ],
                            ),
                        ],
                      );
                    },
                  ),

                  // Ready to Assign
                  DashboardReadyToAssignCard(
                    readyToAssign: state.readyToAssign,
                    carriedRta: state.selectedPeriod?.carriedRta ?? 0,
                    period: state.selectedPeriod,
                    hasPreviousPeriod: state.hasPreviousPeriod,
                    hasNextPeriod: state.hasNextPeriod,
                    onPreviousPeriod: () => context.read<DashboardBloc>().add(
                      const DashboardPreviousPeriodRequested(),
                    ),
                    onNextPeriod: () => context.read<DashboardBloc>().add(
                      const DashboardNextPeriodRequested(),
                    ),
                    onTap: () => context.push(
                      '${AppRoutes.budget}?budgetId=$budgetId',
                    ),
                  ),

                  // Envelope Summaries
                  EnvelopeSummaryCard(
                    summaries: state.envelopeSummaries,
                    categoryGroups: state.categoryGroups,
                    accounts: state.accounts,
                    ccCreditLimits: state.ccCreditLimits,
                    onViewAll: () => context.push(
                      '${AppRoutes.envelopes}?budgetId=$budgetId',
                    ),
                  ),

                  // Accounts
                  DashboardAccountsCard(
                    accounts: state.accounts,
                    totalBalance: state.totalBalance,
                    onTap: () => context.push(
                      '${AppRoutes.accounts}?budgetId=$budgetId',
                    ),
                  ),

                  // Recent Transactions
                  RecentTransactionsCard(
                    transactions: state.recentTransactions,
                    onViewAll: () => context.push(
                      '${AppRoutes.transactions}?budgetId=$budgetId',
                    ),
                  ),

                  const SizedBox(height: 80),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> _confirmDeleteBudget(BuildContext context) async {
    final l10n = context.l10n;
    final confirmed = await showConfirmDeleteDialog(
      context,
      title: l10n.budgetDeleteBudget,
      message: l10n.budgetDeleteConfirmMessage,
      cancelLabel: l10n.settingsCancel,
      confirmLabel: l10n.budgetDeleteBudget,
    );
    if (confirmed == true && context.mounted) {
      context.read<DashboardBloc>().add(const BudgetDeleteRequested());
    }
  }
}
