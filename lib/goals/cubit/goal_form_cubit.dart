import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'goal_form_state.dart';

class GoalFormCubit extends Cubit<GoalFormState> {
  GoalFormCubit({
    required GoalRepository goalRepository,
    required this.budgetId,
    this.goal,
  }) : _goalRepository = goalRepository,
       super(const GoalFormState());

  final GoalRepository _goalRepository;
  final String budgetId;
  final Goal? goal;

  bool get isEditing => goal != null;

  Future<void> submit({
    required String name,
    required String type,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
  }) async {
    emit(state.copyWith(status: GoalFormStatus.submitting));
    try {
      if (isEditing) {
        final updated = goal!.copyWith(
          name: name,
          type: type,
          targetAmount: targetAmount,
          targetDate: targetDate,
          monthlyContribution: monthlyContribution,
          updatedAt: DateTime.now(),
        );
        await _goalRepository.updateGoal(updated);
      } else {
        await _goalRepository.createGoal(
          budgetId: budgetId,
          name: name,
          type: type,
          targetAmount: targetAmount,
          targetDate: targetDate,
          monthlyContribution: monthlyContribution,
        );
      }
      emit(state.copyWith(status: GoalFormStatus.success));
    } on GoalException catch (e) {
      emit(
        state.copyWith(
          status: GoalFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: GoalFormStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
