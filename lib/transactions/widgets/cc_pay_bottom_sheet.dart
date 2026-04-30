import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope/transactions/cubit/transfer_form_cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

Future<void> showCCPayBottomSheet(
  BuildContext context, {
  required String ccAccountId,
  required String ccAccountName,
  required int ccDebtCents,
  required List<Account> accounts,
  required String budgetId,
  required String userId,
  required String? budgetPeriodId,
}) async {
  final transactionRepo = context.read<TransactionRepository>();
  final accountRepo = context.read<AccountRepository>();
  final envelopeRepo = context.read<EnvelopeRepository>();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => BlocProvider(
      create: (_) => TransferFormCubit(
        transactionRepository: transactionRepo,
        accountRepository: accountRepo,
        budgetId: budgetId,
        userId: userId,
        envelopeRepository: envelopeRepo,
        budgetPeriodId: budgetPeriodId,
      ),
      child: _CCPayBottomSheet(
        ccAccountId: ccAccountId,
        ccAccountName: ccAccountName,
        ccDebtCents: ccDebtCents,
        accounts: accounts,
      ),
    ),
  );
}

class _CCPayBottomSheet extends StatefulWidget {
  const _CCPayBottomSheet({
    required this.ccAccountId,
    required this.ccAccountName,
    required this.ccDebtCents,
    required this.accounts,
  });

  final String ccAccountId;
  final String ccAccountName;
  final int ccDebtCents;
  final List<Account> accounts;

  @override
  State<_CCPayBottomSheet> createState() => _CCPayBottomSheetState();
}

class _CCPayBottomSheetState extends State<_CCPayBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _dropdownKey = GlobalKey<FormFieldState<String>>();
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ccDebtCents > 0) {
      _amountController.text = (widget.ccDebtCents / 100).toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  List<Account> get _nonCCAccounts => widget.accounts
      .where((a) => !a.isArchived && !isCreditCard(a.type))
      .toList();

  void _prefillFullAmount() {
    final text = (widget.ccDebtCents / 100).toStringAsFixed(2);
    _amountController
      ..text = text
      ..selection = TextSelection(
        baseOffset: 0,
        extentOffset: text.length,
      );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final fromAccountId = _dropdownKey.currentState?.value;
    final amountCents = parseCents(_amountController.text)!;
    if (fromAccountId == null) return;
    unawaited(
      context.read<TransferFormCubit>().submit(
        fromAccountId: fromAccountId,
        toAccountId: widget.ccAccountId,
        amountCents: amountCents,
        date: context.read<AppClock>().now(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final theme = Theme.of(context);

    return BlocListener<TransferFormCubit, TransferFormState>(
      listener: (ctx, state) {
        if (state.status == TransferFormStatus.success) {
          final messenger = ScaffoldMessenger.of(ctx);
          Navigator.of(ctx).pop();
          messenger.showSnackBar(
            SnackBar(content: Text(l10n.ccPaySuccess)),
          );
        } else if (state.status == TransferFormStatus.failure) {
          ScaffoldMessenger.of(ctx).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage ?? l10n.ccPayError),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.ccPayTitle(widget.ccAccountName),
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    l10n.ccPayBalanceDue,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    formatCents(widget.ccDebtCents, symbol: symbol),
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: widget.ccDebtCents > 0
                          ? AppColors.expense
                          : theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              if (widget.ccDebtCents > 0) ...[
                const SizedBox(height: 12),
                ActionChip(
                  label: Text(
                    l10n.ccPayPayFull(
                      formatCents(widget.ccDebtCents, symbol: symbol),
                    ),
                  ),
                  onPressed: _prefillFullAmount,
                ),
              ],
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                key: _dropdownKey,
                decoration: InputDecoration(
                  labelText: l10n.ccPayFromAccount,
                  border: const OutlineInputBorder(),
                ),
                items: _nonCCAccounts
                    .map(
                      (a) => DropdownMenuItem(
                        value: a.id,
                        child: Text(a.name),
                      ),
                    )
                    .toList(),
                validator: (v) => v == null ? l10n.ccPayFromRequired : null,
                onChanged: (_) {},
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: l10n.ccPayAmount,
                  prefixText: symbol,
                  border: const OutlineInputBorder(),
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                validator: (v) {
                  final cents = parseCents(v ?? '');
                  if (cents == null || cents <= 0) {
                    return l10n.ccPayAmountRequired;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              BlocBuilder<TransferFormCubit, TransferFormState>(
                builder: (ctx, state) {
                  final isSubmitting =
                      state.status == TransferFormStatus.submitting;
                  return SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: isSubmitting ? null : () => _submit(ctx),
                      child: isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.ccPayConfirm),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
