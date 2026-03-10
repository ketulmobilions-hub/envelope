// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_split_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionSplitDto {
  String get id;
  @JsonKey(name: 'transaction_id')
  String get transactionId;
  @JsonKey(name: 'envelope_id')
  String get envelopeId;
  double get amount;

  /// Create a copy of TransactionSplitDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionSplitDtoCopyWith<TransactionSplitDto> get copyWith =>
      _$TransactionSplitDtoCopyWithImpl<TransactionSplitDto>(
        this as TransactionSplitDto,
        _$identity,
      );

  /// Serializes this TransactionSplitDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionSplitDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, transactionId, envelopeId, amount);

  @override
  String toString() {
    return 'TransactionSplitDto(id: $id, transactionId: $transactionId, envelopeId: $envelopeId, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class $TransactionSplitDtoCopyWith<$Res> {
  factory $TransactionSplitDtoCopyWith(
    TransactionSplitDto value,
    $Res Function(TransactionSplitDto) _then,
  ) = _$TransactionSplitDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'transaction_id') String transactionId,
    @JsonKey(name: 'envelope_id') String envelopeId,
    double amount,
  });
}

/// @nodoc
class _$TransactionSplitDtoCopyWithImpl<$Res>
    implements $TransactionSplitDtoCopyWith<$Res> {
  _$TransactionSplitDtoCopyWithImpl(this._self, this._then);

  final TransactionSplitDto _self;
  final $Res Function(TransactionSplitDto) _then;

  /// Create a copy of TransactionSplitDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? envelopeId = null,
    Object? amount = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: null == transactionId
            ? _self.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [TransactionSplitDto].
extension TransactionSplitDtoPatterns on TransactionSplitDto {
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
    TResult Function(_TransactionSplitDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionSplitDto() when $default != null:
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
    TResult Function(_TransactionSplitDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplitDto():
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
    TResult? Function(_TransactionSplitDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplitDto() when $default != null:
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
      @JsonKey(name: 'transaction_id') String transactionId,
      @JsonKey(name: 'envelope_id') String envelopeId,
      double amount,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionSplitDto() when $default != null:
        return $default(
          _that.id,
          _that.transactionId,
          _that.envelopeId,
          _that.amount,
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
      @JsonKey(name: 'transaction_id') String transactionId,
      @JsonKey(name: 'envelope_id') String envelopeId,
      double amount,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplitDto():
        return $default(
          _that.id,
          _that.transactionId,
          _that.envelopeId,
          _that.amount,
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
      @JsonKey(name: 'transaction_id') String transactionId,
      @JsonKey(name: 'envelope_id') String envelopeId,
      double amount,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionSplitDto() when $default != null:
        return $default(
          _that.id,
          _that.transactionId,
          _that.envelopeId,
          _that.amount,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _TransactionSplitDto implements TransactionSplitDto {
  const _TransactionSplitDto({
    required this.id,
    @JsonKey(name: 'transaction_id') required this.transactionId,
    @JsonKey(name: 'envelope_id') required this.envelopeId,
    required this.amount,
  });
  factory _TransactionSplitDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionSplitDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'transaction_id')
  final String transactionId;
  @override
  @JsonKey(name: 'envelope_id')
  final String envelopeId;
  @override
  final double amount;

  /// Create a copy of TransactionSplitDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionSplitDtoCopyWith<_TransactionSplitDto> get copyWith =>
      __$TransactionSplitDtoCopyWithImpl<_TransactionSplitDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionSplitDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionSplitDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.transactionId, transactionId) ||
                other.transactionId == transactionId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.amount, amount) || other.amount == amount));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, transactionId, envelopeId, amount);

  @override
  String toString() {
    return 'TransactionSplitDto(id: $id, transactionId: $transactionId, envelopeId: $envelopeId, amount: $amount)';
  }
}

/// @nodoc
abstract mixin class _$TransactionSplitDtoCopyWith<$Res>
    implements $TransactionSplitDtoCopyWith<$Res> {
  factory _$TransactionSplitDtoCopyWith(
    _TransactionSplitDto value,
    $Res Function(_TransactionSplitDto) _then,
  ) = __$TransactionSplitDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'transaction_id') String transactionId,
    @JsonKey(name: 'envelope_id') String envelopeId,
    double amount,
  });
}

/// @nodoc
class __$TransactionSplitDtoCopyWithImpl<$Res>
    implements _$TransactionSplitDtoCopyWith<$Res> {
  __$TransactionSplitDtoCopyWithImpl(this._self, this._then);

  final _TransactionSplitDto _self;
  final $Res Function(_TransactionSplitDto) _then;

  /// Create a copy of TransactionSplitDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? transactionId = null,
    Object? envelopeId = null,
    Object? amount = null,
  }) {
    return _then(
      _TransactionSplitDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        transactionId: null == transactionId
            ? _self.transactionId
            : transactionId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
