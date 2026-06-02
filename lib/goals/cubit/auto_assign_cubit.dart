import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/shared/services/funding_status_service.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'auto_assign_state.dart';

/// Drives the "auto-assign" flow under the global allocation model: gathers
/// Ready-to-Assign + per-goal needs, asks [AutoAssignPlanner] to build a
/// distribution, and applies it on confirmation.
class AutoAssignCubit extends Cubit<AutoAssignState> {
  AutoAssignCubit({
    required BudgetRepository budgetRepository,
    required EnvelopeRepository envelopeRepository,
    required GoalRepository goalRepository,
    required String budgetId,
    AutoAssignPlanner planner = const AutoAssignPlanner(),
    DateTime Function()? now,
  }) : _budgetRepository = budgetRepository,
       _envelopeRepository = envelopeRepository,
       _goalRepository = goalRepository,
       _budgetId = budgetId,
       _planner = planner,
       _fundingStatus = FundingStatusService(clock: now ?? DateTime.now),
       super(const AutoAssignState());

  final BudgetRepository _budgetRepository;
  final EnvelopeRepository _envelopeRepository;
  final GoalRepository _goalRepository;
  final String _budgetId;
  final AutoAssignPlanner _planner;
  final FundingStatusService _fundingStatus;

  /// Builds a preview distribution.
  Future<void> plan() async {
    emit(state.copyWith(status: AutoAssignStatus.planning, errorMessage: null));
    try {
      final rta = await _budgetRepository.calculateReadyToAssign(_budgetId);
      if (isClosed) return;
      if (rta <= 0) {
        emit(state.copyWith(status: AutoAssignStatus.insufficientRta));
        return;
      }

      final goals = (await _goalRepository.watchGoals(_budgetId).first)
          .where((g) => !g.isCompleted)
          .toList()
        ..sort((a, b) {
          final byOrder = a.sortOrder.compareTo(b.sortOrder);
          return byOrder != 0 ? byOrder : a.id.compareTo(b.id);
        });

      final allocationsByEnvelope = <String, EnvelopeAllocation>{
        for (final a in await _envelopeRepository
            .watchAllocationsByBudgetId(_budgetId)
            .first)
          a.envelopeId: a,
      };

      final needed = <String, int>{};
      for (final goal in goals) {
        if (goal.envelopeId != null) {
          final allocated =
              allocationsByEnvelope[goal.envelopeId!]?.allocatedAmount ?? 0;
          needed[goal.id] = _fundingStatus.neededThisPeriod(
            allocatedCents: allocated,
            linkedGoals: [goal],
          );
        } else {
          needed[goal.id] = _fundingStatus.neededThisPeriodForGoal(goal);
        }
      }

      final actions = _planner.plan(
        goalsByPriority: goals,
        neededByGoalId: needed,
        rtaCents: rta,
      );

      if (isClosed) return;
      if (actions.isEmpty) {
        emit(state.copyWith(status: AutoAssignStatus.noTargets, rtaCents: rta));
        return;
      }

      emit(
        state.copyWith(
          status: AutoAssignStatus.preview,
          actions: actions,
          rtaCents: rta,
        ),
      );
    } on Exception catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: AutoAssignStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  /// Applies the previewed actions. Continues on individual action failures so
  /// that as much of the plan as possible lands.
  Future<void> apply() async {
    if (state.status != AutoAssignStatus.preview) return;

    emit(state.copyWith(status: AutoAssignStatus.applying));

    final existing = {
      for (final a in await _envelopeRepository
          .watchAllocationsByBudgetId(_budgetId)
          .first)
        a.envelopeId: a,
    };

    var failed = 0;
    for (final action in state.actions) {
      try {
        if (action.envelopeId != null) {
          final envelopeId = action.envelopeId!;
          final current = existing[envelopeId];
          final newAmount =
              (current?.allocatedAmount ?? 0) + action.addCents;
          final updated = await _envelopeRepository.allocate(
            envelopeId: envelopeId,
            amount: newAmount,
          );
          existing[envelopeId] = updated;
        } else {
          await _goalRepository.addContribution(
            goalId: action.goal.id,
            amountCents: action.addCents,
          );
        }
      } on Exception {
        failed += 1;
      }
    }

    if (isClosed) return;
    emit(
      state.copyWith(
        status: failed == 0
            ? AutoAssignStatus.success
            : AutoAssignStatus.failure,
        errorMessage: failed == 0
            ? null
            : 'Could not apply $failed of ${state.actions.length} actions.',
      ),
    );
  }

  /// Resets back to initial after a success / failure dialog dismiss.
  void reset() => emit(const AutoAssignState());
}
