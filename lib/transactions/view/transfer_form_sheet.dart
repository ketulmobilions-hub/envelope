import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/app_option_picker.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/widgets/transaction_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Opens the modal bottom-sheet transfer form for moving funds between
/// accounts. Returns `true` on success, `null` on dismiss.
Future<bool?> showTransferFormSheet(
  BuildContext context, {
  required String budgetId,
  required String userId,
  String? budgetPeriodId,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetCtx) => BlocProvider(
      create: (ctx) => TransferFormCubit(
        transactionRepository: ctx.read<TransactionRepository>(),
        accountRepository: ctx.read<AccountRepository>(),
        budgetId: budgetId,
        userId: userId,
        budgetPeriodId: budgetPeriodId,
      ),
      child: const TransferFormSheet(),
    ),
  );
}

/// Compact bottom-sheet form for account-to-account transfers.
class TransferFormSheet extends StatefulWidget {
  const TransferFormSheet({super.key});

  @override
  State<TransferFormSheet> createState() => _TransferFormSheetState();
}

class _TransferFormSheetState extends State<TransferFormSheet> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _amountFocus = FocusNode();
  late DateTime _selectedDate;
  String? _fromAccountId;
  String? _toAccountId;

  @override
  void initState() {
    super.initState();
    _selectedDate = context.read<AppClock>().now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _amountFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_fromAccountId == null || _toAccountId == null) return;
    if (_fromAccountId == _toAccountId) {
      showAppSnackBar(
        context,
        SnackBar(
          content: Text(context.l10n.transactionsTransferSameAccountError),
        ),
      );
      return;
    }
    final amountCents = parseCents(_amountController.text) ?? 0;
    unawaited(
      context.read<TransferFormCubit>().submit(
        fromAccountId: _fromAccountId!,
        toAccountId: _toAccountId!,
        amountCents: amountCents,
        date: _selectedDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return BlocConsumer<TransferFormCubit, TransferFormState>(
      listener: (context, state) {
        if (state.status == TransferFormStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == TransferFormStatus.failure &&
            state.errorMessage != null) {
          showAppSnackBar(
            context,
            SnackBar(content: Text(state.errorMessage!)),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state.status == TransferFormStatus.loading;
        final isSubmitting = state.status == TransferFormStatus.submitting;
        final accounts = state.accounts;

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Theme.of(context).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.transactionsTransferTitle,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _amountController,
                    focusNode: _amountFocus,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d*\.?\d{0,2}'),
                      ),
                    ],
                    decoration: InputDecoration(
                      hintText: '${symbol}0.00',
                      hintStyle: Theme.of(context).textTheme.displaySmall
                          ?.copyWith(
                            color: Theme.of(context).colorScheme.outline,
                          ),
                      border: InputBorder.none,
                    ),
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
                  const SizedBox(height: 12),
                  AppOptionPicker<Account>(
                    options: accounts,
                    value: accounts
                        .where((a) => a.id == _fromAccountId)
                        .firstOrNull,
                    onChanged: (a) => setState(() => _fromAccountId = a.id),
                    labelText: l10n.transactionsTransferFrom,
                    icon: Icons.logout_outlined,
                    itemLabel: (a) => a.name,
                  ),
                  const SizedBox(height: 12),
                  AppOptionPicker<Account>(
                    options: accounts,
                    value: accounts
                        .where((a) => a.id == _toAccountId)
                        .firstOrNull,
                    onChanged: (a) => setState(() => _toAccountId = a.id),
                    labelText: l10n.transactionsTransferTo,
                    icon: Icons.login_outlined,
                    itemLabel: (a) => a.name,
                  ),
                  const SizedBox(height: 12),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.calendar_today),
                    title: Text(formatTransactionDate(_selectedDate)),
                    onTap: _pickDate,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: (isSubmitting || isLoading) ? null : _submit,
                      child: (isSubmitting || isLoading)
                          ? const SizedBox.square(
                              dimension: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : Text(l10n.transactionsTransferButton),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
