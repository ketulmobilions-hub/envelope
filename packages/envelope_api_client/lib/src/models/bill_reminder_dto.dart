import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_reminder_dto.freezed.dart';
part 'bill_reminder_dto.g.dart';

/// Data transfer object for the `bill_reminders` table.
@freezed
abstract class BillReminderDto with _$BillReminderDto {
  const factory BillReminderDto({
    required String id,
    @JsonKey(name: 'budget_id') required String budgetId,
    required String name,
    @JsonKey(name: 'estimated_amount') required int estimatedAmount,
    @JsonKey(name: 'due_day') required int dueDay,
    required String frequency,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'reminder_days_before') @Default(3) int reminderDaysBefore,
    @JsonKey(name: 'envelope_id') String? envelopeId,
  }) = _BillReminderDto;

  factory BillReminderDto.fromJson(Map<String, dynamic> json) =>
      _$BillReminderDtoFromJson(json);
}
