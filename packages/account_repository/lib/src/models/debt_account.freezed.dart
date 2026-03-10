// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'debt_account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DebtAccount {
  String get accountId;
  double get interestRate;
  int get minimumPayment;
  int get originalBalance;
  String? get payoffStrategy;

  /// Create a copy of DebtAccount
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DebtAccountCopyWith<DebtAccount> get copyWith =>
      _$DebtAccountCopyWithImpl<DebtAccount>(this as DebtAccount, _$identity);

  /// Serializes this DebtAccount to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DebtAccount &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.minimumPayment, minimumPayment) ||
                other.minimumPayment == minimumPayment) &&
            (identical(other.originalBalance, originalBalance) ||
                other.originalBalance == originalBalance) &&
            (identical(other.payoffStrategy, payoffStrategy) ||
                other.payoffStrategy == payoffStrategy));
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
  );

  @override
  String toString() {
    return 'DebtAccount(accountId: $accountId, interestRate: $interestRate, minimumPayment: $minimumPayment, originalBalance: $originalBalance, payoffStrategy: $payoffStrategy)';
  }
}

/// @nodoc
abstract mixin class $DebtAccountCopyWith<$Res> {
  factory $DebtAccountCopyWith(
    DebtAccount value,
    $Res Function(DebtAccount) _then,
  ) = _$DebtAccountCopyWithImpl;
  @useResult
  $Res call({
    String accountId,
    double interestRate,
    int minimumPayment,
    int originalBalance,
    String? payoffStrategy,
  });
}

/// @nodoc
class _$DebtAccountCopyWithImpl<$Res> implements $DebtAccountCopyWith<$Res> {
  _$DebtAccountCopyWithImpl(this._self, this._then);

  final DebtAccount _self;
  final $Res Function(DebtAccount) _then;

  /// Create a copy of DebtAccount
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? interestRate = null,
    Object? minimumPayment = null,
    Object? originalBalance = null,
    Object? payoffStrategy = freezed,
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
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [DebtAccount].
extension DebtAccountPatterns on DebtAccount {
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
    TResult Function(_DebtAccount value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DebtAccount() when $default != null:
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
    TResult Function(_DebtAccount value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccount():
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
    TResult? Function(_DebtAccount value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccount() when $default != null:
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
      String accountId,
      double interestRate,
      int minimumPayment,
      int originalBalance,
      String? payoffStrategy,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DebtAccount() when $default != null:
        return $default(
          _that.accountId,
          _that.interestRate,
          _that.minimumPayment,
          _that.originalBalance,
          _that.payoffStrategy,
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
      String accountId,
      double interestRate,
      int minimumPayment,
      int originalBalance,
      String? payoffStrategy,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccount():
        return $default(
          _that.accountId,
          _that.interestRate,
          _that.minimumPayment,
          _that.originalBalance,
          _that.payoffStrategy,
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
      String accountId,
      double interestRate,
      int minimumPayment,
      int originalBalance,
      String? payoffStrategy,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DebtAccount() when $default != null:
        return $default(
          _that.accountId,
          _that.interestRate,
          _that.minimumPayment,
          _that.originalBalance,
          _that.payoffStrategy,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DebtAccount implements DebtAccount {
  const _DebtAccount({
    required this.accountId,
    required this.interestRate,
    required this.minimumPayment,
    required this.originalBalance,
    this.payoffStrategy,
  });
  factory _DebtAccount.fromJson(Map<String, dynamic> json) =>
      _$DebtAccountFromJson(json);

  @override
  final String accountId;
  @override
  final double interestRate;
  @override
  final int minimumPayment;
  @override
  final int originalBalance;
  @override
  final String? payoffStrategy;

  /// Create a copy of DebtAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DebtAccountCopyWith<_DebtAccount> get copyWith =>
      __$DebtAccountCopyWithImpl<_DebtAccount>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DebtAccountToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DebtAccount &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.interestRate, interestRate) ||
                other.interestRate == interestRate) &&
            (identical(other.minimumPayment, minimumPayment) ||
                other.minimumPayment == minimumPayment) &&
            (identical(other.originalBalance, originalBalance) ||
                other.originalBalance == originalBalance) &&
            (identical(other.payoffStrategy, payoffStrategy) ||
                other.payoffStrategy == payoffStrategy));
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
  );

  @override
  String toString() {
    return 'DebtAccount(accountId: $accountId, interestRate: $interestRate, minimumPayment: $minimumPayment, originalBalance: $originalBalance, payoffStrategy: $payoffStrategy)';
  }
}

/// @nodoc
abstract mixin class _$DebtAccountCopyWith<$Res>
    implements $DebtAccountCopyWith<$Res> {
  factory _$DebtAccountCopyWith(
    _DebtAccount value,
    $Res Function(_DebtAccount) _then,
  ) = __$DebtAccountCopyWithImpl;
  @override
  @useResult
  $Res call({
    String accountId,
    double interestRate,
    int minimumPayment,
    int originalBalance,
    String? payoffStrategy,
  });
}

/// @nodoc
class __$DebtAccountCopyWithImpl<$Res> implements _$DebtAccountCopyWith<$Res> {
  __$DebtAccountCopyWithImpl(this._self, this._then);

  final _DebtAccount _self;
  final $Res Function(_DebtAccount) _then;

  /// Create a copy of DebtAccount
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? accountId = null,
    Object? interestRate = null,
    Object? minimumPayment = null,
    Object? originalBalance = null,
    Object? payoffStrategy = freezed,
  }) {
    return _then(
      _DebtAccount(
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
      ),
    );
  }
}
