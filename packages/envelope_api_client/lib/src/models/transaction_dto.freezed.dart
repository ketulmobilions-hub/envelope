// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$TransactionDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  @JsonKey(name: 'account_id')
  String get accountId;
  String get type;
  int get amount;
  String get currency;
  DateTime get date;
  @JsonKey(name: 'created_by')
  String get createdBy;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'exchange_rate')
  double get exchangeRate;
  @JsonKey(name: 'is_reconciled')
  bool get isReconciled;
  @JsonKey(name: 'envelope_id')
  String? get envelopeId;
  String? get payee;
  String? get notes;
  @JsonKey(name: 'recurring_rule_id')
  String? get recurringRuleId;
  @JsonKey(name: 'transfer_pair_id')
  String? get transferPairId;

  /// Create a copy of TransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TransactionDtoCopyWith<TransactionDto> get copyWith =>
      _$TransactionDtoCopyWithImpl<TransactionDto>(
        this as TransactionDto,
        _$identity,
      );

  /// Serializes this TransactionDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TransactionDto &&
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
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    exchangeRate,
    isReconciled,
    envelopeId,
    payee,
    notes,
    recurringRuleId,
    transferPairId,
  );

  @override
  String toString() {
    return 'TransactionDto(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, date: $date, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, exchangeRate: $exchangeRate, isReconciled: $isReconciled, envelopeId: $envelopeId, payee: $payee, notes: $notes, recurringRuleId: $recurringRuleId, transferPairId: $transferPairId)';
  }
}

/// @nodoc
abstract mixin class $TransactionDtoCopyWith<$Res> {
  factory $TransactionDtoCopyWith(
    TransactionDto value,
    $Res Function(TransactionDto) _then,
  ) = _$TransactionDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'account_id') String accountId,
    String type,
    int amount,
    String currency,
    DateTime date,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'exchange_rate') double exchangeRate,
    @JsonKey(name: 'is_reconciled') bool isReconciled,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    String? payee,
    String? notes,
    @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
    @JsonKey(name: 'transfer_pair_id') String? transferPairId,
  });
}

/// @nodoc
class _$TransactionDtoCopyWithImpl<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  _$TransactionDtoCopyWithImpl(this._self, this._then);

  final TransactionDto _self;
  final $Res Function(TransactionDto) _then;

  /// Create a copy of TransactionDto
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
    Object? exchangeRate = null,
    Object? isReconciled = null,
    Object? envelopeId = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
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
        exchangeRate: null == exchangeRate
            ? _self.exchangeRate
            : exchangeRate // ignore: cast_nullable_to_non_nullable
                  as double,
        isReconciled: null == isReconciled
            ? _self.isReconciled
            : isReconciled // ignore: cast_nullable_to_non_nullable
                  as bool,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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

/// Adds pattern-matching-related methods to [TransactionDto].
extension TransactionDtoPatterns on TransactionDto {
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
    TResult Function(_TransactionDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
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
    TResult Function(_TransactionDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto():
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
    TResult? Function(_TransactionDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
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
      @JsonKey(name: 'account_id') String accountId,
      String type,
      int amount,
      String currency,
      DateTime date,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'exchange_rate') double exchangeRate,
      @JsonKey(name: 'is_reconciled') bool isReconciled,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      String? payee,
      String? notes,
      @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
      @JsonKey(name: 'transfer_pair_id') String? transferPairId,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
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
          _that.exchangeRate,
          _that.isReconciled,
          _that.envelopeId,
          _that.payee,
          _that.notes,
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
      @JsonKey(name: 'budget_id') String budgetId,
      @JsonKey(name: 'account_id') String accountId,
      String type,
      int amount,
      String currency,
      DateTime date,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'exchange_rate') double exchangeRate,
      @JsonKey(name: 'is_reconciled') bool isReconciled,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      String? payee,
      String? notes,
      @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
      @JsonKey(name: 'transfer_pair_id') String? transferPairId,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto():
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
          _that.exchangeRate,
          _that.isReconciled,
          _that.envelopeId,
          _that.payee,
          _that.notes,
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
      @JsonKey(name: 'budget_id') String budgetId,
      @JsonKey(name: 'account_id') String accountId,
      String type,
      int amount,
      String currency,
      DateTime date,
      @JsonKey(name: 'created_by') String createdBy,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'exchange_rate') double exchangeRate,
      @JsonKey(name: 'is_reconciled') bool isReconciled,
      @JsonKey(name: 'envelope_id') String? envelopeId,
      String? payee,
      String? notes,
      @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
      @JsonKey(name: 'transfer_pair_id') String? transferPairId,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _TransactionDto() when $default != null:
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
          _that.exchangeRate,
          _that.isReconciled,
          _that.envelopeId,
          _that.payee,
          _that.notes,
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
class _TransactionDto implements TransactionDto {
  const _TransactionDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    @JsonKey(name: 'account_id') required this.accountId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.date,
    @JsonKey(name: 'created_by') required this.createdBy,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'exchange_rate') this.exchangeRate = 1.0,
    @JsonKey(name: 'is_reconciled') this.isReconciled = false,
    @JsonKey(name: 'envelope_id') this.envelopeId,
    this.payee,
    this.notes,
    @JsonKey(name: 'recurring_rule_id') this.recurringRuleId,
    @JsonKey(name: 'transfer_pair_id') this.transferPairId,
  });
  factory _TransactionDto.fromJson(Map<String, dynamic> json) =>
      _$TransactionDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  @JsonKey(name: 'account_id')
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
  @JsonKey(name: 'created_by')
  final String createdBy;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'exchange_rate')
  final double exchangeRate;
  @override
  @JsonKey(name: 'is_reconciled')
  final bool isReconciled;
  @override
  @JsonKey(name: 'envelope_id')
  final String? envelopeId;
  @override
  final String? payee;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'recurring_rule_id')
  final String? recurringRuleId;
  @override
  @JsonKey(name: 'transfer_pair_id')
  final String? transferPairId;

  /// Create a copy of TransactionDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TransactionDtoCopyWith<_TransactionDto> get copyWith =>
      __$TransactionDtoCopyWithImpl<_TransactionDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TransactionDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TransactionDto &&
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
            (identical(other.exchangeRate, exchangeRate) ||
                other.exchangeRate == exchangeRate) &&
            (identical(other.isReconciled, isReconciled) ||
                other.isReconciled == isReconciled) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.payee, payee) || other.payee == payee) &&
            (identical(other.notes, notes) || other.notes == notes) &&
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
    exchangeRate,
    isReconciled,
    envelopeId,
    payee,
    notes,
    recurringRuleId,
    transferPairId,
  );

  @override
  String toString() {
    return 'TransactionDto(id: $id, budgetId: $budgetId, accountId: $accountId, type: $type, amount: $amount, currency: $currency, date: $date, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt, exchangeRate: $exchangeRate, isReconciled: $isReconciled, envelopeId: $envelopeId, payee: $payee, notes: $notes, recurringRuleId: $recurringRuleId, transferPairId: $transferPairId)';
  }
}

/// @nodoc
abstract mixin class _$TransactionDtoCopyWith<$Res>
    implements $TransactionDtoCopyWith<$Res> {
  factory _$TransactionDtoCopyWith(
    _TransactionDto value,
    $Res Function(_TransactionDto) _then,
  ) = __$TransactionDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    @JsonKey(name: 'account_id') String accountId,
    String type,
    int amount,
    String currency,
    DateTime date,
    @JsonKey(name: 'created_by') String createdBy,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'exchange_rate') double exchangeRate,
    @JsonKey(name: 'is_reconciled') bool isReconciled,
    @JsonKey(name: 'envelope_id') String? envelopeId,
    String? payee,
    String? notes,
    @JsonKey(name: 'recurring_rule_id') String? recurringRuleId,
    @JsonKey(name: 'transfer_pair_id') String? transferPairId,
  });
}

/// @nodoc
class __$TransactionDtoCopyWithImpl<$Res>
    implements _$TransactionDtoCopyWith<$Res> {
  __$TransactionDtoCopyWithImpl(this._self, this._then);

  final _TransactionDto _self;
  final $Res Function(_TransactionDto) _then;

  /// Create a copy of TransactionDto
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
    Object? exchangeRate = null,
    Object? isReconciled = null,
    Object? envelopeId = freezed,
    Object? payee = freezed,
    Object? notes = freezed,
    Object? recurringRuleId = freezed,
    Object? transferPairId = freezed,
  }) {
    return _then(
      _TransactionDto(
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
        exchangeRate: null == exchangeRate
            ? _self.exchangeRate
            : exchangeRate // ignore: cast_nullable_to_non_nullable
                  as double,
        isReconciled: null == isReconciled
            ? _self.isReconciled
            : isReconciled // ignore: cast_nullable_to_non_nullable
                  as bool,
        envelopeId: freezed == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String?,
        payee: freezed == payee
            ? _self.payee
            : payee // ignore: cast_nullable_to_non_nullable
                  as String?,
        notes: freezed == notes
            ? _self.notes
            : notes // ignore: cast_nullable_to_non_nullable
                  as String?,
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
