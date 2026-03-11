import 'dart:async';

import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountsStep extends StatelessWidget {
  const AccountsStep({super.key});

  static const _accountTypes = [
    'checking',
    'savings',
    'creditCard',
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
                    return Card(
                      child: ListTile(
                        title: Text(account.name),
                        subtitle: Text(
                          '${_localizedAccountType(l10n, account.type)}'
                          ' • ${account.currency}'
                          ' • ${account.startingBalance}',
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
            ],
          ),
        );
      },
    );
  }

  String _localizedAccountType(AppLocalizations l10n, String type) {
    return switch (type) {
      'checking' => l10n.onboardingAccountTypeChecking,
      'savings' => l10n.onboardingAccountTypeSavings,
      'creditCard' => l10n.onboardingAccountTypeCreditCard,
      'cash' => l10n.onboardingAccountTypeCash,
      'investment' => l10n.onboardingAccountTypeInvestment,
      _ => l10n.onboardingAccountTypeOther,
    };
  }

  void _showAddAccountSheet(BuildContext context) {
    final l10n = context.l10n;
    final cubit = context.read<OnboardingCubit>();
    final nameController = TextEditingController();
    final balanceController = TextEditingController(text: '0');
    var selectedType = _accountTypes.first;

    unawaited(showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (sheetContext, setSheetState) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                24,
                24,
                24 + MediaQuery.of(sheetContext).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.onboardingAddAccount,
                    style: Theme.of(sheetContext).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: l10n.onboardingAccountName,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedType,
                    decoration: InputDecoration(
                      labelText: l10n.onboardingAccountType,
                      border: const OutlineInputBorder(),
                    ),
                    items: _accountTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(
                          _localizedAccountTypeStatic(l10n, type),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setSheetState(() => selectedType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: balanceController,
                    decoration: InputDecoration(
                      labelText: l10n.onboardingStartingBalance,
                      border: const OutlineInputBorder(),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () {
                      final name = nameController.text.trim();
                      if (name.isEmpty) return;
                      cubit.addAccount(
                        OnboardingAccount(
                          name: name,
                          type: selectedType,
                          currency: cubit.state.baseCurrency,
                          startingBalance:
                              double.tryParse(balanceController.text) ?? 0,
                        ),
                      );
                      Navigator.of(sheetContext).pop();
                    },
                    child: Text(l10n.onboardingAddAccount),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      nameController.dispose();
      balanceController.dispose();
    }));
  }

  static String _localizedAccountTypeStatic(
    AppLocalizations l10n,
    String type,
  ) {
    return switch (type) {
      'checking' => l10n.onboardingAccountTypeChecking,
      'savings' => l10n.onboardingAccountTypeSavings,
      'creditCard' => l10n.onboardingAccountTypeCreditCard,
      'cash' => l10n.onboardingAccountTypeCash,
      'investment' => l10n.onboardingAccountTypeInvestment,
      _ => l10n.onboardingAccountTypeOther,
    };
  }
}
