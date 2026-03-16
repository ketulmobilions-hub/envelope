import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/view/transfer_form_page.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page for adding or editing a transaction.
///
/// Pass [transaction] to edit an existing transaction, or leave it `null`
/// to create.
class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    required this.transactionRepository,
    required this.accountRepository,
    required this.envelopeRepository,
    required this.budgetId,
    required this.userId,
    this.transaction,
    super.key,
  });

  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final EnvelopeRepository envelopeRepository;
  final String budgetId;
  final String userId;
  final Transaction? transaction;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedType;
  late DateTime _selectedDate;
  late final TextEditingController _amountController;
  late final TextEditingController _payeeController;
  late final TextEditingController _notesController;
  String? _selectedAccountId;
  String? _selectedEnvelopeId;
  bool _isSubmitting = false;
  bool _isSplitMode = false;

  List<Account> _accounts = [];
  List<Envelope> _envelopes = [];
  List<Tag> _tags = [];
  List<String> _selectedTagIds = [];
  List<SplitEntry> _splits = [];

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _selectedType = txn?.type ?? 'expense';
    _selectedDate = txn?.date ?? DateTime.now();
    _amountController = TextEditingController(
      text: txn != null ? (txn.amount / 100).toStringAsFixed(2) : '',
    );
    _payeeController = TextEditingController(text: txn?.payee ?? '');
    _notesController = TextEditingController(text: txn?.notes ?? '');
    _selectedAccountId = txn?.accountId;
    _selectedEnvelopeId = txn?.envelopeId;

    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    try {
      final accounts = await widget.accountRepository
          .watchAccounts(widget.budgetId)
          .first;
      final envelopes = await widget.envelopeRepository
          .watchEnvelopes(widget.budgetId)
          .first;
      final tags = await widget.transactionRepository.getTags(widget.budgetId);

      if (!mounted) return;

      var selectedTagIds = <String>[];
      if (_isEditing) {
        selectedTagIds = await widget.transactionRepository
            .getTagIdsForTransaction(widget.transaction!.id);
      }

      if (!mounted) return;

      setState(() {
        _accounts = accounts;
        _envelopes = envelopes;
        _tags = tags;
        _selectedTagIds = selectedTagIds;
        _selectedAccountId ??= accounts.isNotEmpty ? accounts.first.id : null;
      });
    } on Exception {
      // Keep current state if loading fails.
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? l10n.transactionsEditTransaction
              : l10n.transactionsAddTransaction,
        ),
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
                // Type selector
                SegmentedButton<String>(
                  segments: [
                    ButtonSegment(
                      value: 'income',
                      label: Text(l10n.transactionsTypeIncome),
                      icon: const Icon(Icons.arrow_downward_outlined),
                    ),
                    ButtonSegment(
                      value: 'expense',
                      label: Text(l10n.transactionsTypeExpense),
                      icon: const Icon(Icons.arrow_upward_outlined),
                    ),
                    ButtonSegment(
                      value: 'transfer',
                      label: Text(l10n.transactionsTypeTransfer),
                      icon: const Icon(Icons.swap_horiz_outlined),
                    ),
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (selected) async {
                    final type = selected.first;
                    if (type == 'transfer') {
                      await _navigateToTransfer();
                      return;
                    }
                    setState(() => _selectedType = type);
                  },
                ),
                const SizedBox(height: 16),

                // Date picker
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text(
                    formatTransactionDate(_selectedDate),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 16),

                // Account dropdown
                if (_accounts.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedAccountId,
                    decoration: InputDecoration(
                      labelText: l10n.transactionsAccountLabel,
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                    ),
                    items: _accounts.map((account) {
                      return DropdownMenuItem(
                        value: account.id,
                        child: Text(account.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() => _selectedAccountId = value);
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return l10n.transactionsAccountRequired;
                      }
                      return null;
                    },
                  ),
                const SizedBox(height: 16),

                // Envelope dropdown (hidden in split mode)
                if (!_isSplitMode && _envelopes.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: _selectedEnvelopeId,
                    decoration: InputDecoration(
                      labelText: l10n.transactionsEnvelopeLabel,
                      prefixIcon: const Icon(Icons.mail_outlined),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        child: Text(l10n.transactionsNoEnvelope),
                      ),
                      ...(_envelopes.map((env) {
                        return DropdownMenuItem(
                          value: env.id,
                          child: Text(env.name),
                        );
                      })),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedEnvelopeId = value);
                    },
                  ),
                if (!_isSplitMode) const SizedBox(height: 16),

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
                      RegExp(r'^\-?\d*\.?\d{0,2}'),
                    ),
                  ],
                  textInputAction: TextInputAction.next,
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

                // Payee
                TextFormField(
                  controller: _payeeController,
                  decoration: InputDecoration(
                    labelText: l10n.transactionsPayeeLabel,
                    prefixIcon: const Icon(Icons.person_outline),
                  ),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  decoration: InputDecoration(
                    labelText: l10n.transactionsNotesLabel,
                    prefixIcon: const Icon(Icons.notes_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                  maxLines: 2,
                ),
                const SizedBox(height: 16),

                // Split mode toggle
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.transactionsSplitMode),
                  value: _isSplitMode,
                  onChanged: (value) {
                    setState(() {
                      _isSplitMode = value;
                      if (value && _splits.length < 2) {
                        _splits = [
                          const SplitEntry(),
                          const SplitEntry(),
                        ];
                      }
                    });
                  },
                ),

                // Split rows
                if (_isSplitMode) ...[
                  const SizedBox(height: 8),
                  SplitRows(
                    splits: _splits,
                    envelopes: _envelopes,
                    totalAmountCents: parseCents(_amountController.text) ?? 0,
                    onChanged: (splits) => setState(() => _splits = splits),
                  ),
                ],

                const SizedBox(height: 16),

                // Tags
                TagPicker(
                  availableTags: _tags,
                  selectedTagIds: _selectedTagIds,
                  onChanged: (tagIds) =>
                      setState(() => _selectedTagIds = tagIds),
                  onCreateTag: _createTag,
                ),

                const SizedBox(height: 32),

                // Submit button
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEditing
                              ? l10n.transactionsSaveButton
                              : l10n.transactionsCreateButton,
                        ),
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

  Future<void> _navigateToTransfer() async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => TransferFormPage(
          transactionRepository: widget.transactionRepository,
          accountRepository: widget.accountRepository,
          budgetId: widget.budgetId,
          userId: widget.userId,
        ),
      ),
    );
    if (mounted && result == true) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _createTag(String name) async {
    try {
      final tag = await widget.transactionRepository.createTag(
        budgetId: widget.budgetId,
        name: name,
      );
      if (mounted) {
        setState(() {
          _tags = [..._tags, tag];
          _selectedTagIds = [..._selectedTagIds, tag.id];
        });
      }
    } on TransactionException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final amountCents = parseCents(_amountController.text) ?? 0;

      if (_isEditing) {
        final updated = widget.transaction!.copyWith(
          type: _selectedType,
          accountId: _selectedAccountId ?? widget.transaction!.accountId,
          envelopeId: _isSplitMode ? null : _selectedEnvelopeId,
          amount: amountCents,
          date: _selectedDate,
          payee: _payeeController.text.trim(),
          notes: _notesController.text.trim(),
          updatedAt: DateTime.now(),
        );
        await widget.transactionRepository.updateTransaction(updated);

        // Handle splits.
        if (_isSplitMode) {
          await _saveSplits(widget.transaction!.id);
        }

        // Handle tags.
        await _saveTags(widget.transaction!.id);
      } else {
        final created = await widget.transactionRepository.createTransaction(
          budgetId: widget.budgetId,
          accountId: _selectedAccountId!,
          type: _selectedType,
          amount: amountCents,
          currency: 'USD',
          date: _selectedDate,
          createdBy: widget.userId,
          envelopeId: _isSplitMode ? null : _selectedEnvelopeId,
          payee: _payeeController.text.trim(),
          notes: _notesController.text.trim(),
        );

        // Handle splits.
        if (_isSplitMode) {
          await _saveSplits(created.id);
        }

        // Handle tags.
        await _saveTags(created.id);
      }

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

  Future<void> _saveSplits(String transactionId) async {
    final validSplits = _splits
        .where((s) => s.envelopeId != null && s.amountCents > 0)
        .toList();

    if (validSplits.isEmpty) return;

    await widget.transactionRepository.replaceSplits(
      transactionId: transactionId,
      splits: validSplits.map((s) {
        return TransactionSplit(
          id: '',
          transactionId: transactionId,
          envelopeId: s.envelopeId!,
          amount: s.amountCents,
        );
      }).toList(),
    );
  }

  Future<void> _saveTags(String transactionId) async {
    if (!_isEditing) {
      // New transaction: just add all selected tags.
      for (final tagId in _selectedTagIds) {
        await widget.transactionRepository.addTagToTransaction(
          transactionId: transactionId,
          tagId: tagId,
        );
      }
      return;
    }

    // Editing: diff the tags.
    final existing = await widget.transactionRepository
        .getTagIdsForTransaction(transactionId);
    final toAdd =
        _selectedTagIds.where((id) => !existing.contains(id)).toList();
    final toRemove =
        existing.where((id) => !_selectedTagIds.contains(id)).toList();

    for (final tagId in toAdd) {
      await widget.transactionRepository.addTagToTransaction(
        transactionId: transactionId,
        tagId: tagId,
      );
    }
    for (final tagId in toRemove) {
      await widget.transactionRepository.removeTagFromTransaction(
        transactionId: transactionId,
        tagId: tagId,
      );
    }
  }
}
