// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Account {
  String get id;
  String get budgetId;
  String get name;
  String get type;
  String get currency;
  DateTime get createdAt;
  DateTime get updatedAt;
  int get startingBalance;
  int get currentBalance;
  bool get isArchived;
  bool get isOnBudget;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AccountCopyWith<Account> get copyWith =>
      _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Account &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
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
    createdAt,
    updatedAt,
    startingBalance,
    currentBalance,
    isArchived,
    isOnBudget,
  );

  @override
  String toString() {
    return 'Account(id: $id, budgetId: $budgetId, name: $name, type: $type, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt, startingBalance: $startingBalance, currentBalance: $currentBalance, isArchived: $isArchived, isOnBudget: $isOnBudget)';
  }
}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res> {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) =
      _$AccountCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    String type,
    String currency,
    DateTime createdAt,
    DateTime updatedAt,
    int startingBalance,
    int currentBalance,
    bool isArchived,
    bool isOnBudget,
  });
}

/// @nodoc
class _$AccountCopyWithImpl<$Res> implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? type = null,
    Object? currency = null,
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

/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
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
    TResult Function(_Account value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Account() when $default != null:
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
    TResult Function(_Account value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Account():
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
    TResult? Function(_Account value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Account() when $default != null:
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
      String name,
      String type,
      String currency,
      DateTime createdAt,
      DateTime updatedAt,
      int startingBalance,
      int currentBalance,
      bool isArchived,
      bool isOnBudget,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _Account() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.currency,
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
      String budgetId,
      String name,
      String type,
      String currency,
      DateTime createdAt,
      DateTime updatedAt,
      int startingBalance,
      int currentBalance,
      bool isArchived,
      bool isOnBudget,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Account():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.currency,
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
      String budgetId,
      String name,
      String type,
      String currency,
      DateTime createdAt,
      DateTime updatedAt,
      int startingBalance,
      int currentBalance,
      bool isArchived,
      bool isOnBudget,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _Account() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.type,
          _that.currency,
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
class _Account implements Account {
  const _Account({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.type,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
    this.startingBalance = 0,
    this.currentBalance = 0,
    this.isArchived = false,
    this.isOnBudget = true,
  });
  factory _Account.fromJson(Map<String, dynamic> json) =>
      _$AccountFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String name;
  @override
  final String type;
  @override
  final String currency;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final int startingBalance;
  @override
  @JsonKey()
  final int currentBalance;
  @override
  @JsonKey()
  final bool isArchived;
  @override
  @JsonKey()
  final bool isOnBudget;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AccountCopyWith<_Account> get copyWith =>
      __$AccountCopyWithImpl<_Account>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AccountToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Account &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.currency, currency) ||
                other.currency == currency) &&
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
    createdAt,
    updatedAt,
    startingBalance,
    currentBalance,
    isArchived,
    isOnBudget,
  );

  @override
  String toString() {
    return 'Account(id: $id, budgetId: $budgetId, name: $name, type: $type, currency: $currency, createdAt: $createdAt, updatedAt: $updatedAt, startingBalance: $startingBalance, currentBalance: $currentBalance, isArchived: $isArchived, isOnBudget: $isOnBudget)';
  }
}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) =
      __$AccountCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    String type,
    String currency,
    DateTime createdAt,
    DateTime updatedAt,
    int startingBalance,
    int currentBalance,
    bool isArchived,
    bool isOnBudget,
  });
}

/// @nodoc
class __$AccountCopyWithImpl<$Res> implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

  /// Create a copy of Account
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? type = null,
    Object? currency = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? startingBalance = null,
    Object? currentBalance = null,
    Object? isArchived = null,
    Object? isOnBudget = null,
  }) {
    return _then(
      _Account(
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
