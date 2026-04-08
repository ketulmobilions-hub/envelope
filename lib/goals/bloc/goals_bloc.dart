import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'goals_event.dart';
part 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  GoalsBloc({
    required GoalRepository goalRepository,
    required String budgetId,
  })  : _goalRepository = goalRepository,
        _budgetId = budgetId,
        super(const GoalsState()) {
    on<GoalsStarted>(_onStarted);
    on<_GoalsUpdated>(_onUpdated);
    on<_GoalsStreamError>(_onStreamError);
    on<GoalsRefreshRequested>(_onRefreshRequested);
    on<GoalDeleted>(_onDeleted);
    on<GoalCompleteToggled>(_onCompleteToggled);
  }

  final GoalRepository _goalRepository;
  final String _budgetId;
  StreamSubscription<List<Goal>>? _goalsSubscription;

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

    try {
      await _goalRepository.refreshGoals(_budgetId);
    } on GoalException {
      // Local watch will still show cached data.
    }
  }

  void _onUpdated(
    _GoalsUpdated event,
    Emitter<GoalsState> emit,
  ) {
    emit(
      state.copyWith(
        status: GoalsStatus.loaded,
        goals: event.goals,
      ),
    );
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
    return super.close();
  }
}
