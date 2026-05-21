import 'package:envelope/shared/feature_flags.dart';
import 'package:envelope/transactions/view/sentence_transaction_form_page.dart';
import 'package:envelope/transactions/view/transaction_form_page.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Routes to the active add/edit-transaction UI.
///
/// Flip [kSentenceTransactionForm] in `lib/shared/feature_flags.dart` to swap
/// between the classic [TransactionFormPage] and the new
/// [SentenceTransactionFormPage] without touching call sites.
class TransactionFormEntry extends StatelessWidget {
  const TransactionFormEntry({this.transaction, super.key});

  final Transaction? transaction;

  @override
  Widget build(BuildContext context) {
    if (kSentenceTransactionForm) {
      return SentenceTransactionFormPage(transaction: transaction);
    }
    return TransactionFormPage(transaction: transaction);
  }
}
