import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/transactions/cubit/cubit.dart';
import 'package:envelope/transactions/view/transfer_form_page.dart';
import 'package:envelope/transactions/widgets/widgets.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:transaction_repository/transaction_repository.dart';

const _kFrequencies = [
  'daily',
  'weekly',
  'bi-weekly',
  'monthly',
  'yearly',
  'custom',
];

/// Page for adding or editing a transaction.
///
/// Pass [transaction] to edit an existing transaction, or leave it `null`
/// to create.
class TransactionFormPage extends StatefulWidget {
  const TransactionFormPage({
    this.transaction,
    super.key,
  });

  final Transaction? transaction;

  @override
  State<TransactionFormPage> createState() => _TransactionFormPageState();
}

class _TransactionFormPageState extends State<TransactionFormPage> {
  final _formKey = GlobalKey<FormState>();
  late String _selectedType;
  late DateTime _selectedDate;
  late final TextEditingController _amountController;
  late final TextEditingController _payeeController;
  late final TextEditingController _notesController;
  String? _selectedAccountId;
  String? _selectedEnvelopeId;
  bool _isSplitMode = false;
  bool _isRecurring = false;
  bool _tagIdsInitialized = false;
  bool _splitsInitialized = false;

  List<SplitEntry> _splits = [];
  List<String> _selectedTagIds = [];

  bool get _isEditing => widget.transaction != null;

  @override
  void initState() {
    super.initState();
    final txn = widget.transaction;
    _selectedType = txn?.type ?? 'expense';
    _selectedDate = txn?.date ?? DateTime.now();
    _amountController = TextEditingController(
      text: txn != null ? (txn.amount / 100).toStringAsFixed(2) : '',
    );
    _payeeController = TextEditingController(text: txn?.payee ?? '');
    _notesController = TextEditingController(text: txn?.notes ?? '');
    _selectedAccountId = txn?.accountId;
    _selectedEnvelopeId = txn?.envelopeId;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _payeeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

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
        } else if (state.tagError != null) {
          showAppSnackBar(
            context,
            SnackBar(content: Text(state.tagError!)),
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
              prev.tags != curr.tags ||
              prev.selectedTagIds != curr.selectedTagIds,
          builder: (context, state) {
            if (state.status == TransactionFormStatus.loading) {
              return const Center(child: CircularProgressIndicator());
            }

            final accounts = state.accounts;
            final envelopes = state.envelopes;

            // Initialize local state from cubit on first load.
            _selectedAccountId ??= accounts.isNotEmpty
                ? accounts.first.id
                : null;
            if (!_tagIdsInitialized && state.selectedTagIds.isNotEmpty) {
              _selectedTagIds = List.of(state.selectedTagIds);
              _tagIdsInitialized = true;
            }
            if (!_splitsInitialized &&
                state.status == TransactionFormStatus.loaded) {
              if (state.initialSplits.isNotEmpty) {
                _splits = List.of(state.initialSplits);
                _isSplitMode = true;
              }
              _splitsInitialized = true;
            }

            final showRecurringToggle = !_isEditing &&
                _selectedType != 'transfer' &&
                !_isSplitMode;

            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Type selector — pill chips.
                      Row(
                        children: [
                          _TypeChip(
                            label: l10n.transactionsTypeExpense,
                            isSelected: _selectedType == 'expense',
                            onTap: () =>
                                setState(() => _selectedType = 'expense'),
                          ),
                          const SizedBox(width: 8),
                          _TypeChip(
                            label: l10n.transactionsTypeIncome,
                            isSelected: _selectedType == 'income',
                            onTap: () => setState(() {
                              _selectedType = 'income';
                              _selectedEnvelopeId = null;
                              _isSplitMode = false;
                            }),
                          ),
                          const SizedBox(width: 8),
                          _TypeChip(
                            label: l10n.transactionsTypeTransfer,
                            isSelected: _selectedType == 'transfer',
                            onTap: () async {
                              if (_isRecurring) {
                                setState(() => _isRecurring = false);
                                context
                                    .read<TransactionFormCubit>()
                                    .toggleRecurring(value: false);
                              }
                              await _navigateToTransfer();
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Horizontal date picker.
                      HorizontalDatePicker(
                        selectedDate: _selectedDate,
                        onDateSelected: (date) =>
                            setState(() => _selectedDate = date),
                      ),
                      const SizedBox(height: 16),

                      // Account dropdown
                      if (accounts.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: _selectedAccountId,
                          decoration: InputDecoration(
                            labelText: l10n.transactionsAccountLabel,
                            prefixIcon: const Icon(
                              Icons.account_balance_outlined,
                            ),
                          ),
                          items: accounts.map((account) {
                            return DropdownMenuItem(
                              value: account.id,
                              child: Text(account.name),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() => _selectedAccountId = value);
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.transactionsAccountRequired;
                            }
                            return null;
                          },
                        ),
                      const SizedBox(height: 16),

                      // Envelope dropdown — hidden for split/income/transfer.
                      if (!_isSplitMode &&
                          _selectedType != 'income' &&
                          _selectedType != 'transfer' &&
                          envelopes.isNotEmpty)
                        DropdownButtonFormField<String>(
                          initialValue: _selectedEnvelopeId,
                          decoration: InputDecoration(
                            labelText: l10n.transactionsEnvelopeLabel,
                            prefixIcon: const Icon(Icons.mail_outlined),
                          ),
                          items: [
                            DropdownMenuItem<String>(
                              child: Text(l10n.transactionsNoEnvelope),
                            ),
                            ...(envelopes.map((env) {
                              return DropdownMenuItem(
                                value: env.id,
                                child: Text(env.name),
                              );
                            })),
                          ],
                          onChanged: (value) {
                            setState(() => _selectedEnvelopeId = value);
                          },
                        ),
                      if (!_isSplitMode) const SizedBox(height: 16),

                      // Amount — large centered serif display.
                      TextFormField(
                        controller: _amountController,
                        decoration: InputDecoration(
                          hintText: r'$0.00',
                          hintStyle: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.outline,
                              ),
                          border: InputBorder.none,
                        ),
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        textAlign: TextAlign.center,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'^\-?\d*\.?\d{0,2}'),
                          ),
                        ],
                        textInputAction: TextInputAction.next,
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

                      // Payee
                      TextFormField(
                        controller: _payeeController,
                        decoration: InputDecoration(
                          labelText: l10n.transactionsPayeeLabel,
                          prefixIcon: const Icon(Icons.person_outline),
                        ),
                        textInputAction: TextInputAction.next,
                        textCapitalization: TextCapitalization.words,
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      TextFormField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: l10n.transactionsNotesLabel,
                          prefixIcon: const Icon(Icons.notes_outlined),
                        ),
                        textInputAction: TextInputAction.done,
                        maxLines: 2,
                      ),
                      const SizedBox(height: 16),

                      const SizedBox(height: 16),

                      // Tags
                      TagPicker(
                        availableTags: state.tags,
                        selectedTagIds: _selectedTagIds,
                        onChanged: (tagIds) =>
                            setState(() => _selectedTagIds = tagIds),
                        onCreateTag: _createTag,
                      ),

                      const SizedBox(height: 16),

                      // Make Recurring toggle
                      if (showRecurringToggle)
                        SwitchListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(l10n.recurringMakeRecurringLabel),
                          value: _isRecurring,
                          onChanged: (value) {
                            setState(() => _isRecurring = value);
                            context
                                .read<TransactionFormCubit>()
                                .toggleRecurring(value: value);
                          },
                        ),

                      // Recurring settings section (animated expand/collapse)
                      AnimatedSize(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        child: showRecurringToggle && _isRecurring
                            ? BlocBuilder<TransactionFormCubit,
                                TransactionFormState>(
                                buildWhen: (prev, curr) =>
                                    prev.recurringFrequency !=
                                        curr.recurringFrequency ||
                                    prev.recurringCustomInterval !=
                                        curr.recurringCustomInterval ||
                                    prev.recurringCustomUnit !=
                                        curr.recurringCustomUnit ||
                                    prev.recurringEndDate !=
                                        curr.recurringEndDate ||
                                    prev.recurringAutoPost !=
                                        curr.recurringAutoPost,
                                builder: (context, recurringState) =>
                                    _RecurringSection(
                                  state: recurringState,
                                  selectedDate: _selectedDate,
                                  isRecurring: _isRecurring,
                                ),
                              )
                            : const SizedBox.shrink(),
                      ),

                      const SizedBox(height: 32),

                      // Submit button — full width.
                      SizedBox(
                        width: double.infinity,
                        child: BlocBuilder<TransactionFormCubit,
                            TransactionFormState>(
                          buildWhen: (prev, curr) =>
                              prev.status != curr.status,
                          builder: (context, submitState) {
                            final isSubmitting =
                                submitState.status ==
                                TransactionFormStatus.submitting;
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
                                          ? l10n.transactionsSaveButton
                                          : l10n.transactionsCreateButton,
                                    ),
                            );
                          },
                        ),
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
            budgetId: cubit.budgetId,
            userId: cubit.userId,
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
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final amountCents = parseCents(_amountController.text) ?? 0;

    context.read<TransactionFormCubit>().submit(
      type: _selectedType,
      accountId: _selectedAccountId!,
      amountCents: amountCents,
      date: _selectedDate,
      envelopeId: _isSplitMode ? null : _selectedEnvelopeId,
      payee: _payeeController.text.trim(),
      notes: _notesController.text.trim(),
      isSplitMode: _isSplitMode,
      splits: _splits,
      selectedTagIds: _selectedTagIds,
      isRecurring: _isRecurring,
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
          // Frequency dropdown
          DropdownButtonFormField<String>(
            initialValue: state.recurringFrequency,
            decoration: InputDecoration(
              labelText: l10n.recurringFrequencyLabel,
              prefixIcon: const Icon(Icons.repeat),
            ),
            items: _kFrequencies.map((f) {
              return DropdownMenuItem(
                value: f,
                child: Text(_localizedFrequency(f, l10n)),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                context
                    .read<TransactionFormCubit>()
                    .setRecurringFrequency(value);
              }
            },
          ),

          // Custom interval row (shown only for 'custom' frequency)
          if (state.recurringFrequency == 'custom') ...[
            const SizedBox(height: 16),
            _RecurringCustomIntervalRow(
              state: state,
              isRecurring: isRecurring,
            ),
          ],

          const SizedBox(height: 16),

          // End date ListTile
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

          // Auto-post toggle
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

// ---------------------------------------------------------------------------
// Custom interval row (StatefulWidget for TextEditingController)
// ---------------------------------------------------------------------------

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
        // Interval number field
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
              context
                  .read<TransactionFormCubit>()
                  .setRecurringCustomInterval(int.tryParse(value));
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

        // Unit dropdown
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
                context
                    .read<TransactionFormCubit>()
                    .setRecurringCustomUnit(value);
              }
            },
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Type chip
// ---------------------------------------------------------------------------

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).dividerColor,
          ),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1,
            color: isSelected
                ? Theme.of(context).colorScheme.onSecondary
                : Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
