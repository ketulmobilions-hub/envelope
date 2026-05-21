import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/services/app_clock.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/view/transfer_form_page.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Modern, fill-in-the-blank style add/edit transaction page.
///
/// Sentence: "I spent $X from account Y in envelope E on date D."
/// Each dynamic token is tappable and opens a focused picker.
///
/// Drop-in alternative to `TransactionFormPage`. Both share the same
/// `TransactionFormCubit` so business logic is untouched.
class SentenceTransactionFormPage extends StatefulWidget {
  const SentenceTransactionFormPage({this.transaction, super.key});

  final Transaction? transaction;

  @override
  State<SentenceTransactionFormPage> createState() =>
      _SentenceTransactionFormPageState();
}

class _SentenceTransactionFormPageState
    extends State<SentenceTransactionFormPage> {
  late String _selectedType;
  late DateTime _selectedDate;
  late final TextEditingController _payeeController;
  late final TextEditingController _notesController;
  int? _amountCents;
  String? _selectedAccountId;
  String? _selectedEnvelopeId;
  List<String> _selectedTagIds = [];
  bool _tagIdsInitialized = false;
  bool _isRecurring = false;
  bool _showMore = false;

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _selectedType = txn?.type ?? 'expense';
    _selectedDate = txn?.date ?? context.read<AppClock>().now();
    _payeeController = TextEditingController(text: txn?.payee ?? '');
    _notesController = TextEditingController(text: txn?.notes ?? '');
    _amountCents = txn?.amount;
    _selectedAccountId = txn?.accountId;
    _selectedEnvelopeId = txn?.envelopeId;
  }

  @override
  void dispose() {
    _payeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final baseCurrency =
        context.watch<AuthBloc>().state.user?.baseCurrency ?? 'USD';
    final symbol = currencySymbolFromCode(baseCurrency);

    return BlocListener<TransactionFormCubit, TransactionFormState>(
      listener: (context, state) {
        if (state.status == TransactionFormStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == TransactionFormStatus.successWithOverspend) {
          unawaited(_handleOverspend(context, state));
        } else if (state.status == TransactionFormStatus.failure) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                state.errorMessage ?? l10n.transactionsErrorLoadFailed,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing
                ? l10n.transactionsEditTransaction
                : l10n.transactionsAddTransaction,
          ),
        ),
        body: BlocBuilder<TransactionFormCubit, TransactionFormState>(
          buildWhen: (prev, curr) =>
              prev.status != curr.status ||
              prev.accounts != curr.accounts ||
              prev.envelopes != curr.envelopes ||
              prev.categoryGroups != curr.categoryGroups ||
              prev.tags != curr.tags ||
              prev.selectedTagIds != curr.selectedTagIds,
          builder: (context, state) {
            if (state.status == TransactionFormStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final accounts = state.accounts;
            final envelopes = state.envelopes;

            _selectedAccountId ??= accounts.isNotEmpty
                ? accounts.first.id
                : null;
            if (!_tagIdsInitialized && state.selectedTagIds.isNotEmpty) {
              _selectedTagIds = List.of(state.selectedTagIds);
              _tagIdsInitialized = true;
            }

            final account = accounts
                .where((a) => a.id == _selectedAccountId)
                .firstOrNull;
            final envelope = envelopes
                .where((e) => e.id == _selectedEnvelopeId)
                .firstOrNull;

            final canSubmit =
                _amountCents != null &&
                _amountCents! > 0 &&
                _selectedAccountId != null &&
                (_selectedType == 'income' || _selectedEnvelopeId != null);

            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _Sentence(
                            type: _selectedType,
                            amountCents: _amountCents,
                            currencySymbol: symbol,
                            account: account,
                            envelope: envelope,
                            date: _selectedDate,
                            onPickType: _pickType,
                            onPickAmount: () => _pickAmount(symbol),
                            onPickAccount: () => _pickAccount(accounts),
                            onPickEnvelope: () => _pickEnvelope(
                              envelopes,
                              state.categoryGroups,
                            ),
                            onPickDate: _pickDate,
                          ),
                          const SizedBox(height: 24),
                          _MoreToggle(
                            expanded: _showMore,
                            onTap: () =>
                                setState(() => _showMore = !_showMore),
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeInOut,
                            child: _showMore
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 16),
                                    child: _MoreSection(
                                      payeeController: _payeeController,
                                      notesController: _notesController,
                                      tags: state.tags,
                                      selectedTagIds: _selectedTagIds,
                                      onTagsChanged: (ids) => setState(
                                        () => _selectedTagIds = ids,
                                      ),
                                      onCreateTag: _createTag,
                                      showRecurring:
                                          !_isEditing &&
                                          _selectedType != 'transfer',
                                      isRecurring: _isRecurring,
                                      onRecurringChanged: (value) {
                                        setState(() => _isRecurring = value);
                                        context
                                            .read<TransactionFormCubit>()
                                            .toggleRecurring(value: value);
                                      },
                                    ),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    child: BlocBuilder<
                      TransactionFormCubit,
                      TransactionFormState
                    >(
                      buildWhen: (prev, curr) => prev.status != curr.status,
                      builder: (context, submitState) {
                        final isSubmitting =
                            submitState.status ==
                            TransactionFormStatus.submitting;
                        return FilledButton(
                          onPressed: (!canSubmit || isSubmitting)
                              ? null
                              : _submit,
                          child: isSubmitting
                              ? const SizedBox.square(
                                  dimension: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  _isEditing
                                      ? l10n.transactionsSaveButton
                                      : l10n.transactionsCreateButton,
                                ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _pickType() async {
    final l10n = context.l10n;
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: Text(l10n.transactionsTypeExpense),
              onTap: () => Navigator.pop(context, 'expense'),
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline),
              title: Text(l10n.transactionsTypeIncome),
              onTap: () => Navigator.pop(context, 'income'),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz),
              title: Text(l10n.transactionsTypeTransfer),
              onTap: () => Navigator.pop(context, 'transfer'),
            ),
          ],
        ),
      ),
    );
    if (picked == null || !mounted) return;

    if (picked == 'transfer') {
      await _navigateToTransfer();
      return;
    }
    setState(() {
      _selectedType = picked;
      if (picked == 'income') {
        _selectedEnvelopeId = null;
      }
    });
  }

  Future<void> _pickAmount(String symbol) async {
    final controller = TextEditingController(
      text: _amountCents != null
          ? (_amountCents! / 100).toStringAsFixed(2)
          : '',
    );
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(sheetCtx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                textAlign: TextAlign.center,
                style: Theme.of(sheetCtx).textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: '${symbol}0.00',
                  border: InputBorder.none,
                ),
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}'),
                  ),
                ],
                onSubmitted: (value) {
                  final cents = parseCents(value);
                  if (cents != null && cents > 0) {
                    Navigator.pop(sheetCtx, cents);
                  }
                },
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {
                  final cents = parseCents(controller.text);
                  if (cents != null && cents > 0) {
                    Navigator.pop(sheetCtx, cents);
                  }
                },
                child: const Text('Done'),
              ),
            ],
          ),
        );
      },
    );
    controller.dispose();
    if (result != null && mounted) {
      setState(() => _amountCents = result);
    }
  }

  Future<void> _pickAccount(List<Account> accounts) async {
    if (accounts.isEmpty) return;
    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => SafeArea(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: accounts.length,
          itemBuilder: (_, i) {
            final a = accounts[i];
            return ListTile(
              leading: const Icon(Icons.account_balance_outlined),
              title: Text(a.name),
              selected: a.id == _selectedAccountId,
              onTap: () => Navigator.pop(context, a.id),
            );
          },
        ),
      ),
    );
    if (picked != null && mounted) {
      setState(() => _selectedAccountId = picked);
    }
  }

  Future<void> _pickEnvelope(
    List<Envelope> envelopes,
    List<CategoryGroup> groups,
  ) async {
    final l10n = context.l10n;
    final ccGroupName = l10n.ccPaymentsCategoryGroupName;
    final visibleGroups = groups.where((g) => g.name != ccGroupName).toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    final picked = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (sheetCtx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          builder: (_, scrollController) {
            return ListView(
              controller: scrollController,
              children: [
                for (final group in visibleGroups) ...[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Text(
                      group.name,
                      style: Theme.of(sheetCtx).textTheme.labelLarge?.copyWith(
                        color: Theme.of(sheetCtx).colorScheme.outline,
                      ),
                    ),
                  ),
                  for (final env in envelopes
                      .where(
                        (e) =>
                            e.categoryGroupId == group.id && !e.isArchived,
                      )
                      .toList()
                    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder)))
                    ListTile(
                      leading: const Icon(Icons.mail_outline),
                      title: Text(env.name),
                      selected: env.id == _selectedEnvelopeId,
                      onTap: () => Navigator.pop(sheetCtx, env.id),
                    ),
                ],
              ],
            );
          },
        );
      },
    );
    if (picked != null && mounted) {
      setState(() => _selectedEnvelopeId = picked);
    }
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
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

  Future<void> _navigateToTransfer() async {
    final cubit = context.read<TransactionFormCubit>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => BlocProvider(
          create: (_) => TransferFormCubit(
            transactionRepository: context.read<TransactionRepository>(),
            accountRepository: context.read<AccountRepository>(),
            envelopeRepository: context.read<EnvelopeRepository>(),
            budgetId: cubit.budgetId,
            userId: cubit.userId,
            budgetPeriodId: cubit.budgetPeriodId,
          ),
          child: const TransferFormPage(),
        ),
      ),
    );
    if (mounted && result == true) {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _handleOverspend(
    BuildContext context,
    TransactionFormState state,
  ) async {
    final data = state.overspendData;
    if (data == null) {
      if (mounted) Navigator.of(context).pop(true);
      return;
    }

    final wantsCover = await showOverspendWarningDialog(
      context,
      envelopeName: data.envelopeName,
      deficitCents: data.deficitCents,
    );

    if (wantsCover != true || !mounted) {
      if (mounted) Navigator.of(context).pop(true);
      return;
    }

    final coverResult = await showCoverOverspendDialog(
      context,
      budgetRepository: context.read<BudgetRepository>(),
      envelopeRepository: context.read<EnvelopeRepository>(),
      allocations: data.allocations,
      envelopes: data.envelopes,
      overspentAllocation: data.overspentAllocation,
      overspentEnvelopeName: data.envelopeName,
      deficitCents: data.deficitCents.abs(),
      readyToAssign: data.readyToAssign,
      ccPaymentAllocation: data.ccPaymentAllocation,
    );

    if (!mounted) return;

    final l10n = context.l10n;
    if (coverResult == true) {
      showAppSnackBar(
        context,
        SnackBar(content: Text(l10n.overspendCoverSuccess)),
      );
    } else if (coverResult == false) {
      showAppSnackBar(
        context,
        SnackBar(content: Text(l10n.overspendCoverFailed)),
      );
    }

    if (mounted) Navigator.of(context).pop(true);
  }

  void _submit() {
    if (_amountCents == null || _amountCents! <= 0) return;
    if (_selectedAccountId == null) return;
    if (_selectedType != 'income' && _selectedEnvelopeId == null) return;

    context.read<TransactionFormCubit>().submit(
      type: _selectedType,
      accountId: _selectedAccountId!,
      amountCents: _amountCents!,
      date: _selectedDate,
      envelopeId: _selectedType == 'income' ? null : _selectedEnvelopeId,
      payee: _payeeController.text.trim(),
      notes: _notesController.text.trim(),
      selectedTagIds: _selectedTagIds,
      isRecurring: _isRecurring,
    );
  }
}

// ---------------------------------------------------------------------------
// Sentence layout
// ---------------------------------------------------------------------------

class _Sentence extends StatelessWidget {
  const _Sentence({
    required this.type,
    required this.amountCents,
    required this.currencySymbol,
    required this.account,
    required this.envelope,
    required this.date,
    required this.onPickType,
    required this.onPickAmount,
    required this.onPickAccount,
    required this.onPickEnvelope,
    required this.onPickDate,
  });

  final String type;
  final int? amountCents;
  final String currencySymbol;
  final Account? account;
  final Envelope? envelope;
  final DateTime date;
  final VoidCallback onPickType;
  final VoidCallback onPickAmount;
  final VoidCallback onPickAccount;
  final VoidCallback onPickEnvelope;
  final VoidCallback onPickDate;

  String _verb(AppLocalizations l10n) {
    return switch (type) {
      'income' => 'earned',
      'transfer' => 'transferred',
      _ => 'spent',
    };
  }

  String _amountLabel() {
    if (amountCents == null) return '${currencySymbol}0.00';
    return '$currencySymbol${(amountCents! / 100).toStringAsFixed(2)}';
  }

  String _dateLabel(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = DateTime(date.year, date.month, date.day);
    final diff = today.difference(picked).inDays;
    if (diff == 0) return 'today';
    if (diff == 1) return 'yesterday';
    if (diff == -1) return 'tomorrow';
    return MaterialLocalizations.of(context).formatMediumDate(date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final textStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      height: 1.7,
      fontWeight: FontWeight.w400,
    );
    final isExpense = type == 'expense';

    return DefaultTextStyle.merge(
      style: textStyle,
      child: Wrap(
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 6,
        runSpacing: 6,
        children: [
          const Text('I'),
          _Token(label: _verb(l10n), onTap: onPickType),
          _Token(
            label: _amountLabel(),
            onTap: onPickAmount,
            placeholder: amountCents == null,
            emphasis: true,
          ),
          Text(isExpense ? 'from' : 'in'),
          _Token(
            label: account?.name ?? 'account',
            onTap: onPickAccount,
            placeholder: account == null,
          ),
          if (isExpense) ...[
            const Text('in'),
            _Token(
              label: envelope?.name ?? 'envelope',
              onTap: onPickEnvelope,
              placeholder: envelope == null,
            ),
          ],
          const Text('on'),
          _Token(label: _dateLabel(context), onTap: onPickDate),
          const Text('.'),
        ],
      ),
    );
  }
}

class _Token extends StatelessWidget {
  const _Token({
    required this.label,
    required this.onTap,
    this.placeholder = false,
    this.emphasis = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool placeholder;
  final bool emphasis;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bg = placeholder
        ? colorScheme.surfaceContainerHighest
        : colorScheme.secondaryContainer;
    final fg = placeholder
        ? colorScheme.onSurfaceVariant
        : colorScheme.onSecondaryContainer;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: fg,
            fontWeight: emphasis ? FontWeight.w700 : FontWeight.w500,
            fontStyle: placeholder ? FontStyle.italic : FontStyle.normal,
            fontSize: emphasis ? 24 : null,
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// More options (payee, notes, tags, recurring)
// ---------------------------------------------------------------------------

class _MoreToggle extends StatelessWidget {
  const _MoreToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      icon: Icon(expanded ? Icons.expand_less : Icons.expand_more),
      label: Text(expanded ? 'Hide details' : 'Add details'),
    );
  }
}

class _MoreSection extends StatelessWidget {
  const _MoreSection({
    required this.payeeController,
    required this.notesController,
    required this.tags,
    required this.selectedTagIds,
    required this.onTagsChanged,
    required this.onCreateTag,
    required this.showRecurring,
    required this.isRecurring,
    required this.onRecurringChanged,
  });

  final TextEditingController payeeController;
  final TextEditingController notesController;
  final List<Tag> tags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onTagsChanged;
  final Future<void> Function(String) onCreateTag;
  final bool showRecurring;
  final bool isRecurring;
  final ValueChanged<bool> onRecurringChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: payeeController,
          decoration: InputDecoration(
            labelText: l10n.transactionsPayeeLabel,
            prefixIcon: const Icon(Icons.person_outline),
          ),
          textInputAction: TextInputAction.next,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 16),
        TextField(
          controller: notesController,
          decoration: InputDecoration(
            labelText: l10n.transactionsNotesLabel,
            prefixIcon: const Icon(Icons.notes_outlined),
          ),
          textInputAction: TextInputAction.done,
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        TagPicker(
          availableTags: tags,
          selectedTagIds: selectedTagIds,
          onChanged: onTagsChanged,
          onCreateTag: onCreateTag,
        ),
        if (showRecurring) ...[
          const SizedBox(height: 8),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.recurringMakeRecurringLabel),
            value: isRecurring,
            onChanged: onRecurringChanged,
          ),
        ],
      ],
    );
  }
}
