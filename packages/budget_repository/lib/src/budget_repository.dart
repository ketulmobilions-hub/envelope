// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:budget_repository/src/models/models.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide AllocationTemplate, AllocationTemplateItem, Budget, BudgetPeriod;

/// Repository for budget operations.
class BudgetRepository {
  const BudgetRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Creates a new budget.
  Future<Budget> createBudget({
    required String name,
    required String baseCurrency,
    String periodType = 'monthly',
    int periodStartDay = 1,
  }) async {
    // TODO(envelope): Implement create budget
    throw UnimplementedError();
  }

  /// Gets a budget by its [id].
  Future<Budget> getBudget(String id) async {
    // TODO(envelope): Implement get budget
    throw UnimplementedError();
  }

  /// Watches all budgets for the current user.
  Stream<List<Budget>> watchBudgets() {
    // TODO(envelope): Implement watch budgets
    throw UnimplementedError();
  }

  /// Updates a [budget].
  Future<void> updateBudget(Budget budget) async {
    // TODO(envelope): Implement update budget
    throw UnimplementedError();
  }

  /// Deletes a budget by its [id].
  Future<void> deleteBudget(String id) async {
    // TODO(envelope): Implement delete budget
    throw UnimplementedError();
  }

  /// Archives a budget by its [id].
  Future<void> archiveBudget(String id) async {
    // TODO(envelope): Implement archive budget
    throw UnimplementedError();
  }

  /// Creates a new budget period.
  Future<BudgetPeriod> createBudgetPeriod({
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // TODO(envelope): Implement create budget period
    throw UnimplementedError();
  }

  /// Watches all budget periods for a [budgetId].
  Stream<List<BudgetPeriod>> watchBudgetPeriods(String budgetId) {
    // TODO(envelope): Implement watch budget periods
    throw UnimplementedError();
  }

  /// Closes a budget period by its [id].
  Future<void> closeBudgetPeriod(String id) async {
    // TODO(envelope): Implement close budget period
    throw UnimplementedError();
  }

  /// Creates a new allocation template.
  Future<AllocationTemplate> createAllocationTemplate({
    required String budgetId,
    required String name,
    required List<AllocationTemplateItem> items,
  }) async {
    // TODO(envelope): Implement create allocation template
    throw UnimplementedError();
  }

  /// Gets all allocation templates for a [budgetId].
  Future<List<AllocationTemplate>> getAllocationTemplates(
    String budgetId,
  ) async {
    // TODO(envelope): Implement get allocation templates
    throw UnimplementedError();
  }

  /// Deletes an allocation template by its [id].
  Future<void> deleteAllocationTemplate(String id) async {
    // TODO(envelope): Implement delete allocation template
    throw UnimplementedError();
  }
}
