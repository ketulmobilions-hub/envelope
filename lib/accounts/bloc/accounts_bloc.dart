import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:equatable/equatable.dart';

part 'accounts_event.dart';
part 'accounts_state.dart';

class AccountsBloc extends Bloc<AccountsEvent, AccountsState> {
  AccountsBloc({
    required AccountRepository accountRepository,
    required BudgetRepository budgetRepository,
    required String budgetId,
  }) : _accountRepository = accountRepository,
       _budgetRepository = budgetRepository,
       _budgetId = budgetId,
       super(const AccountsState()) {
    on<AccountsStarted>(_onStarted);
    on<_AccountsUpdated>(_onUpdated);
    on<_AccountsStreamError>(_onStreamError);
    on<AccountsRefreshRequested>(_onRefreshRequested);
    on<AccountArchiveToggled>(_onArchiveToggled);
    on<AccountDeleted>(_onDeleted);
  }

  final AccountRepository _accountRepository;
  final BudgetRepository _budgetRepository;
  final String _budgetId;
  StreamSubscription<List<Account>>? _accountsSubscription;

  /// The budget ID this bloc is watching.
  String get budgetId => _budgetId;

  Future<void> _onStarted(
    AccountsStarted event,
    Emitter<AccountsState> emit,
  ) async {
    emit(state.copyWith(status: AccountsStatus.loading));

    await _accountsSubscription?.cancel();
    _accountsSubscription = _accountRepository
        .watchAccounts(_budgetId)
        .listen(
          (accounts) => add(_AccountsUpdated(accounts)),
          onError: (Object _) => add(const _AccountsStreamError()),
        );

    try {
      await _accountRepository.refreshAccounts(_budgetId);
    } on AccountException {
      // Local watch will still show cached data.
    }
  }

  void _onUpdated(
    _AccountsUpdated event,
    Emitter<AccountsState> emit,
  ) {
    emit(
      state.copyWith(
        status: AccountsStatus.loaded,
        accounts: event.accounts,
      ),
    );
  }

  void _onStreamError(
    _AccountsStreamError event,
    Emitter<AccountsState> emit,
  ) {
    emit(
      state.copyWith(
        status: AccountsStatus.error,
        error: AccountsError.loadFailed,
      ),
    );
    emit(state.copyWith(status: AccountsStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    AccountsRefreshRequested event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      await _accountRepository.refreshAccounts(_budgetId);
    } on AccountException {
      // Stream will update on its own if data changes.
    } finally {
      event.onComplete?.call();
    }
  }

  Future<void> _onArchiveToggled(
    AccountArchiveToggled event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      if (event.account.isArchived) {
        await _accountRepository.unarchiveAccount(event.account.id);
      } else {
        await _accountRepository.archiveAccount(event.account.id);
      }
    } on AccountException {
      emit(
        state.copyWith(
          status: AccountsStatus.error,
          error: AccountsError.updateFailed,
        ),
      );
      emit(state.copyWith(status: AccountsStatus.loaded, error: null));
    }
  }

  Future<void> _onDeleted(
    AccountDeleted event,
    Emitter<AccountsState> emit,
  ) async {
    try {
      final account = state.accounts.firstWhere(
        (a) => a.id == event.accountId,
      );
      await _accountRepository.deleteAccount(event.accountId);
      if (account.isOnBudget && account.startingBalance != 0) {
        await _budgetRepository.addIncomeToCurrentPeriod(
          budgetId: _budgetId,
          amount: -account.startingBalance,
        );
      }
    } on AccountException {
      emit(
        state.copyWith(
          status: AccountsStatus.error,
          error: AccountsError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: AccountsStatus.loaded, error: null));
    }
  }

  @override
  Future<void> close() async {
    await _accountsSubscription?.cancel();
    return super.close();
  }
}
