import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope/transactions/widgets/split_rows.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' show DateUtils;
import 'package:transaction_repository/transaction_repository.dart';

part 'transaction_form_state.dart';

class TransactionFormCubit extends Cubit<TransactionFormState> {
  TransactionFormCubit({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
    required EnvelopeRepository envelopeRepository,
    required BudgetRepository budgetRepository,
    required this.budgetId,
    required this.userId,
    this.budgetPeriodId,
    this.transaction,
    DateTime Function()? now,
  }) : _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       _budgetRepository = budgetRepository,
       _now = now ?? DateTime.now,
       super(const TransactionFormState()) {
    _loadData();
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository _envelopeRepository;
  final BudgetRepository _budgetRepository;
  final DateTime Function() _now;
  final String budgetId;
  final String userId;
  final String? budgetPeriodId;
  final Transaction? transaction;

  bool get isEditing => transaction != null;

  Future<void> _loadData() async {
    // Each fetch is independent: one failing must not blank out the others.
    Future<T> safe<T>(Future<T> Function() task, T fallback) async {
      try {
        return await task();
      } on Exception {
        return fallback;
      }
    }

    final accountsFuture = safe(
      () => _accountRepository.watchAccounts(budgetId).first,
      const <Account>[],
    );
    final envelopesFuture = safe(
      () => _envelopeRepository.watchEnvelopes(budgetId).first,
      const <Envelope>[],
    );
    final categoryGroupsFuture = safe(
      () => _envelopeRepository.watchCategoryGroups(budgetId).first,
      const <CategoryGroup>[],
    );
    final tagsFuture = safe(
      () => _transactionRepository.getTags(budgetId),
      const <Tag>[],
    );
    final templatesFuture = safe(
      () => _transactionRepository.getTransactionTemplates(budgetId),
      const <TransactionTemplate>[],
    );
    final recentPayeesFuture = safe(() async {
      final txns = await _transactionRepository
          .watchTransactions(budgetId: budgetId)
          .first;
      final freq = <String, int>{};
      for (final t in txns) {
        final p = t.payee;
        if (p != null && p.isNotEmpty) freq[p] = (freq[p] ?? 0) + 1;
      }
      final sorted = freq.keys.toList()
        ..sort((a, b) => freq[b]!.compareTo(freq[a]!));
      return sorted.take(30).toList();
    }, const <String>[]);
    final selectedTagIdsFuture = isEditing
        ? safe(
            () => _transactionRepository.getTagIdsForTransaction(
              transaction!.id,
            ),
            const <String>[],
          )
        : Future.value(const <String>[]);
    final splitsFuture = isEditing
        ? safe(
            () => _transactionRepository.getTransactionSplits(transaction!.id),
            const <TransactionSplit>[],
          )
        : Future.value(const <TransactionSplit>[]);

    final accounts = await accountsFuture;
    final envelopes = await envelopesFuture;
    final categoryGroups = await categoryGroupsFuture;
    final tags = await tagsFuture;
    final templates = await templatesFuture;
    final recentPayees = await recentPayeesFuture;
    final selectedTagIds = await selectedTagIdsFuture;
    final splits = await splitsFuture;
    final initialSplits = splits
        .map(
          (s) => SplitEntry(
            envelopeId: s.envelopeId,
            amountText: (s.amount / 100).toStringAsFixed(2),
          ),
        )
        .toList();

    if (isClosed) return;
    emit(
      state.copyWith(
        status: TransactionFormStatus.loaded,
        accounts: accounts,
        envelopes: envelopes,
        categoryGroups: categoryGroups,
        tags: tags,
        templates: templates,
        recentPayees: recentPayees,
        selectedTagIds: selectedTagIds,
        initialSplits: initialSplits,
      ),
    );
  }

  /// Persists the current transaction shape as a reusable template.
  ///
  /// Best-effort: failures are swallowed and do not block the originating
  /// transaction submit. The new template is appended to [state.templates]
  /// on success.
  Future<void> saveAsTemplate({
    required String name,
    required String type,
    String? accountId,
    String? envelopeId,
    int? amountCents,
    String? payee,
    String? notes,
    String? currency,
    List<String> tagIds = const [],
  }) async {
    try {
      final template = await _transactionRepository.createTransactionTemplate(
        budgetId: budgetId,
        name: name,
        type: type,
        accountId: accountId,
        envelopeId: envelopeId,
        amountCents: amountCents,
        payee: payee,
        notes: notes,
        currency: currency,
        tagIds: tagIds,
      );
      if (isClosed) return;
      emit(state.copyWith(templates: [...state.templates, template]));
    } on Exception {
      // Template save is non-blocking; transaction already created.
    }
  }

  Future<void> createTag(String name) async {
    try {
      final tag = await _transactionRepository.createTag(
        budgetId: budgetId,
        name: name,
      );
      if (isClosed) return;
      emit(
        state.copyWith(
          tags: [...state.tags, tag],
          selectedTagIds: [...state.selectedTagIds, tag.id],
        ),
      );
    } on TransactionException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(tagError: e.message));
      // Clear tagError so duplicate errors still trigger the listener.
      emit(state.copyWith());
    } on Exception {
      if (isClosed) return;
      emit(state.copyWith(tagError: 'Failed to create tag.'));
      emit(state.copyWith());
    }
  }

  Future<void> reloadEnvelopes() async {
    try {
      final envelopes = await _envelopeRepository
          .watchEnvelopes(budgetId)
          .first;
      final categoryGroups = await _envelopeRepository
          .watchCategoryGroups(budgetId)
          .first;
      if (isClosed) return;
      emit(
        state.copyWith(envelopes: envelopes, categoryGroups: categoryGroups),
      );
    } on Exception {
      // Best-effort — stale data remains usable.
    }
  }

  // ---------------------------------------------------------------------------
  // Recurring mutators
  // ---------------------------------------------------------------------------

  void toggleRecurring({required bool value}) =>
      emit(state.copyWith(isRecurring: value));

  void setRecurringFrequency(String frequency) =>
      emit(state.copyWith(recurringFrequency: frequency));

  void setRecurringCustomInterval(int? interval) =>
      emit(state.copyWith(recurringCustomInterval: interval));

  void setRecurringCustomUnit(String unit) =>
      emit(state.copyWith(recurringCustomUnit: unit));

  void setRecurringEndDate(DateTime? date) =>
      emit(state.copyWith(recurringEndDate: date));

  void toggleRecurringAutoPost({required bool value}) =>
      emit(state.copyWith(recurringAutoPost: value));

  // ---------------------------------------------------------------------------
  // Submit
  // ---------------------------------------------------------------------------

  Future<void> submit({
    required String type,
    required String accountId,
    required int amountCents,
    required DateTime date,
    String? envelopeId,
    String? payee,
    String? notes,
    bool isSplitMode = false,
    List<SplitEntry> splits = const [],
    List<String> selectedTagIds = const [],
    bool isRecurring = false,
    String? currencyOverride,
    double exchangeRate = 1.0,
  }) async {
    if (state.accounts.isEmpty) {
      emit(
        state.copyWith(
          status: TransactionFormStatus.failure,
          errorMessage: 'Accounts not loaded yet. Please retry.',
        ),
      );
      return;
    }
    emit(state.copyWith(status: TransactionFormStatus.submitting));
    try {
      // Resolve effective transaction currency: explicit override (form
      // currency picker) wins, else fall back to the selected account's.
      final effectiveCurrency =
          currencyOverride ?? state.accounts.currencyForAccountId(accountId);
      // Convert any amount expressed in the transaction's currency to the
      // budget's base currency cents. Used by addIncomeToCurrentPeriod and
      // incrementLocalSpentAmount, both of which operate in base currency.
      int toBase(int amountInTxCcy) =>
          (amountInTxCcy * exchangeRate).round();
      if (isEditing) {
        // ── Edit existing transaction ──────────────────────────────────────
        final updated = transaction!.copyWith(
          type: type,
          accountId: accountId,
          envelopeId: isSplitMode ? null : envelopeId,
          amount: amountCents,
          currency: effectiveCurrency,
          exchangeRate: exchangeRate,
          date: date,
          payee: payee,
          notes: notes,
          updatedAt: DateTime.now(),
        );
        await _transactionRepository.updateTransaction(updated);
        final transactionId = transaction!.id;

        if (isSplitMode) {
          await _saveSplits(transactionId, splits);
        }
        await _saveTags(transactionId, selectedTagIds);

        // Income delta for edits, expressed in base currency.
        final oldIncome = transaction!.type == 'income'
            ? (transaction!.amount * transaction!.exchangeRate).round()
            : 0;
        final newIncome = type == 'income' ? toBase(amountCents) : 0;
        final incomeDelta = newIncome - oldIncome;
        if (incomeDelta != 0) {
          try {
            await _budgetRepository.addIncomeToCurrentPeriod(
              budgetId: budgetId,
              amount: incomeDelta,
            );
          } on BudgetException {
            // Best-effort.
          }
        }

        if (budgetPeriodId != null) {
          try {
            await _envelopeRepository.refreshAllocations(budgetPeriodId!);
          } on Exception {
            // Best-effort.
          }
        }
        try {
          await _accountRepository.refreshAccounts(budgetId);
        } on AccountException {
          // Best-effort.
        }

        final overspendData = await _checkOverspend(
          type: type,
          envelopeId: envelopeId,
          isSplitMode: isSplitMode,
          splits: splits,
          accountId: accountId,
        );

        if (isClosed) return;
        if (overspendData != null) {
          emit(
            state.copyWith(
              status: TransactionFormStatus.successWithOverspend,
              overspendData: overspendData,
            ),
          );
        } else {
          emit(state.copyWith(status: TransactionFormStatus.success));
        }
      } else if (isRecurring) {
        // ── Create transaction (if today/past) + recurring rule ───────────
        final nowVal = _now();
        final today = DateTime(nowVal.year, nowVal.month, nowVal.day);
        final selectedDay = DateTime(date.year, date.month, date.day);
        final isFutureDate = selectedDay.isAfter(today);

        if (!isFutureDate) {
          // Today or past: post the transaction immediately.

          // Ensure allocation rows exist before the transaction so the DB
          // spent-amount trigger has a row to update (even for $0-allocated envelopes).
          if (type == 'expense' && budgetPeriodId != null) {
            if (!isSplitMode && envelopeId != null) {
              try {
                await _envelopeRepository.ensureAllocation(
                  envelopeId: envelopeId,
                  budgetPeriodId: budgetPeriodId!,
                );
              } on EnvelopeException {
                // Best-effort.
              }
            } else if (isSplitMode) {
              for (final split in splits) {
                if (split.envelopeId != null) {
                  try {
                    await _envelopeRepository.ensureAllocation(
                      envelopeId: split.envelopeId!,
                      budgetPeriodId: budgetPeriodId!,
                    );
                  } on EnvelopeException {
                    // Best-effort.
                  }
                }
              }
            }
          }

          _envelopeRepository.beginExternalWrite();
          _accountRepository.beginExternalWrite();
          late Transaction created;
          try {
            created = await _transactionRepository.createTransaction(
              budgetId: budgetId,
              accountId: accountId,
              type: type,
              amount: amountCents,
              currency: effectiveCurrency,
              exchangeRate: exchangeRate,
              date: date,
              createdBy: userId,
              envelopeId: isSplitMode ? null : envelopeId,
              payee: payee,
              notes: notes,
            );
          } finally {
            _envelopeRepository.endExternalWrite();
            _accountRepository.endExternalWrite();
          }
          final transactionId = created.id;

          if (isSplitMode) {
            await _saveSplits(transactionId, splits);
          }
          await _saveTags(transactionId, selectedTagIds);

          final newIncome = type == 'income' ? toBase(amountCents) : 0;
          if (newIncome != 0) {
            try {
              await _budgetRepository.addIncomeToCurrentPeriod(
                budgetId: budgetId,
                amount: newIncome,
              );
            } on BudgetException {
              // Best-effort.
            }
          }

          if (budgetPeriodId != null) {
            try {
              await _envelopeRepository.refreshAllocations(budgetPeriodId!);
            } on Exception {
              // Best-effort.
            }
          }
          try {
            await _accountRepository.refreshAccounts(budgetId);
          } on AccountException {
            // Best-effort.
          }

          if (type == 'expense' && budgetPeriodId != null) {
            await _transferToCCPaymentEnvelope(
              accountId: accountId,
              envelopeId: isSplitMode ? null : envelopeId,
              splits: isSplitMode ? splits : [],
              expenseAmount: amountCents,
              budgetPeriodId: budgetPeriodId!,
            );
          }

          // Rule starts from the next occurrence so it doesn't banner today.
          await _createRecurringRuleFromForm(
            type: type,
            accountId: accountId,
            amountCents: amountCents,
            transactionDate: date,
            isFutureDate: false,
            envelopeId: envelopeId,
            payee: payee,
            notes: notes,
            currencyOverride: currencyOverride,
            exchangeRate: exchangeRate,
          );

          final overspendData = await _checkOverspend(
            type: type,
            envelopeId: envelopeId,
            isSplitMode: isSplitMode,
            splits: splits,
            accountId: accountId,
          );

          if (isClosed) return;
          if (overspendData != null) {
            emit(
              state.copyWith(
                status: TransactionFormStatus.successWithOverspend,
                overspendData: overspendData,
              ),
            );
          } else {
            emit(state.copyWith(status: TransactionFormStatus.success));
          }
        } else {
          // Future date: skip transaction, just create the rule.
          // autoPost=true → auto-posted when due; autoPost=false → pending
          // banner appears on due date.
          await _createRecurringRuleFromForm(
            type: type,
            accountId: accountId,
            amountCents: amountCents,
            transactionDate: date,
            isFutureDate: true,
            envelopeId: envelopeId,
            payee: payee,
            notes: notes,
            currencyOverride: currencyOverride,
            exchangeRate: exchangeRate,
          );

          if (isClosed) return;
          emit(state.copyWith(status: TransactionFormStatus.success));
        }
      } else {
        // ── Create one-off transaction ─────────────────────────────────────

        // Resolve the period that actually contains the transaction's date —
        // NOT the period selected when the sheet opened. A back-dated expense
        // must hit (and if necessary create) the period covering its date, so
        // its spent/overspend lands in the right month and carries forward.
        final effectivePeriodId = await _resolvePeriodForDate(date);

        // Ensure allocation rows exist before the transaction so the DB
        // spent-amount trigger has a row to update (even for $0-allocated
        // envelopes).
        if (type == 'expense' && effectivePeriodId != null) {
          if (!isSplitMode && envelopeId != null) {
            try {
              await _envelopeRepository.ensureAllocation(
                envelopeId: envelopeId,
                budgetPeriodId: effectivePeriodId,
              );
            } on EnvelopeException {
              // Best-effort.
            }
          } else if (isSplitMode) {
            for (final split in splits) {
              if (split.envelopeId != null) {
                try {
                  await _envelopeRepository.ensureAllocation(
                    envelopeId: split.envelopeId!,
                    budgetPeriodId: effectivePeriodId,
                  );
                } on EnvelopeException {
                  // Best-effort.
                }
              }
            }
          }
        }

        _envelopeRepository.beginExternalWrite();
        _accountRepository.beginExternalWrite();
        late Transaction created;
        try {
          created = await _transactionRepository.createTransaction(
            budgetId: budgetId,
            accountId: accountId,
            type: type,
            amount: amountCents,
            currency: effectiveCurrency,
            exchangeRate: exchangeRate,
            date: date,
            createdBy: userId,
            envelopeId: isSplitMode ? null : envelopeId,
            payee: payee,
            notes: notes,
          );
        } finally {
          _envelopeRepository.endExternalWrite();
          _accountRepository.endExternalWrite();
        }
        final transactionId = created.id;

        if (isSplitMode) {
          await _saveSplits(transactionId, splits);
        }
        await _saveTags(transactionId, selectedTagIds);

        final newIncome = type == 'income' ? toBase(amountCents) : 0;
        if (newIncome != 0) {
          try {
            // Credit the period containing the transaction's date (not the
            // latest period) so back-dated income lands in the right month.
            await _budgetRepository.addIncomeToPeriod(
              budgetId: budgetId,
              date: date,
              amount: newIncome,
            );
          } on BudgetException {
            // Best-effort.
          }
        }

        if (type == 'expense') {
          // Awaited (not fire-and-forget): the carry-forward recompute below
          // reads these local spent amounts, so they must land first.
          if (!isSplitMode && envelopeId != null) {
            await _envelopeRepository.incrementLocalSpentAmount(
              envelopeId: envelopeId,
              budgetId: budgetId,
              date: date,
              baseCurrencyAmount: toBase(amountCents),
            );
          } else if (isSplitMode) {
            for (final split in splits) {
              final splitEnvId = split.envelopeId;
              if (splitEnvId != null && split.amountCents > 0) {
                await _envelopeRepository.incrementLocalSpentAmount(
                  envelopeId: splitEnvId,
                  budgetId: budgetId,
                  date: date,
                  baseCurrencyAmount: toBase(split.amountCents),
                );
              }
            }
          }
        }

        if (effectivePeriodId != null) {
          try {
            await _envelopeRepository.refreshAllocations(effectivePeriodId);
          } on Exception {
            // Best-effort.
          }
        }
        try {
          await _accountRepository.refreshAccounts(budgetId);
        } on AccountException {
          // Best-effort.
        }

        if (type == 'expense' && effectivePeriodId != null) {
          await _transferToCCPaymentEnvelope(
            accountId: accountId,
            envelopeId: isSplitMode ? null : envelopeId,
            splits: isSplitMode ? splits : [],
            expenseAmount: amountCents,
            budgetPeriodId: effectivePeriodId,
          );
        }

        // Propagate carry-forward for a back-dated transaction into later
        // periods: an expense's uncovered overspend reduces, and income raises,
        // the leftover RTA that rolls forward. No-op when the transaction is in
        // the latest period (nothing follows it).
        if (effectivePeriodId != null) {
          try {
            await _budgetRepository.recomputeCarryForwardFrom(
              budgetId: budgetId,
              fromPeriodId: effectivePeriodId,
            );
          } on BudgetException {
            // Best-effort; next period creation recomputes carry-forward.
          }
        }

        // Only prompt the cover-overspend flow for the current period (the one
        // the sheet opened with). A back-dated expense lands in a past period
        // that typically has no funds to cover from — surfacing the dialog
        // there is a dead end. Its overspend instead carries forward into the
        // current period's RTA via recomputeCarryForwardFrom above.
        final overspendData = effectivePeriodId == budgetPeriodId
            ? await _checkOverspend(
                type: type,
                envelopeId: envelopeId,
                isSplitMode: isSplitMode,
                splits: splits,
                accountId: accountId,
                periodId: effectivePeriodId,
              )
            : null;

        if (isClosed) return;
        if (overspendData != null) {
          emit(
            state.copyWith(
              status: TransactionFormStatus.successWithOverspend,
              overspendData: overspendData,
            ),
          );
        } else {
          emit(state.copyWith(status: TransactionFormStatus.success));
        }
      }
    } on TransactionException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransactionFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransactionFormStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }

  Future<void> _createRecurringRuleFromForm({
    required String type,
    required String accountId,
    required int amountCents,
    required DateTime transactionDate,
    required bool isFutureDate,
    String? envelopeId,
    String? payee,
    String? notes,
    String? currencyOverride,
    double exchangeRate = 1.0,
  }) async {
    // Future date: rule starts on the chosen date (no transaction yet).
    // Today/past: rule starts from the next occurrence to avoid an
    // immediate pending banner.
    final startDate = isFutureDate
        ? transactionDate
        : _nextOccurrenceAfter(
            from: transactionDate,
            frequency: state.recurringFrequency,
            customInterval: state.recurringCustomInterval,
            customUnit: state.recurringCustomUnit,
          );
    // Currency is snapshot at rule creation. If the account's currency is
    // later edited, future fired transactions still use the snapshot here
    // (see RecurringCheckCubit._autoPostRule which passes rule.currency).
    await _transactionRepository.createRecurringRule(
      budgetId: budgetId,
      accountId: accountId,
      type: type,
      amount: amountCents,
      currency: currencyOverride ??
          state.accounts.currencyForAccountId(accountId),
      exchangeRate: exchangeRate,
      frequency: state.recurringFrequency,
      startDate: startDate,
      envelopeId: envelopeId,
      payee: payee?.isEmpty == true ? null : payee,
      notes: notes?.isEmpty == true ? null : notes,
      customInterval: state.recurringFrequency == 'custom'
          ? (state.recurringCustomInterval ?? 1)
          : null,
      customUnit: state.recurringFrequency == 'custom'
          ? state.recurringCustomUnit
          : null,
      endDate: state.recurringEndDate,
      autoPost: state.recurringAutoPost,
    );
  }

  static DateTime _nextOccurrenceAfter({
    required DateTime from,
    required String frequency,
    int? customInterval,
    String? customUnit,
  }) {
    return switch (frequency) {
      'daily' => from.add(const Duration(days: 1)),
      'weekly' => from.add(const Duration(days: 7)),
      'bi-weekly' => from.add(const Duration(days: 14)),
      'monthly' => _addMonths(from, 1),
      'yearly' => _addMonths(from, 12),
      'custom' => _addCustomInterval(
        from,
        customInterval ?? 1,
        customUnit ?? 'days',
      ),
      _ => from.add(const Duration(days: 30)),
    };
  }

  static DateTime _addMonths(DateTime date, int months) {
    final total = date.month + months;
    final y = date.year + (total - 1) ~/ 12;
    final m = (total - 1) % 12 + 1;
    final d = date.day.clamp(1, DateUtils.getDaysInMonth(y, m));
    return DateTime(y, m, d);
  }

  static DateTime _addCustomInterval(
    DateTime date,
    int interval,
    String unit,
  ) => switch (unit) {
    'weeks' => date.add(Duration(days: interval * 7)),
    'months' => _addMonths(date, interval),
    _ => date.add(Duration(days: interval)),
  };

  Future<void> _saveSplits(
    String transactionId,
    List<SplitEntry> splits,
  ) async {
    final validSplits = splits
        .where((s) => s.envelopeId != null && s.amountCents > 0)
        .toList();

    if (validSplits.isEmpty) return;

    await _transactionRepository.replaceSplits(
      transactionId: transactionId,
      splits: validSplits.map((s) {
        return TransactionSplit(
          id: '',
          transactionId: transactionId,
          envelopeId: s.envelopeId!,
          amount: s.amountCents,
        );
      }).toList(),
    );
  }

  Future<void> _saveTags(
    String transactionId,
    List<String> selectedTagIds,
  ) async {
    if (!isEditing) {
      for (final tagId in selectedTagIds) {
        await _transactionRepository.addTagToTransaction(
          transactionId: transactionId,
          tagId: tagId,
        );
      }
      return;
    }

    // Editing: diff the tags.
    final existing = await _transactionRepository.getTagIdsForTransaction(
      transactionId,
    );
    final toAdd = selectedTagIds.where((id) => !existing.contains(id)).toList();
    final toRemove = existing
        .where((id) => !selectedTagIds.contains(id))
        .toList();

    for (final tagId in toAdd) {
      await _transactionRepository.addTagToTransaction(
        transactionId: transactionId,
        tagId: tagId,
      );
    }
    for (final tagId in toRemove) {
      await _transactionRepository.removeTagFromTransaction(
        transactionId: transactionId,
        tagId: tagId,
      );
    }
  }

  Future<OverspendData?> _checkOverspend({
    required String type,
    required String? envelopeId,
    required bool isSplitMode,
    required List<SplitEntry> splits,
    String? accountId,
    String? periodId,
  }) async {
    final effectivePeriodId = periodId ?? budgetPeriodId;
    if (effectivePeriodId == null) return null;
    if (type != 'expense') return null;

    final affectedEnvelopeIds = <String>[];
    if (isSplitMode) {
      affectedEnvelopeIds.addAll(
        splits
            .where((s) => s.envelopeId != null && s.amountCents > 0)
            .map((s) => s.envelopeId!),
      );
    } else if (envelopeId != null) {
      affectedEnvelopeIds.add(envelopeId);
    }
    if (affectedEnvelopeIds.isEmpty) return null;

    try {
      final allocations = await _envelopeRepository
          .watchAllocations(effectivePeriodId)
          .first;

      EnvelopeAllocation? overspent;
      for (final envId in affectedEnvelopeIds) {
        final alloc = allocations
            .where((a) => a.envelopeId == envId)
            .firstOrNull;
        if (alloc != null && EnvelopeRepository.calculateRollover(alloc) < 0) {
          overspent = alloc;
          break;
        }
      }
      if (overspent == null) return null;

      final available = EnvelopeRepository.calculateRollover(overspent);
      final envelopeName =
          state.envelopes
              .where((e) => e.id == overspent!.envelopeId)
              .firstOrNull
              ?.name ??
          '';

      // Refresh envelopes for the cover dialog.
      final envelopes = await _envelopeRepository
          .watchEnvelopes(budgetId)
          .first;

      var readyToAssign = 0;
      try {
        readyToAssign = await _budgetRepository.calculateReadyToAssign(
          effectivePeriodId,
        );
      } on Exception {
        // Fallback to 0 if unavailable.
      }

      return OverspendData(
        envelopeName: envelopeName,
        deficitCents: available,
        overspentAllocation: overspent,
        allocations: allocations,
        envelopes: envelopes,
        readyToAssign: readyToAssign,
      );
    } on Exception {
      return null;
    }
  }

  // Ensures the CC Payment envelope has an allocation row for [budgetPeriodId]
  // so it appears in the budget page. No allocation amounts are changed —
  // CC Payment available is derived from transaction history (YNAB approach).
  Future<void> _transferToCCPaymentEnvelope({
    required String accountId,
    required String? envelopeId,
    required List<SplitEntry> splits,
    required int expenseAmount,
    required String budgetPeriodId,
  }) async {
    try {
      final account = state.accounts
          .where((a) => a.id == accountId)
          .firstOrNull;
      if (account == null || !isCreditCard(account.type)) return;

      final ccPaymentEnvelope = await _envelopeRepository
          .getEnvelopeByLinkedAccountId(accountId, budgetId);
      if (ccPaymentEnvelope == null) return;

      await _envelopeRepository.ensureAllocation(
        envelopeId: ccPaymentEnvelope.id,
        budgetPeriodId: budgetPeriodId,
      );
    } on Exception {
      // Best-effort; does not block transaction recording.
    }
  }

  /// Resolves the budget period containing [date], creating coverage if the
  /// transaction is dated outside existing periods. Falls back to the period
  /// the sheet opened with if resolution fails.
  Future<String?> _resolvePeriodForDate(DateTime date) async {
    try {
      final resolved = await _budgetRepository.ensurePeriodForDate(
        budgetId: budgetId,
        date: date,
      );
      return resolved ?? budgetPeriodId;
    } on BudgetException {
      return budgetPeriodId;
    }
  }
}
