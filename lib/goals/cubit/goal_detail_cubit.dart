import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:envelope/goals/services/goal_progress_calculator.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'goal_detail_state.dart';

class GoalDetailCubit extends Cubit<GoalDetailState> {
  GoalDetailCubit({
    required GoalRepository goalRepository,
    required EnvelopeRepository envelopeRepository,
    required TransactionRepository transactionRepository,
    required Goal goal,
  }) : _goalRepository = goalRepository,
       _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       super(GoalDetailState(goal: goal)) {
    if (goal.envelopeId == null) {
      _contributionsSubscription = _goalRepository
          .watchContributions(goal.id)
          .listen(
            (contributions) =>
                emit(state.copyWith(contributions: contributions)),
          );
      _goalRepository.refreshContributions(goal.id).ignore();
    } else {
      _initLinkedWatchers();
    }
  }

  final GoalRepository _goalRepository;
  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;

  StreamSubscription<List<GoalContribution>>? _contributionsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;

  List<EnvelopeAllocation> _envelopeAllocations = const [];
  List<Transaction> _envelopeTransactions = const [];

  void _initLinkedWatchers() {
    final envelopeId = state.goal.envelopeId!;
    final budgetId = state.goal.budgetId;

    _envelopesSubscription = _envelopeRepository
        .watchEnvelopes(budgetId)
        .listen((envelopes) {
          final match = envelopes
              .where((e) => e.id == envelopeId)
              .firstOrNull;
          emit(state.copyWith(linkedEnvelopeName: match?.name));
        });

    _allocationsSubscription = _envelopeRepository
        .watchAllocationsForEnvelope(envelopeId)
        .listen((allocs) {
          _envelopeAllocations = allocs;
          _recompute();
        });

    if (state.goal.type == 'debt_payoff') {
      _transactionsSubscription = _transactionRepository
          .watchTransactions(budgetId: budgetId, envelopeId: envelopeId)
          .listen((txs) {
            _envelopeTransactions = txs;
            _recompute();
          });
    }
  }

  void _recompute() {
    final amount = GoalProgressCalculator.compute(
      goal: state.goal,
      envelopeAllocations: _envelopeAllocations,
      envelopeTransactions: _envelopeTransactions,
    );
    emit(state.copyWith(computedCurrentAmount: amount));
  }

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
    await _envelopesSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    return super.close();
  }
}
