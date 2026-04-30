import 'package:envelope_repository/envelope_repository.dart';

const String ccPaymentsGroupName = 'Credit Card Payments';

/// Returns the existing "Credit Card Payments" [CategoryGroup] for [budgetId],
/// creating it if necessary. Tolerates concurrent creation by re-fetching on
/// failure.
Future<CategoryGroup> findOrCreateCCPaymentsGroup({
  required EnvelopeRepository repository,
  required String budgetId,
}) async {
  final groups = await repository.watchCategoryGroups(budgetId).first;
  final existing = groups
      .where((g) => g.name == ccPaymentsGroupName)
      .firstOrNull;
  if (existing != null) return existing;
  try {
    return await repository.createCategoryGroup(
      budgetId: budgetId,
      name: ccPaymentsGroupName,
    );
  } on Exception {
    final retry = await repository.watchCategoryGroups(budgetId).first;
    return retry.firstWhere((g) => g.name == ccPaymentsGroupName);
  }
}
