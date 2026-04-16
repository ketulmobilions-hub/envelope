// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferencesDto {
  @JsonKey(name: 'user_id')
  String get userId;
  @JsonKey(name: 'push_enabled')
  bool get pushEnabled;
  @JsonKey(name: 'email_enabled')
  bool get emailEnabled;
  @JsonKey(name: 'overspend_alerts')
  bool get overspendAlerts;
  @JsonKey(name: 'bill_reminders')
  bool get billReminders;
  @JsonKey(name: 'email_bill_reminders')
  bool get emailBillReminders;
  @JsonKey(name: 'daily_logging_reminder')
  bool get dailyLoggingReminder;
  @JsonKey(name: 'recurring_transaction_alerts')
  bool get recurringTransactionAlerts;
  @JsonKey(name: 'shared_budget_activity')
  bool get sharedBudgetActivity;
  @JsonKey(name: 'weekly_summary')
  bool get weeklySummary;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationPreferencesDtoCopyWith<NotificationPreferencesDto>
  get copyWith =>
      _$NotificationPreferencesDtoCopyWithImpl<NotificationPreferencesDto>(
        this as NotificationPreferencesDto,
        _$identity,
      );

  /// Serializes this NotificationPreferencesDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPreferencesDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.overspendAlerts, overspendAlerts) ||
                other.overspendAlerts == overspendAlerts) &&
            (identical(other.billReminders, billReminders) ||
                other.billReminders == billReminders) &&
            (identical(other.emailBillReminders, emailBillReminders) ||
                other.emailBillReminders == emailBillReminders) &&
            (identical(other.dailyLoggingReminder, dailyLoggingReminder) ||
                other.dailyLoggingReminder == dailyLoggingReminder) &&
            (identical(
                  other.recurringTransactionAlerts,
                  recurringTransactionAlerts,
                ) ||
                other.recurringTransactionAlerts ==
                    recurringTransactionAlerts) &&
            (identical(other.sharedBudgetActivity, sharedBudgetActivity) ||
                other.sharedBudgetActivity == sharedBudgetActivity) &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    pushEnabled,
    emailEnabled,
    overspendAlerts,
    billReminders,
    emailBillReminders,
    dailyLoggingReminder,
    recurringTransactionAlerts,
    sharedBudgetActivity,
    weeklySummary,
  );

  @override
  String toString() {
    return 'NotificationPreferencesDto(userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, overspendAlerts: $overspendAlerts, billReminders: $billReminders, emailBillReminders: $emailBillReminders, dailyLoggingReminder: $dailyLoggingReminder, recurringTransactionAlerts: $recurringTransactionAlerts, sharedBudgetActivity: $sharedBudgetActivity, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class $NotificationPreferencesDtoCopyWith<$Res> {
  factory $NotificationPreferencesDtoCopyWith(
    NotificationPreferencesDto value,
    $Res Function(NotificationPreferencesDto) _then,
  ) = _$NotificationPreferencesDtoCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'push_enabled') bool pushEnabled,
    @JsonKey(name: 'email_enabled') bool emailEnabled,
    @JsonKey(name: 'overspend_alerts') bool overspendAlerts,
    @JsonKey(name: 'bill_reminders') bool billReminders,
    @JsonKey(name: 'email_bill_reminders') bool emailBillReminders,
    @JsonKey(name: 'daily_logging_reminder') bool dailyLoggingReminder,
    @JsonKey(name: 'recurring_transaction_alerts')
    bool recurringTransactionAlerts,
    @JsonKey(name: 'shared_budget_activity') bool sharedBudgetActivity,
    @JsonKey(name: 'weekly_summary') bool weeklySummary,
  });
}

/// @nodoc
class _$NotificationPreferencesDtoCopyWithImpl<$Res>
    implements $NotificationPreferencesDtoCopyWith<$Res> {
  _$NotificationPreferencesDtoCopyWithImpl(this._self, this._then);

  final NotificationPreferencesDto _self;
  final $Res Function(NotificationPreferencesDto) _then;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? overspendAlerts = null,
    Object? billReminders = null,
    Object? emailBillReminders = null,
    Object? dailyLoggingReminder = null,
    Object? recurringTransactionAlerts = null,
    Object? sharedBudgetActivity = null,
    Object? weeklySummary = null,
  }) {
    return _then(
      _self.copyWith(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        pushEnabled: null == pushEnabled
            ? _self.pushEnabled
            : pushEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailEnabled: null == emailEnabled
            ? _self.emailEnabled
            : emailEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        overspendAlerts: null == overspendAlerts
            ? _self.overspendAlerts
            : overspendAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        billReminders: null == billReminders
            ? _self.billReminders
            : billReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailBillReminders: null == emailBillReminders
            ? _self.emailBillReminders
            : emailBillReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyLoggingReminder: null == dailyLoggingReminder
            ? _self.dailyLoggingReminder
            : dailyLoggingReminder // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurringTransactionAlerts: null == recurringTransactionAlerts
            ? _self.recurringTransactionAlerts
            : recurringTransactionAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharedBudgetActivity: null == sharedBudgetActivity
            ? _self.sharedBudgetActivity
            : sharedBudgetActivity // ignore: cast_nullable_to_non_nullable
                  as bool,
        weeklySummary: null == weeklySummary
            ? _self.weeklySummary
            : weeklySummary // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [NotificationPreferencesDto].
extension NotificationPreferencesDtoPatterns on NotificationPreferencesDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_NotificationPreferencesDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferencesDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_NotificationPreferencesDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferencesDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_NotificationPreferencesDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferencesDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'overspend_alerts') bool overspendAlerts,
      @JsonKey(name: 'bill_reminders') bool billReminders,
      @JsonKey(name: 'email_bill_reminders') bool emailBillReminders,
      @JsonKey(name: 'daily_logging_reminder') bool dailyLoggingReminder,
      @JsonKey(name: 'recurring_transaction_alerts')
      bool recurringTransactionAlerts,
      @JsonKey(name: 'shared_budget_activity') bool sharedBudgetActivity,
      @JsonKey(name: 'weekly_summary') bool weeklySummary,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferencesDto() when $default != null:
        return $default(
          _that.userId,
          _that.pushEnabled,
          _that.emailEnabled,
          _that.overspendAlerts,
          _that.billReminders,
          _that.emailBillReminders,
          _that.dailyLoggingReminder,
          _that.recurringTransactionAlerts,
          _that.sharedBudgetActivity,
          _that.weeklySummary,
        );
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'overspend_alerts') bool overspendAlerts,
      @JsonKey(name: 'bill_reminders') bool billReminders,
      @JsonKey(name: 'email_bill_reminders') bool emailBillReminders,
      @JsonKey(name: 'daily_logging_reminder') bool dailyLoggingReminder,
      @JsonKey(name: 'recurring_transaction_alerts')
      bool recurringTransactionAlerts,
      @JsonKey(name: 'shared_budget_activity') bool sharedBudgetActivity,
      @JsonKey(name: 'weekly_summary') bool weeklySummary,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferencesDto():
        return $default(
          _that.userId,
          _that.pushEnabled,
          _that.emailEnabled,
          _that.overspendAlerts,
          _that.billReminders,
          _that.emailBillReminders,
          _that.dailyLoggingReminder,
          _that.recurringTransactionAlerts,
          _that.sharedBudgetActivity,
          _that.weeklySummary,
        );
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
      @JsonKey(name: 'user_id') String userId,
      @JsonKey(name: 'push_enabled') bool pushEnabled,
      @JsonKey(name: 'email_enabled') bool emailEnabled,
      @JsonKey(name: 'overspend_alerts') bool overspendAlerts,
      @JsonKey(name: 'bill_reminders') bool billReminders,
      @JsonKey(name: 'email_bill_reminders') bool emailBillReminders,
      @JsonKey(name: 'daily_logging_reminder') bool dailyLoggingReminder,
      @JsonKey(name: 'recurring_transaction_alerts')
      bool recurringTransactionAlerts,
      @JsonKey(name: 'shared_budget_activity') bool sharedBudgetActivity,
      @JsonKey(name: 'weekly_summary') bool weeklySummary,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferencesDto() when $default != null:
        return $default(
          _that.userId,
          _that.pushEnabled,
          _that.emailEnabled,
          _that.overspendAlerts,
          _that.billReminders,
          _that.emailBillReminders,
          _that.dailyLoggingReminder,
          _that.recurringTransactionAlerts,
          _that.sharedBudgetActivity,
          _that.weeklySummary,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NotificationPreferencesDto implements NotificationPreferencesDto {
  const _NotificationPreferencesDto({
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'push_enabled') this.pushEnabled = true,
    @JsonKey(name: 'email_enabled') this.emailEnabled = true,
    @JsonKey(name: 'overspend_alerts') this.overspendAlerts = true,
    @JsonKey(name: 'bill_reminders') this.billReminders = true,
    @JsonKey(name: 'email_bill_reminders') this.emailBillReminders = true,
    @JsonKey(name: 'daily_logging_reminder') this.dailyLoggingReminder = true,
    @JsonKey(name: 'recurring_transaction_alerts')
    this.recurringTransactionAlerts = true,
    @JsonKey(name: 'shared_budget_activity') this.sharedBudgetActivity = true,
    @JsonKey(name: 'weekly_summary') this.weeklySummary = true,
  });
  factory _NotificationPreferencesDto.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesDtoFromJson(json);

  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'push_enabled')
  final bool pushEnabled;
  @override
  @JsonKey(name: 'email_enabled')
  final bool emailEnabled;
  @override
  @JsonKey(name: 'overspend_alerts')
  final bool overspendAlerts;
  @override
  @JsonKey(name: 'bill_reminders')
  final bool billReminders;
  @override
  @JsonKey(name: 'email_bill_reminders')
  final bool emailBillReminders;
  @override
  @JsonKey(name: 'daily_logging_reminder')
  final bool dailyLoggingReminder;
  @override
  @JsonKey(name: 'recurring_transaction_alerts')
  final bool recurringTransactionAlerts;
  @override
  @JsonKey(name: 'shared_budget_activity')
  final bool sharedBudgetActivity;
  @override
  @JsonKey(name: 'weekly_summary')
  final bool weeklySummary;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationPreferencesDtoCopyWith<_NotificationPreferencesDto>
  get copyWith =>
      __$NotificationPreferencesDtoCopyWithImpl<_NotificationPreferencesDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationPreferencesDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationPreferencesDto &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.overspendAlerts, overspendAlerts) ||
                other.overspendAlerts == overspendAlerts) &&
            (identical(other.billReminders, billReminders) ||
                other.billReminders == billReminders) &&
            (identical(other.emailBillReminders, emailBillReminders) ||
                other.emailBillReminders == emailBillReminders) &&
            (identical(other.dailyLoggingReminder, dailyLoggingReminder) ||
                other.dailyLoggingReminder == dailyLoggingReminder) &&
            (identical(
                  other.recurringTransactionAlerts,
                  recurringTransactionAlerts,
                ) ||
                other.recurringTransactionAlerts ==
                    recurringTransactionAlerts) &&
            (identical(other.sharedBudgetActivity, sharedBudgetActivity) ||
                other.sharedBudgetActivity == sharedBudgetActivity) &&
            (identical(other.weeklySummary, weeklySummary) ||
                other.weeklySummary == weeklySummary));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    userId,
    pushEnabled,
    emailEnabled,
    overspendAlerts,
    billReminders,
    emailBillReminders,
    dailyLoggingReminder,
    recurringTransactionAlerts,
    sharedBudgetActivity,
    weeklySummary,
  );

  @override
  String toString() {
    return 'NotificationPreferencesDto(userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, overspendAlerts: $overspendAlerts, billReminders: $billReminders, emailBillReminders: $emailBillReminders, dailyLoggingReminder: $dailyLoggingReminder, recurringTransactionAlerts: $recurringTransactionAlerts, sharedBudgetActivity: $sharedBudgetActivity, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class _$NotificationPreferencesDtoCopyWith<$Res>
    implements $NotificationPreferencesDtoCopyWith<$Res> {
  factory _$NotificationPreferencesDtoCopyWith(
    _NotificationPreferencesDto value,
    $Res Function(_NotificationPreferencesDto) _then,
  ) = __$NotificationPreferencesDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'push_enabled') bool pushEnabled,
    @JsonKey(name: 'email_enabled') bool emailEnabled,
    @JsonKey(name: 'overspend_alerts') bool overspendAlerts,
    @JsonKey(name: 'bill_reminders') bool billReminders,
    @JsonKey(name: 'email_bill_reminders') bool emailBillReminders,
    @JsonKey(name: 'daily_logging_reminder') bool dailyLoggingReminder,
    @JsonKey(name: 'recurring_transaction_alerts')
    bool recurringTransactionAlerts,
    @JsonKey(name: 'shared_budget_activity') bool sharedBudgetActivity,
    @JsonKey(name: 'weekly_summary') bool weeklySummary,
  });
}

/// @nodoc
class __$NotificationPreferencesDtoCopyWithImpl<$Res>
    implements _$NotificationPreferencesDtoCopyWith<$Res> {
  __$NotificationPreferencesDtoCopyWithImpl(this._self, this._then);

  final _NotificationPreferencesDto _self;
  final $Res Function(_NotificationPreferencesDto) _then;

  /// Create a copy of NotificationPreferencesDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? overspendAlerts = null,
    Object? billReminders = null,
    Object? emailBillReminders = null,
    Object? dailyLoggingReminder = null,
    Object? recurringTransactionAlerts = null,
    Object? sharedBudgetActivity = null,
    Object? weeklySummary = null,
  }) {
    return _then(
      _NotificationPreferencesDto(
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        pushEnabled: null == pushEnabled
            ? _self.pushEnabled
            : pushEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailEnabled: null == emailEnabled
            ? _self.emailEnabled
            : emailEnabled // ignore: cast_nullable_to_non_nullable
                  as bool,
        overspendAlerts: null == overspendAlerts
            ? _self.overspendAlerts
            : overspendAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        billReminders: null == billReminders
            ? _self.billReminders
            : billReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        emailBillReminders: null == emailBillReminders
            ? _self.emailBillReminders
            : emailBillReminders // ignore: cast_nullable_to_non_nullable
                  as bool,
        dailyLoggingReminder: null == dailyLoggingReminder
            ? _self.dailyLoggingReminder
            : dailyLoggingReminder // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurringTransactionAlerts: null == recurringTransactionAlerts
            ? _self.recurringTransactionAlerts
            : recurringTransactionAlerts // ignore: cast_nullable_to_non_nullable
                  as bool,
        sharedBudgetActivity: null == sharedBudgetActivity
            ? _self.sharedBudgetActivity
            : sharedBudgetActivity // ignore: cast_nullable_to_non_nullable
                  as bool,
        weeklySummary: null == weeklySummary
            ? _self.weeklySummary
            : weeklySummary // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
