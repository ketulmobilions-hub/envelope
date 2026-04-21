import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/recurring/bloc/bloc.dart';
import 'package:envelope/recurring/view/bill_reminder_form_page.dart';
import 'package:envelope/recurring/view/recurring_rule_form_page.dart';
import 'package:envelope/recurring/widgets/widgets.dart';
import 'package:envelope/shared/widgets/app_option_picker.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page that provides [RecurringBloc] and displays recurring rules and
/// bill reminders in a tabbed layout.
class RecurringPage extends StatelessWidget {
  const RecurringPage({
    required this.budgetId,
    this.initialTab = 0,
    super.key,
  });

  final String budgetId;
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    final userId = context.read<AuthBloc>().state.user?.id ?? '';
    return BlocProvider(
      create: (_) => RecurringBloc(
        transactionRepository: context.read<TransactionRepository>(),
        budgetId: budgetId,
        userId: userId,
      )..add(const RecurringStarted()),
      child: RecurringView(budgetId: budgetId, initialTab: initialTab),
    );
  }
}

class RecurringView extends StatelessWidget {
  const RecurringView({
    required this.budgetId,
    this.initialTab = 0,
    super.key,
  });

  final String budgetId;
  final int initialTab;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final userId = context.read<AuthBloc>().state.user?.id ?? '';

    return DefaultTabController(
      length: 2,
      initialIndex: initialTab,
      child: BlocListener<RecurringBloc, RecurringState>(
        listenWhen: (prev, curr) =>
            curr.status == RecurringStatus.error && curr.error != null,
        listener: (context, state) {
          final message = switch (state.error!) {
            RecurringError.loadFailed => l10n.recurringErrorLoadFailed,
            RecurringError.deleteFailed => l10n.recurringErrorDeleteFailed,
            RecurringError.undoFailed => l10n.recurringErrorUndoFailed,
            RecurringError.pauseFailed => l10n.recurringErrorPauseFailed,
            RecurringError.postFailed => l10n.recurringErrorPostFailed,
          };
          showAppSnackBar(context, SnackBar(content: Text(message)));
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(l10n.recurringTitle),
            bottom: TabBar(
              tabs: [
                Tab(text: l10n.recurringTabRecurring),
                Tab(text: l10n.recurringTabBills),
              ],
            ),
          ),
          floatingActionButton: Builder(
            builder: (innerContext) => FloatingActionButton(
              onPressed: () => _onFabPressed(innerContext),
              child: const Icon(Icons.add),
            ),
          ),
          body: BlocBuilder<RecurringBloc, RecurringState>(
            builder: (context, state) {
              if (state.status == RecurringStatus.loading ||
                  state.status == RecurringStatus.initial) {
                return const Center(child: CircularProgressIndicator());
              }

              return TabBarView(
                children: [
                  _RecurringRulesTab(
                    state: state,
                    budgetId: budgetId,
                  ),
                  _BillRemindersTab(
                    state: state,
                    budgetId: budgetId,
                    userId: userId,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onFabPressed(BuildContext context) async {
    final tabController = DefaultTabController.of(context);
    if (tabController.index == 0) {
      await _openAddRule(context);
    } else {
      await _openAddBill(context);
    }
  }

  Future<void> _openAddRule(BuildContext context) async {
    final bloc = context.read<RecurringBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RecurringRuleFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const RecurringRefreshRequested());
    }
  }

  Future<void> _openAddBill(BuildContext context) async {
    final bloc = context.read<RecurringBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BillReminderFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const RecurringRefreshRequested());
    }
  }
}

class _RecurringRulesTab extends StatelessWidget {
  const _RecurringRulesTab({required this.state, required this.budgetId});

  final RecurringState state;
  final String budgetId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (state.recurringRules.isEmpty) {
      return RecurringEmptyState(
        icon: Icons.repeat_outlined,
        title: l10n.recurringEmptyRulesTitle,
        subtitle: l10n.recurringEmptyRulesSubtitle,
        actionLabel: l10n.recurringAddRule,
        onAction: () => _openAddRule(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<RecurringBloc>()
          ..add(const RecurringRefreshRequested());
        await bloc.stream
            .firstWhere((s) => s.status == RecurringStatus.loaded)
            .timeout(const Duration(seconds: 10), onTimeout: () => bloc.state);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.recurringRules.length,
        itemBuilder: (context, index) {
          final rule = state.recurringRules[index];
          final isPending = !rule.isPaused &&
              !rule.autoPost &&
              !rule.nextOccurrence.isAfter(DateTime.now());
          return RecurringRuleListTile(
            rule: rule,
            isPending: isPending,
            onTap: () => _openEditRule(context, rule),
            onDelete: () => _onDeleteRule(context, rule),
            onPost: () => context
                .read<RecurringBloc>()
                .add(RecurringRulePosted(rule.id)),
            onPauseToggle: () => context
                .read<RecurringBloc>()
                .add(RecurringRulePauseToggled(rule.id)),
          );
        },
      ),
    );
  }

  Future<void> _openAddRule(BuildContext context) async {
    final bloc = context.read<RecurringBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RecurringRuleFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const RecurringRefreshRequested());
    }
  }

  Future<void> _openEditRule(
    BuildContext context,
    RecurringRule rule,
  ) async {
    final bloc = context.read<RecurringBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => RecurringRuleFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
          rule: rule,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const RecurringRefreshRequested());
    }
  }

  Future<void> _onDeleteRule(
    BuildContext context,
    RecurringRule rule,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.recurringDeleteConfirmTitle),
        content: Text(l10n.recurringDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.recurringCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.recurringDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final bloc = context.read<RecurringBloc>()
      ..add(RecurringRuleDeleted(rule.id));

    showUndoSnackBar(
      context,
      message: l10n.recurringDeleted,
      undoLabel: l10n.recurringUndo,
      onUndo: () => bloc.add(const RecurringRuleUndoDeleteRequested()),
    );
  }
}

class _BillRemindersTab extends StatelessWidget {
  const _BillRemindersTab({
    required this.state,
    required this.budgetId,
    required this.userId,
  });

  final RecurringState state;
  final String budgetId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    if (state.billReminders.isEmpty) {
      return RecurringEmptyState(
        icon: Icons.receipt_long_outlined,
        title: l10n.recurringEmptyBillsTitle,
        subtitle: l10n.recurringEmptyBillsSubtitle,
        actionLabel: l10n.recurringAddBill,
        onAction: () => _openAddBill(context),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        final bloc = context.read<RecurringBloc>()
          ..add(const RecurringRefreshRequested());
        await bloc.stream
            .firstWhere((s) => s.status == RecurringStatus.loaded)
            .timeout(const Duration(seconds: 10), onTimeout: () => bloc.state);
      },
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: state.billReminders.length,
        itemBuilder: (context, index) {
          final reminder = state.billReminders[index];
          return BillReminderListTile(
            reminder: reminder,
            onTap: () => _openEditBill(context, reminder),
            onDelete: () => _onDeleteBill(context, reminder),
            onPay: () => _onPayBill(context, reminder),
          );
        },
      ),
    );
  }

  Future<void> _openAddBill(BuildContext context) async {
    final bloc = context.read<RecurringBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BillReminderFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const RecurringRefreshRequested());
    }
  }

  Future<void> _openEditBill(
    BuildContext context,
    BillReminder reminder,
  ) async {
    final bloc = context.read<RecurringBloc>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BillReminderFormPage(
          transactionRepository: context.read<TransactionRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
          reminder: reminder,
        ),
      ),
    );
    if (result == true && context.mounted) {
      bloc.add(const RecurringRefreshRequested());
    }
  }

  Future<void> _onDeleteBill(
    BuildContext context,
    BillReminder reminder,
  ) async {
    final l10n = context.l10n;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.recurringDeleteConfirmTitle),
        content: Text(l10n.recurringDeleteConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(l10n.recurringCancel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(l10n.recurringDelete),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    final bloc = context.read<RecurringBloc>()
      ..add(BillReminderDeleted(reminder.id));

    showUndoSnackBar(
      context,
      message: l10n.recurringDeleted,
      undoLabel: l10n.recurringUndo,
      onUndo: () => bloc.add(const BillReminderUndoDeleteRequested()),
    );
  }

  Future<void> _onPayBill(
    BuildContext context,
    BillReminder reminder,
  ) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => _SimpleBillPaymentForm(
          transactionRepository: context.read<TransactionRepository>(),
          accountRepository: context.read<AccountRepository>(),
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: budgetId,
          userId: userId,
          reminder: reminder,
        ),
      ),
    );
    if (context.mounted) {
      context.read<RecurringBloc>().add(const RecurringRefreshRequested());
    }
  }
}

/// Simplified form for paying a bill (pre-filled from reminder).
class _SimpleBillPaymentForm extends StatefulWidget {
  const _SimpleBillPaymentForm({
    required this.transactionRepository,
    required this.accountRepository,
    required this.envelopeRepository,
    required this.budgetId,
    required this.userId,
    required this.reminder,
  });

  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final EnvelopeRepository envelopeRepository;
  final String budgetId;
  final String userId;
  final BillReminder reminder;

  @override
  State<_SimpleBillPaymentForm> createState() =>
      _SimpleBillPaymentFormState();
}

class _SimpleBillPaymentFormState extends State<_SimpleBillPaymentForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  String? _selectedAccountId;
  bool _isSubmitting = false;
  bool _isLoadingAccounts = true;
  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController(
      text: (widget.reminder.estimatedAmount / 100).toStringAsFixed(2),
    );
    unawaited(_loadAccounts());
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await widget.accountRepository
          .watchAccounts(widget.budgetId)
          .first;
      if (mounted) {
        setState(() {
          _accounts = accounts;
          _selectedAccountId =
              accounts.isNotEmpty ? accounts.first.id : null;
          _isLoadingAccounts = false;
        });
      }
    } on Exception {
      if (mounted) setState(() => _isLoadingAccounts = false);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.reminder.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isLoadingAccounts)
                const Center(child: CircularProgressIndicator())
              else if (_accounts.isNotEmpty)
                AppOptionPicker<Account>(
                  options: _accounts,
                  value: _accounts
                      .where((a) => a.id == _selectedAccountId)
                      .firstOrNull,
                  onChanged: (a) =>
                      setState(() => _selectedAccountId = a.id),
                  labelText: l10n.transactionsAccountLabel,
                  icon: Icons.account_balance_outlined,
                  itemLabel: (a) => a.name,
                ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.transactionsAmountLabel,
                  prefixText: symbol,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.transactionsAmountRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: _isSubmitting || _isLoadingAccounts ? null : _submit,
                child: _isSubmitting
                    ? const SizedBox.square(
                        dimension: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.recurringPayNow),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedAccountId == null) return;

    setState(() => _isSubmitting = true);

    try {
      final amountText = _amountController.text.trim();
      final amount = (double.tryParse(amountText) ?? 0) * 100;
      final account = _accounts
          .where((a) => a.id == _selectedAccountId)
          .firstOrNull;

      await widget.transactionRepository.createTransaction(
        budgetId: widget.budgetId,
        accountId: _selectedAccountId!,
        type: 'expense',
        amount: amount.round(),
        currency: account?.currency ?? 'USD',
        date: DateTime.now(),
        createdBy: widget.userId,
        envelopeId: widget.reminder.envelopeId,
        payee: widget.reminder.name,
        notes: 'Bill payment',
      );

      if (mounted) Navigator.of(context).pop(true);
    } on TransactionException catch (e) {
      if (mounted) {
        showAppSnackBar(context, SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
