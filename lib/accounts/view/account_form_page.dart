import 'package:account_repository/account_repository.dart';
import 'package:envelope/accounts/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Page for adding or editing an account.
///
/// Pass [account] to edit an existing account, or leave it `null` to create.
class AccountFormPage extends StatefulWidget {
  const AccountFormPage({
    required this.accountRepository,
    required this.budgetId,
    this.account,
    super.key,
  });

  final AccountRepository accountRepository;
  final String budgetId;
  final Account? account;

  @override
  State<AccountFormPage> createState() => _AccountFormPageState();
}

class _AccountFormPageState extends State<AccountFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _balanceController;
  late String _selectedType;
  late String _selectedCurrency;
  bool _isSubmitting = false;

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
          ? (widget.account!.startingBalance / 100).toStringAsFixed(2)
          : '',
    );
    _selectedType = widget.account?.type ?? _accountTypes.first;
    _selectedCurrency = widget.account?.currency ?? 'USD';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
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
                DropdownButtonFormField<String>(
                  initialValue: _selectedType,
                  decoration: InputDecoration(
                    labelText: l10n.accountsTypeLabel,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  items: _accountTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(_typeDisplayName(type, l10n)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedType = value);
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _balanceController,
                  decoration: InputDecoration(
                    labelText: l10n.accountsStartingBalanceLabel,
                    prefixIcon: const Icon(Icons.attach_money),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                      RegExp(r'^\-?\d*\.?\d{0,2}'),
                    ),
                  ],
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEditing
                              ? l10n.accountsSaveButton
                              : l10n.accountsCreateButton,
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
      final balanceCents = parseCents(_balanceController.text) ?? 0;


      if (_isEditing) {
        final updated = widget.account!.copyWith(
          name: _nameController.text.trim(),
          type: _selectedType,
          startingBalance: balanceCents,
          currency: _selectedCurrency,
          updatedAt: DateTime.now(),
        );
        await widget.accountRepository.updateAccount(updated);
      } else {
        await widget.accountRepository.createAccount(
          budgetId: widget.budgetId,
          name: _nameController.text.trim(),
          type: _selectedType,
          currency: _selectedCurrency,
          startingBalance: balanceCents,
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } on AccountException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  String _typeDisplayName(String type, AppLocalizations l10n) =>
      localizedAccountType(type, l10n);
}
