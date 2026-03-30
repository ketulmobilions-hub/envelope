// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserDto {
  String get id;
  String get email;
  @JsonKey(name: 'display_name')
  String get displayName;
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @JsonKey(name: 'base_currency')
  String get baseCurrency;
  @JsonKey(name: 'theme_mode')
  String get themeMode;
  @JsonKey(name: 'accent_color')
  String? get accentColor;
  @JsonKey(name: 'privacy_accepted_at')
  DateTime? get privacyAcceptedAt;
  @JsonKey(name: 'terms_accepted_at')
  DateTime? get termsAcceptedAt;
  @JsonKey(name: 'consent_version')
  String? get consentVersion;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserDtoCopyWith<UserDto> get copyWith =>
      _$UserDtoCopyWithImpl<UserDto>(this as UserDto, _$identity);

  /// Serializes this UserDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.privacyAcceptedAt, privacyAcceptedAt) ||
                other.privacyAcceptedAt == privacyAcceptedAt) &&
            (identical(other.termsAcceptedAt, termsAcceptedAt) ||
                other.termsAcceptedAt == termsAcceptedAt) &&
            (identical(other.consentVersion, consentVersion) ||
                other.consentVersion == consentVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    displayName,
    createdAt,
    updatedAt,
    baseCurrency,
    themeMode,
    accentColor,
    privacyAcceptedAt,
    termsAcceptedAt,
    consentVersion,
  );

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, baseCurrency: $baseCurrency, themeMode: $themeMode, accentColor: $accentColor, privacyAcceptedAt: $privacyAcceptedAt, termsAcceptedAt: $termsAcceptedAt, consentVersion: $consentVersion)';
  }
}

/// @nodoc
abstract mixin class $UserDtoCopyWith<$Res> {
  factory $UserDtoCopyWith(UserDto value, $Res Function(UserDto) _then) =
      _$UserDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String email,
    @JsonKey(name: 'display_name') String displayName,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'base_currency') String baseCurrency,
    @JsonKey(name: 'theme_mode') String themeMode,
    @JsonKey(name: 'accent_color') String? accentColor,
    @JsonKey(name: 'privacy_accepted_at') DateTime? privacyAcceptedAt,
    @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
    @JsonKey(name: 'consent_version') String? consentVersion,
  });
}

/// @nodoc
class _$UserDtoCopyWithImpl<$Res> implements $UserDtoCopyWith<$Res> {
  _$UserDtoCopyWithImpl(this._self, this._then);

  final UserDto _self;
  final $Res Function(UserDto) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? baseCurrency = null,
    Object? themeMode = null,
    Object? accentColor = freezed,
    Object? privacyAcceptedAt = freezed,
    Object? termsAcceptedAt = freezed,
    Object? consentVersion = freezed,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _self.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _self.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        baseCurrency: null == baseCurrency
            ? _self.baseCurrency
            : baseCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        themeMode: null == themeMode
            ? _self.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as String,
        accentColor: freezed == accentColor
            ? _self.accentColor
            : accentColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        privacyAcceptedAt: freezed == privacyAcceptedAt
            ? _self.privacyAcceptedAt
            : privacyAcceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        termsAcceptedAt: freezed == termsAcceptedAt
            ? _self.termsAcceptedAt
            : termsAcceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        consentVersion: freezed == consentVersion
            ? _self.consentVersion
            : consentVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [UserDto].
extension UserDtoPatterns on UserDto {
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
    TResult Function(_UserDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
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
    TResult Function(_UserDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto():
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
    TResult? Function(_UserDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
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
      String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'base_currency') String baseCurrency,
      @JsonKey(name: 'theme_mode') String themeMode,
      @JsonKey(name: 'accent_color') String? accentColor,
      @JsonKey(name: 'privacy_accepted_at') DateTime? privacyAcceptedAt,
      @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
      @JsonKey(name: 'consent_version') String? consentVersion,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
        return $default(
          _that.id,
          _that.email,
          _that.displayName,
          _that.createdAt,
          _that.updatedAt,
          _that.baseCurrency,
          _that.themeMode,
          _that.accentColor,
          _that.privacyAcceptedAt,
          _that.termsAcceptedAt,
          _that.consentVersion,
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
      String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'base_currency') String baseCurrency,
      @JsonKey(name: 'theme_mode') String themeMode,
      @JsonKey(name: 'accent_color') String? accentColor,
      @JsonKey(name: 'privacy_accepted_at') DateTime? privacyAcceptedAt,
      @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
      @JsonKey(name: 'consent_version') String? consentVersion,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto():
        return $default(
          _that.id,
          _that.email,
          _that.displayName,
          _that.createdAt,
          _that.updatedAt,
          _that.baseCurrency,
          _that.themeMode,
          _that.accentColor,
          _that.privacyAcceptedAt,
          _that.termsAcceptedAt,
          _that.consentVersion,
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
      String email,
      @JsonKey(name: 'display_name') String displayName,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt,
      @JsonKey(name: 'base_currency') String baseCurrency,
      @JsonKey(name: 'theme_mode') String themeMode,
      @JsonKey(name: 'accent_color') String? accentColor,
      @JsonKey(name: 'privacy_accepted_at') DateTime? privacyAcceptedAt,
      @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
      @JsonKey(name: 'consent_version') String? consentVersion,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserDto() when $default != null:
        return $default(
          _that.id,
          _that.email,
          _that.displayName,
          _that.createdAt,
          _that.updatedAt,
          _that.baseCurrency,
          _that.themeMode,
          _that.accentColor,
          _that.privacyAcceptedAt,
          _that.termsAcceptedAt,
          _that.consentVersion,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserDto implements UserDto {
  const _UserDto({
    required this.id,
    required this.email,
    @JsonKey(name: 'display_name') required this.displayName,
    @JsonKey(name: 'created_at') required this.createdAt,
    @JsonKey(name: 'updated_at') required this.updatedAt,
    @JsonKey(name: 'base_currency') this.baseCurrency = 'USD',
    @JsonKey(name: 'theme_mode') this.themeMode = 'system',
    @JsonKey(name: 'accent_color') this.accentColor,
    @JsonKey(name: 'privacy_accepted_at') this.privacyAcceptedAt,
    @JsonKey(name: 'terms_accepted_at') this.termsAcceptedAt,
    @JsonKey(name: 'consent_version') this.consentVersion,
  });
  factory _UserDto.fromJson(Map<String, dynamic> json) =>
      _$UserDtoFromJson(json);

  @override
  final String id;
  @override
  final String email;
  @override
  @JsonKey(name: 'display_name')
  final String displayName;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;
  @override
  @JsonKey(name: 'base_currency')
  final String baseCurrency;
  @override
  @JsonKey(name: 'theme_mode')
  final String themeMode;
  @override
  @JsonKey(name: 'accent_color')
  final String? accentColor;
  @override
  @JsonKey(name: 'privacy_accepted_at')
  final DateTime? privacyAcceptedAt;
  @override
  @JsonKey(name: 'terms_accepted_at')
  final DateTime? termsAcceptedAt;
  @override
  @JsonKey(name: 'consent_version')
  final String? consentVersion;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserDtoCopyWith<_UserDto> get copyWith =>
      __$UserDtoCopyWithImpl<_UserDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.displayName, displayName) ||
                other.displayName == displayName) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.baseCurrency, baseCurrency) ||
                other.baseCurrency == baseCurrency) &&
            (identical(other.themeMode, themeMode) ||
                other.themeMode == themeMode) &&
            (identical(other.accentColor, accentColor) ||
                other.accentColor == accentColor) &&
            (identical(other.privacyAcceptedAt, privacyAcceptedAt) ||
                other.privacyAcceptedAt == privacyAcceptedAt) &&
            (identical(other.termsAcceptedAt, termsAcceptedAt) ||
                other.termsAcceptedAt == termsAcceptedAt) &&
            (identical(other.consentVersion, consentVersion) ||
                other.consentVersion == consentVersion));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    email,
    displayName,
    createdAt,
    updatedAt,
    baseCurrency,
    themeMode,
    accentColor,
    privacyAcceptedAt,
    termsAcceptedAt,
    consentVersion,
  );

  @override
  String toString() {
    return 'UserDto(id: $id, email: $email, displayName: $displayName, createdAt: $createdAt, updatedAt: $updatedAt, baseCurrency: $baseCurrency, themeMode: $themeMode, accentColor: $accentColor, privacyAcceptedAt: $privacyAcceptedAt, termsAcceptedAt: $termsAcceptedAt, consentVersion: $consentVersion)';
  }
}

/// @nodoc
abstract mixin class _$UserDtoCopyWith<$Res> implements $UserDtoCopyWith<$Res> {
  factory _$UserDtoCopyWith(_UserDto value, $Res Function(_UserDto) _then) =
      __$UserDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String email,
    @JsonKey(name: 'display_name') String displayName,
    @JsonKey(name: 'created_at') DateTime createdAt,
    @JsonKey(name: 'updated_at') DateTime updatedAt,
    @JsonKey(name: 'base_currency') String baseCurrency,
    @JsonKey(name: 'theme_mode') String themeMode,
    @JsonKey(name: 'accent_color') String? accentColor,
    @JsonKey(name: 'privacy_accepted_at') DateTime? privacyAcceptedAt,
    @JsonKey(name: 'terms_accepted_at') DateTime? termsAcceptedAt,
    @JsonKey(name: 'consent_version') String? consentVersion,
  });
}

/// @nodoc
class __$UserDtoCopyWithImpl<$Res> implements _$UserDtoCopyWith<$Res> {
  __$UserDtoCopyWithImpl(this._self, this._then);

  final _UserDto _self;
  final $Res Function(_UserDto) _then;

  /// Create a copy of UserDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? email = null,
    Object? displayName = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? baseCurrency = null,
    Object? themeMode = null,
    Object? accentColor = freezed,
    Object? privacyAcceptedAt = freezed,
    Object? termsAcceptedAt = freezed,
    Object? consentVersion = freezed,
  }) {
    return _then(
      _UserDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        email: null == email
            ? _self.email
            : email // ignore: cast_nullable_to_non_nullable
                  as String,
        displayName: null == displayName
            ? _self.displayName
            : displayName // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: null == updatedAt
            ? _self.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        baseCurrency: null == baseCurrency
            ? _self.baseCurrency
            : baseCurrency // ignore: cast_nullable_to_non_nullable
                  as String,
        themeMode: null == themeMode
            ? _self.themeMode
            : themeMode // ignore: cast_nullable_to_non_nullable
                  as String,
        accentColor: freezed == accentColor
            ? _self.accentColor
            : accentColor // ignore: cast_nullable_to_non_nullable
                  as String?,
        privacyAcceptedAt: freezed == privacyAcceptedAt
            ? _self.privacyAcceptedAt
            : privacyAcceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        termsAcceptedAt: freezed == termsAcceptedAt
            ? _self.termsAcceptedAt
            : termsAcceptedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        consentVersion: freezed == consentVersion
            ? _self.consentVersion
            : consentVersion // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}
