import 'package:freezed_annotation/freezed_annotation.dart';

part 'recurring_rule_dto.freezed.dart';
part 'recurring_rule_dto.g.dart';

/// Data transfer object for the `recurring_rules` table.
@freezed
abstract class RecurringRuleDto with _$RecurringRuleDto {
  const factory RecurringRuleDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    @JsonKey(name: 'account_id') required String accountId,
    required String type,
    required int amount,
    required String currency,
    required String frequency,
    @JsonKey(name: 'start_date') required DateTime startDate,
    @JsonKey(name: 'next_occurrence') required DateTime nextOccurrence,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'auto_post') @Default(false) bool autoPost,
    @JsonKey(name: 'is_paused') @Default(false) bool isPaused,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    String? payee,
    String? notes,
    @JsonKey(name: 'custom_interval') int? customInterval,
    @JsonKey(name: 'custom_unit') String? customUnit,
    @JsonKey(name: 'end_date') DateTime? endDate,
  }) = _RecurringRuleDto;

  factory RecurringRuleDto.fromJson(Map<String, dynamic> json) =>
      _$RecurringRuleDtoFromJson(json);
}
