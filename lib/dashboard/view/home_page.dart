import 'dart:async';

import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/cubit/recurring_check_cubit.dart';
import 'package:envelope/sync/sync.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Home/dashboard page placeholder.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    // TODO(budget): Replace with actual budget ID once budget selection
    // is implemented. Using user ID as a placeholder.
    final budgetId = authState.user?.id ?? '';
    final userId = authState.user?.id ?? '';

    return BlocProvider(
      create: (_) {
        final cubit = RecurringCheckCubit(
          transactionRepository: context.read<TransactionRepository>(),
          budgetId: budgetId,
          userId: userId,
        );
        unawaited(cubit.check());
        return cubit;
      },
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

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
      body: Column(
        children: [
          BlocBuilder<RecurringCheckCubit, RecurringCheckState>(
            builder: (context, state) {
              if (!state.hasPendingItems) return const SizedBox.shrink();

              return Column(
                children: [
                  if (state.pendingRules.isNotEmpty)
                    MaterialBanner(
                      content: Text(l10n.recurringPendingBanner),
                      leading: const Icon(Icons.repeat),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: Text(l10n.recurringTabRecurring),
                        ),
                      ],
                    ),
                  if (state.upcomingBills.isNotEmpty)
                    MaterialBanner(
                      content: Text(l10n.recurringUpcomingBillsBanner),
                      leading: const Icon(Icons.receipt_outlined),
                      actions: [
                        TextButton(
                          onPressed: () {},
                          child: Text(l10n.recurringTabBills),
                        ),
                      ],
                    ),
                ],
              );
            },
          ),
          Expanded(
            child: Center(
              child: Text(l10n.homeTitle),
            ),
          ),
        ],
      ),
    );
  }
}
