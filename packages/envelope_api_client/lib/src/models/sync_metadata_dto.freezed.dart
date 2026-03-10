// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sync_metadata_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SyncMetadataDto {
  String get id;
  @JsonKey(name: 'table_name')
  String get tableName;
  @JsonKey(name: 'record_id')
  String get recordId;
  @JsonKey(name: 'last_modified')
  DateTime get lastModified;
  @JsonKey(name: 'device_id')
  String get deviceId;
  @JsonKey(name: 'is_deleted')
  bool get isDeleted;
  @JsonKey(name: 'sync_status')
  String get syncStatus;

  /// Create a copy of SyncMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $SyncMetadataDtoCopyWith<SyncMetadataDto> get copyWith =>
      _$SyncMetadataDtoCopyWithImpl<SyncMetadataDto>(
        this as SyncMetadataDto,
        _$identity,
      );

  /// Serializes this SyncMetadataDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is SyncMetadataDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tableName,
    recordId,
    lastModified,
    deviceId,
    isDeleted,
    syncStatus,
  );

  @override
  String toString() {
    return 'SyncMetadataDto(id: $id, tableName: $tableName, recordId: $recordId, lastModified: $lastModified, deviceId: $deviceId, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }
}

/// @nodoc
abstract mixin class $SyncMetadataDtoCopyWith<$Res> {
  factory $SyncMetadataDtoCopyWith(
    SyncMetadataDto value,
    $Res Function(SyncMetadataDto) _then,
  ) = _$SyncMetadataDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'table_name') String tableName,
    @JsonKey(name: 'record_id') String recordId,
    @JsonKey(name: 'last_modified') DateTime lastModified,
    @JsonKey(name: 'device_id') String deviceId,
    @JsonKey(name: 'is_deleted') bool isDeleted,
    @JsonKey(name: 'sync_status') String syncStatus,
  });
}

/// @nodoc
class _$SyncMetadataDtoCopyWithImpl<$Res>
    implements $SyncMetadataDtoCopyWith<$Res> {
  _$SyncMetadataDtoCopyWithImpl(this._self, this._then);

  final SyncMetadataDto _self;
  final $Res Function(SyncMetadataDto) _then;

  /// Create a copy of SyncMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? lastModified = null,
    Object? deviceId = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tableName: null == tableName
            ? _self.tableName
            : tableName // ignore: cast_nullable_to_non_nullable
                  as String,
        recordId: null == recordId
            ? _self.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        lastModified: null == lastModified
            ? _self.lastModified
            : lastModified // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deviceId: null == deviceId
            ? _self.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        isDeleted: null == isDeleted
            ? _self.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncStatus: null == syncStatus
            ? _self.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [SyncMetadataDto].
extension SyncMetadataDtoPatterns on SyncMetadataDto {
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
    TResult Function(_SyncMetadataDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SyncMetadataDto() when $default != null:
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
    TResult Function(_SyncMetadataDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncMetadataDto():
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
    TResult? Function(_SyncMetadataDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncMetadataDto() when $default != null:
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
      @JsonKey(name: 'table_name') String tableName,
      @JsonKey(name: 'record_id') String recordId,
      @JsonKey(name: 'last_modified') DateTime lastModified,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'sync_status') String syncStatus,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _SyncMetadataDto() when $default != null:
        return $default(
          _that.id,
          _that.tableName,
          _that.recordId,
          _that.lastModified,
          _that.deviceId,
          _that.isDeleted,
          _that.syncStatus,
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
      @JsonKey(name: 'table_name') String tableName,
      @JsonKey(name: 'record_id') String recordId,
      @JsonKey(name: 'last_modified') DateTime lastModified,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'sync_status') String syncStatus,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncMetadataDto():
        return $default(
          _that.id,
          _that.tableName,
          _that.recordId,
          _that.lastModified,
          _that.deviceId,
          _that.isDeleted,
          _that.syncStatus,
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
      @JsonKey(name: 'table_name') String tableName,
      @JsonKey(name: 'record_id') String recordId,
      @JsonKey(name: 'last_modified') DateTime lastModified,
      @JsonKey(name: 'device_id') String deviceId,
      @JsonKey(name: 'is_deleted') bool isDeleted,
      @JsonKey(name: 'sync_status') String syncStatus,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _SyncMetadataDto() when $default != null:
        return $default(
          _that.id,
          _that.tableName,
          _that.recordId,
          _that.lastModified,
          _that.deviceId,
          _that.isDeleted,
          _that.syncStatus,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _SyncMetadataDto implements SyncMetadataDto {
  const _SyncMetadataDto({
    required this.id,
    @JsonKey(name: 'table_name') required this.tableName,
    @JsonKey(name: 'record_id') required this.recordId,
    @JsonKey(name: 'last_modified') required this.lastModified,
    @JsonKey(name: 'device_id') required this.deviceId,
    @JsonKey(name: 'is_deleted') this.isDeleted = false,
    @JsonKey(name: 'sync_status') this.syncStatus = 'pending',
  });
  factory _SyncMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$SyncMetadataDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'table_name')
  final String tableName;
  @override
  @JsonKey(name: 'record_id')
  final String recordId;
  @override
  @JsonKey(name: 'last_modified')
  final DateTime lastModified;
  @override
  @JsonKey(name: 'device_id')
  final String deviceId;
  @override
  @JsonKey(name: 'is_deleted')
  final bool isDeleted;
  @override
  @JsonKey(name: 'sync_status')
  final String syncStatus;

  /// Create a copy of SyncMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$SyncMetadataDtoCopyWith<_SyncMetadataDto> get copyWith =>
      __$SyncMetadataDtoCopyWithImpl<_SyncMetadataDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$SyncMetadataDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _SyncMetadataDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.tableName, tableName) ||
                other.tableName == tableName) &&
            (identical(other.recordId, recordId) ||
                other.recordId == recordId) &&
            (identical(other.lastModified, lastModified) ||
                other.lastModified == lastModified) &&
            (identical(other.deviceId, deviceId) ||
                other.deviceId == deviceId) &&
            (identical(other.isDeleted, isDeleted) ||
                other.isDeleted == isDeleted) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    tableName,
    recordId,
    lastModified,
    deviceId,
    isDeleted,
    syncStatus,
  );

  @override
  String toString() {
    return 'SyncMetadataDto(id: $id, tableName: $tableName, recordId: $recordId, lastModified: $lastModified, deviceId: $deviceId, isDeleted: $isDeleted, syncStatus: $syncStatus)';
  }
}

/// @nodoc
abstract mixin class _$SyncMetadataDtoCopyWith<$Res>
    implements $SyncMetadataDtoCopyWith<$Res> {
  factory _$SyncMetadataDtoCopyWith(
    _SyncMetadataDto value,
    $Res Function(_SyncMetadataDto) _then,
  ) = __$SyncMetadataDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'table_name') String tableName,
    @JsonKey(name: 'record_id') String recordId,
    @JsonKey(name: 'last_modified') DateTime lastModified,
    @JsonKey(name: 'device_id') String deviceId,
    @JsonKey(name: 'is_deleted') bool isDeleted,
    @JsonKey(name: 'sync_status') String syncStatus,
  });
}

/// @nodoc
class __$SyncMetadataDtoCopyWithImpl<$Res>
    implements _$SyncMetadataDtoCopyWith<$Res> {
  __$SyncMetadataDtoCopyWithImpl(this._self, this._then);

  final _SyncMetadataDto _self;
  final $Res Function(_SyncMetadataDto) _then;

  /// Create a copy of SyncMetadataDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? tableName = null,
    Object? recordId = null,
    Object? lastModified = null,
    Object? deviceId = null,
    Object? isDeleted = null,
    Object? syncStatus = null,
  }) {
    return _then(
      _SyncMetadataDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        tableName: null == tableName
            ? _self.tableName
            : tableName // ignore: cast_nullable_to_non_nullable
                  as String,
        recordId: null == recordId
            ? _self.recordId
            : recordId // ignore: cast_nullable_to_non_nullable
                  as String,
        lastModified: null == lastModified
            ? _self.lastModified
            : lastModified // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        deviceId: null == deviceId
            ? _self.deviceId
            : deviceId // ignore: cast_nullable_to_non_nullable
                  as String,
        isDeleted: null == isDeleted
            ? _self.isDeleted
            : isDeleted // ignore: cast_nullable_to_non_nullable
                  as bool,
        syncStatus: null == syncStatus
            ? _self.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}
