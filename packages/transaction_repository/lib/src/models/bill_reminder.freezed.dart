// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_reminder.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillReminder {
  String get id;
  String get budgetId;
  String get name;
  int get estimatedAmount;
  int get dueDay;
  String get frequency;
  DateTime get createdAt;
  String? get envelopeId;
  int get reminderDaysBefore;

  /// Create a copy of BillReminder
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BillReminderCopyWith<BillReminder> get copyWith =>
      _$BillReminderCopyWithImpl<BillReminder>(
        this as BillReminder,
        _$identity,
      );

  /// Serializes this BillReminder to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BillReminder &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.estimatedAmount, estimatedAmount) ||
                other.estimatedAmount == estimatedAmount) &&
            (identical(other.dueDay, dueDay) || other.dueDay == dueDay) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.reminderDaysBefore, reminderDaysBefore) ||
                other.reminderDaysBefore == reminderDaysBefore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    estimatedAmount,
    dueDay,
    frequency,
    createdAt,
    envelopeId,
    reminderDaysBefore,
  );

  @override
  String toString() {
    return 'BillReminder(id: $id, budgetId: $budgetId, name: $name, estimatedAmount: $estimatedAmount, dueDay: $dueDay, frequency: $frequency, createdAt: $createdAt, envelopeId: $envelopeId, reminderDaysBefore: $reminderDaysBefore)';
  }
}

/// @nodoc
abstract mixin class $BillReminderCopyWith<$Res> {
  factory $BillReminderCopyWith(
    BillReminder value,
    $Res Function(BillReminder) _then,
  ) = _$BillReminderCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    int estimatedAmount,
    int dueDay,
    String frequency,
    DateTime createdAt,
    String? envelopeId,
    int reminderDaysBefore,
  });
}

/// @nodoc
class _$BillReminderCopyWithImpl<$Res> implements $BillReminderCopyWith<$Res> {
  _$BillReminderCopyWithImpl(this._self, this._then);

  final BillReminder _self;
  final $Res Function(BillReminder) _then;

  /// Create a copy of BillReminder
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? estimatedAmount = null,
    Object? dueDay = null,
    Object? frequency = null,
    Object? createdAt = null,
    Object? envelopeId = freezed,
    Object? reminderDaysBefore = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedAmount: null == estimatedAmount
            ? _self.estimatedAmount
            : estimatedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        dueDay: null == dueDay
            ? _self.dueDay
            : dueDay // ignore: cast_nullable_to_non_nullable
                  as int,
        frequency: null == frequency
            ? _self.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderDaysBefore: null == reminderDaysBefore
            ? _self.reminderDaysBefore
            : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BillReminder].
extension BillReminderPatterns on BillReminder {
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
    TResult Function(_BillReminder value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BillReminder() when $default != null:
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
    TResult Function(_BillReminder value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminder():
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
    TResult? Function(_BillReminder value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminder() when $default != null:
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
      String id,
      String budgetId,
      String name,
      int estimatedAmount,
      int dueDay,
      String frequency,
      DateTime createdAt,
      String? envelopeId,
      int reminderDaysBefore,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BillReminder() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.estimatedAmount,
          _that.dueDay,
          _that.frequency,
          _that.createdAt,
          _that.envelopeId,
          _that.reminderDaysBefore,
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
      String id,
      String budgetId,
      String name,
      int estimatedAmount,
      int dueDay,
      String frequency,
      DateTime createdAt,
      String? envelopeId,
      int reminderDaysBefore,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminder():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.estimatedAmount,
          _that.dueDay,
          _that.frequency,
          _that.createdAt,
          _that.envelopeId,
          _that.reminderDaysBefore,
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
      String id,
      String budgetId,
      String name,
      int estimatedAmount,
      int dueDay,
      String frequency,
      DateTime createdAt,
      String? envelopeId,
      int reminderDaysBefore,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminder() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.estimatedAmount,
          _that.dueDay,
          _that.frequency,
          _that.createdAt,
          _that.envelopeId,
          _that.reminderDaysBefore,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BillReminder implements BillReminder {
  const _BillReminder({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.estimatedAmount,
    required this.dueDay,
    required this.frequency,
    required this.createdAt,
    this.envelopeId,
    this.reminderDaysBefore = 3,
  });
  factory _BillReminder.fromJson(Map<String, dynamic> json) =>
      _$BillReminderFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String name;
  @override
  final int estimatedAmount;
  @override
  final int dueDay;
  @override
  final String frequency;
  @override
  final DateTime createdAt;
  @override
  final String? envelopeId;
  @override
  @JsonKey()
  final int reminderDaysBefore;

  /// Create a copy of BillReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BillReminderCopyWith<_BillReminder> get copyWith =>
      __$BillReminderCopyWithImpl<_BillReminder>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BillReminderToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BillReminder &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.estimatedAmount, estimatedAmount) ||
                other.estimatedAmount == estimatedAmount) &&
            (identical(other.dueDay, dueDay) || other.dueDay == dueDay) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.reminderDaysBefore, reminderDaysBefore) ||
                other.reminderDaysBefore == reminderDaysBefore));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    estimatedAmount,
    dueDay,
    frequency,
    createdAt,
    envelopeId,
    reminderDaysBefore,
  );

  @override
  String toString() {
    return 'BillReminder(id: $id, budgetId: $budgetId, name: $name, estimatedAmount: $estimatedAmount, dueDay: $dueDay, frequency: $frequency, createdAt: $createdAt, envelopeId: $envelopeId, reminderDaysBefore: $reminderDaysBefore)';
  }
}

/// @nodoc
abstract mixin class _$BillReminderCopyWith<$Res>
    implements $BillReminderCopyWith<$Res> {
  factory _$BillReminderCopyWith(
    _BillReminder value,
    $Res Function(_BillReminder) _then,
  ) = __$BillReminderCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    int estimatedAmount,
    int dueDay,
    String frequency,
    DateTime createdAt,
    String? envelopeId,
    int reminderDaysBefore,
  });
}

/// @nodoc
class __$BillReminderCopyWithImpl<$Res>
    implements _$BillReminderCopyWith<$Res> {
  __$BillReminderCopyWithImpl(this._self, this._then);

  final _BillReminder _self;
  final $Res Function(_BillReminder) _then;

  /// Create a copy of BillReminder
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? estimatedAmount = null,
    Object? dueDay = null,
    Object? frequency = null,
    Object? createdAt = null,
    Object? envelopeId = freezed,
    Object? reminderDaysBefore = null,
  }) {
    return _then(
      _BillReminder(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        estimatedAmount: null == estimatedAmount
            ? _self.estimatedAmount
            : estimatedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        dueDay: null == dueDay
            ? _self.dueDay
            : dueDay // ignore: cast_nullable_to_non_nullable
                  as int,
        frequency: null == frequency
            ? _self.frequency
            : frequency // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        reminderDaysBefore: null == reminderDaysBefore
            ? _self.reminderDaysBefore
            : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
