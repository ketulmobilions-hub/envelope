import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/transactions/widgets/split_rows.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
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
  })  : _transactionRepository = transactionRepository,
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
      final accounts = await _accountRepository
          .watchAccounts(budgetId)
          .first;
      final envelopes = await _envelopeRepository
          .watchEnvelopes(budgetId)
          .first;
      final tags = await _transactionRepository.getTags(budgetId);

      var selectedTagIds = <String>[];
      var initialSplits = <SplitEntry>[];
      if (isEditing) {
        selectedTagIds = await _transactionRepository
            .getTagIdsForTransaction(transaction!.id);

        final splits = await _transactionRepository
            .getTransactionSplits(transaction!.id);
        
        initialSplits = splits
            .map((s) => SplitEntry(
                  envelopeId: s.envelopeId,
                  amountText: (s.amount / 100).toStringAsFixed(2),
                ))
            .toList();
      }

      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransactionFormStatus.loaded,
          accounts: accounts,
          envelopes: envelopes,
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
  }) async {
    emit(state.copyWith(status: TransactionFormStatus.submitting));
    try {
      String transactionId;

      if (isEditing) {
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
        transactionId = transaction!.id;
      } else {
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
        transactionId = created.id;
      }

      // Handle splits.
      if (isSplitMode) {
        await _saveSplits(transactionId, splits);
      }

      // Handle tags.
      await _saveTags(transactionId, selectedTagIds);

      // Update budget period income for income transactions.
      final oldIncome = (isEditing && transaction!.type == 'income')
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
          // Best-effort; budget income update is non-critical.
        }
      }

      // Refresh allocations so the local Drift cache reflects the updated
      // spent_amount computed by the database trigger.
      if (budgetPeriodId != null) {
        try {
          await _envelopeRepository.refreshAllocations(budgetPeriodId!);
        } on Exception {
          // Best-effort; Realtime will eventually sync.
        }
      }

      // Refresh accounts so current_balance reflects the database trigger update.
      try {
        await _accountRepository.refreshAccounts(budgetId);
      } on AccountException {
        // Best-effort; local cache will be corrected on next full sync.
      }

      // Check for overspend on expense transactions.
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
    final toAdd = selectedTagIds
        .where((id) => !existing.contains(id))
        .toList();
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
        if (alloc != null &&
            EnvelopeRepository.calculateRollover(alloc) < 0) {
          overspent = alloc;
          break;
        }
      }
      if (overspent == null) return null;

      final available = EnvelopeRepository.calculateRollover(overspent);
      final envelopeName = state.envelopes
              .where((e) => e.id == overspent!.envelopeId)
              .firstOrNull
              ?.name ??
          '';

      // Refresh envelopes for the cover dialog.
      final envelopes = await _envelopeRepository
          .watchEnvelopes(budgetId)
          .first;

      int readyToAssign = 0;
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
}
