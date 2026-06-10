import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/data/currencies.dart';
import 'package:envelope/shared/feature_flags.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/app_option_picker.dart';
import 'package:envelope/shared/widgets/currency_picker_sheet.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transaction_repository/transaction_repository.dart';

const _kLastAccountKey = 'quick_add_last_account_id';
const _kLastEnvelopeKey = 'quick_add_last_envelope_id';

const _kFrequencies = [
  'daily',
  'weekly',
  'bi-weekly',
  'monthly',
  'yearly',
  'custom',
];

/// Opens the modal bottom-sheet transaction form. Pass [transaction] to edit
/// an existing one; omit it to create a new transaction.
///
/// Returns `true` if a transaction was created/updated, `null` if dismissed.
Future<bool?> showTransactionFormSheet(
  BuildContext context, {
  required String budgetId,
  required String userId,
  String? budgetPeriodId,
  Transaction? transaction,
  String? initialType,
  TransactionTemplate? initialTemplate,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    // Present above the shell so the sheet covers the app's add-transaction
    // FAB (and nav bar) instead of leaving them floating over the form.
    useRootNavigator: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetCtx) => BlocProvider(
      create: (ctx) => TransactionFormCubit(
        transactionRepository: ctx.read<TransactionRepository>(),
        accountRepository: ctx.read<AccountRepository>(),
        envelopeRepository: ctx.read<EnvelopeRepository>(),
        budgetRepository: ctx.read<BudgetRepository>(),
        budgetId: budgetId,
        budgetPeriodId: budgetPeriodId,
        userId: userId,
        transaction: transaction,
        now: ctx.read<AppClock>().now,
      ),
      child: QuickAddTransactionSheet(
        transaction: transaction,
        initialType: initialType,
        initialTemplate: initialTemplate,
      ),
    ),
  );
}

/// Bottom-sheet form for creating or editing a transaction.
///
/// Caller must provide [TransactionFormCubit] via [BlocProvider]. Cubit
/// receives an optional [Transaction] for edit mode.
class QuickAddTransactionSheet extends StatefulWidget {
  const QuickAddTransactionSheet({
    this.transaction,
    this.initialType,
    this.initialTemplate,
    super.key,
  });

  final Transaction? transaction;
  final String? initialType;
  final TransactionTemplate? initialTemplate;

  @override
  State<QuickAddTransactionSheet> createState() =>
      _QuickAddTransactionSheetState();
}

class _QuickAddTransactionSheetState extends State<QuickAddTransactionSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  final _amountFocus = FocusNode();
  late final TextEditingController _payeeController;
  late final TextEditingController _notesController;
  late final TextEditingController _fxRateController;
  final _templateNameController = TextEditingController();
  final _stopwatch = Stopwatch();

  late String _type;
  late DateTime _date;
  String? _accountId;
  String? _envelopeId;
  String? _currency;
  bool _currencyManuallySet = false;
  bool _isRecurring = false;
  bool _moreExpanded = false;
  bool _defaultsApplied = false;
  bool _tagIdsInitialized = false;
  bool _saveAsTemplate = false;
  List<String> _selectedTagIds = [];
  String? _amountError;
  String? _accountError;
  String? _envelopeError;
  String? _templateNameError;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _type = txn?.type ?? widget.initialType ?? 'expense';
    _date = txn?.date ?? context.read<AppClock>().now();
    _amountController = TextEditingController(
      text: txn != null ? (txn.amount / 100).toStringAsFixed(2) : '',
    );
    _payeeController = TextEditingController(text: txn?.payee ?? '');
    _notesController = TextEditingController(text: txn?.notes ?? '');
    _fxRateController = TextEditingController(
      text: txn != null ? txn.exchangeRate.toString() : '1.0',
    );
    _accountId = txn?.accountId;
    _envelopeId = txn?.envelopeId;
    _currency = txn?.currency;
    _currencyManuallySet = txn != null;
    final initialTemplate = widget.initialTemplate;
    if (txn == null && initialTemplate != null) {
      _type = initialTemplate.type;
      _accountId = initialTemplate.accountId ?? _accountId;
      _envelopeId = initialTemplate.type == 'expense'
          ? initialTemplate.envelopeId
          : null;
      if (initialTemplate.amountCents != null &&
          initialTemplate.amountCents! > 0) {
        _amountController.text = (initialTemplate.amountCents! / 100)
            .toStringAsFixed(2);
      }
      if (initialTemplate.payee != null) {
        _payeeController.text = initialTemplate.payee!;
      }
      if (initialTemplate.notes != null) {
        _notesController.text = initialTemplate.notes!;
      }
      if (initialTemplate.currency != null) {
        _currency = initialTemplate.currency;
        _currencyManuallySet = true;
      }
      if (initialTemplate.tagIds.isNotEmpty) {
        _selectedTagIds = List.of(initialTemplate.tagIds);
        _tagIdsInitialized = true;
      }
    }
    _stopwatch.start();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_isEditing) _amountFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _amountFocus.dispose();
    _payeeController.dispose();
    _notesController.dispose();
    _fxRateController.dispose();
    _templateNameController.dispose();
    super.dispose();
  }

  static bool _recurringChanged(
    TransactionFormState prev,
    TransactionFormState curr,
  ) =>
      prev.recurringFrequency != curr.recurringFrequency ||
      prev.recurringCustomInterval != curr.recurringCustomInterval ||
      prev.recurringCustomUnit != curr.recurringCustomUnit ||
      prev.recurringEndDate != curr.recurringEndDate ||
      prev.recurringAutoPost != curr.recurringAutoPost;

  void _applyTemplate(TransactionTemplate template) {
    setState(() {
      _type = template.type;
      _accountId = template.accountId ?? _accountId;
      _envelopeId = template.type == 'expense'
          ? (template.envelopeId ?? _envelopeId)
          : null;
      if (template.amountCents != null && template.amountCents! > 0) {
        _amountController.text = (template.amountCents! / 100).toStringAsFixed(
          2,
        );
      }
      if (template.payee != null) _payeeController.text = template.payee!;
      if (template.notes != null) _notesController.text = template.notes!;
      if (template.currency != null) {
        _currency = template.currency;
        _currencyManuallySet = true;
      }
      if (template.tagIds.isNotEmpty) {
        _selectedTagIds = List.of(template.tagIds);
      }
      _amountError = null;
    });
  }

  Future<void> _showTemplatePicker() async {
    final templates = context.read<TransactionFormCubit>().state.templates;
    final l10n = context.l10n;
    final baseCurrency =
        context.read<AuthBloc>().state.user?.baseCurrency ?? 'USD';
    final picked = await showModalBottomSheet<TransactionTemplate>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _TemplatePickerSheet(
        templates: templates,
        emptyLabel: l10n.templatesEmpty,
        title: l10n.templatesPickerTitle,
        baseCurrency: baseCurrency,
      ),
    );
    if (picked != null && mounted) {
      _applyTemplate(picked);
    }
  }

  void _applyDefaults(TransactionFormState state) {
    if (_defaultsApplied) return;
    if (state.status != TransactionFormStatus.loaded) return;
    if (!mounted) return;
    _defaultsApplied = true;
    if (_isEditing) return;
    final prefs = context.read<SharedPreferences>();
    final lastAccount = prefs.getString(_kLastAccountKey);
    final lastEnvelope = prefs.getString(_kLastEnvelopeKey);

    setState(() {
      // Recover from stale prefs: fall back to first account when the stored
      // id no longer exists.
      final eligible = state.accounts
          .where((a) => a.isOnBudget || isCreditCard(a.type))
          .toList();
      if (eligible.isNotEmpty &&
          (_accountId == null ||
              !eligible.any((a) => a.id == _accountId))) {
        final preferred = eligible
            .where((a) => a.id == lastAccount)
            .firstOrNull;
        _accountId = preferred?.id ?? eligible.first.id;
      }
      if (state.envelopes.isNotEmpty &&
          (_envelopeId == null ||
              !state.envelopes.any((e) => e.id == _envelopeId))) {
        final preferred = state.envelopes
            .where((e) => e.id == lastEnvelope)
            .firstOrNull;
        _envelopeId = preferred?.id ?? state.envelopes.first.id;
      }
    });
  }

  void _maybeInitTagIds(TransactionFormState state) {
    if (_tagIdsInitialized) return;
    if (state.status != TransactionFormStatus.loaded) return;
    if (!mounted) return;
    _tagIdsInitialized = true;
    if (state.selectedTagIds.isNotEmpty) {
      setState(() => _selectedTagIds = List.of(state.selectedTagIds));
    }
  }

  Future<void> _maybePersistTemplate() async {
    if (!_saveAsTemplate || _isEditing) return;
    final name = _templateNameController.text.trim();
    if (name.isEmpty) return;
    // Templates intentionally omit the amount (and date) — they capture the
    // reusable shape (account, envelope, payee, notes, tags), not a one-off
    // value. The amount field stays blank when the template is applied.
    await context.read<TransactionFormCubit>().saveAsTemplate(
      name: name,
      type: _type,
      accountId: _accountId,
      envelopeId: _type == 'expense' ? _envelopeId : null,
      payee: _payeeController.text.trim().isEmpty
          ? null
          : _payeeController.text.trim(),
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
      currency: _currency,
      tagIds: _selectedTagIds,
    );
  }

  Future<void> _persistDefaults() async {
    final prefs = context.read<SharedPreferences>();
    if (_accountId != null) {
      await prefs.setString(_kLastAccountKey, _accountId!);
    }
    if (_envelopeId != null && _type == 'expense') {
      await prefs.setString(_kLastEnvelopeKey, _envelopeId!);
    }
  }

  Future<void> _createTag(String name) async {
    final cubit = context.read<TransactionFormCubit>();
    await cubit.createTag(name);
    if (mounted) {
      setState(() {
        _selectedTagIds = List.of(cubit.state.selectedTagIds);
      });
    }
  }

  void _submit() {
    final l10n = context.l10n;
    final cents = parseCents(_amountController.text) ?? 0;
    final amountInvalid = cents <= 0;
    final accountMissing = _accountId == null;
    final envelopeMissing = _type == 'expense' && _envelopeId == null;
    final templateNameMissing =
        _saveAsTemplate &&
        !_isEditing &&
        _templateNameController.text.trim().isEmpty;
    if (amountInvalid ||
        accountMissing ||
        envelopeMissing ||
        templateNameMissing) {
      setState(() {
        _amountError = amountInvalid ? l10n.transactionsAmountRequired : null;
        _accountError = accountMissing
            ? l10n.transactionsAccountRequired
            : null;
        _envelopeError = envelopeMissing
            ? l10n.transactionsEnvelopeRequired
            : null;
        _templateNameError = templateNameMissing
            ? l10n.templatesNameRequired
            : null;
      });
      return;
    }
    if (!(_formKey.currentState?.validate() ?? true)) return;
    setState(() {
      _amountError = null;
      _accountError = null;
      _envelopeError = null;
      _templateNameError = null;
    });

    final baseCurrency =
        context.read<AuthBloc>().state.user?.baseCurrency ?? 'USD';
    final rate = kMultiCurrencyEnabled
        ? (double.tryParse(_fxRateController.text.trim()) ?? 1.0)
        : 1.0;
    final currencyOverride = kMultiCurrencyEnabled ? _currency : baseCurrency;

    unawaited(
      context.read<TransactionFormCubit>().submit(
        type: _type,
        accountId: _accountId!,
        amountCents: cents,
        date: _date,
        envelopeId: _type == 'expense' ? _envelopeId : null,
        payee: _payeeController.text.trim(),
        notes: _notesController.text.trim(),
        selectedTagIds: _selectedTagIds,
        isRecurring: _isRecurring,
        currencyOverride: currencyOverride,
        exchangeRate: rate,
      ),
    );
  }

  Future<void> _handleOverspend(TransactionFormState state) async {
    await _maybePersistTemplate();
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final baseCurrency =
        context.watch<AuthBloc>().state.user?.baseCurrency ?? 'USD';
    final txCurrency = _currency ?? baseCurrency;
    final symbol = currencySymbolFromCode(txCurrency);
    final baseSymbol = currencySymbolFromCode(baseCurrency);
    final isForeign = txCurrency != baseCurrency;

    return BlocConsumer<TransactionFormCubit, TransactionFormState>(
      listenWhen: (prev, curr) =>
          prev.status != curr.status || prev.tagError != curr.tagError,
      listener: (context, state) async {
        final navigator = Navigator.of(context);
        final messenger = ScaffoldMessenger.of(context);
        if (state.status == TransactionFormStatus.loaded) {
          _applyDefaults(state);
          _maybeInitTagIds(state);
        }
        if (state.status == TransactionFormStatus.success) {
          _stopwatch.stop();
          if (kDebugMode) {
            debugPrint(
              '[quick-add] saved in ${_stopwatch.elapsedMilliseconds}ms',
            );
          }
          unawaited(HapticFeedback.mediumImpact());
          await _persistDefaults();
          await _maybePersistTemplate();
          if (mounted) navigator.pop(true);
        } else if (state.status == TransactionFormStatus.successWithOverspend) {
          await _persistDefaults();
          if (mounted) await _handleOverspend(state);
        } else if (state.status == TransactionFormStatus.failure) {
          final msg = state.errorMessage ?? l10n.transactionsErrorLoadFailed;
          messenger.showSnackBar(SnackBar(content: Text(msg)));
        } else if (state.tagError != null) {
          messenger.showSnackBar(SnackBar(content: Text(state.tagError!)));
        }
      },
      builder: (context, state) {
        final isLoading = state.status == TransactionFormStatus.loading;
        final isSubmitting = state.status == TransactionFormStatus.submitting;
        final eligibleAccounts = state.accounts
            .where((a) => a.isOnBudget || isCreditCard(a.type))
            .toList();
        final selectedAccount = eligibleAccounts
            .where((a) => a.id == _accountId)
            .firstOrNull;
        final selectedEnvelope = state.envelopes
            .where((e) => e.id == _envelopeId)
            .firstOrNull;
        final showRecurringToggle = !_isEditing && _type != 'transfer';

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 12,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
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
                                _isEditing
                                    ? l10n.transactionsEditTransaction
                                    : _type == 'income'
                                    ? l10n.transactionsTypeIncome
                                    : l10n.transactionsTypeExpense,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            if (!_isEditing && state.templates.isNotEmpty)
                              TextButton.icon(
                                icon: const Icon(
                                  Icons.bookmarks_outlined,
                                  size: 18,
                                ),
                                label: Text(l10n.templatesApplyButton),
                                onPressed: _showTemplatePicker,
                              ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Symbol is a separate widget so it stays left of the
                        // amount in both LTR and RTL locales (Row layout, not
                        // bidi text ordering).
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(
                              symbol,
                              style: Theme.of(context)
                                  .textTheme
                                  .displaySmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            IntrinsicWidth(
                              child: TextField(
                                controller: _amountController,
                                focusNode: _amountFocus,
                                textAlign: TextAlign.center,
                                style: Theme.of(context)
                                    .textTheme
                                    .displaySmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                                keyboardType:
                                    const TextInputType.numberWithOptions(
                                  decimal: true,
                                ),
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d*\.?\d{0,2}'),
                                  ),
                                ],
                                decoration: InputDecoration(
                                  hintText: '0.00',
                                  hintStyle: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.outline,
                                      ),
                                  border: InputBorder.none,
                                  errorText: _amountError,
                                  isDense: true,
                                  contentPadding: EdgeInsets.zero,
                                ),
                                onChanged: (_) {
                                  if (_amountError != null) {
                                    setState(() => _amountError = null);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        AppOptionPicker<Account>(
                          options: eligibleAccounts,
                          value: selectedAccount,
                          onChanged: (a) => setState(() {
                            _accountId = a.id;
                            _accountError = null;
                            if (kMultiCurrencyEnabled &&
                                !_currencyManuallySet) {
                              _currency = a.currency;
                              _fxRateController.text = a.displayFxRate
                                  .toString();
                            }
                          }),
                          labelText: l10n.transactionsAccountLabel,
                          icon: Icons.account_balance_outlined,
                          itemLabel: (a) => a.name,
                        ),
                        if (_accountError != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4, left: 12),
                            child: Text(
                              _accountError!,
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        if (_type == 'expense') ...[
                          const SizedBox(height: 12),
                          EnvelopePicker(
                            value: selectedEnvelope,
                            onChanged: (e) => setState(() {
                              _envelopeId = e.id;
                              _envelopeError = null;
                            }),
                            hideCCPaymentsGroup: true,
                          ),
                          if (_envelopeError != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 4, left: 12),
                              child: Text(
                                _envelopeError!,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                        if (kMultiCurrencyEnabled) ...[
                          const SizedBox(height: 12),
                          _CurrencyOverrideTile(
                            code: txCurrency,
                            onChanged: (code) => setState(() {
                              _currency = code;
                              _currencyManuallySet = true;
                              if (code == baseCurrency) {
                                _fxRateController.text = '1.0';
                              }
                            }),
                          ),
                        ],
                        if (kMultiCurrencyEnabled && isForeign) ...[
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _fxRateController,
                            decoration: InputDecoration(
                              labelText: l10n.transactionsExchangeRateLabel,
                              helperText: l10n.transactionsExchangeRateHelper(
                                txCurrency,
                                baseSymbol,
                                baseCurrency,
                              ),
                              prefixIcon: const Icon(Icons.currency_exchange),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,6}'),
                              ),
                            ],
                            onChanged: (_) => setState(() {}),
                            validator: (value) {
                              final parsed = double.tryParse(
                                value?.trim() ?? '',
                              );
                              if (parsed == null || parsed <= 0) {
                                return l10n.transactionsExchangeRateInvalid;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 4),
                          Builder(
                            builder: (_) {
                              final cents =
                                  parseCents(_amountController.text) ?? 0;
                              final rateVal =
                                  double.tryParse(
                                    _fxRateController.text.trim(),
                                  ) ??
                                  1.0;
                              final base = ((cents * rateVal).round() / 100)
                                  .toStringAsFixed(2);
                              return Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  '≈ $baseSymbol$base',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              );
                            },
                          ),
                        ],
                        if (!_isEditing) ...[
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              if (_saveAsTemplate) ...[
                                Expanded(
                                  child: TextField(
                                    controller: _templateNameController,
                                    onChanged: (_) {
                                      if (_templateNameError != null) {
                                        setState(
                                          () => _templateNameError = null,
                                        );
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: l10n.templatesNameLabel,
                                      isDense: true,
                                      contentPadding:
                                          const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 6,
                                          ),
                                      errorText: _templateNameError,
                                    ),
                                    textCapitalization:
                                        TextCapitalization.words,
                                  ),
                                ),
                                const SizedBox(width: 8),
                              ],
                              GestureDetector(
                                onTap: () => setState(() {
                                  _saveAsTemplate = !_saveAsTemplate;
                                  if (!_saveAsTemplate)
                                    _templateNameError = null;
                                }),
                                child: Text(
                                  l10n.templatesSaveAs,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                              const SizedBox(width: 4),
                              SizedBox(
                                height: 24,
                                width: 24,
                                child: Checkbox(
                                  value: _saveAsTemplate,
                                  onChanged: (v) => setState(() {
                                    _saveAsTemplate = v ?? false;
                                    if (!_saveAsTemplate) {
                                      _templateNameError = null;
                                    }
                                  }),
                                  visualDensity: VisualDensity.compact,
                                  materialTapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 12),
                        BlocBuilder<TransactionFormCubit,
                            TransactionFormState>(
                          buildWhen: (prev, curr) =>
                              prev.recentPayees != curr.recentPayees,
                          builder: (context, state) {
                            return Autocomplete<String>(
                              initialValue: TextEditingValue(
                                text: _payeeController.text,
                              ),
                              optionsBuilder: (value) {
                                if (value.text.isEmpty) return const [];
                                final q = value.text.toLowerCase();
                                return state.recentPayees.where(
                                  (p) => p.toLowerCase().contains(q),
                                );
                              },
                              onSelected: (p) => _payeeController.text = p,
                              fieldViewBuilder: (
                                context,
                                controller,
                                focusNode,
                                onSubmitted,
                              ) {
                                return TextField(
                                  controller: controller,
                                  focusNode: focusNode,
                                  decoration: InputDecoration(
                                    labelText: l10n.transactionsPayeeLabel,
                                    prefixIcon: const Icon(
                                      Icons.person_outline,
                                    ),
                                  ),
                                  textCapitalization:
                                      TextCapitalization.words,
                                  onChanged: (v) =>
                                      _payeeController.text = v,
                                  onEditingComplete: onSubmitted,
                                );
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            onPressed: () =>
                                setState(() => _moreExpanded = !_moreExpanded),
                            icon: Icon(
                              _moreExpanded
                                  ? Icons.expand_less
                                  : Icons.expand_more,
                            ),
                            label: Text(
                              _moreExpanded
                                  ? l10n.transactionsHideOptions
                                  : l10n.transactionsMoreOptions,
                            ),
                          ),
                        ),
                        AnimatedSize(
                          duration: const Duration(milliseconds: 180),
                          curve: Curves.easeOutCubic,
                          child: _moreExpanded
                              ? Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    HorizontalDatePicker(
                                      selectedDate: _date,
                                      onDateSelected: (d) =>
                                          setState(() => _date = d),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _notesController,
                                      decoration: InputDecoration(
                                        labelText: l10n.transactionsNotesLabel,
                                        isDense: true,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                              horizontal: 12,
                                              vertical: 8,
                                            ),
                                        prefixIcon: const Icon(
                                          Icons.notes_outlined,
                                        ),
                                      ),
                                      minLines: 1,
                                      maxLines: 3,
                                    ),
                                    const SizedBox(height: 12),
                                    TagPicker(
                                      availableTags: state.tags,
                                      selectedTagIds: _selectedTagIds,
                                      onChanged: (ids) => setState(
                                        () => _selectedTagIds = ids,
                                      ),
                                      onCreateTag: _createTag,
                                    ),
                                    if (showRecurringToggle) ...[
                                      const SizedBox(height: 4),
                                      SwitchListTile(
                                        contentPadding: EdgeInsets.zero,
                                        title: Text(
                                          l10n.recurringMakeRecurringLabel,
                                        ),
                                        value: _isRecurring,
                                        onChanged: (value) {
                                          setState(() => _isRecurring = value);
                                          context
                                              .read<TransactionFormCubit>()
                                              .toggleRecurring(value: value);
                                        },
                                      ),
                                      AnimatedSize(
                                        duration: const Duration(
                                          milliseconds: 200,
                                        ),
                                        curve: Curves.easeInOut,
                                        child: _isRecurring
                                            ? BlocBuilder<
                                                TransactionFormCubit,
                                                TransactionFormState
                                              >(
                                                buildWhen: _recurringChanged,
                                                builder:
                                                    (context, recurringState) =>
                                                        _RecurringSection(
                                                          state: recurringState,
                                                          selectedDate: _date,
                                                          isRecurring:
                                                              _isRecurring,
                                                        ),
                                              )
                                            : const SizedBox.shrink(),
                                      ),
                                    ],
                                    const SizedBox(height: 4),
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ActionChip(
                      avatar: const Icon(Icons.calendar_today, size: 16),
                      label: Text(_dateChipLabel(context)),
                      onPressed: () => _pickTransactionDate(context),
                    ),
                    const Spacer(),
                    FloatingActionButton(
                    // No hero animation: a page FAB may sit behind this
                    // modal sheet and share the default tag.
                    heroTag: null,
                    tooltip: _isEditing
                        ? l10n.transactionsSaveButton
                        : l10n.transactionsCreateButton,
                    onPressed: (isSubmitting || isLoading) ? null : _submit,
                    child: (isSubmitting || isLoading)
                        ? const SizedBox.square(
                            dimension: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.check),
                  ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _dateChipLabel(BuildContext context) {
    final now = context.read<AppClock>().now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = DateTime(_date.year, _date.month, _date.day);
    final diff = selected.difference(today).inDays;
    if (diff == 0) return context.l10n.transactionsDateToday;
    if (diff == -1) return context.l10n.transactionsDateYesterday;
    return DateFormat('MMM d').format(_date);
  }

  Future<void> _pickTransactionDate(BuildContext context) async {
    final now = context.read<AppClock>().now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(now.year - 10),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && mounted) {
      setState(() => _date = picked);
    }
  }
}

// ---------------------------------------------------------------------------
// Currency override tile
// ---------------------------------------------------------------------------

class _CurrencyOverrideTile extends StatelessWidget {
  const _CurrencyOverrideTile({
    required this.code,
    required this.onChanged,
  });

  final String code;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final selected = supportedCurrencies.firstWhere(
      (c) => c.code == code,
      orElse: () => supportedCurrencies.first,
    );
    return InkWell(
      onTap: () async {
        final picked = await showModalBottomSheet<String>(
          context: context,
          isScrollControlled: true,
          builder: (_) => CurrencyPickerSheet(initialCode: code),
        );
        if (picked != null) onChanged(picked);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Currency',
          prefixIcon: Icon(Icons.attach_money_outlined),
          suffixIcon: Icon(Icons.arrow_drop_down),
          isDense: true,
        ),
        child: Text(
          '${selected.symbol} ${selected.code} - ${selected.name}',
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Recurring section
// ---------------------------------------------------------------------------

class _RecurringSection extends StatelessWidget {
  const _RecurringSection({
    required this.state,
    required this.selectedDate,
    required this.isRecurring,
  });

  final TransactionFormState state;
  final DateTime selectedDate;
  final bool isRecurring;

  String _localizedFrequency(String frequency, AppLocalizations l10n) {
    return switch (frequency) {
      'daily' => l10n.recurringFrequencyDaily,
      'weekly' => l10n.recurringFrequencyWeekly,
      'bi-weekly' => l10n.recurringFrequencyBiWeekly,
      'monthly' => l10n.recurringFrequencyMonthly,
      'yearly' => l10n.recurringFrequencyYearly,
      _ => l10n.recurringFrequencyCustom,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppOptionPicker<String>(
            options: _kFrequencies,
            value: state.recurringFrequency,
            onChanged: (f) =>
                context.read<TransactionFormCubit>().setRecurringFrequency(f),
            labelText: l10n.recurringFrequencyLabel,
            icon: Icons.repeat,
            itemLabel: (f) => _localizedFrequency(f, l10n),
          ),
          if (state.recurringFrequency == 'custom') ...[
            const SizedBox(height: 16),
            _RecurringCustomIntervalRow(
              state: state,
              isRecurring: isRecurring,
            ),
          ],
          const SizedBox(height: 16),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.event_outlined),
            title: Text(l10n.recurringEndDateLabel),
            subtitle: state.recurringEndDate != null
                ? Text(
                    MaterialLocalizations.of(context).formatCompactDate(
                      state.recurringEndDate!,
                    ),
                  )
                : null,
            onTap: () => _pickEndDate(context, state, selectedDate),
            trailing: state.recurringEndDate != null
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () => context
                        .read<TransactionFormCubit>()
                        .setRecurringEndDate(null),
                  )
                : null,
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.recurringAutoPostLabel),
            subtitle: Text(l10n.recurringAutoPostSubtitle),
            value: state.recurringAutoPost,
            onChanged: (value) => context
                .read<TransactionFormCubit>()
                .toggleRecurringAutoPost(value: value),
          ),
        ],
      ),
    );
  }

  Future<void> _pickEndDate(
    BuildContext context,
    TransactionFormState state,
    DateTime startDate,
  ) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          state.recurringEndDate ?? startDate.add(const Duration(days: 30)),
      firstDate: startDate,
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
    );
    if (picked != null && context.mounted) {
      context.read<TransactionFormCubit>().setRecurringEndDate(picked);
    }
  }
}

class _RecurringCustomIntervalRow extends StatefulWidget {
  const _RecurringCustomIntervalRow({
    required this.state,
    required this.isRecurring,
  });

  final TransactionFormState state;
  final bool isRecurring;

  @override
  State<_RecurringCustomIntervalRow> createState() =>
      _RecurringCustomIntervalRowState();
}

class _RecurringCustomIntervalRowState
    extends State<_RecurringCustomIntervalRow> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.state.recurringCustomInterval?.toString() ?? '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: TextFormField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.recurringCustomIntervalLabel,
              prefixIcon: const Icon(Icons.numbers_outlined),
            ),
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            onChanged: (value) {
              context.read<TransactionFormCubit>().setRecurringCustomInterval(
                int.tryParse(value),
              );
            },
            validator: (value) {
              if (!widget.isRecurring) return null;
              final parsed = int.tryParse(value ?? '');
              if (parsed == null || parsed <= 0) {
                return l10n.recurringCustomIntervalRequired;
              }
              return null;
            },
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DropdownButtonFormField<String>(
            initialValue: widget.state.recurringCustomUnit,
            decoration: InputDecoration(
              labelText: l10n.recurringCustomUnitLabel,
            ),
            items: [
              DropdownMenuItem(
                value: 'days',
                child: Text(l10n.recurringCustomUnitDays),
              ),
              DropdownMenuItem(
                value: 'weeks',
                child: Text(l10n.recurringCustomUnitWeeks),
              ),
              DropdownMenuItem(
                value: 'months',
                child: Text(l10n.recurringCustomUnitMonths),
              ),
            ],
            onChanged: (value) {
              if (value != null) {
                context.read<TransactionFormCubit>().setRecurringCustomUnit(
                  value,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}

/// Opens a modal bottom-sheet picker over [templates]. Returns the chosen
/// template, or `null` if the user dismissed without picking.
Future<TransactionTemplate?> showTemplatePickerSheet(
  BuildContext context, {
  required List<TransactionTemplate> templates,
  required String baseCurrency,
}) {
  final l10n = context.l10n;
  return showModalBottomSheet<TransactionTemplate>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _TemplatePickerSheet(
      templates: templates,
      title: l10n.templatesPickerTitle,
      emptyLabel: l10n.templatesEmpty,
      baseCurrency: baseCurrency,
    ),
  );
}

class _TemplatePickerSheet extends StatelessWidget {
  const _TemplatePickerSheet({
    required this.templates,
    required this.title,
    required this.emptyLabel,
    required this.baseCurrency,
  });

  final List<TransactionTemplate> templates;
  final String title;
  final String emptyLabel;
  final String baseCurrency;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DraggableScrollableSheet(
      minChildSize: 0.3,
      maxChildSize: 0.9,
      initialChildSize: 0.5,
      expand: false,
      builder: (_, scrollController) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                width: 36,
                height: 4,
                decoration: BoxDecoration(
                  color: theme.colorScheme.outlineVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
              child: Text(
                title,
                style: theme.textTheme.titleMedium,
              ),
            ),
            const Divider(height: 1),
            if (templates.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Center(
                  child: Text(
                    emptyLabel,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  itemCount: templates.length,
                  separatorBuilder: (_, _) =>
                      const Divider(height: 1, indent: 56),
                  itemBuilder: (_, i) {
                    final t = templates[i];
                    final amount = t.amountCents;
                    final symbol = currencySymbolFromCode(
                      t.currency ?? baseCurrency,
                    );
                    return ListTile(
                      leading: Icon(
                        t.type == 'income'
                            ? Icons.trending_up
                            : Icons.shopping_bag_outlined,
                      ),
                      title: Text(t.name),
                      subtitle: (amount != null && amount > 0)
                          ? Text(
                              '$symbol${(amount / 100).toStringAsFixed(2)}',
                            )
                          : null,
                      onTap: () => Navigator.of(context).pop(t),
                    );
                  },
                ),
              ),
            const SizedBox(height: 24),
          ],
        );
      },
    );
  }
}
