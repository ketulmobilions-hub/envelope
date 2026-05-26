import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:goal_repository/goal_repository.dart';

part 'goal_form_state.dart';

class GoalFormCubit extends Cubit<GoalFormState> {
  GoalFormCubit({
    required GoalRepository goalRepository,
    required EnvelopeRepository envelopeRepository,
    required AccountRepository accountRepository,
    required this.budgetId,
    this.goal,
  }) : _goalRepository = goalRepository,
       _envelopeRepository = envelopeRepository,
       _accountRepository = accountRepository,
       super(
         GoalFormState(
           envelopeId: goal?.envelopeId,
           accountId: goal?.accountId,
         ),
       ) {
    _envelopesSub = _envelopeRepository.watchEnvelopes(budgetId).listen(
      (envelopes) => emit(
        state.copyWith(envelopes: envelopes, envelopesLoading: false),
      ),
    );
    _accountsSub = _accountRepository.watchAccounts(budgetId).listen(
      (accounts) => emit(
        state.copyWith(accounts: accounts, accountsLoading: false),
      ),
    );
  }

  final GoalRepository _goalRepository;
  final EnvelopeRepository _envelopeRepository;
  final AccountRepository _accountRepository;
  final String budgetId;
  final Goal? goal;
  StreamSubscription<List<Envelope>>? _envelopesSub;
  StreamSubscription<List<Account>>? _accountsSub;

  bool get isEditing => goal != null;

  /// Selecting an envelope clears any account link (mutually exclusive).
  void envelopeChanged(String? envelopeId) {
    emit(
      state.copyWith(
        envelopeId: envelopeId,
        accountId: envelopeId == null ? state.accountId : null,
      ),
    );
  }

  /// Selecting an account clears any envelope link (mutually exclusive).
  void accountChanged(String? accountId) {
    emit(
      state.copyWith(
        accountId: accountId,
        envelopeId: accountId == null ? state.envelopeId : null,
      ),
    );
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
          accountId: state.accountId,
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
          accountId: state.accountId,
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
    await _accountsSub?.cancel();
    return super.close();
  }
}
