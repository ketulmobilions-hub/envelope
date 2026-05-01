import 'package:csv/csv.dart';
import 'package:envelope_api_client/envelope_api_client.dart';
import 'package:envelope_local_storage/envelope_local_storage.dart' as storage;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:report_repository/src/exceptions.dart';
import 'package:report_repository/src/models/models.dart';

/// Repository for spending reports, trends, and net worth.
class ReportRepository {
  /// Creates a [ReportRepository].
  ///
  /// Optionally accepts a [now] function for testing;
  /// defaults to [DateTime.now].
  ReportRepository({
    required EnvelopeApiClient apiClient,
    required storage.AppDatabase localDatabase,
    DateTime Function()? now,
  }) : _apiClient = apiClient,
       _localDatabase = localDatabase,
       _now = now ?? DateTime.now;

  final EnvelopeApiClient _apiClient;
  final storage.AppDatabase _localDatabase;
  final DateTime Function() _now;

  static const _assetTypes = {
    'checking',
    'savings',
    'investment',
  };
  static const _liabilityTypes = {'credit_card', 'loan'};

  // -------------------------------------------------------------------
  // Spending Report
  // -------------------------------------------------------------------

  /// Gets a spending report for the given date range.
  Future<SpendingReport> getSpendingReport({
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final transactions = await _localDatabase.transactionsDao
          .getTransactionsByBudgetId(budgetId);

      final filtered = transactions.where((t) {
        return !t.date.isBefore(startDate) &&
            !t.date.isAfter(endDate) &&
            t.transferPairId == null;
      }).toList();

      var totalIncome = 0;
      var totalSpent = 0;

      // envelopeId -> accumulated spend
      final envelopeSpend = <String, int>{};

      for (final tx in filtered) {
        // Aggregate in base currency. baseCurrencyAmount = amount × exchangeRate
        // and is maintained by a server-side trigger (see migration 00029).
        final baseAmount = tx.baseCurrencyAmount;
        if (tx.type == 'income') {
          totalIncome += baseAmount;
        } else if (tx.type == 'expense') {
          totalSpent += baseAmount;

          if (tx.envelopeId != null) {
            envelopeSpend.update(
              tx.envelopeId!,
              (v) => v + baseAmount,
              ifAbsent: () => baseAmount,
            );
          } else {
            // Split transaction — split.amount is stored in the transaction's
            // currency; multiply by the parent's exchangeRate to convert.
            final splits = await _localDatabase.transactionsDao
                .getSplitsByTransactionId(tx.id);
            for (final split in splits) {
              final amount = (split.amount * tx.exchangeRate).round();
              envelopeSpend.update(
                split.envelopeId,
                (v) => v + amount,
                ifAbsent: () => amount,
              );
            }
          }
        }
      }

      // Build category group hierarchy
      final envelopes = await _localDatabase.envelopesDao
          .getEnvelopesByBudgetId(budgetId);
      final categoryGroups = await _localDatabase.envelopesDao
          .getCategoryGroupsByBudgetId(budgetId);

      final envelopeMap = {
        for (final e in envelopes) e.id: e,
      };
      final groupMap = {
        for (final g in categoryGroups) g.id: g,
      };

      // Group envelope spend by category group
      final groupedSpend = <String, List<SpendingByEnvelope>>{};
      final groupTotals = <String, int>{};

      for (final entry in envelopeSpend.entries) {
        final envelope = envelopeMap[entry.key];
        if (envelope == null) continue;

        final groupId = envelope.categoryGroupId;
        groupedSpend.putIfAbsent(groupId, () => []);
        groupedSpend[groupId]!.add(
          SpendingByEnvelope(
            envelopeId: entry.key,
            envelopeName: envelope.name,
            amount: entry.value,
          ),
        );
        groupTotals.update(
          groupId,
          (v) => v + entry.value,
          ifAbsent: () => entry.value,
        );
      }

      final byCategory = groupedSpend.entries.map((e) {
        final group = groupMap[e.key];
        return SpendingByCategory(
          categoryGroupId: e.key,
          categoryGroupName: group?.name ?? 'Unknown',
          amount: groupTotals[e.key] ?? 0,
          envelopes: e.value,
        );
      }).toList();

      return SpendingReport(
        startDate: startDate,
        endDate: endDate,
        totalSpent: totalSpent,
        totalIncome: totalIncome,
        byCategory: byCategory,
      );
    } catch (e) {
      if (e is ReportException) rethrow;
      throw ReportException(
        'Failed to get spending report',
        error: e,
      );
    }
  }

  // -------------------------------------------------------------------
  // Trend Report
  // -------------------------------------------------------------------

  /// Gets a trend report for the given number of months.
  Future<TrendReport> getTrendReport({
    required String budgetId,
    required int months,
  }) async {
    try {
      final now = _now();
      final startDate = DateTime(now.year, now.month - months + 1);
      // Upper bound: end of current month
      final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

      final transactions = await _localDatabase.transactionsDao
          .getTransactionsByBudgetId(budgetId);

      final filtered = transactions.where((t) {
        return !t.date.isBefore(startDate) &&
            !t.date.isAfter(endDate) &&
            t.transferPairId == null;
      }).toList();

      // Group by year-month
      final buckets = <String, ({int income, int expense})>{};

      for (final tx in filtered) {
        final key = _monthKey(tx.date);
        final current = buckets[key] ?? (income: 0, expense: 0);
        // Aggregate in base currency so trends across mixed-currency
        // transactions are comparable.
        final baseAmount = tx.baseCurrencyAmount;

        if (tx.type == 'income') {
          buckets[key] = (
            income: current.income + baseAmount,
            expense: current.expense,
          );
        } else if (tx.type == 'expense') {
          buckets[key] = (
            income: current.income,
            expense: current.expense + baseAmount,
          );
        }
      }

      // Build sorted data points
      final dataPoints = <TrendDataPoint>[];
      for (var i = 0; i < months; i++) {
        final date = DateTime(
          now.year,
          now.month - months + 1 + i,
        );
        final key = _monthKey(date);
        final bucket = buckets[key] ?? (income: 0, expense: 0);
        dataPoints.add(
          TrendDataPoint(
            date: date,
            income: bucket.income,
            spending: bucket.expense,
            netSavings: bucket.income - bucket.expense,
          ),
        );
      }

      return TrendReport(dataPoints: dataPoints);
    } catch (e) {
      if (e is ReportException) rethrow;
      throw ReportException(
        'Failed to get trend report',
        error: e,
      );
    }
  }

  // -------------------------------------------------------------------
  // Budget vs Actual Report
  // -------------------------------------------------------------------

  /// Gets a budget vs actual report for a budget period.
  Future<BudgetVsActualReport> getBudgetVsActualReport({
    required String budgetPeriodId,
  }) async {
    try {
      final period = await _localDatabase.budgetsDao.getBudgetPeriod(
        budgetPeriodId,
      );
      if (period == null) {
        throw const ReportException(
          'Budget period not found',
        );
      }

      final allocations = await _localDatabase.envelopesDao
          .getAllocationsByPeriodId(budgetPeriodId);

      final envelopes = await _localDatabase.envelopesDao
          .getEnvelopesByBudgetId(period.budgetId);
      final categoryGroups = await _localDatabase.envelopesDao
          .getCategoryGroupsByBudgetId(period.budgetId);

      final envelopeMap = {
        for (final e in envelopes) e.id: e,
      };
      final groupMap = {
        for (final g in categoryGroups) g.id: g,
      };

      var totalAllocated = 0;
      var totalSpent = 0;

      final items = <BudgetVsActualItem>[];
      for (final alloc in allocations) {
        final envelope = envelopeMap[alloc.envelopeId];
        final group = envelope != null
            ? groupMap[envelope.categoryGroupId]
            : null;

        totalAllocated += alloc.allocatedAmount;
        totalSpent += alloc.spentAmount;

        items.add(
          BudgetVsActualItem(
            envelopeId: alloc.envelopeId,
            envelopeName: envelope?.name ?? 'Unknown',
            categoryGroupName: group?.name ?? 'Unknown',
            allocated: alloc.allocatedAmount,
            spent: alloc.spentAmount,
            remaining: alloc.allocatedAmount - alloc.spentAmount,
          ),
        );
      }

      return BudgetVsActualReport(
        budgetPeriodId: budgetPeriodId,
        startDate: period.startDate,
        endDate: period.endDate,
        totalAllocated: totalAllocated,
        totalSpent: totalSpent,
        items: items,
      );
    } catch (e) {
      if (e is ReportException) rethrow;
      throw ReportException(
        'Failed to get budget vs actual report',
        error: e,
      );
    }
  }

  // -------------------------------------------------------------------
  // Net Worth
  // -------------------------------------------------------------------

  /// Gets the net worth history for a budget.
  ///
  /// Always fetches from API and merges with local cache
  /// to ensure fresh data across devices.
  Future<List<NetWorthSnapshot>> getNetWorthHistory(
    String budgetId,
  ) async {
    try {
      // Always try API first for fresh data
      final remoteSnapshots = await _apiClient.reports
          .getNetWorthSnapshotsByBudget(budgetId);

      // Cache remotely-fetched snapshots locally
      for (final dto in remoteSnapshots) {
        await _localDatabase.reportsDao.upsertNetWorthSnapshot(
          _toCompanion(dto),
        );
      }

      if (remoteSnapshots.isNotEmpty) {
        return remoteSnapshots.map(_mapFromDto).toList();
      }

      // Fallback to local when API returns empty
      final localSnapshots = await _localDatabase.reportsDao
          .getNetWorthSnapshotsByBudgetId(budgetId);

      return localSnapshots.map(_mapFromLocal).toList();
    } catch (e) {
      // On network error, fall back to local cache
      try {
        final localSnapshots = await _localDatabase.reportsDao
            .getNetWorthSnapshotsByBudgetId(budgetId);
        if (localSnapshots.isNotEmpty) {
          return localSnapshots.map(_mapFromLocal).toList();
        }
      } on Exception catch (_) {
        // Local also failed — throw original error
      }
      if (e is ReportException) rethrow;
      throw ReportException(
        'Failed to get net worth history',
        error: e,
      );
    }
  }

  /// Records a net worth snapshot for a budget.
  Future<void> recordNetWorthSnapshot({
    required String budgetId,
  }) async {
    try {
      final accounts = await _localDatabase.accountsDao.getAccountsByBudgetId(
        budgetId,
      );

      var assets = 0;
      var liabilities = 0;

      // Net worth includes ALL accounts regardless of isOnBudget —
      // isOnBudget only controls whether the balance feeds into the budget's
      // "Ready to Assign" pool, not whether the account counts toward wealth.
      for (final account in accounts) {
        if (_assetTypes.contains(account.type)) {
          assets += account.currentBalance;
        } else if (_liabilityTypes.contains(account.type)) {
          liabilities += account.currentBalance.abs();
        }
      }

      final netWorth = assets - liabilities;
      final now = _now();

      // ID is a placeholder — the API generates the
      // real ID server-side and returns it.
      final dto = NetWorthSnapshotDto(
        id: 'pending',
        budgetId: budgetId,
        date: now,
        assets: assets,
        liabilities: liabilities,
        netWorth: netWorth,
        createdAt: now,
      );

      // Remote-first
      final created = await _apiClient.reports.createNetWorthSnapshot(
        dto,
      );

      // Cache locally
      await _localDatabase.reportsDao.upsertNetWorthSnapshot(
        _toCompanion(created),
      );
    } catch (e) {
      if (e is ReportException) rethrow;
      throw ReportException(
        'Failed to record net worth snapshot',
        error: e,
      );
    }
  }

  // -------------------------------------------------------------------
  // Export — CSV
  // -------------------------------------------------------------------

  /// Exports a spending report as CSV.
  ///
  /// Amounts are formatted as dollar values (e.g. 50.00).
  String exportSpendingReportCsv(SpendingReport report) {
    const converter = ListToCsvConverter();
    final rows = <List<dynamic>>[
      ['Category Group', 'Envelope', 'Amount'],
    ];

    for (final category in report.byCategory) {
      for (final envelope in category.envelopes) {
        rows.add([
          category.categoryGroupName,
          envelope.envelopeName,
          _csvCents(envelope.amount),
        ]);
      }
    }

    rows
      ..add([])
      ..add([
        'Total Spent',
        '',
        _csvCents(report.totalSpent),
      ])
      ..add([
        'Total Income',
        '',
        _csvCents(report.totalIncome),
      ]);

    return converter.convert(rows);
  }

  /// Exports a budget vs actual report as CSV.
  ///
  /// Amounts are formatted as dollar values (e.g. 50.00).
  String exportBudgetVsActualCsv(
    BudgetVsActualReport report,
  ) {
    const converter = ListToCsvConverter();
    final rows = <List<dynamic>>[
      [
        'Category Group',
        'Envelope',
        'Allocated',
        'Spent',
        'Remaining',
      ],
    ];

    for (final item in report.items) {
      rows.add([
        item.categoryGroupName,
        item.envelopeName,
        _csvCents(item.allocated),
        _csvCents(item.spent),
        _csvCents(item.remaining),
      ]);
    }

    final totalRemaining = report.totalAllocated - report.totalSpent;
    rows
      ..add([])
      ..add([
        'Total',
        '',
        _csvCents(report.totalAllocated),
        _csvCents(report.totalSpent),
        _csvCents(totalRemaining),
      ]);

    return converter.convert(rows);
  }

  /// Exports a trend report as CSV.
  ///
  /// Amounts are formatted as dollar values (e.g. 50.00).
  String exportTrendReportCsv(TrendReport report) {
    const converter = ListToCsvConverter();
    final rows = <List<dynamic>>[
      ['Date', 'Income', 'Spending', 'Net Savings'],
    ];

    for (final point in report.dataPoints) {
      rows.add([
        _monthKey(point.date),
        _csvCents(point.income),
        _csvCents(point.spending),
        _csvCents(point.netSavings),
      ]);
    }

    return converter.convert(rows);
  }

  // -------------------------------------------------------------------
  // Export — PDF
  // -------------------------------------------------------------------

  /// Exports a spending report as PDF bytes.
  Future<List<int>> exportSpendingReportPdf(
    SpendingReport report,
  ) async {
    try {
      final pdf = pw.Document()
        ..addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  text: 'Spending Report',
                ),
                pw.Text(
                  '${_fmtDate(report.startDate)}'
                  ' - '
                  '${_fmtDate(report.endDate)}',
                ),
                pw.SizedBox(height: 16),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  headers: [
                    'Category Group',
                    'Envelope',
                    'Amount',
                  ],
                  data: [
                    for (final c in report.byCategory)
                      for (final e in c.envelopes)
                        [
                          c.categoryGroupName,
                          e.envelopeName,
                          _fmtCents(e.amount),
                        ],
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Total Spent: '
                  '${_fmtCents(report.totalSpent)}',
                ),
                pw.Text(
                  'Total Income: '
                  '${_fmtCents(report.totalIncome)}',
                ),
              ],
            ),
          ),
        );

      return pdf.save();
    } catch (e) {
      throw ReportException(
        'Failed to export spending report PDF',
        error: e,
      );
    }
  }

  /// Exports a budget vs actual report as PDF bytes.
  Future<List<int>> exportBudgetVsActualPdf(
    BudgetVsActualReport report,
  ) async {
    try {
      final pdf = pw.Document()
        ..addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  text: 'Budget vs Actual Report',
                ),
                pw.Text(
                  '${_fmtDate(report.startDate)}'
                  ' - '
                  '${_fmtDate(report.endDate)}',
                ),
                pw.SizedBox(height: 16),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  headers: [
                    'Category Group',
                    'Envelope',
                    'Allocated',
                    'Spent',
                    'Remaining',
                  ],
                  data: [
                    for (final item in report.items)
                      [
                        item.categoryGroupName,
                        item.envelopeName,
                        _fmtCents(item.allocated),
                        _fmtCents(item.spent),
                        _fmtCents(item.remaining),
                      ],
                  ],
                ),
                pw.SizedBox(height: 16),
                pw.Text(
                  'Total Allocated: '
                  '${_fmtCents(report.totalAllocated)}',
                ),
                pw.Text(
                  'Total Spent: '
                  '${_fmtCents(report.totalSpent)}',
                ),
              ],
            ),
          ),
        );

      return pdf.save();
    } catch (e) {
      throw ReportException(
        'Failed to export budget vs actual PDF',
        error: e,
      );
    }
  }

  /// Exports a trend report as PDF bytes.
  Future<List<int>> exportTrendReportPdf(
    TrendReport report,
  ) async {
    try {
      final pdf = pw.Document()
        ..addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (context) => pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  text: 'Trend Report',
                ),
                pw.SizedBox(height: 16),
                pw.TableHelper.fromTextArray(
                  headerStyle: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                  ),
                  headers: [
                    'Date',
                    'Income',
                    'Spending',
                    'Net Savings',
                  ],
                  data: [
                    for (final p in report.dataPoints)
                      [
                        _monthKey(p.date),
                        _fmtCents(p.income),
                        _fmtCents(p.spending),
                        _fmtCents(p.netSavings),
                      ],
                  ],
                ),
              ],
            ),
          ),
        );

      return pdf.save();
    } catch (e) {
      throw ReportException(
        'Failed to export trend report PDF',
        error: e,
      );
    }
  }

  // -------------------------------------------------------------------
  // Private helpers
  // -------------------------------------------------------------------

  static NetWorthSnapshot _mapFromLocal(
    storage.NetWorthSnapshot row,
  ) {
    return NetWorthSnapshot(
      id: row.id,
      budgetId: row.budgetId,
      date: row.date,
      assets: row.assets,
      liabilities: row.liabilities,
      netWorth: row.netWorth,
      createdAt: row.createdAt,
    );
  }

  static NetWorthSnapshot _mapFromDto(
    NetWorthSnapshotDto dto,
  ) {
    return NetWorthSnapshot(
      id: dto.id,
      budgetId: dto.budgetId,
      date: dto.date,
      assets: dto.assets,
      liabilities: dto.liabilities,
      netWorth: dto.netWorth,
      createdAt: dto.createdAt,
    );
  }

  static storage.NetWorthSnapshotsCompanion _toCompanion(
    NetWorthSnapshotDto dto,
  ) {
    return storage.NetWorthSnapshotsCompanion.insert(
      id: dto.id,
      budgetId: dto.budgetId,
      date: dto.date,
      assets: dto.assets,
      liabilities: dto.liabilities,
      netWorth: dto.netWorth,
      createdAt: dto.createdAt,
    );
  }

  static String _monthKey(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    return '${date.year}-$m';
  }

  static String _fmtDate(DateTime date) {
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '${date.year}-$m-$d';
  }

  static String _fmtCents(int cents) {
    final negative = cents < 0;
    final abs = cents.abs();
    final dollars = abs ~/ 100;
    final rem = (abs % 100).toString().padLeft(2, '0');
    final sign = negative ? '-' : '';
    return '$sign\$$dollars.$rem';
  }

  /// Formats cents as a decimal number for CSV
  /// (e.g. 5000 → "50.00").
  static String _csvCents(int cents) {
    final negative = cents < 0;
    final abs = cents.abs();
    final dollars = abs ~/ 100;
    final rem = (abs % 100).toString().padLeft(2, '0');
    final sign = negative ? '-' : '';
    return '$sign$dollars.$rem';
  }
}
