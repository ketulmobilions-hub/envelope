import 'dart:async';

import 'package:account_repository/account_repository.dart';
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
    required AccountRepository accountRepository,
    required Goal goal,
    DebtPayoffCalculator payoffCalculator = const DebtPayoffCalculator(),
  }) : _goalRepository = goalRepository,
       _envelopeRepository = envelopeRepository,
       _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _payoffCalculator = payoffCalculator,
       super(
         GoalDetailState(
           goal: goal,
           payoffSchedule: _projectPayoff(
             goal,
             goal.currentAmount,
             payoffCalculator,
           ),
         ),
       ) {
    _initWatchers();
  }

  /// Subscribes to the data source backing the current `state.goal`: the
  /// linked account, the linked envelope, or (unlinked) manual contributions.
  /// Re-runnable: call after [_cancelLinkSubscriptions] when the link changes.
  void _initWatchers() {
    final goal = state.goal;
    if (goal.accountId != null) {
      _initAccountWatcher();
    } else if (goal.envelopeId == null) {
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

  /// Cancels all link-source subscriptions and resets their cached data, so a
  /// re-link starts clean.
  Future<void> _cancelLinkSubscriptions() async {
    await _contributionsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _allocationsSubscription?.cancel();
    await _transactionsSubscription?.cancel();
    await _accountsSubscription?.cancel();
    _contributionsSubscription = null;
    _envelopesSubscription = null;
    _allocationsSubscription = null;
    _transactionsSubscription = null;
    _accountsSubscription = null;
    _envelopeAllocations = const [];
    _envelopeTransactions = const [];
    _linkedAccountBalance = null;
  }

  final GoalRepository _goalRepository;
  final EnvelopeRepository _envelopeRepository;
  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final DebtPayoffCalculator _payoffCalculator;

  /// Computes a [DebtPayoffSchedule] for `debt_payoff` goals when APR and a
  /// monthly payment are both available. Prefers `monthlyContribution` and
  /// falls back to `minPaymentCents`. [effectiveCurrentAmount] is the
  /// possibly-derived current amount the rest of the UI is rendering, so the
  /// schedule stays in sync with the progress card on envelope-linked goals.
  static DebtPayoffSchedule? _projectPayoff(
    Goal goal,
    int effectiveCurrentAmount,
    DebtPayoffCalculator calculator,
  ) {
    if (goal.type != 'debt_payoff') return null;
    final apr = goal.aprBps;
    if (apr == null) return null;
    final balance = (goal.targetAmount ?? 0) - effectiveCurrentAmount;
    if (balance <= 0) return null;
    final monthly = goal.monthlyContribution ?? 0;
    final payment = monthly > 0 ? monthly : goal.minPaymentCents;
    if (payment == null || payment <= 0) return null;
    return calculator.compute(
      balanceCents: balance,
      aprBps: apr,
      monthlyPaymentCents: payment,
    );
  }

  StreamSubscription<List<GoalContribution>>? _contributionsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<List<EnvelopeAllocation>>? _allocationsSubscription;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;

  List<EnvelopeAllocation> _envelopeAllocations = const [];
  List<Transaction> _envelopeTransactions = const [];
  int? _linkedAccountBalance;

  void _initAccountWatcher() {
    final accountId = state.goal.accountId!;
    _accountsSubscription = _accountRepository
        .watchAccounts(state.goal.budgetId)
        .listen((accounts) {
          final match = accounts.where((a) => a.id == accountId).firstOrNull;
          _linkedAccountBalance = match == null
              ? null
              : (match.currentBalance * match.displayFxRate).round();
          emit(state.copyWith(linkedAccountName: match?.name));
          _recompute();
        });
  }

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
      accountBalance: _linkedAccountBalance,
    );
    emit(
      state.copyWith(
        computedCurrentAmount: amount,
        payoffSchedule: _projectPayoff(state.goal, amount, _payoffCalculator),
      ),
    );
  }

  Future<void> refresh() async {
    try {
      final updated = await _goalRepository.getGoal(state.goal.id);
      final linkChanged =
          updated.envelopeId != state.goal.envelopeId ||
          updated.accountId != state.goal.accountId;
      if (linkChanged) {
        // An edit repointed the goal to a different envelope/account (or
        // changed link type). Tear down the old watchers and rebind.
        await _cancelLinkSubscriptions();
        emit(
          state.copyWith(
            computedCurrentAmount: null,
            linkedEnvelopeName: null,
            linkedAccountName: null,
          ),
        );
        _emitWithGoal(updated);
        _initWatchers();
      } else {
        _emitWithGoal(updated);
      }
    } on GoalException {
      // Keep current data if refresh fails.
    }
  }

  void _emitWithGoal(Goal goal, {GoalDetailStatus? status}) {
    final effective = state.computedCurrentAmount ?? goal.currentAmount;
    emit(
      state.copyWith(
        goal: goal,
        status: status,
        payoffSchedule: _projectPayoff(goal, effective, _payoffCalculator),
      ),
    );
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
      _emitWithGoal(refreshed, status: GoalDetailStatus.completed);
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
      _emitWithGoal(refreshed, status: GoalDetailStatus.contributed);
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
      _emitWithGoal(refreshed, status: GoalDetailStatus.idle);
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
    await _accountsSubscription?.cancel();
    return super.close();
  }
}
