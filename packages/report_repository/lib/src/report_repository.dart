// Repository stub — fields will be used when methods are implemented.
// ignore_for_file: unused_field
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart'
    hide NetWorthSnapshot;
import 'package:report_repository/src/models/models.dart';

/// Repository for spending reports, trends, and net worth.
class ReportRepository {
  const ReportRepository({
    required EnvelopeApiClient apiClient,
    required AppDatabase localDatabase,
  })  : _apiClient = apiClient,
        _localDatabase = localDatabase;

  final EnvelopeApiClient _apiClient;
  final AppDatabase _localDatabase;

  /// Gets a spending report for the given date range.
  Future<SpendingReport> getSpendingReport({
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    // TODO(envelope): Implement get spending report
    throw UnimplementedError();
  }

  /// Gets a trend report for the given number of months.
  Future<TrendReport> getTrendReport({
    required String budgetId,
    required int months,
  }) async {
    // TODO(envelope): Implement get trend report
    throw UnimplementedError();
  }

  /// Gets the net worth history for a budget.
  Future<List<NetWorthSnapshot>> getNetWorthHistory(String budgetId) async {
    // TODO(envelope): Implement get net worth history
    throw UnimplementedError();
  }

  /// Records a net worth snapshot for a budget.
  Future<void> recordNetWorthSnapshot({
    required String budgetId,
  }) async {
    // TODO(envelope): Implement record net worth snapshot
    throw UnimplementedError();
  }
}
