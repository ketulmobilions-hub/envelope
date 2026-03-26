import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:transaction_repository/transaction_repository.dart';
import 'package:uuid/uuid.dart';

part 'transfer_form_state.dart';

class TransferFormCubit extends Cubit<TransferFormState> {
  TransferFormCubit({
    required TransactionRepository transactionRepository,
    required AccountRepository accountRepository,
    required this.budgetId,
    required this.userId,
  })  : _transactionRepository = transactionRepository,
        _accountRepository = accountRepository,
        super(const TransferFormState()) {
    _loadAccounts();
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final String budgetId;
  final String userId;

  Future<void> _loadAccounts() async {
    try {
      final accounts = await _accountRepository
          .watchAccounts(budgetId)
          .first;
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransferFormStatus.loaded,
          accounts: accounts,
        ),
      );
    } on Exception {
      if (isClosed) return;
      emit(state.copyWith(status: TransferFormStatus.failure));
    }
  }

  Future<void> submit({
    required String fromAccountId,
    required String toAccountId,
    required int amountCents,
    required DateTime date,
  }) async {
    emit(state.copyWith(status: TransferFormStatus.submitting));
    try {
      final transferPairId = const Uuid().v4();

      // Create outgoing transaction (from account — negative amount).
      await _transactionRepository.createTransaction(
        budgetId: budgetId,
        accountId: fromAccountId,
        type: 'transfer',
        amount: -amountCents,
        currency: 'USD',
        date: date,
        createdBy: userId,
        transferPairId: transferPairId,
      );

      // Create incoming transaction (to account).
      await _transactionRepository.createTransaction(
        budgetId: budgetId,
        accountId: toAccountId,
        type: 'transfer',
        amount: amountCents,
        currency: 'USD',
        date: date,
        createdBy: userId,
        transferPairId: transferPairId,
      );

      if (isClosed) return;
      emit(state.copyWith(status: TransferFormStatus.success));
    } on TransactionException catch (e) {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransferFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransferFormStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
