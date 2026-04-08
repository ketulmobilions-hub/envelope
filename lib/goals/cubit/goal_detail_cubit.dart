import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'goal_detail_state.dart';

class GoalDetailCubit extends Cubit<GoalDetailState> {
  GoalDetailCubit({
    required GoalRepository goalRepository,
    required Goal goal,
  }) : _goalRepository = goalRepository,
       super(GoalDetailState(goal: goal)) {
    _contributionsSubscription = _goalRepository
        .watchContributions(goal.id)
        .listen(
          (contributions) => emit(state.copyWith(contributions: contributions)),
        );
    _goalRepository.refreshContributions(goal.id).ignore();
  }

  final GoalRepository _goalRepository;
  StreamSubscription<List<GoalContribution>>? _contributionsSubscription;

  Future<void> refresh() async {
    try {
      final updated = await _goalRepository.getGoal(state.goal.id);
      emit(state.copyWith(goal: updated));
    } on GoalException {
      // Keep current data if refresh fails.
    }
  }

  Future<void> toggleComplete() async {
    emit(state.copyWith(status: GoalDetailStatus.submitting));
    try {
      if (state.goal.isCompleted) {
        await _goalRepository.uncompleteGoal(state.goal.id);
      } else {
        await _goalRepository.completeGoal(state.goal.id);
      }
      final refreshed = await _goalRepository.getGoal(state.goal.id);
      emit(
        state.copyWith(
          status: GoalDetailStatus.completed,
          goal: refreshed,
        ),
      );
    } on GoalException catch (e) {
      emit(
        state.copyWith(
          status: GoalDetailStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
    emit(state.copyWith(status: GoalDetailStatus.idle, errorMessage: null));
  }

  Future<void> addContribution(int amountCents) async {
    emit(state.copyWith(status: GoalDetailStatus.submitting));
    try {
      await _goalRepository.addContribution(
        goalId: state.goal.id,
        amountCents: amountCents,
      );
      final refreshed = await _goalRepository.getGoal(state.goal.id);
      emit(
        state.copyWith(
          status: GoalDetailStatus.contributed,
          goal: refreshed,
        ),
      );
    } on GoalException catch (e) {
      emit(
        state.copyWith(
          status: GoalDetailStatus.failure,
          errorMessage: e.message,
        ),
      );
    }
    emit(state.copyWith(status: GoalDetailStatus.idle, errorMessage: null));
  }

  Future<void> deleteContribution(GoalContribution contribution) async {
    emit(state.copyWith(status: GoalDetailStatus.submitting));
    try {
      await _goalRepository.removeContribution(contribution);
      final refreshed = await _goalRepository.getGoal(state.goal.id);
      emit(state.copyWith(status: GoalDetailStatus.idle, goal: refreshed));
    } on GoalException catch (e) {
      emit(
        state.copyWith(
          status: GoalDetailStatus.failure,
          errorMessage: e.message,
        ),
      );
      emit(state.copyWith(status: GoalDetailStatus.idle, errorMessage: null));
    }
  }

  Future<void> delete() async {
    emit(state.copyWith(status: GoalDetailStatus.submitting));
    try {
      await _goalRepository.deleteGoal(state.goal.id);
      emit(state.copyWith(status: GoalDetailStatus.deleted));
    } on GoalException catch (e) {
      emit(
        state.copyWith(
          status: GoalDetailStatus.failure,
          errorMessage: e.message,
        ),
      );
      emit(state.copyWith(status: GoalDetailStatus.idle, errorMessage: null));
    }
  }

  @override
  Future<void> close() async {
    await _contributionsSubscription?.cancel();
    return super.close();
  }
}
