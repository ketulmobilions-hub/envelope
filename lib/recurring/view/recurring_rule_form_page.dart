import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/widgets/frequency_label.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page for adding or editing a recurring rule.
class RecurringRuleFormPage extends StatefulWidget {
  const RecurringRuleFormPage({
    required this.transactionRepository,
    required this.accountRepository,
    required this.envelopeRepository,
    required this.budgetId,
    this.rule,
    super.key,
  });

  final TransactionRepository transactionRepository;
  final AccountRepository accountRepository;
  final EnvelopeRepository envelopeRepository;
  final String budgetId;
  final RecurringRule? rule;

  @override
  State<RecurringRuleFormPage> createState() => _RecurringRuleFormPageState();
}

class _RecurringRuleFormPageState extends State<RecurringRuleFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedType;
  late String _selectedFrequency;
  late DateTime _startDate;
  DateTime? _endDate;
  late bool _autoPost;
  late final TextEditingController _amountController;
  late final TextEditingController _payeeController;
  late final TextEditingController _notesController;
  late final TextEditingController _customIntervalController;
  String? _selectedAccountId;
  String? _selectedEnvelopeId;
  String _customUnit = 'days';
  bool _isSubmitting = false;

  List<Account> _accounts = [];
  List<Envelope> _envelopes = [];

  bool get _isEditing => widget.rule != null;

  static const _frequencies = [
    'daily',
    'weekly',
    'bi-weekly',
    'monthly',
    'yearly',
    'custom',
  ];

  static const _customUnits = ['days', 'weeks', 'months'];

  @override
  void initState() {
    super.initState();
    final rule = widget.rule;
    _selectedType = rule?.type ?? 'expense';
    _selectedFrequency = rule?.frequency ?? 'monthly';
    _startDate = rule?.startDate ?? DateTime.now();
    _endDate = rule?.endDate;
    _autoPost = rule?.autoPost ?? false;
    _amountController = TextEditingController(
      text: rule != null ? (rule.amount / 100).toStringAsFixed(2) : '',
    );
    _payeeController = TextEditingController(text: rule?.payee ?? '');
    _notesController = TextEditingController(text: rule?.notes ?? '');
    _customIntervalController = TextEditingController(
      text: rule?.customInterval?.toString() ?? '',
    );
    _selectedAccountId = rule?.accountId;
    _selectedEnvelopeId = rule?.envelopeId;
    _customUnit = rule?.customUnit ?? 'days';

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

      if (!mounted) return;

      setState(() {
        _accounts = accounts;
        _envelopes = envelopes;
        _selectedAccountId ??= accounts.isNotEmpty ? accounts.first.id : null;
      });
    } on Exception {
      // Keep current state.
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _notesController.dispose();
    _customIntervalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.recurringEditRule : l10n.recurringAddRule,
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
                  ],
                  selected: {_selectedType},
                  onSelectionChanged: (selected) {
                    setState(() => _selectedType = selected.first);
                  },
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

                // Envelope dropdown
                if (_envelopes.isNotEmpty)
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
                      ..._envelopes.map((env) {
                        return DropdownMenuItem(
                          value: env.id,
                          child: Text(env.name),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedEnvelopeId = value);
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

                // Frequency dropdown
                DropdownButtonFormField<String>(
                  initialValue: _selectedFrequency,
                  decoration: InputDecoration(
                    labelText: l10n.recurringFrequencyLabel,
                    prefixIcon: const Icon(Icons.repeat),
                  ),
                  items: _frequencies.map((f) {
                    return DropdownMenuItem(
                      value: f,
                      child: Text(localizedFrequency(f, l10n)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedFrequency = value);
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Custom interval fields
                if (_selectedFrequency == 'custom') ...[
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _customIntervalController,
                          decoration: InputDecoration(
                            labelText: l10n.recurringCustomIntervalLabel,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (_selectedFrequency == 'custom') {
                              final n = int.tryParse(value ?? '');
                              if (n == null || n <= 0) {
                                return l10n
                                    .recurringCustomIntervalRequired;
                              }
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _customUnit,
                          decoration: InputDecoration(
                            labelText: l10n.recurringCustomUnitLabel,
                          ),
                          items: _customUnits.map((u) {
                            return DropdownMenuItem(
                              value: u,
                              child: Text(_localizedUnit(u, l10n)),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              setState(() => _customUnit = value);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],

                // Start date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.calendar_today),
                  title: Text(l10n.recurringStartDateLabel),
                  subtitle: Text(formatTransactionDate(_startDate)),
                  onTap: _pickStartDate,
                ),

                // End date
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.event),
                  title: Text(l10n.recurringEndDateLabel),
                  subtitle: Text(
                    _endDate != null
                        ? formatTransactionDate(_endDate!)
                        : '—',
                  ),
                  onTap: _pickEndDate,
                  trailing: _endDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => _endDate = null),
                        )
                      : null,
                ),
                const SizedBox(height: 8),

                // Auto-post toggle
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.recurringAutoPostLabel),
                  subtitle: Text(l10n.recurringAutoPostSubtitle),
                  value: _autoPost,
                  onChanged: (value) => setState(() => _autoPost = value),
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
                              ? l10n.recurringSaveButton
                              : l10n.recurringCreateButton,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _startDate = picked);
    }
  }

  Future<void> _pickEndDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? _startDate.add(const Duration(days: 30)),
      firstDate: _startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null) {
      setState(() => _endDate = picked);
    }
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final amountCents = parseCents(_amountController.text) ?? 0;

      if (_isEditing) {
        final updated = widget.rule!.copyWith(
          type: _selectedType,
          accountId: _selectedAccountId ?? widget.rule!.accountId,
          envelopeId: _selectedEnvelopeId,
          amount: amountCents,
          frequency: _selectedFrequency,
          startDate: _startDate,
          endDate: _endDate,
          autoPost: _autoPost,
          payee: _payeeController.text.trim(),
          notes: _notesController.text.trim(),
          customInterval: _selectedFrequency == 'custom'
              ? int.tryParse(_customIntervalController.text)
              : null,
          customUnit: _selectedFrequency == 'custom' ? _customUnit : null,
        );
        await widget.transactionRepository.updateRecurringRule(updated);
      } else {
        await widget.transactionRepository.createRecurringRule(
          budgetId: widget.budgetId,
          accountId: _selectedAccountId!,
          type: _selectedType,
          amount: amountCents,
          currency: 'USD',
          frequency: _selectedFrequency,
          startDate: _startDate,
          envelopeId: _selectedEnvelopeId,
          payee: _payeeController.text.trim(),
          notes: _notesController.text.trim(),
          customInterval: _selectedFrequency == 'custom'
              ? int.tryParse(_customIntervalController.text)
              : null,
          customUnit: _selectedFrequency == 'custom' ? _customUnit : null,
          endDate: _endDate,
          autoPost: _autoPost,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } on TransactionException catch (e) {
      if (mounted) {
        showAppSnackBar(context, SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  static String _localizedUnit(String unit, AppLocalizations l10n) {
    return switch (unit) {
      'days' => l10n.recurringCustomUnitDays,
      'weeks' => l10n.recurringCustomUnitWeeks,
      'months' => l10n.recurringCustomUnitMonths,
      _ => unit,
    };
  }
}
