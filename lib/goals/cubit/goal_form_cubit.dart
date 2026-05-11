import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'goal_form_state.dart';

class GoalFormCubit extends Cubit<GoalFormState> {
  GoalFormCubit({
    required GoalRepository goalRepository,
    required EnvelopeRepository envelopeRepository,
    required this.budgetId,
    this.goal,
  }) : _goalRepository = goalRepository,
       _envelopeRepository = envelopeRepository,
       super(GoalFormState(envelopeId: goal?.envelopeId)) {
    _envelopesSub = _envelopeRepository.watchEnvelopes(budgetId).listen(
      (envelopes) => emit(
        state.copyWith(envelopes: envelopes, envelopesLoading: false),
      ),
    );
  }

  final GoalRepository _goalRepository;
  final EnvelopeRepository _envelopeRepository;
  final String budgetId;
  final Goal? goal;
  StreamSubscription<List<Envelope>>? _envelopesSub;

  bool get isEditing => goal != null;

  void envelopeChanged(String? envelopeId) {
    emit(state.copyWith(envelopeId: envelopeId));
  }

  Future<void> submit({
    required String name,
    required String type,
    int? targetAmount,
    DateTime? targetDate,
    int? monthlyContribution,
    int? aprBps,
    int? minPaymentCents,
  }) async {
    emit(state.copyWith(status: GoalFormStatus.submitting));
    try {
      if (isEditing) {
        final updated = goal!.copyWith(
          name: name,
          type: type,
          envelopeId: state.envelopeId,
          targetAmount: targetAmount,
          targetDate: targetDate,
          monthlyContribution: monthlyContribution,
          aprBps: aprBps,
          minPaymentCents: minPaymentCents,
          updatedAt: DateTime.now(),
        );
        await _goalRepository.updateGoal(updated);
      } else {
        await _goalRepository.createGoal(
          budgetId: budgetId,
          name: name,
          type: type,
          envelopeId: state.envelopeId,
          targetAmount: targetAmount,
          targetDate: targetDate,
          monthlyContribution: monthlyContribution,
          aprBps: aprBps,
          minPaymentCents: minPaymentCents,
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

  @override
  Future<void> close() async {
    await _envelopesSub?.cancel();
    return super.close();
  }
}
