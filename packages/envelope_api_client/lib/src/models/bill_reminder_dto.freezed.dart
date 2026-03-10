// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_reminder_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BillReminderDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get name;
  @JsonKey(name: 'estimated_amount')
  int get estimatedAmount;
  @JsonKey(name: 'due_day')
  int get dueDay;
  String get frequency;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'reminder_days_before')
  int get reminderDaysBefore;
  @JsonKey(name: 'envelope_id')
  String? get envelopeId;

  /// Create a copy of BillReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BillReminderDtoCopyWith<BillReminderDto> get copyWith =>
      _$BillReminderDtoCopyWithImpl<BillReminderDto>(
        this as BillReminderDto,
        _$identity,
      );

  /// Serializes this BillReminderDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BillReminderDto &&
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
            (identical(other.reminderDaysBefore, reminderDaysBefore) ||
                other.reminderDaysBefore == reminderDaysBefore) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId));
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
    reminderDaysBefore,
    envelopeId,
  );

  @override
  String toString() {
    return 'BillReminderDto(id: $id, budgetId: $budgetId, name: $name, estimatedAmount: $estimatedAmount, dueDay: $dueDay, frequency: $frequency, createdAt: $createdAt, reminderDaysBefore: $reminderDaysBefore, envelopeId: $envelopeId)';
  }
}

/// @nodoc
abstract mixin class $BillReminderDtoCopyWith<$Res> {
  factory $BillReminderDtoCopyWith(
    BillReminderDto value,
    $Res Function(BillReminderDto) _then,
  ) = _$BillReminderDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'estimated_amount') int estimatedAmount,
    @JsonKey(name: 'due_day') int dueDay,
    String frequency,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'reminder_days_before') int reminderDaysBefore,
    @JsonKey(name: 'envelope_id') String? envelopeId,
  });
}

/// @nodoc
class _$BillReminderDtoCopyWithImpl<$Res>
    implements $BillReminderDtoCopyWith<$Res> {
  _$BillReminderDtoCopyWithImpl(this._self, this._then);

  final BillReminderDto _self;
  final $Res Function(BillReminderDto) _then;

  /// Create a copy of BillReminderDto
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
    Object? reminderDaysBefore = null,
    Object? envelopeId = freezed,
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
        reminderDaysBefore: null == reminderDaysBefore
            ? _self.reminderDaysBefore
            : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
                  as int,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BillReminderDto].
extension BillReminderDtoPatterns on BillReminderDto {
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
    TResult Function(_BillReminderDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BillReminderDto() when $default != null:
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
    TResult Function(_BillReminderDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminderDto():
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
    TResult? Function(_BillReminderDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminderDto() when $default != null:
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
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'estimated_amount') int estimatedAmount,
      @JsonKey(name: 'due_day') int dueDay,
      String frequency,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'reminder_days_before') int reminderDaysBefore,
      @JsonKey(name: 'envelope_id') String? envelopeId,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BillReminderDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.estimatedAmount,
          _that.dueDay,
          _that.frequency,
          _that.createdAt,
          _that.reminderDaysBefore,
          _that.envelopeId,
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
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'estimated_amount') int estimatedAmount,
      @JsonKey(name: 'due_day') int dueDay,
      String frequency,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'reminder_days_before') int reminderDaysBefore,
      @JsonKey(name: 'envelope_id') String? envelopeId,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminderDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.estimatedAmount,
          _that.dueDay,
          _that.frequency,
          _that.createdAt,
          _that.reminderDaysBefore,
          _that.envelopeId,
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
      @JsonKey(name: 'budget_id') String budgetId,
      String name,
      @JsonKey(name: 'estimated_amount') int estimatedAmount,
      @JsonKey(name: 'due_day') int dueDay,
      String frequency,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'reminder_days_before') int reminderDaysBefore,
      @JsonKey(name: 'envelope_id') String? envelopeId,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BillReminderDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.estimatedAmount,
          _that.dueDay,
          _that.frequency,
          _that.createdAt,
          _that.reminderDaysBefore,
          _that.envelopeId,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BillReminderDto implements BillReminderDto {
  const _BillReminderDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.name,
    @JsonKey(name: 'estimated_amount') required this.estimatedAmount,
    @JsonKey(name: 'due_day') required this.dueDay,
    required this.frequency,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'reminder_days_before') this.reminderDaysBefore = 3,
    @JsonKey(name: 'envelope_id') this.envelopeId,
  });
  factory _BillReminderDto.fromJson(Map<String, dynamic> json) =>
      _$BillReminderDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  final String name;
  @override
  @JsonKey(name: 'estimated_amount')
  final int estimatedAmount;
  @override
  @JsonKey(name: 'due_day')
  final int dueDay;
  @override
  final String frequency;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'reminder_days_before')
  final int reminderDaysBefore;
  @override
  @JsonKey(name: 'envelope_id')
  final String? envelopeId;

  /// Create a copy of BillReminderDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BillReminderDtoCopyWith<_BillReminderDto> get copyWith =>
      __$BillReminderDtoCopyWithImpl<_BillReminderDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BillReminderDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BillReminderDto &&
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
            (identical(other.reminderDaysBefore, reminderDaysBefore) ||
                other.reminderDaysBefore == reminderDaysBefore) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId));
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
    reminderDaysBefore,
    envelopeId,
  );

  @override
  String toString() {
    return 'BillReminderDto(id: $id, budgetId: $budgetId, name: $name, estimatedAmount: $estimatedAmount, dueDay: $dueDay, frequency: $frequency, createdAt: $createdAt, reminderDaysBefore: $reminderDaysBefore, envelopeId: $envelopeId)';
  }
}

/// @nodoc
abstract mixin class _$BillReminderDtoCopyWith<$Res>
    implements $BillReminderDtoCopyWith<$Res> {
  factory _$BillReminderDtoCopyWith(
    _BillReminderDto value,
    $Res Function(_BillReminderDto) _then,
  ) = __$BillReminderDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    @JsonKey(name: 'estimated_amount') int estimatedAmount,
    @JsonKey(name: 'due_day') int dueDay,
    String frequency,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'reminder_days_before') int reminderDaysBefore,
    @JsonKey(name: 'envelope_id') String? envelopeId,
  });
}

/// @nodoc
class __$BillReminderDtoCopyWithImpl<$Res>
    implements _$BillReminderDtoCopyWith<$Res> {
  __$BillReminderDtoCopyWithImpl(this._self, this._then);

  final _BillReminderDto _self;
  final $Res Function(_BillReminderDto) _then;

  /// Create a copy of BillReminderDto
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
    Object? reminderDaysBefore = null,
    Object? envelopeId = freezed,
  }) {
    return _then(
      _BillReminderDto(
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
        reminderDaysBefore: null == reminderDaysBefore
            ? _self.reminderDaysBefore
            : reminderDaysBefore // ignore: cast_nullable_to_non_nullable
                  as int,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
