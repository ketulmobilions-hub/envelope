import 'package:freezed_annotation/freezed_annotation.dart';

part 'bill_reminder.freezed.dart';
part 'bill_reminder.g.dart';

@freezed
abstract class BillReminder with _$BillReminder {
  const factory BillReminder({
    required String id,
    required String budgetId,
    required String name,
    required int estimatedAmount,
    required int dueDay,
    required String frequency,
    required DateTime createdAt,
    String? envelopeId,
    @Default(3) int reminderDaysBefore,
  }) = _BillReminder;

  factory BillReminder.fromJson(Map<String, dynamic> json) =>
      _$BillReminderFromJson(json);
}
