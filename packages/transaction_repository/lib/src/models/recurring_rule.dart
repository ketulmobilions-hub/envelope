import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_rule.freezed.dart';
part 'recurring_rule.g.dart';

@freezed
abstract class RecurringRule with _$RecurringRule {
  const factory RecurringRule({
    required String id,
    required String budgetId,
    required String accountId,
    required String type,
    required int amount,
    required String currency,
    @Default(1.0) double exchangeRate,
    required String frequency,
    required DateTime startDate,
    required DateTime nextOccurrence,
    required DateTime createdAt,
    String? envelopeId,
    String? payee,
    String? notes,
    int? customInterval,
    String? customUnit,
    DateTime? endDate,
    @Default(false) bool autoPost,
    @Default(false) bool isPaused,
  }) = _RecurringRule;

  factory RecurringRule.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleFromJson(json);
}
