// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountDto {
  String get id;
  @JsonKey(name: 'budget_id')
  String get budgetId;
  String get name;
  String get type;
  String get currency;
  @JsonKey(name: 'display_fx_rate')
  double get displayFxRate;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'starting_balance')
  int get startingBalance;
  @JsonKey(name: 'current_balance')
  int get currentBalance;
  @JsonKey(name: 'is_archived')
  bool get isArchived;
  @JsonKey(name: 'is_on_budget')
  bool get isOnBudget;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountDtoCopyWith<AccountDto> get copyWith =>
      _$AccountDtoCopyWithImpl<AccountDto>(this as AccountDto, _$identity);

  /// Serializes this AccountDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AccountDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.displayFxRate, displayFxRate) ||
                other.displayFxRate == displayFxRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.startingBalance, startingBalance) ||
                other.startingBalance == startingBalance) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isOnBudget, isOnBudget) ||
                other.isOnBudget == isOnBudget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    type,
    currency,
    displayFxRate,
    createdAt,
    updatedAt,
    startingBalance,
    currentBalance,
    isArchived,
    isOnBudget,
  );

  @override
  String toString() {
    return 'AccountDto(id: $id, budgetId: $budgetId, name: $name, type: $type, currency: $currency, displayFxRate: $displayFxRate, createdAt: $createdAt, updatedAt: $updatedAt, startingBalance: $startingBalance, currentBalance: $currentBalance, isArchived: $isArchived, isOnBudget: $isOnBudget)';
  }
}

/// @nodoc
abstract mixin class $AccountDtoCopyWith<$Res> {
  factory $AccountDtoCopyWith(
    AccountDto value,
    $Res Function(AccountDto) _then,
  ) = _$AccountDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    String type,
    String currency,
    @JsonKey(name: 'display_fx_rate') double displayFxRate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'starting_balance') int startingBalance,
    @JsonKey(name: 'current_balance') int currentBalance,
    @JsonKey(name: 'is_archived') bool isArchived,
    @JsonKey(name: 'is_on_budget') bool isOnBudget,
  });
}

/// @nodoc
class _$AccountDtoCopyWithImpl<$Res> implements $AccountDtoCopyWith<$Res> {
  _$AccountDtoCopyWithImpl(this._self, this._then);

  final AccountDto _self;
  final $Res Function(AccountDto) _then;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? type = null,
    Object? currency = null,
    Object? displayFxRate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? startingBalance = null,
    Object? currentBalance = null,
    Object? isArchived = null,
    Object? isOnBudget = null,
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        displayFxRate: null == displayFxRate
            ? _self.displayFxRate
            : displayFxRate // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startingBalance: null == startingBalance
            ? _self.startingBalance
            : startingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        currentBalance: null == currentBalance
            ? _self.currentBalance
            : currentBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOnBudget: null == isOnBudget
            ? _self.isOnBudget
            : isOnBudget // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AccountDto].
extension AccountDtoPatterns on AccountDto {
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
    TResult Function(_AccountDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
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
    TResult Function(_AccountDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto():
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
    TResult? Function(_AccountDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
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
      String type,
      String currency,
      @JsonKey(name: 'display_fx_rate') double displayFxRate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'starting_balance') int startingBalance,
      @JsonKey(name: 'current_balance') int currentBalance,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'is_on_budget') bool isOnBudget,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.currency,
          _that.displayFxRate,
          _that.createdAt,
          _that.updatedAt,
          _that.startingBalance,
          _that.currentBalance,
          _that.isArchived,
          _that.isOnBudget,
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
      String type,
      String currency,
      @JsonKey(name: 'display_fx_rate') double displayFxRate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'starting_balance') int startingBalance,
      @JsonKey(name: 'current_balance') int currentBalance,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'is_on_budget') bool isOnBudget,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.currency,
          _that.displayFxRate,
          _that.createdAt,
          _that.updatedAt,
          _that.startingBalance,
          _that.currentBalance,
          _that.isArchived,
          _that.isOnBudget,
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
      String type,
      String currency,
      @JsonKey(name: 'display_fx_rate') double displayFxRate,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'starting_balance') int startingBalance,
      @JsonKey(name: 'current_balance') int currentBalance,
      @JsonKey(name: 'is_archived') bool isArchived,
      @JsonKey(name: 'is_on_budget') bool isOnBudget,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AccountDto() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.currency,
          _that.displayFxRate,
          _that.createdAt,
          _that.updatedAt,
          _that.startingBalance,
          _that.currentBalance,
          _that.isArchived,
          _that.isOnBudget,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AccountDto implements AccountDto {
  const _AccountDto({
    required this.id,
    @JsonKey(name: 'budget_id') required this.budgetId,
    required this.name,
    required this.type,
    required this.currency,
    @JsonKey(name: 'display_fx_rate') this.displayFxRate = 1.0,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'starting_balance') this.startingBalance = 0,
    @JsonKey(name: 'current_balance') this.currentBalance = 0,
    @JsonKey(name: 'is_archived') this.isArchived = false,
    @JsonKey(name: 'is_on_budget') this.isOnBudget = true,
  });
  factory _AccountDto.fromJson(Map<String, dynamic> json) =>
      _$AccountDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'budget_id')
  final String budgetId;
  @override
  final String name;
  @override
  final String type;
  @override
  final String currency;
  @override
  @JsonKey(name: 'display_fx_rate')
  final double displayFxRate;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'starting_balance')
  final int startingBalance;
  @override
  @JsonKey(name: 'current_balance')
  final int currentBalance;
  @override
  @JsonKey(name: 'is_archived')
  final bool isArchived;
  @override
  @JsonKey(name: 'is_on_budget')
  final bool isOnBudget;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountDtoCopyWith<_AccountDto> get copyWith =>
      __$AccountDtoCopyWithImpl<_AccountDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AccountDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
            (identical(other.displayFxRate, displayFxRate) ||
                other.displayFxRate == displayFxRate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.startingBalance, startingBalance) ||
                other.startingBalance == startingBalance) &&
            (identical(other.currentBalance, currentBalance) ||
                other.currentBalance == currentBalance) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived) &&
            (identical(other.isOnBudget, isOnBudget) ||
                other.isOnBudget == isOnBudget));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    type,
    currency,
    displayFxRate,
    createdAt,
    updatedAt,
    startingBalance,
    currentBalance,
    isArchived,
    isOnBudget,
  );

  @override
  String toString() {
    return 'AccountDto(id: $id, budgetId: $budgetId, name: $name, type: $type, currency: $currency, displayFxRate: $displayFxRate, createdAt: $createdAt, updatedAt: $updatedAt, startingBalance: $startingBalance, currentBalance: $currentBalance, isArchived: $isArchived, isOnBudget: $isOnBudget)';
  }
}

/// @nodoc
abstract mixin class _$AccountDtoCopyWith<$Res>
    implements $AccountDtoCopyWith<$Res> {
  factory _$AccountDtoCopyWith(
    _AccountDto value,
    $Res Function(_AccountDto) _then,
  ) = __$AccountDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'budget_id') String budgetId,
    String name,
    String type,
    String currency,
    @JsonKey(name: 'display_fx_rate') double displayFxRate,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'starting_balance') int startingBalance,
    @JsonKey(name: 'current_balance') int currentBalance,
    @JsonKey(name: 'is_archived') bool isArchived,
    @JsonKey(name: 'is_on_budget') bool isOnBudget,
  });
}

/// @nodoc
class __$AccountDtoCopyWithImpl<$Res> implements _$AccountDtoCopyWith<$Res> {
  __$AccountDtoCopyWithImpl(this._self, this._then);

  final _AccountDto _self;
  final $Res Function(_AccountDto) _then;

  /// Create a copy of AccountDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? type = null,
    Object? currency = null,
    Object? displayFxRate = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? startingBalance = null,
    Object? currentBalance = null,
    Object? isArchived = null,
    Object? isOnBudget = null,
  }) {
    return _then(
      _AccountDto(
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
        type: null == type
            ? _self.type
            : type // ignore: cast_nullable_to_non_nullable
                  as String,
        currency: null == currency
            ? _self.currency
            : currency // ignore: cast_nullable_to_non_nullable
                  as String,
        displayFxRate: null == displayFxRate
            ? _self.displayFxRate
            : displayFxRate // ignore: cast_nullable_to_non_nullable
                  as double,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        startingBalance: null == startingBalance
            ? _self.startingBalance
            : startingBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        currentBalance: null == currentBalance
            ? _self.currentBalance
            : currentBalance // ignore: cast_nullable_to_non_nullable
                  as int,
        isArchived: null == isArchived
            ? _self.isArchived
            : isArchived // ignore: cast_nullable_to_non_nullable
                  as bool,
        isOnBudget: null == isOnBudget
            ? _self.isOnBudget
            : isOnBudget // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}
