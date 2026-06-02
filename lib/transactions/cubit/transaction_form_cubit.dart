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
  final Transaction? transaction;

  bool get isEditing => transaction != null;

  Future<void> _loadData() async {
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
    final selectedTagIdsFuture = isEditing
        ? safe(
            () => _transactionRepository.getTagIdsForTransaction(transaction!.id),
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
        selectedTagIds: selectedTagIds,
        initialSplits: initialSplits,
      ),
    );
  }

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
      final effectiveCurrency =
          currencyOverride ?? state.accounts.currencyForAccountId(accountId);

      if (isEditing) {
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

        await _refreshSideEffects();

        final overspendData = await _checkOverspend(
          type: type,
          envelopeId: envelopeId,
          isSplitMode: isSplitMode,
          splits: splits,
          accountId: accountId,
        );

        if (isClosed) return;
        emit(
          state.copyWith(
            status: overspendData != null
                ? TransactionFormStatus.successWithOverspend
                : TransactionFormStatus.success,
            overspendData: overspendData,
          ),
        );
        return;
      }

      if (isRecurring) {
        final nowVal = _now();
        final today = DateTime(nowVal.year, nowVal.month, nowVal.day);
        final selectedDay = DateTime(date.year, date.month, date.day);
        final isFutureDate = selectedDay.isAfter(today);

        if (isFutureDate) {
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
          return;
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

      if (isRecurring) {
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
      }

      await _refreshSideEffects();

      final overspendData = await _checkOverspend(
        type: type,
        envelopeId: envelopeId,
        isSplitMode: isSplitMode,
        splits: splits,
        accountId: accountId,
      );

      if (isClosed) return;
      emit(
        state.copyWith(
          status: overspendData != null
              ? TransactionFormStatus.successWithOverspend
              : TransactionFormStatus.success,
          overspendData: overspendData,
        ),
      );
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

  Future<void> _refreshSideEffects() async {
    try {
      await _envelopeRepository.refreshAllocations(budgetId);
    } on Exception {
      // Best-effort.
    }
    try {
      await _accountRepository.refreshAccounts(budgetId);
    } on AccountException {
      // Best-effort.
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
    final startDate = isFutureDate
        ? transactionDate
        : _nextOccurrenceAfter(
            from: transactionDate,
            frequency: state.recurringFrequency,
            customInterval: state.recurringCustomInterval,
            customUnit: state.recurringCustomUnit,
          );
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

    final existing = await _transactionRepository.getTagIdsForTransaction(
      transactionId,
    );
    final toAdd = selectedTagIds.where((id) => !existing.contains(id)).toList();
    final toRemove =
        existing.where((id) => !selectedTagIds.contains(id)).toList();

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
  }) async {
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
      var allocations = await _envelopeRepository
          .watchAllocationsByBudgetId(budgetId)
          .first;

      // Bulk spent lookup: one DB round-trip via Future.wait covers every
      // affected envelope. Treat a missing allocation row as a $0 baseline so
      // overspend on a never-allocated envelope is still surfaced.
      final spentByEnvelope = <String, int>{};
      await Future.wait(
        affectedEnvelopeIds.map(
          (id) async => spentByEnvelope[id] =
              await _envelopeRepository.sumSpentForEnvelope(id),
        ),
      );

      String? overspentEnvelopeId;
      int overspentAvailable = 0;
      for (final envId in affectedEnvelopeIds) {
        final alloc = allocations
            .where((a) => a.envelopeId == envId)
            .firstOrNull;
        final allocated = alloc?.allocatedAmount ?? 0;
        final spent = spentByEnvelope[envId] ?? 0;
        final available = allocated - spent;
        if (available < 0) {
          overspentEnvelopeId = envId;
          overspentAvailable = available;
          break;
        }
      }
      if (overspentEnvelopeId == null) return null;

      // Materialize a $0 allocation row if the envelope was never allocated to
      // — the cover dialog needs a real allocation to target.
      var overspent = allocations
          .where((a) => a.envelopeId == overspentEnvelopeId)
          .firstOrNull;
      if (overspent == null) {
        await _envelopeRepository.ensureAllocation(
          envelopeId: overspentEnvelopeId,
        );
        allocations = await _envelopeRepository
            .watchAllocationsByBudgetId(budgetId)
            .first;
        overspent = allocations
            .where((a) => a.envelopeId == overspentEnvelopeId)
            .firstOrNull;
        if (overspent == null) return null;
      }

      final overspentRow = overspent;
      final envelopeName = state.envelopes
              .where((e) => e.id == overspentRow.envelopeId)
              .firstOrNull
              ?.name ??
          '';

      final envelopes = await _envelopeRepository
          .watchEnvelopes(budgetId)
          .first;

      EnvelopeAllocation? ccPaymentAllocation;
      if (accountId != null) {
        final account =
            state.accounts.where((a) => a.id == accountId).firstOrNull;
        if (account != null && isCreditCard(account.type)) {
          try {
            final ccEnvelope = await _envelopeRepository
                .getEnvelopeByLinkedAccountId(accountId, budgetId);
            if (ccEnvelope != null) {
              ccPaymentAllocation =
                  await _envelopeRepository.getEnvelopeAllocation(ccEnvelope.id);
            }
          } on Exception {
            // Best-effort; omit CC Payment funding if lookup fails.
          }
        }
      }

      var readyToAssign = 0;
      try {
        readyToAssign =
            await _budgetRepository.calculateReadyToAssign(budgetId);
      } on Exception {
        // Best-effort; cover dialog falls back to envelope-only sources.
      }

      return OverspendData(
        envelopeName: envelopeName,
        deficitCents: overspentAvailable,
        overspentAllocation: overspent,
        allocations: allocations,
        envelopes: envelopes,
        readyToAssign: readyToAssign,
        ccPaymentAllocation: ccPaymentAllocation,
      );
    } on Exception {
      return null;
    }
  }
}
