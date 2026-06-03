import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:envelope/goals/services/goal_progress_calculator.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  GoalsBloc({
    required GoalRepository goalRepository,
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
    required String budgetId,
  }) : _goalRepository = goalRepository,
       _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _budgetId = budgetId,
       super(const GoalsState()) {
    on<GoalsStarted>(_onStarted);
    on<_GoalsUpdated>(_onUpdated);
    on<_GoalsRecomputeRequested>(_onRecomputeRequested);
    on<_GoalsStreamError>(_onStreamError);
    on<GoalsRefreshRequested>(_onRefreshRequested);
    on<GoalDeleted>(_onDeleted);
    on<GoalCompleteToggled>(_onCompleteToggled);
  }

  final GoalRepository _goalRepository;
  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final String _budgetId;

  StreamSubscription<List<Goal>>? _goalsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;
  final Map<String, StreamSubscription<List<EnvelopeAllocation>>>
  _envelopeSubscriptions = {};
  final Map<String, List<EnvelopeAllocation>> _envelopeAllocations = {};
  final Map<String, Account> _accountsById = {};
  List<Transaction> _allTransactions = const [];

  String get budgetId => _budgetId;

  Future<void> _onStarted(
    GoalsStarted event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.loading));

    await _goalsSubscription?.cancel();
    _goalsSubscription = _goalRepository
        .watchGoals(_budgetId)
        .listen(
          (goals) => add(_GoalsUpdated(goals)),
          onError: (Object _) => add(const _GoalsStreamError()),
        );

    _transactionsSubscription?.cancel().ignore();
    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen((txs) {
          _allTransactions = txs;
          add(const _GoalsRecomputeRequested());
        });

    // Account balances drive account-linked goal progress.
    _accountsSubscription?.cancel().ignore();
    _accountsSubscription = _accountRepository
        .watchAccounts(_budgetId)
        .listen((accounts) {
          _accountsById
            ..clear()
            ..addEntries(accounts.map((a) => MapEntry(a.id, a)));
          add(const _GoalsRecomputeRequested());
        });

    try {
      await _goalRepository.refreshGoals(_budgetId);
    } on GoalException {
      // Local watch will still show cached data.
    }
  }

  void _syncEnvelopeSubscriptions(List<Goal> goals) {
    final needed = goals
        .where((g) => g.envelopeId != null)
        .map((g) => g.envelopeId!)
        .toSet();

    for (final id in _envelopeSubscriptions.keys.toList()) {
      if (!needed.contains(id)) {
        _envelopeSubscriptions.remove(id)?.cancel().ignore();
        _envelopeAllocations.remove(id);
      }
    }

    for (final id in needed) {
      if (_envelopeSubscriptions.containsKey(id)) continue;
      _envelopeSubscriptions[id] = _envelopeRepository
          .watchAllocationsForEnvelope(id)
          .listen((allocs) {
            _envelopeAllocations[id] = allocs;
            add(const _GoalsRecomputeRequested());
          });
    }
  }

  void _onUpdated(
    _GoalsUpdated event,
    Emitter<GoalsState> emit,
  ) {
    _syncEnvelopeSubscriptions(event.goals);
    emit(
      state.copyWith(
        status: GoalsStatus.loaded,
        goals: event.goals,
        computedAmounts: _computeAmounts(event.goals),
      ),
    );
  }

  void _onRecomputeRequested(
    _GoalsRecomputeRequested event,
    Emitter<GoalsState> emit,
  ) {
    if (state.goals.isEmpty) return;
    emit(state.copyWith(computedAmounts: _computeAmounts(state.goals)));
  }

  Map<String, int> _computeAmounts(List<Goal> goals) {
    final amounts = <String, int>{};
    for (final goal in goals) {
      if (goal.accountId != null) {
        // Account-linked: progress = the linked account's base-currency
        // balance. Skip if the account isn't loaded yet.
        final account = _accountsById[goal.accountId];
        if (account == null) continue;
        amounts[goal.id] = GoalProgressCalculator.compute(
          goal: goal,
          accountBalance:
              (account.currentBalance * account.displayFxRate).round(),
        );
      } else if (goal.envelopeId != null) {
        final envelopeAllocs =
            _envelopeAllocations[goal.envelopeId] ?? const [];
        final envTxs = goal.type == 'debt_payoff'
            ? _allTransactions.where((t) => t.envelopeId == goal.envelopeId)
            : const <Transaction>[];
        amounts[goal.id] = GoalProgressCalculator.compute(
          goal: goal,
          envelopeAllocations: envelopeAllocs,
          envelopeTransactions: envTxs,
        );
      }
    }
    return amounts;
  }

  void _onStreamError(
    _GoalsStreamError event,
    Emitter<GoalsState> emit,
  ) {
    emit(
      state.copyWith(
        status: GoalsStatus.error,
        error: GoalsError.loadFailed,
      ),
    );
    emit(state.copyWith(status: GoalsStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    GoalsRefreshRequested event,
    Emitter<GoalsState> emit,
  ) async {
    emit(state.copyWith(status: GoalsStatus.refreshing));
    try {
      await _goalRepository.refreshGoals(_budgetId);
    } on GoalException {
      // Stream will update on its own if data changes.
    } finally {
      emit(state.copyWith(status: GoalsStatus.loaded));
    }
  }

  Future<void> _onCompleteToggled(
    GoalCompleteToggled event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      if (event.goal.isCompleted) {
        await _goalRepository.uncompleteGoal(event.goal.id);
      } else {
        await _goalRepository.completeGoal(event.goal.id);
      }
    } on GoalException {
      emit(
        state.copyWith(
          status: GoalsStatus.error,
          error: GoalsError.updateFailed,
        ),
      );
      emit(state.copyWith(status: GoalsStatus.loaded, error: null));
    }
  }

  Future<void> _onDeleted(
    GoalDeleted event,
    Emitter<GoalsState> emit,
  ) async {
    try {
      await _goalRepository.deleteGoal(event.goalId);
    } on GoalException {
      emit(
        state.copyWith(
          status: GoalsStatus.error,
          error: GoalsError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: GoalsStatus.loaded, error: null));
    }
  }

  @override
  Future<void> close() async {
    await _goalsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    await _accountsSubscription?.cancel();
    for (final sub in _envelopeSubscriptions.values) {
      await sub.cancel();
    }
    _envelopeSubscriptions.clear();
    return super.close();
  }
}
