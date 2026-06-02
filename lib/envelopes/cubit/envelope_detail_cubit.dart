import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'envelope_detail_state.dart';

class EnvelopeDetailCubit extends Cubit<EnvelopeDetailState> {
  EnvelopeDetailCubit({
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required BudgetRepository budgetRepository,
    required AccountRepository accountRepository,
    required Envelope envelope,
    DateTime Function()? now,
  }) : _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _budgetRepository = budgetRepository,
       _accountRepository = accountRepository,
       _now = now ?? DateTime.now,
       super(EnvelopeDetailState(envelope: envelope)) {
    _transactionSubscription = transactionRepository
        .watchTransactions(
          budgetId: envelope.budgetId,
          accountId: envelope.linkedAccountId,
          envelopeId: envelope.linkedAccountId == null ? envelope.id : null,
        )
        .listen((txns) {
          if (isClosed) return;
          emit(state.copyWith(transactions: txns));
        });

    _allocationsSubscription = _envelopeRepository
        .watchAllocationsForEnvelope(envelope.id)
        .listen((allocations) {
          if (isClosed) return;
          emit(state.copyWith(allocations: allocations));
        });

    _periodsSubscription = _budgetRepository
        .watchBudgetPeriods(envelope.budgetId)
        .listen((periods) {
          if (isClosed) return;
          emit(
            state.copyWith(
              periods: periods,
              currentPeriodId: _selectCurrentPeriodId(periods),
            ),
          );
        });

    // CC Payment envelope: track the linked credit-card account's balance and
    // credit limit so the detail header can show available-credit / due
    // instead of the (meaningless here) allocated/spent figures.
    final linkedAccountId = envelope.linkedAccountId;
    if (linkedAccountId != null) {
      _accountsSubscription = _accountRepository
          .watchAccounts(envelope.budgetId)
          .listen((accounts) {
            if (isClosed) return;
            final linked = accounts
                .where((a) => a.id == linkedAccountId)
                .firstOrNull;
            if (linked != null) emit(state.copyWith(linkedAccount: linked));
          });
      unawaited(_loadCreditLimit(linkedAccountId));
    }

    unawaited(_refreshTransactions());
  }

  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  final BudgetRepository _budgetRepository;
  final AccountRepository _accountRepository;
  final DateTime Function() _now;
  StreamSubscription<List<Transaction>>? _transactionSubscription;
  StreamSubscription<List<BudgetPeriod>>? _periodsSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;

  Future<void> _loadCreditLimit(String accountId) async {
    try {
      final debt = await _accountRepository.getDebtAccount(accountId);
      if (isClosed) return;
      emit(state.copyWith(ccCreditLimit: debt?.creditLimit));
    } on Exception {
      // Best-effort; header falls back to the "due" view without a limit.
    }
  }

  String? _selectCurrentPeriodId(List<BudgetPeriod> periods) {
    if (periods.isEmpty) return null;
    final now = _now();
    final containing = BudgetRepository.periodForDate<BudgetPeriod>(
      now,
      periods,
      startDate: (p) => p.startDate,
      endDate: (p) => p.endDate,
    );
    if (containing != null) return containing.id;
    // Fallback mirrors the previous behavior: latest non-closed period, or
    // the most recent period overall.
    final sorted = [...periods]
      ..sort((a, b) => a.startDate.compareTo(b.startDate));
    final openFallback = sorted.where((p) => !p.isClosed).lastOrNull;
    return (openFallback ?? sorted.last).id;
  }

  Future<void> _refreshTransactions() async {
    try {
      await _transactionRepository.refreshTransactions(state.envelope.budgetId);
    } on TransactionException {
      // Keep showing whatever is cached if refresh fails.
    }
  }

  /// Refreshes the envelope data from the repository.
  Future<void> refresh() async {
    try {
      final updated = await _envelopeRepository.getEnvelope(state.envelope.id);
      emit(state.copyWith(envelope: updated));
    } on EnvelopeException {
      // Keep current data if refresh fails.
    }
  }

  /// Deletes the envelope from the repository.
  /// Returns `true` on success, `false` on failure.
  Future<bool> deleteEnvelope() async {
    try {
      await _envelopeRepository.deleteEnvelope(state.envelope.id);
      return true;
    } on EnvelopeException {
      return false;
    }
  }

  @override
  Future<void> close() async {
    await _transactionSubscription?.cancel();
    await _periodsSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _accountsSubscription?.cancel();
    return super.close();
  }
}
