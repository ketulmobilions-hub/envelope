import 'dart:math' show min, max;

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
  }) : _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       _budgetRepository = budgetRepository,
       super(const TransactionFormState()) {
    _loadData();
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository _envelopeRepository;
  final BudgetRepository _budgetRepository;
  final String budgetId;
  final String userId;
  final String? budgetPeriodId;
  final Transaction? transaction;

  bool get isEditing => transaction != null;

  Future<void> _loadData() async {
    try {
      final accounts = await _accountRepository.watchAccounts(budgetId).first;
      final envelopes = await _envelopeRepository
          .watchEnvelopes(budgetId)
          .first;
      final categoryGroups = await _envelopeRepository
          .watchCategoryGroups(budgetId)
          .first;
      final tags = await _transactionRepository.getTags(budgetId);

      var selectedTagIds = <String>[];
      var initialSplits = <SplitEntry>[];
      if (isEditing) {
        selectedTagIds = await _transactionRepository.getTagIdsForTransaction(
          transaction!.id,
        );

        final splits = await _transactionRepository.getTransactionSplits(
          transaction!.id,
        );

        initialSplits = splits
            .map(
              (s) => SplitEntry(
                envelopeId: s.envelopeId,
                amountText: (s.amount / 100).toStringAsFixed(2),
              ),
            )
            .toList();
      }

      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransactionFormStatus.loaded,
          accounts: accounts,
          envelopes: envelopes,
          categoryGroups: categoryGroups,
          tags: tags,
          selectedTagIds: selectedTagIds,
          initialSplits: initialSplits,
        ),
      );
    } on Exception {
      if (isClosed) return;
      emit(state.copyWith(status: TransactionFormStatus.loaded));
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
  }) async {
    emit(state.copyWith(status: TransactionFormStatus.submitting));
    try {
      if (isEditing) {
        // ── Edit existing transaction ──────────────────────────────────────
        final updated = transaction!.copyWith(
          type: type,
          accountId: accountId,
          envelopeId: isSplitMode ? null : envelopeId,
          amount: amountCents,
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

        // Income delta for edits.
        final oldIncome = transaction!.type == 'income'
            ? transaction!.amount
            : 0;
        final newIncome = type == 'income' ? amountCents : 0;
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
        final today = DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
        );
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

          final created = await _transactionRepository.createTransaction(
            budgetId: budgetId,
            accountId: accountId,
            type: type,
            amount: amountCents,
            currency: 'USD',
            date: date,
            createdBy: userId,
            envelopeId: isSplitMode ? null : envelopeId,
            payee: payee,
            notes: notes,
          );
          final transactionId = created.id;

          if (isSplitMode) {
            await _saveSplits(transactionId, splits);
          }
          await _saveTags(transactionId, selectedTagIds);

          final newIncome = type == 'income' ? amountCents : 0;
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
          );

          final overspendData = await _checkOverspend(
            type: type,
            envelopeId: envelopeId,
            isSplitMode: isSplitMode,
            splits: splits,
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
          );

          if (isClosed) return;
          emit(state.copyWith(status: TransactionFormStatus.success));
        }
      } else {
        // ── Create one-off transaction ─────────────────────────────────────

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

        final created = await _transactionRepository.createTransaction(
          budgetId: budgetId,
          accountId: accountId,
          type: type,
          amount: amountCents,
          currency: 'USD',
          date: date,
          createdBy: userId,
          envelopeId: isSplitMode ? null : envelopeId,
          payee: payee,
          notes: notes,
        );
        final transactionId = created.id;

        if (isSplitMode) {
          await _saveSplits(transactionId, splits);
        }
        await _saveTags(transactionId, selectedTagIds);

        final newIncome = type == 'income' ? amountCents : 0;
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
          );
        }

        final overspendData = await _checkOverspend(
          type: type,
          envelopeId: envelopeId,
          isSplitMode: isSplitMode,
          splits: splits,
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
    await _transactionRepository.createRecurringRule(
      budgetId: budgetId,
      accountId: accountId,
      type: type,
      amount: amountCents,
      currency: 'USD',
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
  }) async {
    final periodId = budgetPeriodId;
    if (periodId == null) return null;
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
          .watchAllocations(periodId)
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
          periodId,
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

  // When a CC expense is recorded, moves funds from the spending envelope
  // allocation to the linked CC Payment envelope allocation (best-effort).
  Future<void> _transferToCCPaymentEnvelope({
    required String accountId,
    required String? envelopeId,
    required List<SplitEntry> splits,
    required int expenseAmount,
  }) async {
    try {
      final account = state.accounts.where((a) => a.id == accountId).firstOrNull;
      if (account == null || !isCreditCard(account.type)) return;

      final ccPaymentEnvelope = await _envelopeRepository
          .getEnvelopeByLinkedAccountId(accountId, budgetId);
      if (ccPaymentEnvelope == null || budgetPeriodId == null) return;

      await _envelopeRepository.ensureAllocation(
        envelopeId: ccPaymentEnvelope.id,
        budgetPeriodId: budgetPeriodId!,
      );

      if (splits.isEmpty && envelopeId != null) {
        await _transferSingleEnvelopeToCCPayment(
          spendingEnvelopeId: envelopeId,
          ccPaymentEnvelopeId: ccPaymentEnvelope.id,
          expenseAmount: expenseAmount,
        );
      } else {
        for (final split in splits) {
          if (split.envelopeId != null && split.amountCents > 0) {
            await _transferSingleEnvelopeToCCPayment(
              spendingEnvelopeId: split.envelopeId!,
              ccPaymentEnvelopeId: ccPaymentEnvelope.id,
              expenseAmount: split.amountCents,
            );
          }
        }
      }
    } on Exception {
      // Best-effort; does not block transaction recording.
    }
  }

  Future<void> _transferSingleEnvelopeToCCPayment({
    required String spendingEnvelopeId,
    required String ccPaymentEnvelopeId,
    required int expenseAmount,
  }) async {
    final spendingAlloc = await _envelopeRepository
        .getEnvelopeAllocationByEnvelopeAndPeriod(
          envelopeId: spendingEnvelopeId,
          budgetPeriodId: budgetPeriodId!,
        );
    if (spendingAlloc == null) return;

    final ccPaymentAlloc = await _envelopeRepository
        .getEnvelopeAllocationByEnvelopeAndPeriod(
          envelopeId: ccPaymentEnvelopeId,
          budgetPeriodId: budgetPeriodId!,
        );
    if (ccPaymentAlloc == null) return;

    // spentAmount already includes this expense (DB trigger ran before we get
    // here), so available = allocated - spent (no adjustment needed).
    final available = max(0, EnvelopeRepository.calculateRollover(spendingAlloc));
    final transferAmount = min(expenseAmount, available);
    if (transferAmount <= 0) return;

    await _budgetRepository.transferBetweenEnvelopes(
      fromAllocationId: spendingAlloc.id,
      toAllocationId: ccPaymentAlloc.id,
      amount: transferAmount,
    );
  }
}
