import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

/// Page for creating an account-to-account transfer.
///
/// Creates two linked transactions with a shared transfer pair ID.
class TransferFormPage extends StatefulWidget {
  const TransferFormPage({
    required this.transactionRepository,
    required this.accountRepository,
    required this.budgetId,
    required this.userId,
    super.key,
  });

  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final String budgetId;
  final String userId;

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  String? _fromAccountId;
  String? _toAccountId;
  bool _isSubmitting = false;

  List<Account> _accounts = [];

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _selectedDate = DateTime.now();
    unawaited(_loadAccounts());
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await widget.accountRepository
          .watchAccounts(widget.budgetId)
          .first;
      if (mounted) {
        setState(() => _accounts = accounts);
      }
    } on Exception {
      // Keep empty list.
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

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.transactionsTransferTitle),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 500),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // From account
                if (_accounts.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _fromAccountId,
                    decoration: InputDecoration(
                      labelText: l10n.transactionsTransferFrom,
                      prefixIcon: const Icon(Icons.logout_outlined),
                    ),
                    items: _accounts.map((a) {
                      return DropdownMenuItem(
                        value: a.id,
                        child: Text(a.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _fromAccountId = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.transactionsAccountRequired;
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),

                // To account
                if (_accounts.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _toAccountId,
                    decoration: InputDecoration(
                      labelText: l10n.transactionsTransferTo,
                      prefixIcon: const Icon(Icons.login_outlined),
                    ),
                    items: _accounts.map((a) {
                      return DropdownMenuItem(
                        value: a.id,
                        child: Text(a.name),
                      );
                    }).toList(),
                    onChanged: (value) =>
                        setState(() => _toAccountId = value),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.transactionsAccountRequired;
                      }
                      if (value == _fromAccountId) {
                        return l10n.transactionsTransferSameAccount;
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),

                // Amount
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: l10n.transactionsAmountLabel,
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\d*\.?\d{0,2}'),
                    ),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.transactionsAmountRequired;
                    }
                    final cents = parseCents(value);
                    if (cents == null || cents <= 0) {
                      return l10n.transactionsAmountRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text(formatTransactionDate(_selectedDate)),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 32),

                // Submit
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.transactionsTransferButton),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final amountCents = parseCents(_amountController.text) ?? 0;
      final transferPairId = const Uuid().v4();

      // Create outgoing transaction (from account — negative amount).
      await widget.transactionRepository.createTransaction(
        budgetId: widget.budgetId,
        accountId: _fromAccountId!,
        type: 'transfer',
        amount: -amountCents,
        currency: 'USD',
        date: _selectedDate,
        createdBy: widget.userId,
        transferPairId: transferPairId,
      );

      // Create incoming transaction (to account).
      await widget.transactionRepository.createTransaction(
        budgetId: widget.budgetId,
        accountId: _toAccountId!,
        type: 'transfer',
        amount: amountCents,
        currency: 'USD',
        date: _selectedDate,
        createdBy: widget.userId,
        transferPairId: transferPairId,
      );

      if (mounted) Navigator.of(context).pop(true);
    } on TransactionException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
