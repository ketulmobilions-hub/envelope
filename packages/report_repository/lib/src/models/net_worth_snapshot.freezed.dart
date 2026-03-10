// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'net_worth_snapshot.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NetWorthSnapshot {
  String get id;
  String get budgetId;
  DateTime get date;
  int get assets;
  int get liabilities;
  int get netWorth;
  DateTime get createdAt;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $NetWorthSnapshotCopyWith<NetWorthSnapshot> get copyWith =>
      _$NetWorthSnapshotCopyWithImpl<NetWorthSnapshot>(
        this as NetWorthSnapshot,
        _$identity,
      );

  /// Serializes this NetWorthSnapshot to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is NetWorthSnapshot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.assets, assets) || other.assets == assets) &&
            (identical(other.liabilities, liabilities) ||
                other.liabilities == liabilities) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    date,
    assets,
    liabilities,
    netWorth,
    createdAt,
  );

  @override
  String toString() {
    return 'NetWorthSnapshot(id: $id, budgetId: $budgetId, date: $date, assets: $assets, liabilities: $liabilities, netWorth: $netWorth, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $NetWorthSnapshotCopyWith<$Res> {
  factory $NetWorthSnapshotCopyWith(
    NetWorthSnapshot value,
    $Res Function(NetWorthSnapshot) _then,
  ) = _$NetWorthSnapshotCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    DateTime date,
    int assets,
    int liabilities,
    int netWorth,
    DateTime createdAt,
  });
}

/// @nodoc
class _$NetWorthSnapshotCopyWithImpl<$Res>
    implements $NetWorthSnapshotCopyWith<$Res> {
  _$NetWorthSnapshotCopyWithImpl(this._self, this._then);

  final NetWorthSnapshot _self;
  final $Res Function(NetWorthSnapshot) _then;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? date = null,
    Object? assets = null,
    Object? liabilities = null,
    Object? netWorth = null,
    Object? createdAt = null,
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
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        assets: null == assets
            ? _self.assets
            : assets // ignore: cast_nullable_to_non_nullable
                  as int,
        liabilities: null == liabilities
            ? _self.liabilities
            : liabilities // ignore: cast_nullable_to_non_nullable
                  as int,
        netWorth: null == netWorth
            ? _self.netWorth
            : netWorth // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [NetWorthSnapshot].
extension NetWorthSnapshotPatterns on NetWorthSnapshot {
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
    TResult Function(_NetWorthSnapshot value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NetWorthSnapshot() when $default != null:
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
    TResult Function(_NetWorthSnapshot value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetWorthSnapshot():
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
    TResult? Function(_NetWorthSnapshot value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetWorthSnapshot() when $default != null:
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
      DateTime date,
      int assets,
      int liabilities,
      int netWorth,
      DateTime createdAt,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _NetWorthSnapshot() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.date,
          _that.assets,
          _that.liabilities,
          _that.netWorth,
          _that.createdAt,
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
      DateTime date,
      int assets,
      int liabilities,
      int netWorth,
      DateTime createdAt,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetWorthSnapshot():
        return $default(
          _that.id,
          _that.budgetId,
          _that.date,
          _that.assets,
          _that.liabilities,
          _that.netWorth,
          _that.createdAt,
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
      DateTime date,
      int assets,
      int liabilities,
      int netWorth,
      DateTime createdAt,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _NetWorthSnapshot() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.date,
          _that.assets,
          _that.liabilities,
          _that.netWorth,
          _that.createdAt,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _NetWorthSnapshot implements NetWorthSnapshot {
  const _NetWorthSnapshot({
    required this.id,
    required this.budgetId,
    required this.date,
    required this.assets,
    required this.liabilities,
    required this.netWorth,
    required this.createdAt,
  });
  factory _NetWorthSnapshot.fromJson(Map<String, dynamic> json) =>
      _$NetWorthSnapshotFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final DateTime date;
  @override
  final int assets;
  @override
  final int liabilities;
  @override
  final int netWorth;
  @override
  final DateTime createdAt;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$NetWorthSnapshotCopyWith<_NetWorthSnapshot> get copyWith =>
      __$NetWorthSnapshotCopyWithImpl<_NetWorthSnapshot>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$NetWorthSnapshotToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _NetWorthSnapshot &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.assets, assets) || other.assets == assets) &&
            (identical(other.liabilities, liabilities) ||
                other.liabilities == liabilities) &&
            (identical(other.netWorth, netWorth) ||
                other.netWorth == netWorth) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    date,
    assets,
    liabilities,
    netWorth,
    createdAt,
  );

  @override
  String toString() {
    return 'NetWorthSnapshot(id: $id, budgetId: $budgetId, date: $date, assets: $assets, liabilities: $liabilities, netWorth: $netWorth, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$NetWorthSnapshotCopyWith<$Res>
    implements $NetWorthSnapshotCopyWith<$Res> {
  factory _$NetWorthSnapshotCopyWith(
    _NetWorthSnapshot value,
    $Res Function(_NetWorthSnapshot) _then,
  ) = __$NetWorthSnapshotCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    DateTime date,
    int assets,
    int liabilities,
    int netWorth,
    DateTime createdAt,
  });
}

/// @nodoc
class __$NetWorthSnapshotCopyWithImpl<$Res>
    implements _$NetWorthSnapshotCopyWith<$Res> {
  __$NetWorthSnapshotCopyWithImpl(this._self, this._then);

  final _NetWorthSnapshot _self;
  final $Res Function(_NetWorthSnapshot) _then;

  /// Create a copy of NetWorthSnapshot
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? date = null,
    Object? assets = null,
    Object? liabilities = null,
    Object? netWorth = null,
    Object? createdAt = null,
  }) {
    return _then(
      _NetWorthSnapshot(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        date: null == date
            ? _self.date
            : date // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        assets: null == assets
            ? _self.assets
            : assets // ignore: cast_nullable_to_non_nullable
                  as int,
        liabilities: null == liabilities
            ? _self.liabilities
            : liabilities // ignore: cast_nullable_to_non_nullable
                  as int,
        netWorth: null == netWorth
            ? _self.netWorth
            : netWorth // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}
