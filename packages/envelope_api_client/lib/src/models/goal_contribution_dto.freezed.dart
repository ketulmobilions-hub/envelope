// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'goal_contribution_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GoalContributionDto {
  String get id;
  @JsonKey(name: 'goal_id')
  String get goalId;
  @JsonKey(name: 'amount_cents')
  int get amountCents;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  String? get note;

  /// Create a copy of GoalContributionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GoalContributionDtoCopyWith<GoalContributionDto> get copyWith =>
      _$GoalContributionDtoCopyWithImpl<GoalContributionDto>(
        this as GoalContributionDto,
        _$identity,
      );

  /// Serializes this GoalContributionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GoalContributionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, goalId, amountCents, createdAt, note);

  @override
  String toString() {
    return 'GoalContributionDto(id: $id, goalId: $goalId, amountCents: $amountCents, createdAt: $createdAt, note: $note)';
  }
}

/// @nodoc
abstract mixin class $GoalContributionDtoCopyWith<$Res> {
  factory $GoalContributionDtoCopyWith(
    GoalContributionDto value,
    $Res Function(GoalContributionDto) _then,
  ) = _$GoalContributionDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'goal_id') String goalId,
    @JsonKey(name: 'amount_cents') int amountCents,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? note,
  });
}

/// @nodoc
class _$GoalContributionDtoCopyWithImpl<$Res>
    implements $GoalContributionDtoCopyWith<$Res> {
  _$GoalContributionDtoCopyWithImpl(this._self, this._then);

  final GoalContributionDto _self;
  final $Res Function(GoalContributionDto) _then;

  /// Create a copy of GoalContributionDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? amountCents = null,
    Object? createdAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        goalId: null == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountCents: null == amountCents
            ? _self.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: freezed == note
            ? _self.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [GoalContributionDto].
extension GoalContributionDtoPatterns on GoalContributionDto {
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
    TResult Function(_GoalContributionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalContributionDto() when $default != null:
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
    TResult Function(_GoalContributionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContributionDto():
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
    TResult? Function(_GoalContributionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContributionDto() when $default != null:
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
      @JsonKey(name: 'goal_id') String goalId,
      @JsonKey(name: 'amount_cents') int amountCents,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? note,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _GoalContributionDto() when $default != null:
        return $default(
          _that.id,
          _that.goalId,
          _that.amountCents,
          _that.createdAt,
          _that.note,
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
      @JsonKey(name: 'goal_id') String goalId,
      @JsonKey(name: 'amount_cents') int amountCents,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? note,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContributionDto():
        return $default(
          _that.id,
          _that.goalId,
          _that.amountCents,
          _that.createdAt,
          _that.note,
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
      @JsonKey(name: 'goal_id') String goalId,
      @JsonKey(name: 'amount_cents') int amountCents,
      @JsonKey(name: 'created_at') DateTime createdAt,
      String? note,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _GoalContributionDto() when $default != null:
        return $default(
          _that.id,
          _that.goalId,
          _that.amountCents,
          _that.createdAt,
          _that.note,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _GoalContributionDto implements GoalContributionDto {
  const _GoalContributionDto({
    required this.id,
    @JsonKey(name: 'goal_id') required this.goalId,
    @JsonKey(name: 'amount_cents') required this.amountCents,
    @JsonKey(name: 'created_at') required this.createdAt,
    this.note,
  });
  factory _GoalContributionDto.fromJson(Map<String, dynamic> json) =>
      _$GoalContributionDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'goal_id')
  final String goalId;
  @override
  @JsonKey(name: 'amount_cents')
  final int amountCents;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  final String? note;

  /// Create a copy of GoalContributionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GoalContributionDtoCopyWith<_GoalContributionDto> get copyWith =>
      __$GoalContributionDtoCopyWithImpl<_GoalContributionDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$GoalContributionDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GoalContributionDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.goalId, goalId) || other.goalId == goalId) &&
            (identical(other.amountCents, amountCents) ||
                other.amountCents == amountCents) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.note, note) || other.note == note));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, goalId, amountCents, createdAt, note);

  @override
  String toString() {
    return 'GoalContributionDto(id: $id, goalId: $goalId, amountCents: $amountCents, createdAt: $createdAt, note: $note)';
  }
}

/// @nodoc
abstract mixin class _$GoalContributionDtoCopyWith<$Res>
    implements $GoalContributionDtoCopyWith<$Res> {
  factory _$GoalContributionDtoCopyWith(
    _GoalContributionDto value,
    $Res Function(_GoalContributionDto) _then,
  ) = __$GoalContributionDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'goal_id') String goalId,
    @JsonKey(name: 'amount_cents') int amountCents,
    @JsonKey(name: 'created_at') DateTime createdAt,
    String? note,
  });
}

/// @nodoc
class __$GoalContributionDtoCopyWithImpl<$Res>
    implements _$GoalContributionDtoCopyWith<$Res> {
  __$GoalContributionDtoCopyWithImpl(this._self, this._then);

  final _GoalContributionDto _self;
  final $Res Function(_GoalContributionDto) _then;

  /// Create a copy of GoalContributionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? goalId = null,
    Object? amountCents = null,
    Object? createdAt = null,
    Object? note = freezed,
  }) {
    return _then(
      _GoalContributionDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        goalId: null == goalId
            ? _self.goalId
            : goalId // ignore: cast_nullable_to_non_nullable
                  as String,
        amountCents: null == amountCents
            ? _self.amountCents
            : amountCents // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        note: freezed == note
            ? _self.note
            : note // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
