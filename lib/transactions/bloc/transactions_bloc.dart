import 'dart:async';

import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:budget_repository/budget_repository.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';

part 'transactions_event.dart';
part 'transactions_state.dart';

class TransactionsBloc extends Bloc<TransactionsEvent, TransactionsState> {
  TransactionsBloc({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
    required EnvelopeRepository envelopeRepository,
    required BudgetRepository budgetRepository,
    required String budgetId,
  }) : _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       _budgetRepository = budgetRepository,
       _budgetId = budgetId,
       super(const TransactionsState()) {
    on<TransactionsStarted>(_onStarted);
    on<_TransactionsUpdated>(_onUpdated);
    on<_AccountsUpdated>(_onAccountsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_SplitEnvelopeIdsUpdated>(_onSplitEnvelopeIdsUpdated);
    on<_TransactionsStreamError>(_onStreamError);
    on<TransactionsRefreshRequested>(_onRefreshRequested);
    on<TransactionDeleted>(_onDeleted);
    on<TransactionUndoDeleteRequested>(_onUndoDelete);
    on<TransactionsFilterChanged>(_onFilterChanged);
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository _envelopeRepository;
  final BudgetRepository _budgetRepository;
  final String _budgetId;
  StreamSubscription<List<Transaction>>? _transactionsSubscription;
  StreamSubscription<List<Account>>? _accountsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;
  StreamSubscription<Map<String, List<String>>>? _splitIdsSubscription;
  Transaction? _lastDeleted;

  /// The budget ID this bloc is watching.
  String get budgetId => _budgetId;

  Future<void> _onStarted(
    TransactionsStarted event,
    Emitter<TransactionsState> emit,
  ) async {
    emit(state.copyWith(status: TransactionsStatus.loading));

    await _transactionsSubscription?.cancel();
    _transactionsSubscription = _transactionRepository
        .watchTransactions(budgetId: _budgetId)
        .listen(
          (transactions) => add(_TransactionsUpdated(transactions)),
          onError: (Object _) => add(const _TransactionsStreamError()),
        );

    await _accountsSubscription?.cancel();
    _accountsSubscription = _accountRepository
        .watchAccounts(_budgetId)
        .listen((accounts) => add(_AccountsUpdated(accounts)));

    await _envelopesSubscription?.cancel();
    _envelopesSubscription = _envelopeRepository
        .watchEnvelopes(_budgetId)
        .listen((envelopes) => add(_EnvelopesUpdated(envelopes)));

    await _splitIdsSubscription?.cancel();
    _splitIdsSubscription = _transactionRepository
        .watchSplitEnvelopeIds(_budgetId)
        .listen((ids) => add(_SplitEnvelopeIdsUpdated(ids)));

    try {
      await _transactionRepository.refreshTransactions(_budgetId);
    } on TransactionException {
      // Local watch will still show cached data.
    }
  }

  void _onUpdated(
    _TransactionsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(
      state.copyWith(
        status: TransactionsStatus.loaded,
        transactions: event.transactions,
      ),
    );
  }

  void _onAccountsUpdated(
    _AccountsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(accounts: event.accounts));
  }

  void _onEnvelopesUpdated(
    _EnvelopesUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(envelopes: event.envelopes));
  }

  void _onSplitEnvelopeIdsUpdated(
    _SplitEnvelopeIdsUpdated event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(splitEnvelopeIds: event.splitEnvelopeIds));
  }

  void _onStreamError(
    _TransactionsStreamError event,
    Emitter<TransactionsState> emit,
  ) {
    emit(
      state.copyWith(
        status: TransactionsStatus.error,
        error: TransactionsError.loadFailed,
      ),
    );
    emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    TransactionsRefreshRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    try {
      await _transactionRepository.refreshTransactions(_budgetId);
    } on TransactionException {
      // Stream will update on its own if data changes.
    }
  }

  Future<void> _onDeleted(
    TransactionDeleted event,
    Emitter<TransactionsState> emit,
  ) async {
    // Store for undo before deleting.
    _lastDeleted = state.transactions.cast<Transaction?>().firstWhere(
      (t) => t!.id == event.id,
      orElse: () => null,
    );

    try {
      await _transactionRepository.deleteTransaction(event.id);
      // Optimistically decrement local spentAmount so the envelope card on
      // the home page reflects the deletion instantly (before the API
      // refreshAllocations round-trip completes).
      final deleted = _lastDeleted;
      if (deleted != null) {
        if (deleted.type == 'expense' && deleted.envelopeId != null) {
          unawaited(
            _envelopeRepository.decrementLocalSpentAmount(
              envelopeId: deleted.envelopeId!,
              budgetId: deleted.budgetId,
              date: deleted.date,
              amount: deleted.amount,
            ),
          );
        }
        if (deleted.type == 'income') {
          unawaited(
            _budgetRepository
                .removeIncomeFromPeriod(
                  budgetId: deleted.budgetId,
                  date: deleted.date,
                  amount: deleted.amount,
                )
                .catchError((_) {}),
          );
        }
      }
    } on TransactionException {
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          error: TransactionsError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
    }
  }

  Future<void> _onUndoDelete(
    TransactionUndoDeleteRequested event,
    Emitter<TransactionsState> emit,
  ) async {
    final deleted = _lastDeleted;
    if (deleted == null) return;
    _lastDeleted = null;

    try {
      await _transactionRepository.createTransaction(
        budgetId: deleted.budgetId,
        accountId: deleted.accountId,
        type: deleted.type,
        amount: deleted.amount,
        currency: deleted.currency,
        date: deleted.date,
        createdBy: deleted.createdBy,
        envelopeId: deleted.envelopeId,
        exchangeRate: deleted.exchangeRate,
        payee: deleted.payee,
        notes: deleted.notes,
        transferPairId: deleted.transferPairId,
      );
    } on TransactionException {
      emit(
        state.copyWith(
          status: TransactionsStatus.error,
          error: TransactionsError.undoFailed,
        ),
      );
      emit(state.copyWith(status: TransactionsStatus.loaded, error: null));
    }
  }

  void _onFilterChanged(
    TransactionsFilterChanged event,
    Emitter<TransactionsState> emit,
  ) {
    emit(state.copyWith(filter: event.filter));
  }

  @override
  Future<void> close() async {
    await _transactionsSubscription?.cancel();
    await _accountsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    await _splitIdsSubscription?.cancel();
    return super.close();
  }
}
