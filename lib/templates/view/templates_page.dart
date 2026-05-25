import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/onboarding_cubit.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/templates/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

class TemplatesPage extends StatelessWidget {
  const TemplatesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final budgetId =
        context.read<SharedPreferences>().getString(activeBudgetIdKey) ?? '';
    return BlocProvider(
      create: (ctx) => TransactionTemplatesCubit(
        transactionRepository: ctx.read(),
        budgetId: budgetId,
      ),
      child: const _TemplatesView(),
    );
  }
}

class _TemplatesView extends StatelessWidget {
  const _TemplatesView();

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final baseCurrency =
        context.watch<AuthBloc>().state.user?.baseCurrency ?? 'USD';

    return Scaffold(
      appBar: AppBar(title: Text(l10n.templatesTitle)),
      body: BlocBuilder<TransactionTemplatesCubit, TransactionTemplatesState>(
        builder: (context, state) {
          if (state.status == TransactionTemplatesStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.templates.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Text(
                  l10n.templatesEmpty,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            itemCount: state.templates.length,
            separatorBuilder: (_, _) => const Divider(height: 1, indent: 56),
            itemBuilder: (_, i) {
              final t = state.templates[i];
              final amount = t.amountCents;
              final symbol = currencySymbolFromCode(t.currency ?? baseCurrency);
              return ListTile(
                leading: Icon(
                  t.type == 'income'
                      ? Icons.trending_up
                      : Icons.shopping_bag_outlined,
                ),
                title: Text(t.name),
                subtitle: (amount != null && amount > 0)
                    ? Text('$symbol${(amount / 100).toStringAsFixed(2)}')
                    : null,
                trailing: IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: l10n.templatesDelete,
                  color: Theme.of(context).colorScheme.error,
                  onPressed: () => _confirmDelete(context, t),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    TransactionTemplate template,
  ) async {
    final l10n = context.l10n;
    final cubit = context.read<TransactionTemplatesCubit>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.templatesDelete),
        content: Text(l10n.templatesDeleteConfirm(template.name)),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text(l10n.transactionsCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            onPressed: () => context.pop(true),
            child: Text(l10n.templatesDelete),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await cubit.deleteTemplate(template.id);
    }
  }
}
