import 'dart:async';

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
    required Envelope envelope,
    EnvelopeAllocation? allocation,
    DateTime Function()? now,
  }) : _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _budgetRepository = budgetRepository,
       _now = now ?? DateTime.now,
       super(
         EnvelopeDetailState(
           envelope: envelope,
           allocation: allocation,
         ),
       ) {
    _transactionSubscription = transactionRepository
        .watchTransactions(
          budgetId: envelope.budgetId,
          accountId: envelope.linkedAccountId,
          envelopeId: envelope.linkedAccountId == null ? envelope.id : null,
        )
        .listen((txns) {
          if (_initialTransactionsLoaded && _currentPeriodId != null) {
            unawaited(_refreshAllocations());
          }
          _initialTransactionsLoaded = true;
          emit(state.copyWith(transactions: txns));
        });

    _periodsSubscription = _budgetRepository
        .watchBudgetPeriods(envelope.budgetId)
        .listen((periods) {
          final sortedPeriods = [...periods]
            ..sort((a, b) => a.startDate.compareTo(b.startDate));

          BudgetPeriod? selected;
          if (sortedPeriods.isNotEmpty) {
            final now = _now();
            selected = sortedPeriods.firstWhere(
              (p) =>
                  !p.isClosed &&
                  !p.startDate.isAfter(now) &&
                  !p.endDate.isBefore(now),
              orElse: () =>
                  sortedPeriods.where((p) => !p.isClosed).lastOrNull ??
                  sortedPeriods.last,
            );
          }

          if (selected != null && _currentPeriodId != selected.id) {
            _currentPeriodId = selected.id;
            _allocationsSubscription?.cancel();
            _allocationsSubscription = _envelopeRepository
                .watchAllocations(selected.id)
                .listen((allocations) {
                  final alloc = allocations
                      .where((a) => a.envelopeId == envelope.id)
                      .firstOrNull;
                  emit(state.copyWith(allocation: alloc));
                });
          }
        });
    unawaited(_refreshTransactions());
  }

  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  final BudgetRepository _budgetRepository;
  final DateTime Function() _now;
  StreamSubscription<List<Transaction>>? _transactionSubscription;
  StreamSubscription<List<BudgetPeriod>>? _periodsSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  String? _currentPeriodId;
  bool _initialTransactionsLoaded = false;

  Future<void> _refreshTransactions() async {
    try {
      await _transactionRepository.refreshTransactions(state.envelope.budgetId);
    } on TransactionException {
      // Keep showing whatever is cached if refresh fails.
    }
  }

  Future<void> _refreshAllocations() async {
    final periodId = _currentPeriodId;
    if (periodId == null) return;
    try {
      await _envelopeRepository.refreshAllocations(periodId);
    } on EnvelopeException {
      // Keep cached data if refresh fails.
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
    return super.close();
  }
}
