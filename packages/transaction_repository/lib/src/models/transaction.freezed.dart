// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Transaction {
  String get id;
  String get budgetId;
  String get accountId;
  String get type;
  int get amount;
  String get currency;
  DateTime get date;
  String get createdBy;
  DateTime get createdAt;
  DateTime get updatedAt;
  String? get envelopeId;
  double get exchangeRate;
  int get baseCurrencyAmount;
  String? get payee;
  String? get notes;
  bool get isReconciled;
  String? get recurringRuleId;
  String? get transferPairId;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionCopyWith<Transaction> get copyWith =>
      _$TransactionCopyWithImpl<Transaction>(this as Transaction, _$identity);

  /// Serializes this Transaction to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Transaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.baseCurrencyAmount, baseCurrencyAmount) ||
                other.baseCurrencyAmount == baseCurrencyAmount) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.recurringRuleId, recurringRuleId) ||
                other.recurringRuleId == recurringRuleId) &&
            (identical(other.transferPairId, transferPairId) ||
                other.transferPairId == transferPairId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    accountId,
    type,
    amount,
    currency,
    date,
    createdBy,
    createdAt,
    updatedAt,
    envelopeId,
    exchangeRate,
    baseCurrencyAmount,
    payee,
    notes,
    isReconciled,
    recurringRuleId,
    transferPairId,
  );

  @override
  String toString() {
    return 'Transaction(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, date: $date, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, envelopeId: $envelopeId, exchangeRate: $exchangeRate, baseCurrencyAmount: $baseCurrencyAmount, payee: $payee, notes: $notes, isReconciled: $isReconciled, recurringRuleId: $recurringRuleId, transferPairId: $transferPairId)';
  }
}

/// @nodoc
abstract mixin class $TransactionCopyWith<$Res> {
  factory $TransactionCopyWith(
    Transaction value,
    $Res Function(Transaction) _then,
  ) = _$TransactionCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String accountId,
    String type,
    int amount,
    String currency,
    DateTime date,
    String createdBy,
    DateTime createdAt,
    DateTime updatedAt,
    String? envelopeId,
    double exchangeRate,
    int baseCurrencyAmount,
    String? payee,
    String? notes,
    bool isReconciled,
    String? recurringRuleId,
    String? transferPairId,
  });
}

/// @nodoc
class _$TransactionCopyWithImpl<$Res> implements $TransactionCopyWith<$Res> {
  _$TransactionCopyWithImpl(this._self, this._then);

  final Transaction _self;
  final $Res Function(Transaction) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? accountId = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? envelopeId = freezed,
    Object? exchangeRate = null,
    Object? baseCurrencyAmount = null,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? isReconciled = null,
    Object? recurringRuleId = freezed,
    Object? transferPairId = freezed,
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
        accountId: null == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        exchangeRate: null == exchangeRate
            ? _self.exchangeRate
            : exchangeRate // ignore: cast_nullable_to_non_nullable
                  as double,
        baseCurrencyAmount: null == baseCurrencyAmount
            ? _self.baseCurrencyAmount
            : baseCurrencyAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isReconciled: null == isReconciled
            ? _self.isReconciled
            : isReconciled // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurringRuleId: freezed == recurringRuleId
            ? _self.recurringRuleId
            : recurringRuleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        transferPairId: freezed == transferPairId
            ? _self.transferPairId
            : transferPairId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [Transaction].
extension TransactionPatterns on Transaction {
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
    TResult Function(_Transaction value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
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
    TResult Function(_Transaction value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction():
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
    TResult? Function(_Transaction value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
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
      String accountId,
      String type,
      int amount,
      String currency,
      DateTime date,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String? envelopeId,
      double exchangeRate,
      int baseCurrencyAmount,
      String? payee,
      String? notes,
      bool isReconciled,
      String? recurringRuleId,
      String? transferPairId,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.accountId,
          _that.type,
          _that.amount,
          _that.currency,
          _that.date,
          _that.createdBy,
          _that.createdAt,
          _that.updatedAt,
          _that.envelopeId,
          _that.exchangeRate,
          _that.baseCurrencyAmount,
          _that.payee,
          _that.notes,
          _that.isReconciled,
          _that.recurringRuleId,
          _that.transferPairId,
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
      String accountId,
      String type,
      int amount,
      String currency,
      DateTime date,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String? envelopeId,
      double exchangeRate,
      int baseCurrencyAmount,
      String? payee,
      String? notes,
      bool isReconciled,
      String? recurringRuleId,
      String? transferPairId,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction():
        return $default(
          _that.id,
          _that.budgetId,
          _that.accountId,
          _that.type,
          _that.amount,
          _that.currency,
          _that.date,
          _that.createdBy,
          _that.createdAt,
          _that.updatedAt,
          _that.envelopeId,
          _that.exchangeRate,
          _that.baseCurrencyAmount,
          _that.payee,
          _that.notes,
          _that.isReconciled,
          _that.recurringRuleId,
          _that.transferPairId,
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
      String accountId,
      String type,
      int amount,
      String currency,
      DateTime date,
      String createdBy,
      DateTime createdAt,
      DateTime updatedAt,
      String? envelopeId,
      double exchangeRate,
      int baseCurrencyAmount,
      String? payee,
      String? notes,
      bool isReconciled,
      String? recurringRuleId,
      String? transferPairId,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Transaction() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.accountId,
          _that.type,
          _that.amount,
          _that.currency,
          _that.date,
          _that.createdBy,
          _that.createdAt,
          _that.updatedAt,
          _that.envelopeId,
          _that.exchangeRate,
          _that.baseCurrencyAmount,
          _that.payee,
          _that.notes,
          _that.isReconciled,
          _that.recurringRuleId,
          _that.transferPairId,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _Transaction implements Transaction {
  const _Transaction({
    required this.id,
    required this.budgetId,
    required this.accountId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.date,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.envelopeId,
    this.exchangeRate = 1.0,
    this.baseCurrencyAmount = 0,
    this.payee,
    this.notes,
    this.isReconciled = false,
    this.recurringRuleId,
    this.transferPairId,
  });
  factory _Transaction.fromJson(Map<String, dynamic> json) =>
      _$TransactionFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String accountId;
  @override
  final String type;
  @override
  final int amount;
  @override
  final String currency;
  @override
  final DateTime date;
  @override
  final String createdBy;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  final String? envelopeId;
  @override
  @JsonKey()
  final double exchangeRate;
  @override
  @JsonKey()
  final int baseCurrencyAmount;
  @override
  final String? payee;
  @override
  final String? notes;
  @override
  @JsonKey()
  final bool isReconciled;
  @override
  final String? recurringRuleId;
  @override
  final String? transferPairId;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionCopyWith<_Transaction> get copyWith =>
      __$TransactionCopyWithImpl<_Transaction>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Transaction &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.createdBy, createdBy) ||
                other.createdBy == createdBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.baseCurrencyAmount, baseCurrencyAmount) ||
                other.baseCurrencyAmount == baseCurrencyAmount) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.recurringRuleId, recurringRuleId) ||
                other.recurringRuleId == recurringRuleId) &&
            (identical(other.transferPairId, transferPairId) ||
                other.transferPairId == transferPairId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    accountId,
    type,
    amount,
    currency,
    date,
    createdBy,
    createdAt,
    updatedAt,
    envelopeId,
    exchangeRate,
    baseCurrencyAmount,
    payee,
    notes,
    isReconciled,
    recurringRuleId,
    transferPairId,
  );

  @override
  String toString() {
    return 'Transaction(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, date: $date, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, envelopeId: $envelopeId, exchangeRate: $exchangeRate, baseCurrencyAmount: $baseCurrencyAmount, payee: $payee, notes: $notes, isReconciled: $isReconciled, recurringRuleId: $recurringRuleId, transferPairId: $transferPairId)';
  }
}

/// @nodoc
abstract mixin class _$TransactionCopyWith<$Res>
    implements $TransactionCopyWith<$Res> {
  factory _$TransactionCopyWith(
    _Transaction value,
    $Res Function(_Transaction) _then,
  ) = __$TransactionCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String accountId,
    String type,
    int amount,
    String currency,
    DateTime date,
    String createdBy,
    DateTime createdAt,
    DateTime updatedAt,
    String? envelopeId,
    double exchangeRate,
    int baseCurrencyAmount,
    String? payee,
    String? notes,
    bool isReconciled,
    String? recurringRuleId,
    String? transferPairId,
  });
}

/// @nodoc
class __$TransactionCopyWithImpl<$Res> implements _$TransactionCopyWith<$Res> {
  __$TransactionCopyWithImpl(this._self, this._then);

  final _Transaction _self;
  final $Res Function(_Transaction) _then;

  /// Create a copy of Transaction
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? accountId = null,
    Object? type = null,
    Object? amount = null,
    Object? currency = null,
    Object? date = null,
    Object? createdBy = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? envelopeId = freezed,
    Object? exchangeRate = null,
    Object? baseCurrencyAmount = null,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? isReconciled = null,
    Object? recurringRuleId = freezed,
    Object? transferPairId = freezed,
  }) {
    return _then(
      _Transaction(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        accountId: null == accountId
            ? _self.accountId
            : accountId // ignore: cast_nullable_to_non_nullable
                  as String,
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _self.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        createdBy: null == createdBy
            ? _self.createdBy
            : createdBy // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        exchangeRate: null == exchangeRate
            ? _self.exchangeRate
            : exchangeRate // ignore: cast_nullable_to_non_nullable
                  as double,
        baseCurrencyAmount: null == baseCurrencyAmount
            ? _self.baseCurrencyAmount
            : baseCurrencyAmount // ignore: cast_nullable_to_non_nullable
                  as int,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
        isReconciled: null == isReconciled
            ? _self.isReconciled
            : isReconciled // ignore: cast_nullable_to_non_nullable
                  as bool,
        recurringRuleId: freezed == recurringRuleId
            ? _self.recurringRuleId
            : recurringRuleId // ignore: cast_nullable_to_non_nullable
                  as String?,
        transferPairId: freezed == transferPairId
            ? _self.transferPairId
            : transferPairId // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
