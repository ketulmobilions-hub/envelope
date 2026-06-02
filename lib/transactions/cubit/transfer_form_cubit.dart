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
  }) : _transactionRepository = transactionRepository,
       _accountRepository = accountRepository,
       _envelopeRepository = envelopeRepository,
       super(const TransferFormState()) {
    _load();
  }

  final TransactionRepository _transactionRepository;
  final AccountRepository _accountRepository;
  final EnvelopeRepository? _envelopeRepository;
  final String budgetId;
  final String userId;

  Future<void> _load() async {
    try {
      final accounts = await _accountRepository.watchAccounts(budgetId).first;
      final envelopeRepo = _envelopeRepository;
      // Exclude archived envelopes and CC-payment envelopes (linked to a credit
      // card account) — neither is a valid manual funding source for a transfer.
      final envelopes = envelopeRepo == null
          ? const <Envelope>[]
          : (await envelopeRepo.watchEnvelopes(budgetId).first)
                .where((e) => !e.isArchived && e.linkedAccountId == null)
                .toList();
      if (isClosed) return;
      emit(
        state.copyWith(
          status: TransferFormStatus.loaded,
          accounts: accounts,
          envelopes: envelopes,
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
    String? envelopeId,
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

    final fromAccount = state.accounts
        .where((a) => a.id == fromAccountId)
        .firstOrNull;
    final toAccount = state.accounts
        .where((a) => a.id == toAccountId)
        .firstOrNull;

    // A transfer OUT to an off-budget account leaves the budget, so it is
    // categorized against an envelope (reduces that envelope's available).
    // (The inverse — off->on raising Ready to Assign — is a separate change:
    // it needs delete-time income reversal, so it is intentionally not handled
    // here yet.)
    final fromOnBudget = fromAccount?.isOnBudget ?? true;
    final toOnBudget = toAccount?.isOnBudget ?? true;
    final isOutToOffBudget = fromOnBudget && !toOnBudget;

    if (isOutToOffBudget && envelopeId == null) {
      emit(
        state.copyWith(
          status: TransferFormStatus.failure,
          errorMessage: 'Select an envelope to fund this transfer.',
        ),
      );
      return;
    }

    emit(state.copyWith(status: TransferFormStatus.submitting));
    try {
      final transferPairId = const Uuid().v4();
      final fromCurrency = fromAccount?.currency ?? 'USD';
      final toCurrency = toAccount?.currency ?? 'USD';
      // Each leg snapshots its own account's displayFxRate so the
      // base_currency_amount is correct per leg, even for cross-currency
      // transfers (e.g. USD → INR via Wise).
      final fromRate = fromAccount?.displayFxRate ?? 1.0;
      final toRate = toAccount?.displayFxRate ?? 1.0;

      // Create outgoing transaction (from account — negative amount).
      // For an on->off-budget transfer the outgoing leg carries the funding
      // envelope so the spent trigger reduces that envelope's available.
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
        envelopeId: isOutToOffBudget ? envelopeId : null,
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

      // Refresh allocations so BudgetBloc recomputes CC Payment available
      // (and the on→off envelope's spent) from the new transactions.
      final needsRefresh = _envelopeRepository != null &&
          ((toAccount != null && isCreditCard(toAccount.type)) ||
              isOutToOffBudget);
      if (needsRefresh) {
        try {
          await _envelopeRepository.refreshAllocations(budgetId);
        } on Exception {
          // Best-effort; next full sync reconciles.
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
