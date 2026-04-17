import 'dart:async';

import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/recurring/widgets/frequency_label.dart';
import 'package:envelope/shared/widgets/app_option_picker.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Page for adding or editing a bill reminder.
class BillReminderFormPage extends StatefulWidget {
  const BillReminderFormPage({
    required this.transactionRepository,
    required this.envelopeRepository,
    required this.budgetId,
    this.reminder,
    super.key,
  });

  final TransactionRepository transactionRepository;
  final EnvelopeRepository envelopeRepository;
  final String budgetId;
  final BillReminder? reminder;

  @override
  State<BillReminderFormPage> createState() => _BillReminderFormPageState();
}

class _BillReminderFormPageState extends State<BillReminderFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedFrequency;
  late final TextEditingController _nameController;
  late final TextEditingController _amountController;
  late final TextEditingController _dueDayController;
  late final TextEditingController _reminderDaysController;
  String? _selectedEnvelopeId;
  bool _isSubmitting = false;

  List<Envelope> _envelopes = [];

  bool get _isEditing => widget.reminder != null;

  static const _frequencies = [
    'monthly',
    'yearly',
    'weekly',
    'bi-weekly',
    'daily',
  ];

  @override
  void initState() {
    super.initState();
    final reminder = widget.reminder;
    _selectedFrequency = reminder?.frequency ?? 'monthly';
    _nameController = TextEditingController(text: reminder?.name ?? '');
    _amountController = TextEditingController(
      text: reminder != null
          ? (reminder.estimatedAmount / 100).toStringAsFixed(2)
          : '',
    );
    _dueDayController = TextEditingController(
      text: reminder?.dueDay.toString() ?? '',
    );
    _reminderDaysController = TextEditingController(
      text: (reminder?.reminderDaysBefore ?? 3).toString(),
    );
    _selectedEnvelopeId = reminder?.envelopeId;

    unawaited(_loadData());
  }

  Future<void> _loadData() async {
    try {
      final envelopes = await widget.envelopeRepository
          .watchEnvelopes(widget.budgetId)
          .first;

      if (!mounted) return;

      setState(() {
        _envelopes = envelopes;
      });
    } on Exception {
      // Keep current state.
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _dueDayController.dispose();
    _reminderDaysController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing ? l10n.recurringEditBill : l10n.recurringAddBill,
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
                // Bill name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: l10n.recurringBillNameLabel,
                    prefixIcon: const Icon(Icons.receipt_outlined),
                  ),
                  textInputAction: TextInputAction.next,
                  textCapitalization: TextCapitalization.words,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.recurringBillNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Estimated amount
                TextFormField(
                  controller: _amountController,
                  decoration: InputDecoration(
                    labelText: l10n.recurringEstimatedAmountLabel,
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
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.transactionsAmountRequired;
                    }
                    final amount = double.tryParse(value);
                    if (amount == null || amount <= 0) {
                      return l10n.transactionsAmountRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Due day
                TextFormField(
                  controller: _dueDayController,
                  decoration: InputDecoration(
                    labelText: l10n.recurringDueDayLabel,
                    prefixIcon: const Icon(Icons.calendar_today),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    final day = int.tryParse(value ?? '');
                    if (day == null || day < 1 || day > 31) {
                      return l10n.recurringDueDayRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Frequency picker
                AppOptionPicker<String>(
                  options: _frequencies,
                  value: _selectedFrequency,
                  onChanged: (f) =>
                      setState(() => _selectedFrequency = f),
                  labelText: l10n.recurringFrequencyLabel,
                  icon: Icons.repeat,
                  itemLabel: (f) => localizedFrequency(f, l10n),
                ),
                const SizedBox(height: 16),

                // Envelope picker
                if (_envelopes.isNotEmpty)
                  AppOptionPicker<Envelope>(
                    options: _envelopes,
                    value: _envelopes
                        .where((e) => e.id == _selectedEnvelopeId)
                        .firstOrNull,
                    onChanged: (e) =>
                        setState(() => _selectedEnvelopeId = e.id),
                    labelText: l10n.transactionsEnvelopeLabel,
                    icon: Icons.mail_outlined,
                    itemLabel: (e) => e.name,
                  ),
                const SizedBox(height: 16),

                // Reminder days before
                TextFormField(
                  controller: _reminderDaysController,
                  decoration: InputDecoration(
                    labelText: l10n.recurringReminderDaysLabel,
                    prefixIcon: const Icon(Icons.notifications_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                  ],
                  textInputAction: TextInputAction.done,
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

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      final amountCents =
          ((double.tryParse(_amountController.text) ?? 0) * 100).round();
      final dueDay = int.tryParse(_dueDayController.text) ?? 1;
      final reminderDays = int.tryParse(_reminderDaysController.text) ?? 3;

      if (_isEditing) {
        final updated = widget.reminder!.copyWith(
          name: _nameController.text.trim(),
          estimatedAmount: amountCents,
          dueDay: dueDay,
          frequency: _selectedFrequency,
          envelopeId: _selectedEnvelopeId,
          reminderDaysBefore: reminderDays,
        );
        await widget.transactionRepository.updateBillReminder(updated);
      } else {
        await widget.transactionRepository.createBillReminder(
          budgetId: widget.budgetId,
          name: _nameController.text.trim(),
          estimatedAmount: amountCents,
          dueDay: dueDay,
          frequency: _selectedFrequency,
          envelopeId: _selectedEnvelopeId,
          reminderDaysBefore: reminderDays,
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

}
