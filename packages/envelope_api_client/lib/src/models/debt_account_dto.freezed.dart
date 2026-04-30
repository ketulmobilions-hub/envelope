// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_account_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtAccountDto {
  @JsonKey(name: 'account_id')
  String get accountId;
  @JsonKey(name: 'interest_rate')
  double get interestRate;
  @JsonKey(name: 'minimum_payment')
  int get minimumPayment;
  @JsonKey(name: 'original_balance')
  int get originalBalance;
  @JsonKey(name: 'payoff_strategy')
  String? get payoffStrategy;
  @JsonKey(name: 'credit_limit', includeIfNull: false)
  int? get creditLimit;

  /// Create a copy of DebtAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DebtAccountDtoCopyWith<DebtAccountDto> get copyWith =>
      _$DebtAccountDtoCopyWithImpl<DebtAccountDto>(
        this as DebtAccountDto,
        _$identity,
      );

  /// Serializes this DebtAccountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DebtAccountDto &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.minimumPayment, minimumPayment) ||
                other.minimumPayment == minimumPayment) &&
            (identical(other.originalBalance, originalBalance) ||
                other.originalBalance == originalBalance) &&
            (identical(other.payoffStrategy, payoffStrategy) ||
                other.payoffStrategy == payoffStrategy) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accountId,
    interestRate,
    minimumPayment,
    originalBalance,
    payoffStrategy,
    creditLimit,
  );

  @override
  String toString() {
    return 'DebtAccountDto(accountId: $accountId, interestRate: $interestRate, minimumPayment: $minimumPayment, originalBalance: $originalBalance, payoffStrategy: $payoffStrategy, creditLimit: $creditLimit)';
  }
}

/// @nodoc
abstract mixin class $DebtAccountDtoCopyWith<$Res> {
  factory $DebtAccountDtoCopyWith(
    DebtAccountDto value,
    $Res Function(DebtAccountDto) _then,
  ) = _$DebtAccountDtoCopyWithImpl;
  @useResult
  $Res call({
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'interest_rate') double interestRate,
    @JsonKey(name: 'minimum_payment') int minimumPayment,
    @JsonKey(name: 'original_balance') int originalBalance,
    @JsonKey(name: 'payoff_strategy') String? payoffStrategy,
    @JsonKey(name: 'credit_limit', includeIfNull: false) int? creditLimit,
  });
}

/// @nodoc
class _$DebtAccountDtoCopyWithImpl<$Res>
    implements $DebtAccountDtoCopyWith<$Res> {
  _$DebtAccountDtoCopyWithImpl(this._self, this._then);

  final DebtAccountDto _self;
  final $Res Function(DebtAccountDto) _then;

  /// Create a copy of DebtAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? interestRate = null,
    Object? minimumPayment = null,
    Object? originalBalance = null,
    Object? payoffStrategy = freezed,
    Object? creditLimit = freezed,
  }) {
    return _then(
      _self.copyWith(
        accountId: null == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        interestRate: null == interestRate
            ? _self.interestRate
            : interestRate // ignore: cast_nullable_to_non_nullable
                  as double,
        minimumPayment: null == minimumPayment
            ? _self.minimumPayment
            : minimumPayment // ignore: cast_nullable_to_non_nullable
                  as int,
        originalBalance: null == originalBalance
            ? _self.originalBalance
            : originalBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        payoffStrategy: freezed == payoffStrategy
            ? _self.payoffStrategy
            : payoffStrategy // ignore: cast_nullable_to_non_nullable
                  as String?,
        creditLimit: freezed == creditLimit
            ? _self.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [DebtAccountDto].
extension DebtAccountDtoPatterns on DebtAccountDto {
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
    TResult Function(_DebtAccountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DebtAccountDto() when $default != null:
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
    TResult Function(_DebtAccountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccountDto():
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
    TResult? Function(_DebtAccountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccountDto() when $default != null:
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
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'interest_rate') double interestRate,
      @JsonKey(name: 'minimum_payment') int minimumPayment,
      @JsonKey(name: 'original_balance') int originalBalance,
      @JsonKey(name: 'payoff_strategy') String? payoffStrategy,
      @JsonKey(name: 'credit_limit', includeIfNull: false) int? creditLimit,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DebtAccountDto() when $default != null:
        return $default(
          _that.accountId,
          _that.interestRate,
          _that.minimumPayment,
          _that.originalBalance,
          _that.payoffStrategy,
          _that.creditLimit,
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
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'interest_rate') double interestRate,
      @JsonKey(name: 'minimum_payment') int minimumPayment,
      @JsonKey(name: 'original_balance') int originalBalance,
      @JsonKey(name: 'payoff_strategy') String? payoffStrategy,
      @JsonKey(name: 'credit_limit', includeIfNull: false) int? creditLimit,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccountDto():
        return $default(
          _that.accountId,
          _that.interestRate,
          _that.minimumPayment,
          _that.originalBalance,
          _that.payoffStrategy,
          _that.creditLimit,
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
      @JsonKey(name: 'account_id') String accountId,
      @JsonKey(name: 'interest_rate') double interestRate,
      @JsonKey(name: 'minimum_payment') int minimumPayment,
      @JsonKey(name: 'original_balance') int originalBalance,
      @JsonKey(name: 'payoff_strategy') String? payoffStrategy,
      @JsonKey(name: 'credit_limit', includeIfNull: false) int? creditLimit,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccountDto() when $default != null:
        return $default(
          _that.accountId,
          _that.interestRate,
          _that.minimumPayment,
          _that.originalBalance,
          _that.payoffStrategy,
          _that.creditLimit,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DebtAccountDto implements DebtAccountDto {
  const _DebtAccountDto({
    @JsonKey(name: 'account_id') required this.accountId,
    @JsonKey(name: 'interest_rate') required this.interestRate,
    @JsonKey(name: 'minimum_payment') required this.minimumPayment,
    @JsonKey(name: 'original_balance') required this.originalBalance,
    @JsonKey(name: 'payoff_strategy') this.payoffStrategy,
    @JsonKey(name: 'credit_limit', includeIfNull: false) this.creditLimit,
  });
  factory _DebtAccountDto.fromJson(Map<String, dynamic> json) =>
      _$DebtAccountDtoFromJson(json);

  @override
  @JsonKey(name: 'account_id')
  final String accountId;
  @override
  @JsonKey(name: 'interest_rate')
  final double interestRate;
  @override
  @JsonKey(name: 'minimum_payment')
  final int minimumPayment;
  @override
  @JsonKey(name: 'original_balance')
  final int originalBalance;
  @override
  @JsonKey(name: 'payoff_strategy')
  final String? payoffStrategy;
  @override
  @JsonKey(name: 'credit_limit', includeIfNull: false)
  final int? creditLimit;

  /// Create a copy of DebtAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DebtAccountDtoCopyWith<_DebtAccountDto> get copyWith =>
      __$DebtAccountDtoCopyWithImpl<_DebtAccountDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DebtAccountDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DebtAccountDto &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.minimumPayment, minimumPayment) ||
                other.minimumPayment == minimumPayment) &&
            (identical(other.originalBalance, originalBalance) ||
                other.originalBalance == originalBalance) &&
            (identical(other.payoffStrategy, payoffStrategy) ||
                other.payoffStrategy == payoffStrategy) &&
            (identical(other.creditLimit, creditLimit) ||
                other.creditLimit == creditLimit));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    accountId,
    interestRate,
    minimumPayment,
    originalBalance,
    payoffStrategy,
    creditLimit,
  );

  @override
  String toString() {
    return 'DebtAccountDto(accountId: $accountId, interestRate: $interestRate, minimumPayment: $minimumPayment, originalBalance: $originalBalance, payoffStrategy: $payoffStrategy, creditLimit: $creditLimit)';
  }
}

/// @nodoc
abstract mixin class _$DebtAccountDtoCopyWith<$Res>
    implements $DebtAccountDtoCopyWith<$Res> {
  factory _$DebtAccountDtoCopyWith(
    _DebtAccountDto value,
    $Res Function(_DebtAccountDto) _then,
  ) = __$DebtAccountDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    @JsonKey(name: 'account_id') String accountId,
    @JsonKey(name: 'interest_rate') double interestRate,
    @JsonKey(name: 'minimum_payment') int minimumPayment,
    @JsonKey(name: 'original_balance') int originalBalance,
    @JsonKey(name: 'payoff_strategy') String? payoffStrategy,
    @JsonKey(name: 'credit_limit', includeIfNull: false) int? creditLimit,
  });
}

/// @nodoc
class __$DebtAccountDtoCopyWithImpl<$Res>
    implements _$DebtAccountDtoCopyWith<$Res> {
  __$DebtAccountDtoCopyWithImpl(this._self, this._then);

  final _DebtAccountDto _self;
  final $Res Function(_DebtAccountDto) _then;

  /// Create a copy of DebtAccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountId = null,
    Object? interestRate = null,
    Object? minimumPayment = null,
    Object? originalBalance = null,
    Object? payoffStrategy = freezed,
    Object? creditLimit = freezed,
  }) {
    return _then(
      _DebtAccountDto(
        accountId: null == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        interestRate: null == interestRate
            ? _self.interestRate
            : interestRate // ignore: cast_nullable_to_non_nullable
                  as double,
        minimumPayment: null == minimumPayment
            ? _self.minimumPayment
            : minimumPayment // ignore: cast_nullable_to_non_nullable
                  as int,
        originalBalance: null == originalBalance
            ? _self.originalBalance
            : originalBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        payoffStrategy: freezed == payoffStrategy
            ? _self.payoffStrategy
            : payoffStrategy // ignore: cast_nullable_to_non_nullable
                  as String?,
        creditLimit: freezed == creditLimit
            ? _self.creditLimit
            : creditLimit // ignore: cast_nullable_to_non_nullable
                  as int?,
      ),
    );
  }
}
