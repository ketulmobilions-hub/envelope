import 'dart:async';

import 'package:envelope/accounts/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/app_option_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsStep extends StatelessWidget {
  const AccountsStep({super.key});

  static const _accountTypes = [
    'checking',
    'savings',
    'credit_card',
    'cash',
    'investment',
    'other',
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.onboardingAccountsTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(l10n.onboardingAccountsDescription),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.builder(
                  itemCount: state.accounts.length,
                  itemBuilder: (context, index) {
                    final account = state.accounts[index];
                    final balance = account.startingBalance
                        .abs()
                        .toStringAsFixed(2);
                    final accountSymbol = supportedCurrencies
                        .firstWhere(
                          (c) => c.code == account.currency,
                          orElse: () => supportedCurrencies.first,
                        )
                        .symbol;
                    return Card(
                      child: ListTile(
                        title: Text(account.name),
                        subtitle: Text(
                          '${_localizedOnboardingType(l10n, account.type)}'
                          ' • ${account.currency}'
                          ' • $accountSymbol$balance'
                          '${account.isOnBudget ? '' : ' • '
                                    '${l10n.accountsOffBudgetIndicator}'}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline),
                          onPressed: () => context
                              .read<OnboardingCubit>()
                              .removeAccount(index),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(l10n.onboardingAddAccount),
                  onPressed: () => _showAddAccountSheet(context),
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        );
      },
    );
  }

  void _showAddAccountSheet(BuildContext context) {
    final cubit = context.read<OnboardingCubit>();
    unawaited(
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (sheetContext) => _AddAccountSheet(
          accountTypes: _accountTypes,
          baseCurrency: cubit.state.baseCurrency,
          onAdd: cubit.addAccount,
        ),
      ),
    );
  }
}

String _localizedOnboardingType(AppLocalizations l10n, String type) {
  return switch (type) {
    'checking' => l10n.onboardingAccountTypeChecking,
    'savings' => l10n.onboardingAccountTypeSavings,
    'credit_card' => l10n.onboardingAccountTypeCreditCard,
    'cash' => l10n.onboardingAccountTypeCash,
    'investment' => l10n.onboardingAccountTypeInvestment,
    _ => l10n.onboardingAccountTypeOther,
  };
}

class _AddAccountSheet extends StatefulWidget {
  const _AddAccountSheet({
    required this.accountTypes,
    required this.baseCurrency,
    required this.onAdd,
  });

  final List<String> accountTypes;
  final String baseCurrency;
  final void Function(OnboardingAccount) onAdd;

  @override
  State<_AddAccountSheet> createState() => _AddAccountSheetState();
}

class _AddAccountSheetState extends State<_AddAccountSheet> {
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late final TextEditingController _creditLimitController;
  late String _selectedType;
  late bool _isOnBudget;
  String? _balanceError;
  String? _creditLimitError;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _balanceController = TextEditingController(text: '0');
    _creditLimitController = TextEditingController();
    _selectedType = widget.accountTypes.first;
    _isOnBudget = defaultIsOnBudget(_selectedType);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _creditLimitController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = context.l10n;
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    final maxAmountLabel = '${supportedCurrencies.firstWhere(
      (c) => c.code == widget.baseCurrency,
      orElse: () => supportedCurrencies.first,
    ).symbol}999,999,999.99';

    var startingBalance = double.tryParse(_balanceController.text) ?? 0;
    if (startingBalance.abs() > maxDollarAmount) {
      setState(
        () => _balanceError = l10n.accountsBalanceTooLarge(maxAmountLabel),
      );
      return;
    }
    if (isCreditCard(_selectedType) && startingBalance > 0) {
      startingBalance = -startingBalance;
    }

    int? creditLimitCents;
    if (isCreditCard(_selectedType) &&
        _creditLimitController.text.trim().isNotEmpty) {
      final parsed = parseCents(_creditLimitController.text);
      if (parsed == null || parsed < 0) {
        setState(
          () => _creditLimitError = l10n.accountsCreditLimitTooLarge(
            maxAmountLabel,
          ),
        );
        return;
      }
      creditLimitCents = parsed;
    }

    widget.onAdd(
      OnboardingAccount(
        name: name,
        type: _selectedType,
        currency: widget.baseCurrency,
        startingBalance: startingBalance,
        isOnBudget: _isOnBudget,
        creditLimitCents: creditLimitCents,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final isCC = isCreditCard(_selectedType);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        24,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.onboardingAddAccount,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: l10n.onboardingAccountName,
            ),
            textCapitalization: TextCapitalization.words,
          ),
          const SizedBox(height: 12),
          AppOptionPicker<String>(
            options: widget.accountTypes,
            value: _selectedType,
            onChanged: (type) => setState(() {
              _selectedType = type;
              _isOnBudget = defaultIsOnBudget(type);
            }),
            labelText: l10n.onboardingAccountType,
            icon: Icons.category_outlined,
            itemLabel: (type) => _localizedOnboardingType(l10n, type),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _balanceController,
            decoration: InputDecoration(
              labelText: isCC
                  ? l10n.accountsAmountOwedLabel
                  : l10n.onboardingStartingBalance,
              prefixText: symbol,
              errorText: _balanceError,
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                isCC ? RegExp(r'^\d*\.?\d{0,2}') : RegExp(r'^\-?\d*\.?\d{0,2}'),
              ),
            ],
            onTap: () {
              if (_balanceController.text == '0') {
                _balanceController.clear();
              }
            },
            onChanged: (_) {
              if (_balanceError != null) {
                setState(() => _balanceError = null);
              }
            },
          ),
          if (isCC) ...[
            const SizedBox(height: 12),
            TextField(
              controller: _creditLimitController,
              decoration: InputDecoration(
                labelText: l10n.accountsCreditLimitLabel,
                prefixText: symbol,
                errorText: _creditLimitError,
              ),
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
              ],
              onChanged: (_) {
                if (_creditLimitError != null) {
                  setState(() => _creditLimitError = null);
                }
              },
            ),
          ],
          const SizedBox(height: 12),
          SwitchListTile(
            title: Text(l10n.accountsOnBudgetLabel),
            subtitle: Text(l10n.accountsOnBudgetDescription),
            value: _isOnBudget,
            onChanged: (value) => setState(() => _isOnBudget = value),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _submit,
            child: Text(l10n.onboardingAddAccount),
          ),
        ],
      ),
    );
  }
}
