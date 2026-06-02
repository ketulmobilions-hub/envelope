// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'envelope_allocation_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvelopeAllocationDto {
  String get id;
  @JsonKey(name: 'envelope_id')
  String get envelopeId;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'allocated_amount')
  int get allocatedAmount;

  /// Create a copy of EnvelopeAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvelopeAllocationDtoCopyWith<EnvelopeAllocationDto> get copyWith =>
      _$EnvelopeAllocationDtoCopyWithImpl<EnvelopeAllocationDto>(
        this as EnvelopeAllocationDto,
        _$identity,
      );

  /// Serializes this EnvelopeAllocationDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvelopeAllocationDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.allocatedAmount, allocatedAmount) ||
                other.allocatedAmount == allocatedAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, envelopeId, createdAt, allocatedAmount);

  @override
  String toString() {
    return 'EnvelopeAllocationDto(id: $id, envelopeId: $envelopeId, createdAt: $createdAt, allocatedAmount: $allocatedAmount)';
  }
}

/// @nodoc
abstract mixin class $EnvelopeAllocationDtoCopyWith<$Res> {
  factory $EnvelopeAllocationDtoCopyWith(
    EnvelopeAllocationDto value,
    $Res Function(EnvelopeAllocationDto) _then,
  ) = _$EnvelopeAllocationDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'envelope_id') String envelopeId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'allocated_amount') int allocatedAmount,
  });
}

/// @nodoc
class _$EnvelopeAllocationDtoCopyWithImpl<$Res>
    implements $EnvelopeAllocationDtoCopyWith<$Res> {
  _$EnvelopeAllocationDtoCopyWithImpl(this._self, this._then);

  final EnvelopeAllocationDto _self;
  final $Res Function(EnvelopeAllocationDto) _then;

  /// Create a copy of EnvelopeAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? envelopeId = null,
    Object? createdAt = null,
    Object? allocatedAmount = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        allocatedAmount: null == allocatedAmount
            ? _self.allocatedAmount
            : allocatedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [EnvelopeAllocationDto].
extension EnvelopeAllocationDtoPatterns on EnvelopeAllocationDto {
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
    TResult Function(_EnvelopeAllocationDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocationDto() when $default != null:
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
    TResult Function(_EnvelopeAllocationDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocationDto():
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
    TResult? Function(_EnvelopeAllocationDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocationDto() when $default != null:
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
      @JsonKey(name: 'envelope_id') String envelopeId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'allocated_amount') int allocatedAmount,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocationDto() when $default != null:
        return $default(
          _that.id,
          _that.envelopeId,
          _that.createdAt,
          _that.allocatedAmount,
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
      @JsonKey(name: 'envelope_id') String envelopeId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'allocated_amount') int allocatedAmount,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocationDto():
        return $default(
          _that.id,
          _that.envelopeId,
          _that.createdAt,
          _that.allocatedAmount,
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
      @JsonKey(name: 'envelope_id') String envelopeId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'allocated_amount') int allocatedAmount,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocationDto() when $default != null:
        return $default(
          _that.id,
          _that.envelopeId,
          _that.createdAt,
          _that.allocatedAmount,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _EnvelopeAllocationDto implements EnvelopeAllocationDto {
  const _EnvelopeAllocationDto({
    required this.id,
    @JsonKey(name: 'envelope_id') required this.envelopeId,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'allocated_amount') this.allocatedAmount = 0,
  });
  factory _EnvelopeAllocationDto.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeAllocationDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'envelope_id')
  final String envelopeId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'allocated_amount')
  final int allocatedAmount;

  /// Create a copy of EnvelopeAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvelopeAllocationDtoCopyWith<_EnvelopeAllocationDto> get copyWith =>
      __$EnvelopeAllocationDtoCopyWithImpl<_EnvelopeAllocationDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$EnvelopeAllocationDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvelopeAllocationDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.allocatedAmount, allocatedAmount) ||
                other.allocatedAmount == allocatedAmount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, envelopeId, createdAt, allocatedAmount);

  @override
  String toString() {
    return 'EnvelopeAllocationDto(id: $id, envelopeId: $envelopeId, createdAt: $createdAt, allocatedAmount: $allocatedAmount)';
  }
}

/// @nodoc
abstract mixin class _$EnvelopeAllocationDtoCopyWith<$Res>
    implements $EnvelopeAllocationDtoCopyWith<$Res> {
  factory _$EnvelopeAllocationDtoCopyWith(
    _EnvelopeAllocationDto value,
    $Res Function(_EnvelopeAllocationDto) _then,
  ) = __$EnvelopeAllocationDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'envelope_id') String envelopeId,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'allocated_amount') int allocatedAmount,
  });
}

/// @nodoc
class __$EnvelopeAllocationDtoCopyWithImpl<$Res>
    implements _$EnvelopeAllocationDtoCopyWith<$Res> {
  __$EnvelopeAllocationDtoCopyWithImpl(this._self, this._then);

  final _EnvelopeAllocationDto _self;
  final $Res Function(_EnvelopeAllocationDto) _then;

  /// Create a copy of EnvelopeAllocationDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? envelopeId = null,
    Object? createdAt = null,
    Object? allocatedAmount = null,
  }) {
    return _then(
      _EnvelopeAllocationDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        allocatedAmount: null == allocatedAmount
            ? _self.allocatedAmount
            : allocatedAmount // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}
