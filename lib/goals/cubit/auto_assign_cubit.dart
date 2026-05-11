import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope/shared/services/funding_status_service.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'auto_assign_state.dart';

/// Drives the "auto-assign" flow: gathers Ready-to-Assign + per-goal needs
/// for the current period, asks [AutoAssignPlanner] to build a distribution,
/// and applies it on confirmation.
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
       _now = now ?? DateTime.now,
       _fundingStatus = FundingStatusService(clock: now ?? DateTime.now),
       super(const AutoAssignState());

  final BudgetRepository _budgetRepository;
  final EnvelopeRepository _envelopeRepository;
  final GoalRepository _goalRepository;
  final String _budgetId;
  final AutoAssignPlanner _planner;
  final FundingStatusService _fundingStatus;
  final DateTime Function() _now;

  /// Builds a preview distribution. Emits one of:
  ///   * [AutoAssignStatus.noTargets]      — no active goal has an unmet monthly need
  ///   * [AutoAssignStatus.insufficientRta] — RTA <= 0
  ///   * [AutoAssignStatus.preview]         — `actions` populated
  ///   * [AutoAssignStatus.failure]         — repository error
  Future<void> plan() async {
    emit(state.copyWith(status: AutoAssignStatus.planning, errorMessage: null));
    try {
      final period = await _resolveCurrentPeriod();
      if (isClosed) return;
      if (period == null) {
        emit(
          state.copyWith(
            status: AutoAssignStatus.failure,
            errorMessage: 'No active budget period.',
          ),
        );
        return;
      }

      final rta = await _budgetRepository.calculateReadyToAssign(period.id);
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
        for (final a
            in await _envelopeRepository.watchAllocations(period.id).first)
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
          periodId: period.id,
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

  /// Applies the previewed [AutoAssignState.actions]. Continues on individual
  /// action failures so that as much of the plan as possible lands.
  Future<void> apply() async {
    if (state.status != AutoAssignStatus.preview) return;
    final periodId = state.periodId;
    if (periodId == null) return;

    emit(state.copyWith(status: AutoAssignStatus.applying));

    final existing = {
      for (final a in await _envelopeRepository.watchAllocations(periodId).first)
        a.envelopeId: a,
    };

    var failed = 0;
    for (final action in state.actions) {
      try {
        if (action.envelopeId != null) {
          final envelopeId = action.envelopeId!;
          final current = existing[envelopeId];
          if (current != null) {
            final updated = current.copyWith(
              allocatedAmount: current.allocatedAmount + action.addCents,
            );
            await _envelopeRepository.updateAllocation(updated);
            existing[envelopeId] = updated;
          } else {
            final created = await _envelopeRepository.allocate(
              envelopeId: envelopeId,
              budgetPeriodId: periodId,
              amount: action.addCents,
            );
            existing[envelopeId] = created;
          }
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

  Future<BudgetPeriod?> _resolveCurrentPeriod() async {
    final periods = await _budgetRepository.watchBudgetPeriods(_budgetId).first;
    if (periods.isEmpty) return null;
    final now = _now();
    final match = periods.where(
      (p) => !p.startDate.isAfter(now) && !p.endDate.isBefore(now),
    );
    if (match.isNotEmpty) return match.first;
    // Fallback: latest period.
    return periods.reduce(
      (a, b) => a.endDate.isAfter(b.endDate) ? a : b,
    );
  }
}
