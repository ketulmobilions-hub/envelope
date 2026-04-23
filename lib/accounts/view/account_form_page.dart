import 'package:account_repository/account_repository.dart';
import 'package:envelope/accounts/cubit/cubit.dart';
import 'package:envelope/accounts/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/app_option_picker.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page for adding or editing an account.
///
/// Pass [account] to edit an existing account, or leave it `null` to create.
class AccountFormPage extends StatefulWidget {
  const AccountFormPage({
    this.account,
    super.key,
  });

  final Account? account;

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _creditLimitController;
  late String _selectedType;
  late String _selectedCurrency;
  late bool _isOnBudget;

  bool get _isEditing => widget.account != null;

  static const _accountTypes = [
    'checking',
    'savings',
    'credit_card',
    'cash',
    'investment',
    'other',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.account?.name ?? '');
    _balanceController = TextEditingController(
      text: widget.account != null
          ? (widget.account!.startingBalance.abs() / 100).toStringAsFixed(2)
          : '',
    );
    _creditLimitController = TextEditingController();
    _selectedType = widget.account?.type ?? _accountTypes.first;
    _selectedCurrency = widget.account?.currency ?? 'USD';
    _isOnBudget = widget.account?.isOnBudget ??
        defaultIsOnBudget(_selectedType);

    if (_isEditing && isCreditCard(_selectedType)) {
      context.read<AccountFormCubit>().loadExistingCreditLimit();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);

    return BlocListener<AccountFormCubit, AccountFormState>(
      listener: (context, state) {
        if (state.status == AccountFormStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == AccountFormStatus.failure) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                state.errorMessage ?? l10n.accountsErrorUpdateFailed,
              ),
            ),
          );
        }
        if (state.existingCreditLimitCents != null &&
            _creditLimitController.text.isEmpty) {
          _creditLimitController.text =
              (state.existingCreditLimitCents! / 100).toStringAsFixed(2);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? l10n.accountsEditAccount : l10n.accountsAddAccount,
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
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.accountsNameLabel,
                      prefixIcon: const Icon(Icons.account_balance_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.accountsNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  AppOptionPicker<String>(
                    options: _accountTypes,
                    value: _selectedType,
                    onChanged: (type) => setState(() {
                      _selectedType = type;
                      if (!_isEditing) {
                        _isOnBudget = defaultIsOnBudget(type);
                      }
                    }),
                    labelText: l10n.accountsTypeLabel,
                    icon: Icons.category_outlined,
                    itemLabel: (type) => _typeDisplayName(type, l10n),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _balanceController,
                    decoration: InputDecoration(
                      labelText: isCreditCard(_selectedType)
                          ? l10n.accountsAmountOwedLabel
                          : l10n.accountsStartingBalanceLabel,
                      prefixText: symbol,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                        isCreditCard(_selectedType)
                            ? RegExp(r'^\d*\.?\d{0,2}')
                            : RegExp(r'^\-?\d*\.?\d{0,2}'),
                      ),
                    ],
                    textInputAction: TextInputAction.done,
                    validator: (value) {
                      final parsed =
                          double.tryParse(value?.trim() ?? '');
                      if (parsed != null &&
                          parsed.abs() > maxDollarAmount) {
                        return l10n.accountsBalanceTooLarge;
                      }
                      return null;
                    },
                  ),
                  if (isCreditCard(_selectedType)) ...[
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _creditLimitController,
                      decoration: InputDecoration(
                        labelText: l10n.accountsCreditLimitLabel,
                        prefixText: symbol,
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return null;
                        final parsed = double.tryParse(value.trim());
                        if (parsed != null && parsed > maxDollarAmount) {
                          return l10n.accountsBalanceTooLarge;
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: Text(l10n.accountsOnBudgetLabel),
                    subtitle: Text(l10n.accountsOnBudgetDescription),
                    value: _isOnBudget,
                    onChanged: (value) => setState(() => _isOnBudget = value),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<AccountFormCubit, AccountFormState>(
                    buildWhen: (prev, curr) => prev.status != curr.status,
                    builder: (context, state) {
                      final isSubmitting =
                          state.status == AccountFormStatus.submitting;
                      return FilledButton(
                        onPressed: isSubmitting ? null : _submit,
                        child: isSubmitting
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isEditing
                                    ? l10n.accountsSaveButton
                                    : l10n.accountsCreateButton,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    var balanceCents = parseCents(_balanceController.text) ?? 0;
    if (isCreditCard(_selectedType) && balanceCents > 0) {
      balanceCents = -balanceCents;
    }

    int? creditLimitCents;
    if (isCreditCard(_selectedType) &&
        _creditLimitController.text.trim().isNotEmpty) {
      creditLimitCents = parseCents(_creditLimitController.text);
    }

    context.read<AccountFormCubit>().submit(
      name: _nameController.text.trim(),
      type: _selectedType,
      balanceCents: balanceCents,
      currency: _selectedCurrency,
      isOnBudget: _isOnBudget,
      creditLimitCents: creditLimitCents,
    );
  }

  String _typeDisplayName(String type, AppLocalizations l10n) =>
      localizedAccountType(type, l10n);
}
