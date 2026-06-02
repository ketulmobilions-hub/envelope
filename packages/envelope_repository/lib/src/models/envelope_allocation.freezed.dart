// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'envelope_allocation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$EnvelopeAllocation {
  String get id;
  String get envelopeId;
  DateTime get createdAt;
  int get allocatedAmount;

  /// Create a copy of EnvelopeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $EnvelopeAllocationCopyWith<EnvelopeAllocation> get copyWith =>
      _$EnvelopeAllocationCopyWithImpl<EnvelopeAllocation>(
        this as EnvelopeAllocation,
        _$identity,
      );

  /// Serializes this EnvelopeAllocation to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is EnvelopeAllocation &&
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
    return 'EnvelopeAllocation(id: $id, envelopeId: $envelopeId, createdAt: $createdAt, allocatedAmount: $allocatedAmount)';
  }
}

/// @nodoc
abstract mixin class $EnvelopeAllocationCopyWith<$Res> {
  factory $EnvelopeAllocationCopyWith(
    EnvelopeAllocation value,
    $Res Function(EnvelopeAllocation) _then,
  ) = _$EnvelopeAllocationCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String envelopeId,
    DateTime createdAt,
    int allocatedAmount,
  });
}

/// @nodoc
class _$EnvelopeAllocationCopyWithImpl<$Res>
    implements $EnvelopeAllocationCopyWith<$Res> {
  _$EnvelopeAllocationCopyWithImpl(this._self, this._then);

  final EnvelopeAllocation _self;
  final $Res Function(EnvelopeAllocation) _then;

  /// Create a copy of EnvelopeAllocation
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

/// Adds pattern-matching-related methods to [EnvelopeAllocation].
extension EnvelopeAllocationPatterns on EnvelopeAllocation {
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
    TResult Function(_EnvelopeAllocation value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocation() when $default != null:
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
    TResult Function(_EnvelopeAllocation value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocation():
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
    TResult? Function(_EnvelopeAllocation value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocation() when $default != null:
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
      String envelopeId,
      DateTime createdAt,
      int allocatedAmount,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocation() when $default != null:
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
      String envelopeId,
      DateTime createdAt,
      int allocatedAmount,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocation():
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
      String envelopeId,
      DateTime createdAt,
      int allocatedAmount,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _EnvelopeAllocation() when $default != null:
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
class _EnvelopeAllocation implements EnvelopeAllocation {
  const _EnvelopeAllocation({
    required this.id,
    required this.envelopeId,
    required this.createdAt,
    this.allocatedAmount = 0,
  });
  factory _EnvelopeAllocation.fromJson(Map<String, dynamic> json) =>
      _$EnvelopeAllocationFromJson(json);

  @override
  final String id;
  @override
  final String envelopeId;
  @override
  final DateTime createdAt;
  @override
  @JsonKey()
  final int allocatedAmount;

  /// Create a copy of EnvelopeAllocation
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$EnvelopeAllocationCopyWith<_EnvelopeAllocation> get copyWith =>
      __$EnvelopeAllocationCopyWithImpl<_EnvelopeAllocation>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$EnvelopeAllocationToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _EnvelopeAllocation &&
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
    return 'EnvelopeAllocation(id: $id, envelopeId: $envelopeId, createdAt: $createdAt, allocatedAmount: $allocatedAmount)';
  }
}

/// @nodoc
abstract mixin class _$EnvelopeAllocationCopyWith<$Res>
    implements $EnvelopeAllocationCopyWith<$Res> {
  factory _$EnvelopeAllocationCopyWith(
    _EnvelopeAllocation value,
    $Res Function(_EnvelopeAllocation) _then,
  ) = __$EnvelopeAllocationCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String envelopeId,
    DateTime createdAt,
    int allocatedAmount,
  });
}

/// @nodoc
class __$EnvelopeAllocationCopyWithImpl<$Res>
    implements _$EnvelopeAllocationCopyWith<$Res> {
  __$EnvelopeAllocationCopyWithImpl(this._self, this._then);

  final _EnvelopeAllocation _self;
  final $Res Function(_EnvelopeAllocation) _then;

  /// Create a copy of EnvelopeAllocation
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
      _EnvelopeAllocation(
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
