import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page for creating an account-to-account transfer.
///
/// Creates two linked transactions with a shared transfer pair ID.
class TransferFormPage extends StatefulWidget {
  const TransferFormPage({super.key});

  @override
  State<TransferFormPage> createState() => _TransferFormPageState();
}

class _TransferFormPageState extends State<TransferFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late DateTime _selectedDate;
  String? _fromAccountId;
  String? _toAccountId;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _selectedDate = DateTime.now();
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<TransferFormCubit, TransferFormState>(
      listener: (context, state) {
        if (state.status == TransferFormStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == TransferFormStatus.failure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.transactionsTransferTitle),
        ),
        body: BlocBuilder<TransferFormCubit, TransferFormState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status || prev.accounts != curr.accounts,
          builder: (context, state) {
            if (state.status == TransferFormStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final accounts = state.accounts;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // From account
                      if (accounts.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: _fromAccountId,
                          decoration: InputDecoration(
                            labelText: l10n.transactionsTransferFrom,
                            prefixIcon: const Icon(Icons.logout_outlined),
                          ),
                          items: accounts.map((a) {
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
                      if (accounts.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: _toAccountId,
                          decoration: InputDecoration(
                            labelText: l10n.transactionsTransferTo,
                            prefixIcon: const Icon(Icons.login_outlined),
                          ),
                          items: accounts.map((a) {
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
                      BlocBuilder<TransferFormCubit, TransferFormState>(
                        buildWhen: (prev, curr) =>
                            prev.status != curr.status,
                        builder: (context, submitState) {
                          final isSubmitting = submitState.status ==
                              TransferFormStatus.submitting;
                          return FilledButton(
                            onPressed: isSubmitting ? null : _submit,
                            child: isSubmitting
                                ? const SizedBox.square(
                                    dimension: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(l10n.transactionsTransferButton),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
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

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amountCents = parseCents(_amountController.text) ?? 0;

    context.read<TransferFormCubit>().submit(
      fromAccountId: _fromAccountId!,
      toAccountId: _toAccountId!,
      amountCents: amountCents,
      date: _selectedDate,
    );
  }
}
