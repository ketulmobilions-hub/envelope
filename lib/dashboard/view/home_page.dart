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
        centerTitle: false,
        title: BlocBuilder<DashboardBloc, DashboardState>(
          buildWhen: (prev, curr) =>
              prev.selectedPeriod != curr.selectedPeriod ||
              prev.periods != curr.periods,
          builder: (context, state) {
            if (state.selectedPeriod == null) return Text(l10n.homeTitle);
            return TextButton(
              onPressed: () async {
                final picked = await showPeriodPickerSheet(
                  context,
                  periods: state.sortedPeriods,
                  selectedPeriod: state.selectedPeriod,
                );
                if (picked != null && context.mounted) {
                  context.read<DashboardBloc>().add(
                    DashboardPeriodSelected(picked),
                  );
                }
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                minimumSize: const Size(0, 44),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _formatPeriod(state.selectedPeriod!),
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(width: 2),
                  Icon(
                    Icons.arrow_drop_down,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          BlocBuilder<DashboardBloc, DashboardState>(
            buildWhen: (prev, curr) => prev.memberCount != curr.memberCount,
            builder: (context, state) {
              final isShared = state.memberCount > 1;
              return IconButton(
                onPressed: () => context.push(
                  '${AppRoutes.sharedBudget}?budgetId=$budgetId',
                ),
                icon: Icon(
                  isShared
                      ? Icons.group_outlined
                      : Icons.group_add_outlined,
                ),
                tooltip: l10n.sharedBudgetTitle,
              );
            },
          ),
          const SyncStatusIndicator(),
          PopupMenuButton<String>(
            onSelected: (value) async {
              if (value == 'recurring') {
                unawaited(
                  context.push(
                    '${AppRoutes.recurring}?budgetId=$budgetId',
                  ),
                );
              } else if (value == 'settings') {
                unawaited(context.push(AppRoutes.settings));
              } else if (value == 'delete_budget') {
                unawaited(_confirmDeleteBudget(context));
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
                  leading: const Icon(Icons.repeat_outlined),
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
              const PopupMenuDivider(),
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
              if (state.error == DashboardError.allocationFailed) {
                showAppSnackBar(
                  context,
                  SnackBar(content: Text(l10n.dashboardErrorAllocation)),
                );
              } else {
                showAppSnackBar(
                  context,
                  SnackBar(
                    content: Text(l10n.dashboardErrorLoad),
                    action: SnackBarAction(
                      label: l10n.dashboardErrorRetry,
                      onPressed: () => context
                          .read<DashboardBloc>()
                          .add(const DashboardRefreshRequested()),
                    ),
                  ),
                );
              }
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
              return const DashboardSkeleton();
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
                    readyToAssign: state.adjustedReadyToAssign,
                    totalSpent: state.totalSpent,
                    totalAllocated: state.totalAllocated,
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

  static String _formatPeriod(BudgetPeriod period) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];
    final start = period.startDate;
    final end = period.endDate;
    if (start.year == end.year && start.month == end.month) {
      return '${months[start.month - 1]} ${start.year}';
    }
    if (start.year != end.year) {
      final s = '${months[start.month - 1]} ${start.year}';
      final e = '${months[end.month - 1]} ${end.year}';
      return '$s – $e';
    }
    return '${months[start.month - 1]} – ${months[end.month - 1]} ${end.year}';
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
