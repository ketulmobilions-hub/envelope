// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$BudgetDto {
  String get id;
  @JsonKey(name: 'owner_id')
  String get ownerId;
  String get name;
  @JsonKey(name: 'base_currency')
  String get baseCurrency;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'period_type')
  String get periodType;
  @JsonKey(name: 'period_start_day')
  int get periodStartDay;
  @JsonKey(name: 'is_archived')
  bool get isArchived;

  /// Legacy seed cash + migrated historical income (cents). Set during
  /// onboarding and never overwritten by routine account-balance refresh.
  @JsonKey(name: 'opening_balance')
  int get openingBalance;

  /// Cached sum of on-budget account starting balances (cents). Kept in
  /// sync by the client whenever an account's starting balance changes.
  @JsonKey(name: 'account_seed_balance')
  int get accountSeedBalance;

  /// Date the opening balance is anchored to.
  @JsonKey(name: 'opening_date')
  DateTime? get openingDate;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $BudgetDtoCopyWith<BudgetDto> get copyWith =>
      _$BudgetDtoCopyWithImpl<BudgetDto>(this as BudgetDto, _$identity);

  /// Serializes this BudgetDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is BudgetDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.periodStartDay, periodStartDay) ||
                other.periodStartDay == periodStartDay) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.openingBalance, openingBalance) ||
                other.openingBalance == openingBalance) &&
            (identical(other.accountSeedBalance, accountSeedBalance) ||
                other.accountSeedBalance == accountSeedBalance) &&
            (identical(other.openingDate, openingDate) ||
                other.openingDate == openingDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    name,
    baseCurrency,
    createdAt,
    updatedAt,
    periodType,
    periodStartDay,
    isArchived,
    openingBalance,
    accountSeedBalance,
    openingDate,
  );

  @override
  String toString() {
    return 'BudgetDto(id: $id, ownerId: $ownerId, name: $name, baseCurrency: $baseCurrency, createdAt: $createdAt, updatedAt: $updatedAt, periodType: $periodType, periodStartDay: $periodStartDay, isArchived: $isArchived, openingBalance: $openingBalance, accountSeedBalance: $accountSeedBalance, openingDate: $openingDate)';
  }
}

/// @nodoc
abstract mixin class $BudgetDtoCopyWith<$Res> {
  factory $BudgetDtoCopyWith(BudgetDto value, $Res Function(BudgetDto) _then) =
      _$BudgetDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'owner_id') String ownerId,
    String name,
    @JsonKey(name: 'base_currency') String baseCurrency,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'period_type') String periodType,
    @JsonKey(name: 'period_start_day') int periodStartDay,
    @JsonKey(name: 'is_archived') bool isArchived,
    @JsonKey(name: 'opening_balance') int openingBalance,
    @JsonKey(name: 'account_seed_balance') int accountSeedBalance,
    @JsonKey(name: 'opening_date') DateTime? openingDate,
  });
}

/// @nodoc
class _$BudgetDtoCopyWithImpl<$Res> implements $BudgetDtoCopyWith<$Res> {
  _$BudgetDtoCopyWithImpl(this._self, this._then);

  final BudgetDto _self;
  final $Res Function(BudgetDto) _then;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? baseCurrency = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? periodType = null,
    Object? periodStartDay = null,
    Object? isArchived = null,
    Object? openingBalance = null,
    Object? accountSeedBalance = null,
    Object? openingDate = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _self.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        baseCurrency: null == baseCurrency
            ? _self.baseCurrency
            : baseCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodType: null == periodType
            ? _self.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        periodStartDay: null == periodStartDay
            ? _self.periodStartDay
            : periodStartDay // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        openingBalance: null == openingBalance
            ? _self.openingBalance
            : openingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        accountSeedBalance: null == accountSeedBalance
            ? _self.accountSeedBalance
            : accountSeedBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        openingDate: freezed == openingDate
            ? _self.openingDate
            : openingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [BudgetDto].
extension BudgetDtoPatterns on BudgetDto {
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
    TResult Function(_BudgetDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetDto() when $default != null:
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
    TResult Function(_BudgetDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetDto():
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
    TResult? Function(_BudgetDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetDto() when $default != null:
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
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      @JsonKey(name: 'base_currency') String baseCurrency,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'period_type') String periodType,
      @JsonKey(name: 'period_start_day') int periodStartDay,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'opening_balance') int openingBalance,
      @JsonKey(name: 'account_seed_balance') int accountSeedBalance,
      @JsonKey(name: 'opening_date') DateTime? openingDate,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _BudgetDto() when $default != null:
        return $default(
          _that.id,
          _that.ownerId,
          _that.name,
          _that.baseCurrency,
          _that.createdAt,
          _that.updatedAt,
          _that.periodType,
          _that.periodStartDay,
          _that.isArchived,
          _that.openingBalance,
          _that.accountSeedBalance,
          _that.openingDate,
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
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      @JsonKey(name: 'base_currency') String baseCurrency,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'period_type') String periodType,
      @JsonKey(name: 'period_start_day') int periodStartDay,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'opening_balance') int openingBalance,
      @JsonKey(name: 'account_seed_balance') int accountSeedBalance,
      @JsonKey(name: 'opening_date') DateTime? openingDate,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetDto():
        return $default(
          _that.id,
          _that.ownerId,
          _that.name,
          _that.baseCurrency,
          _that.createdAt,
          _that.updatedAt,
          _that.periodType,
          _that.periodStartDay,
          _that.isArchived,
          _that.openingBalance,
          _that.accountSeedBalance,
          _that.openingDate,
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
      @JsonKey(name: 'owner_id') String ownerId,
      String name,
      @JsonKey(name: 'base_currency') String baseCurrency,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'period_type') String periodType,
      @JsonKey(name: 'period_start_day') int periodStartDay,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'opening_balance') int openingBalance,
      @JsonKey(name: 'account_seed_balance') int accountSeedBalance,
      @JsonKey(name: 'opening_date') DateTime? openingDate,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _BudgetDto() when $default != null:
        return $default(
          _that.id,
          _that.ownerId,
          _that.name,
          _that.baseCurrency,
          _that.createdAt,
          _that.updatedAt,
          _that.periodType,
          _that.periodStartDay,
          _that.isArchived,
          _that.openingBalance,
          _that.accountSeedBalance,
          _that.openingDate,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _BudgetDto implements BudgetDto {
  const _BudgetDto({
    required this.id,
    @JsonKey(name: 'owner_id') required this.ownerId,
    required this.name,
    @JsonKey(name: 'base_currency') required this.baseCurrency,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'period_type') this.periodType = 'monthly',
    @JsonKey(name: 'period_start_day') this.periodStartDay = 1,
    @JsonKey(name: 'is_archived') this.isArchived = false,
    @JsonKey(name: 'opening_balance') this.openingBalance = 0,
    @JsonKey(name: 'account_seed_balance') this.accountSeedBalance = 0,
    @JsonKey(name: 'opening_date') this.openingDate,
  });
  factory _BudgetDto.fromJson(Map<String, dynamic> json) =>
      _$BudgetDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'owner_id')
  final String ownerId;
  @override
  final String name;
  @override
  @JsonKey(name: 'base_currency')
  final String baseCurrency;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'period_type')
  final String periodType;
  @override
  @JsonKey(name: 'period_start_day')
  final int periodStartDay;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;

  /// Legacy seed cash + migrated historical income (cents). Set during
  /// onboarding and never overwritten by routine account-balance refresh.
  @override
  @JsonKey(name: 'opening_balance')
  final int openingBalance;

  /// Cached sum of on-budget account starting balances (cents). Kept in
  /// sync by the client whenever an account's starting balance changes.
  @override
  @JsonKey(name: 'account_seed_balance')
  final int accountSeedBalance;

  /// Date the opening balance is anchored to.
  @override
  @JsonKey(name: 'opening_date')
  final DateTime? openingDate;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$BudgetDtoCopyWith<_BudgetDto> get copyWith =>
      __$BudgetDtoCopyWithImpl<_BudgetDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$BudgetDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _BudgetDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ownerId, ownerId) || other.ownerId == ownerId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.periodType, periodType) ||
                other.periodType == periodType) &&
            (identical(other.periodStartDay, periodStartDay) ||
                other.periodStartDay == periodStartDay) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.openingBalance, openingBalance) ||
                other.openingBalance == openingBalance) &&
            (identical(other.accountSeedBalance, accountSeedBalance) ||
                other.accountSeedBalance == accountSeedBalance) &&
            (identical(other.openingDate, openingDate) ||
                other.openingDate == openingDate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ownerId,
    name,
    baseCurrency,
    createdAt,
    updatedAt,
    periodType,
    periodStartDay,
    isArchived,
    openingBalance,
    accountSeedBalance,
    openingDate,
  );

  @override
  String toString() {
    return 'BudgetDto(id: $id, ownerId: $ownerId, name: $name, baseCurrency: $baseCurrency, createdAt: $createdAt, updatedAt: $updatedAt, periodType: $periodType, periodStartDay: $periodStartDay, isArchived: $isArchived, openingBalance: $openingBalance, accountSeedBalance: $accountSeedBalance, openingDate: $openingDate)';
  }
}

/// @nodoc
abstract mixin class _$BudgetDtoCopyWith<$Res>
    implements $BudgetDtoCopyWith<$Res> {
  factory _$BudgetDtoCopyWith(
    _BudgetDto value,
    $Res Function(_BudgetDto) _then,
  ) = __$BudgetDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'owner_id') String ownerId,
    String name,
    @JsonKey(name: 'base_currency') String baseCurrency,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'period_type') String periodType,
    @JsonKey(name: 'period_start_day') int periodStartDay,
    @JsonKey(name: 'is_archived') bool isArchived,
    @JsonKey(name: 'opening_balance') int openingBalance,
    @JsonKey(name: 'account_seed_balance') int accountSeedBalance,
    @JsonKey(name: 'opening_date') DateTime? openingDate,
  });
}

/// @nodoc
class __$BudgetDtoCopyWithImpl<$Res> implements _$BudgetDtoCopyWith<$Res> {
  __$BudgetDtoCopyWithImpl(this._self, this._then);

  final _BudgetDto _self;
  final $Res Function(_BudgetDto) _then;

  /// Create a copy of BudgetDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? ownerId = null,
    Object? name = null,
    Object? baseCurrency = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? periodType = null,
    Object? periodStartDay = null,
    Object? isArchived = null,
    Object? openingBalance = null,
    Object? accountSeedBalance = null,
    Object? openingDate = freezed,
  }) {
    return _then(
      _BudgetDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ownerId: null == ownerId
            ? _self.ownerId
            : ownerId // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _self.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        baseCurrency: null == baseCurrency
            ? _self.baseCurrency
            : baseCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        periodType: null == periodType
            ? _self.periodType
            : periodType // ignore: cast_nullable_to_non_nullable
                  as String,
        periodStartDay: null == periodStartDay
            ? _self.periodStartDay
            : periodStartDay // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        openingBalance: null == openingBalance
            ? _self.openingBalance
            : openingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        accountSeedBalance: null == accountSeedBalance
            ? _self.accountSeedBalance
            : accountSeedBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        openingDate: freezed == openingDate
            ? _self.openingDate
            : openingDate // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}
