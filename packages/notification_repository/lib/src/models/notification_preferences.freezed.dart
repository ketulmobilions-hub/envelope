// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_preferences.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NotificationPreferences {
  String get userId;
  bool get pushEnabled;
  bool get emailEnabled;
  bool get overspendAlerts;
  bool get billReminders;
  bool get dailyLoggingReminder;
  bool get recurringTransactionAlerts;
  bool get sharedBudgetActivity;
  bool get weeklySummary;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NotificationPreferencesCopyWith<NotificationPreferences> get copyWith =>
      _$NotificationPreferencesCopyWithImpl<NotificationPreferences>(
        this as NotificationPreferences,
        _$identity,
      );

  /// Serializes this NotificationPreferences to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NotificationPreferences &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.overspendAlerts, overspendAlerts) ||
                other.overspendAlerts == overspendAlerts) &&
            (identical(other.billReminders, billReminders) ||
                other.billReminders == billReminders) &&
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
    dailyLoggingReminder,
    recurringTransactionAlerts,
    sharedBudgetActivity,
    weeklySummary,
  );

  @override
  String toString() {
    return 'NotificationPreferences(userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, overspendAlerts: $overspendAlerts, billReminders: $billReminders, dailyLoggingReminder: $dailyLoggingReminder, recurringTransactionAlerts: $recurringTransactionAlerts, sharedBudgetActivity: $sharedBudgetActivity, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class $NotificationPreferencesCopyWith<$Res> {
  factory $NotificationPreferencesCopyWith(
    NotificationPreferences value,
    $Res Function(NotificationPreferences) _then,
  ) = _$NotificationPreferencesCopyWithImpl;
  @useResult
  $Res call({
    String userId,
    bool pushEnabled,
    bool emailEnabled,
    bool overspendAlerts,
    bool billReminders,
    bool dailyLoggingReminder,
    bool recurringTransactionAlerts,
    bool sharedBudgetActivity,
    bool weeklySummary,
  });
}

/// @nodoc
class _$NotificationPreferencesCopyWithImpl<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  _$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final NotificationPreferences _self;
  final $Res Function(NotificationPreferences) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? overspendAlerts = null,
    Object? billReminders = null,
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

/// Adds pattern-matching-related methods to [NotificationPreferences].
extension NotificationPreferencesPatterns on NotificationPreferences {
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
    TResult Function(_NotificationPreferences value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferences() when $default != null:
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
    TResult Function(_NotificationPreferences value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferences():
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
    TResult? Function(_NotificationPreferences value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferences() when $default != null:
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
      String userId,
      bool pushEnabled,
      bool emailEnabled,
      bool overspendAlerts,
      bool billReminders,
      bool dailyLoggingReminder,
      bool recurringTransactionAlerts,
      bool sharedBudgetActivity,
      bool weeklySummary,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferences() when $default != null:
        return $default(
          _that.userId,
          _that.pushEnabled,
          _that.emailEnabled,
          _that.overspendAlerts,
          _that.billReminders,
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
      String userId,
      bool pushEnabled,
      bool emailEnabled,
      bool overspendAlerts,
      bool billReminders,
      bool dailyLoggingReminder,
      bool recurringTransactionAlerts,
      bool sharedBudgetActivity,
      bool weeklySummary,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferences():
        return $default(
          _that.userId,
          _that.pushEnabled,
          _that.emailEnabled,
          _that.overspendAlerts,
          _that.billReminders,
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
      String userId,
      bool pushEnabled,
      bool emailEnabled,
      bool overspendAlerts,
      bool billReminders,
      bool dailyLoggingReminder,
      bool recurringTransactionAlerts,
      bool sharedBudgetActivity,
      bool weeklySummary,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NotificationPreferences() when $default != null:
        return $default(
          _that.userId,
          _that.pushEnabled,
          _that.emailEnabled,
          _that.overspendAlerts,
          _that.billReminders,
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
class _NotificationPreferences implements NotificationPreferences {
  const _NotificationPreferences({
    required this.userId,
    this.pushEnabled = true,
    this.emailEnabled = true,
    this.overspendAlerts = true,
    this.billReminders = true,
    this.dailyLoggingReminder = true,
    this.recurringTransactionAlerts = true,
    this.sharedBudgetActivity = true,
    this.weeklySummary = true,
  });
  factory _NotificationPreferences.fromJson(Map<String, dynamic> json) =>
      _$NotificationPreferencesFromJson(json);

  @override
  final String userId;
  @override
  @JsonKey()
  final bool pushEnabled;
  @override
  @JsonKey()
  final bool emailEnabled;
  @override
  @JsonKey()
  final bool overspendAlerts;
  @override
  @JsonKey()
  final bool billReminders;
  @override
  @JsonKey()
  final bool dailyLoggingReminder;
  @override
  @JsonKey()
  final bool recurringTransactionAlerts;
  @override
  @JsonKey()
  final bool sharedBudgetActivity;
  @override
  @JsonKey()
  final bool weeklySummary;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NotificationPreferencesCopyWith<_NotificationPreferences> get copyWith =>
      __$NotificationPreferencesCopyWithImpl<_NotificationPreferences>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$NotificationPreferencesToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NotificationPreferences &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.pushEnabled, pushEnabled) ||
                other.pushEnabled == pushEnabled) &&
            (identical(other.emailEnabled, emailEnabled) ||
                other.emailEnabled == emailEnabled) &&
            (identical(other.overspendAlerts, overspendAlerts) ||
                other.overspendAlerts == overspendAlerts) &&
            (identical(other.billReminders, billReminders) ||
                other.billReminders == billReminders) &&
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
    dailyLoggingReminder,
    recurringTransactionAlerts,
    sharedBudgetActivity,
    weeklySummary,
  );

  @override
  String toString() {
    return 'NotificationPreferences(userId: $userId, pushEnabled: $pushEnabled, emailEnabled: $emailEnabled, overspendAlerts: $overspendAlerts, billReminders: $billReminders, dailyLoggingReminder: $dailyLoggingReminder, recurringTransactionAlerts: $recurringTransactionAlerts, sharedBudgetActivity: $sharedBudgetActivity, weeklySummary: $weeklySummary)';
  }
}

/// @nodoc
abstract mixin class _$NotificationPreferencesCopyWith<$Res>
    implements $NotificationPreferencesCopyWith<$Res> {
  factory _$NotificationPreferencesCopyWith(
    _NotificationPreferences value,
    $Res Function(_NotificationPreferences) _then,
  ) = __$NotificationPreferencesCopyWithImpl;
  @override
  @useResult
  $Res call({
    String userId,
    bool pushEnabled,
    bool emailEnabled,
    bool overspendAlerts,
    bool billReminders,
    bool dailyLoggingReminder,
    bool recurringTransactionAlerts,
    bool sharedBudgetActivity,
    bool weeklySummary,
  });
}

/// @nodoc
class __$NotificationPreferencesCopyWithImpl<$Res>
    implements _$NotificationPreferencesCopyWith<$Res> {
  __$NotificationPreferencesCopyWithImpl(this._self, this._then);

  final _NotificationPreferences _self;
  final $Res Function(_NotificationPreferences) _then;

  /// Create a copy of NotificationPreferences
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? userId = null,
    Object? pushEnabled = null,
    Object? emailEnabled = null,
    Object? overspendAlerts = null,
    Object? billReminders = null,
    Object? dailyLoggingReminder = null,
    Object? recurringTransactionAlerts = null,
    Object? sharedBudgetActivity = null,
    Object? weeklySummary = null,
  }) {
    return _then(
      _NotificationPreferences(
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
