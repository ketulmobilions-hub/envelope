import 'package:account_repository/account_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:envelope/accounts/widgets/account_helpers.dart';
import 'package:envelope_repository/envelope_repository.dart';
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
    EnvelopeRepository? envelopeRepository,
    this.budgetPeriodId,
  }) : _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       super(const TransferFormState()) {
    _loadAccounts();
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository? _envelopeRepository;
  final String budgetId;
  final String userId;
  final String? budgetPeriodId;

  Future<void> _loadAccounts() async {
    try {
      final accounts = await _accountRepository.watchAccounts(budgetId).first;
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
    if (state.accounts.isEmpty) {
      emit(
        state.copyWith(
          status: TransferFormStatus.failure,
          errorMessage: 'Accounts not loaded yet. Please retry.',
        ),
      );
      return;
    }
    emit(state.copyWith(status: TransferFormStatus.submitting));
    try {
      final transferPairId = const Uuid().v4();
      final fromAccount = state.accounts
          .where((a) => a.id == fromAccountId)
          .firstOrNull;
      final toAccount = state.accounts
          .where((a) => a.id == toAccountId)
          .firstOrNull;
      final fromCurrency = fromAccount?.currency ?? 'USD';
      final toCurrency = toAccount?.currency ?? 'USD';
      // Each leg snapshots its own account's displayFxRate so the
      // base_currency_amount is correct per leg, even for cross-currency
      // transfers (e.g. USD → INR via Wise).
      final fromRate = fromAccount?.displayFxRate ?? 1.0;
      final toRate = toAccount?.displayFxRate ?? 1.0;

      // Create outgoing transaction (from account — negative amount).
      await _transactionRepository.createTransaction(
        budgetId: budgetId,
        accountId: fromAccountId,
        type: 'transfer',
        amount: -amountCents,
        currency: fromCurrency,
        exchangeRate: fromRate,
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
        currency: toCurrency,
        exchangeRate: toRate,
        date: date,
        createdBy: userId,
        transferPairId: transferPairId,
      );

      // Refresh accounts so current_balance reflects the trigger update.
      try {
        await _accountRepository.refreshAccounts(budgetId);
      } on AccountException {
        // Best-effort; local cache will be corrected on next full sync.
      }

      // When paying a CC bill, refresh allocations so BudgetBloc recomputes
      // CC Payment available from the new transaction in local storage.
      if (toAccount != null &&
          isCreditCard(toAccount.type) &&
          _envelopeRepository != null &&
          budgetPeriodId != null) {
        try {
          await _envelopeRepository!.refreshAllocations(budgetPeriodId!);
        } on Exception {
          // Best-effort.
        }
      }

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
