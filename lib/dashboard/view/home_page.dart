import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/app/routes/app_router.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/dashboard/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/cubit/recurring_check_cubit.dart';
import 'package:envelope/sync/sync.dart';
import 'package:envelope/transactions/transactions.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
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

    // TODO(budget): Replace with actual budget ID once budget selection
    // is implemented. Using user ID as a placeholder.
    final budgetId = user.id;
    final userId = user.id;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) {
            final cubit = RecurringCheckCubit(
              transactionRepository: context.read<TransactionRepository>(),
              budgetId: budgetId,
              userId: userId,
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
            budgetId: budgetId,
          )..add(const DashboardStarted()),
        ),
      ],
      child: _HomeView(budgetId: budgetId, userId: userId),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView({required this.budgetId, required this.userId});

  final String budgetId;
  final String userId;

  void _openAddTransaction(BuildContext context) {
    unawaited(
      Navigator.of(context).push<bool>(
        MaterialPageRoute(
          builder: (_) => TransactionFormPage(
            transactionRepository:
                context.read<TransactionRepository>(),
            accountRepository: context.read<AccountRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: budgetId,
            userId: userId,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.homeTitle),
        actions: const [
          SyncStatusIndicator(),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddTransaction(context),
        child: const Icon(Icons.add),
      ),
      body: BlocListener<DashboardBloc, DashboardState>(
        listenWhen: (prev, curr) =>
            prev.error != curr.error && curr.error != null,
        listener: (context, state) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.dashboardErrorLoad)),
          );
        },
        child: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state.status == DashboardStatus.initial ||
                state.status == DashboardStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<DashboardBloc>()
                    .add(const DashboardRefreshRequested());
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
                                  onPressed: () => context.go(
                                    '${AppRoutes.recurring}?budgetId=$budgetId',
                                  ),
                                  child: Text(l10n.recurringTabRecurring),
                                ),
                              ],
                            ),
                          if (recurringState.upcomingBills.isNotEmpty)
                            MaterialBanner(
                              content:
                                  Text(l10n.recurringUpcomingBillsBanner),
                              leading: const Icon(Icons.receipt_outlined),
                              actions: [
                                TextButton(
                                  onPressed: () => context.go(
                                    '${AppRoutes.recurring}?budgetId=$budgetId',
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
                    onTap: () => context.go(
                      '${AppRoutes.budget}?budgetId=$budgetId',
                    ),
                  ),

                  // Quick Actions
                  QuickActionsRow(
                    onAddTransaction: () =>
                        _openAddTransaction(context),
                    onViewBudget: () => context.go(
                      '${AppRoutes.budget}?budgetId=$budgetId',
                    ),
                    onViewAccounts: () => context.go(
                      '${AppRoutes.accounts}?budgetId=$budgetId',
                    ),
                  ),

                  // Envelope Summaries
                  EnvelopeSummaryCard(
                    summaries: state.envelopeSummaries,
                    onViewAll: () => context.go(
                      '${AppRoutes.envelopes}?budgetId=$budgetId',
                    ),
                  ),

                  // Accounts
                  DashboardAccountsCard(
                    accounts: state.accounts,
                    totalBalance: state.totalBalance,
                    onTap: () => context.go(
                      '${AppRoutes.accounts}?budgetId=$budgetId',
                    ),
                  ),

                  // Recent Transactions
                  RecentTransactionsCard(
                    transactions: state.recentTransactions,
                    onViewAll: () => context.go(
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
}
