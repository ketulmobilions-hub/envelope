import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
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
    required BudgetRepository budgetRepository,
    required TransactionRepository transactionRepository,
    required String budgetId,
  }) : _goalRepository = goalRepository,
       _envelopeRepository = envelopeRepository,
       _budgetRepository = budgetRepository,
       _transactionRepository = transactionRepository,
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
  final BudgetRepository _budgetRepository;
  final TransactionRepository _transactionRepository;
  final String _budgetId;

  StreamSubscription<List<Goal>>? _goalsSubscription;
  StreamSubscription<List<BudgetPeriod>>? _periodsSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;

  String? _watchedPeriodId;
  List<EnvelopeAllocation> _currentAllocations = const [];
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

    _initEnvelopeWatchers();

    try {
      await _goalRepository.refreshGoals(_budgetId);
    } on GoalException {
      // Local watch will still show cached data.
    }
  }

  void _initEnvelopeWatchers() {
    _periodsSubscription?.cancel().ignore();
    _periodsSubscription = _budgetRepository
        .watchBudgetPeriods(_budgetId)
        .listen((periods) {
          _watchPeriodAllocations(_pickCurrentPeriod(periods)?.id);
        });

    _transactionsSubscription?.cancel().ignore();
    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen((txs) {
          _allTransactions = txs;
          add(const _GoalsRecomputeRequested());
        });
  }

  static BudgetPeriod? _pickCurrentPeriod(List<BudgetPeriod> periods) {
    if (periods.isEmpty) return null;
    final now = DateTime.now();
    final containing = periods
        .where(
          (p) => !p.startDate.isAfter(now) && !p.endDate.isBefore(now),
        )
        .firstOrNull;
    if (containing != null) return containing;
    // Fallback: latest period by end date — matches BudgetBloc selection so
    // allocations land on the same period goals are reading from.
    return periods.reduce((a, b) => a.endDate.isAfter(b.endDate) ? a : b);
  }

  void _watchPeriodAllocations(String? periodId) {
    if (periodId == _watchedPeriodId) return;
    _watchedPeriodId = periodId;
    _allocationsSubscription?.cancel().ignore();
    if (periodId == null) {
      _currentAllocations = const [];
      add(const _GoalsRecomputeRequested());
      return;
    }
    _allocationsSubscription = _envelopeRepository
        .watchAllocations(periodId)
        .listen((allocs) {
          _currentAllocations = allocs;
          add(const _GoalsRecomputeRequested());
        });
  }

  void _onUpdated(
    _GoalsUpdated event,
    Emitter<GoalsState> emit,
  ) {
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
    final linked = goals.where((g) => g.envelopeId != null);
    if (linked.isEmpty) return const {};

    final amounts = <String, int>{};
    for (final goal in linked) {
      final allocation = _currentAllocations
          .where((a) => a.envelopeId == goal.envelopeId)
          .firstOrNull;
      final envTxs = goal.type == 'debt_payoff'
          ? _allTransactions.where((t) => t.envelopeId == goal.envelopeId)
          : const <Transaction>[];
      amounts[goal.id] = GoalProgressCalculator.compute(
        goal: goal,
        allocation: allocation,
        envelopeTransactions: envTxs,
      );
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
    await _periodsSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}
