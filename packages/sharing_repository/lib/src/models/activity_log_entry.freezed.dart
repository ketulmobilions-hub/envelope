// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'activity_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ActivityLogEntry {
  String get id;
  String get budgetId;
  String get userId;
  String get action;
  String get entityType;
  String get entityId;
  DateTime get createdAt;
  String? get details;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ActivityLogEntryCopyWith<ActivityLogEntry> get copyWith =>
      _$ActivityLogEntryCopyWithImpl<ActivityLogEntry>(
        this as ActivityLogEntry,
        _$identity,
      );

  /// Serializes this ActivityLogEntry to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ActivityLogEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    userId,
    action,
    entityType,
    entityId,
    createdAt,
    details,
  );

  @override
  String toString() {
    return 'ActivityLogEntry(id: $id, budgetId: $budgetId, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, createdAt: $createdAt, details: $details)';
  }
}

/// @nodoc
abstract mixin class $ActivityLogEntryCopyWith<$Res> {
  factory $ActivityLogEntryCopyWith(
    ActivityLogEntry value,
    $Res Function(ActivityLogEntry) _then,
  ) = _$ActivityLogEntryCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String userId,
    String action,
    String entityType,
    String entityId,
    DateTime createdAt,
    String? details,
  });
}

/// @nodoc
class _$ActivityLogEntryCopyWithImpl<$Res>
    implements $ActivityLogEntryCopyWith<$Res> {
  _$ActivityLogEntryCopyWithImpl(this._self, this._then);

  final ActivityLogEntry _self;
  final $Res Function(ActivityLogEntry) _then;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = null,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? createdAt = null,
    Object? details = freezed,
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
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        details: freezed == details
            ? _self.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [ActivityLogEntry].
extension ActivityLogEntryPatterns on ActivityLogEntry {
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
    TResult Function(_ActivityLogEntry value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityLogEntry() when $default != null:
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
    TResult Function(_ActivityLogEntry value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogEntry():
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
    TResult? Function(_ActivityLogEntry value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogEntry() when $default != null:
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
      String userId,
      String action,
      String entityType,
      String entityId,
      DateTime createdAt,
      String? details,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ActivityLogEntry() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.action,
          _that.entityType,
          _that.entityId,
          _that.createdAt,
          _that.details,
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
      String userId,
      String action,
      String entityType,
      String entityId,
      DateTime createdAt,
      String? details,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogEntry():
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.action,
          _that.entityType,
          _that.entityId,
          _that.createdAt,
          _that.details,
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
      String userId,
      String action,
      String entityType,
      String entityId,
      DateTime createdAt,
      String? details,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ActivityLogEntry() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.userId,
          _that.action,
          _that.entityType,
          _that.entityId,
          _that.createdAt,
          _that.details,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ActivityLogEntry implements ActivityLogEntry {
  const _ActivityLogEntry({
    required this.id,
    required this.budgetId,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    required this.createdAt,
    this.details,
  });
  factory _ActivityLogEntry.fromJson(Map<String, dynamic> json) =>
      _$ActivityLogEntryFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String userId;
  @override
  final String action;
  @override
  final String entityType;
  @override
  final String entityId;
  @override
  final DateTime createdAt;
  @override
  final String? details;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ActivityLogEntryCopyWith<_ActivityLogEntry> get copyWith =>
      __$ActivityLogEntryCopyWithImpl<_ActivityLogEntry>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ActivityLogEntryToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ActivityLogEntry &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.action, action) || other.action == action) &&
            (identical(other.entityType, entityType) ||
                other.entityType == entityType) &&
            (identical(other.entityId, entityId) ||
                other.entityId == entityId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.details, details) || other.details == details));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    userId,
    action,
    entityType,
    entityId,
    createdAt,
    details,
  );

  @override
  String toString() {
    return 'ActivityLogEntry(id: $id, budgetId: $budgetId, userId: $userId, action: $action, entityType: $entityType, entityId: $entityId, createdAt: $createdAt, details: $details)';
  }
}

/// @nodoc
abstract mixin class _$ActivityLogEntryCopyWith<$Res>
    implements $ActivityLogEntryCopyWith<$Res> {
  factory _$ActivityLogEntryCopyWith(
    _ActivityLogEntry value,
    $Res Function(_ActivityLogEntry) _then,
  ) = __$ActivityLogEntryCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String userId,
    String action,
    String entityType,
    String entityId,
    DateTime createdAt,
    String? details,
  });
}

/// @nodoc
class __$ActivityLogEntryCopyWithImpl<$Res>
    implements _$ActivityLogEntryCopyWith<$Res> {
  __$ActivityLogEntryCopyWithImpl(this._self, this._then);

  final _ActivityLogEntry _self;
  final $Res Function(_ActivityLogEntry) _then;

  /// Create a copy of ActivityLogEntry
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? userId = null,
    Object? action = null,
    Object? entityType = null,
    Object? entityId = null,
    Object? createdAt = null,
    Object? details = freezed,
  }) {
    return _then(
      _ActivityLogEntry(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        budgetId: null == budgetId
            ? _self.budgetId
            : budgetId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _self.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        action: null == action
            ? _self.action
            : action // ignore: cast_nullable_to_non_nullable
                  as String,
        entityType: null == entityType
            ? _self.entityType
            : entityType // ignore: cast_nullable_to_non_nullable
                  as String,
        entityId: null == entityId
            ? _self.entityId
            : entityId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        details: freezed == details
            ? _self.details
            : details // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
