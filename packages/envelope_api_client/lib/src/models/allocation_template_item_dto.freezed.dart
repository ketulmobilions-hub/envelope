// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'allocation_template_item_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AllocationTemplateItemDto {
  String get id;
  @JsonKey(name: 'template_id')
  String get templateId;
  @JsonKey(name: 'envelope_id')
  String get envelopeId;
  double get percentage;

  /// Create a copy of AllocationTemplateItemDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AllocationTemplateItemDtoCopyWith<AllocationTemplateItemDto> get copyWith =>
      _$AllocationTemplateItemDtoCopyWithImpl<AllocationTemplateItemDto>(
        this as AllocationTemplateItemDto,
        _$identity,
      );

  /// Serializes this AllocationTemplateItemDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AllocationTemplateItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, templateId, envelopeId, percentage);

  @override
  String toString() {
    return 'AllocationTemplateItemDto(id: $id, templateId: $templateId, envelopeId: $envelopeId, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $AllocationTemplateItemDtoCopyWith<$Res> {
  factory $AllocationTemplateItemDtoCopyWith(
    AllocationTemplateItemDto value,
    $Res Function(AllocationTemplateItemDto) _then,
  ) = _$AllocationTemplateItemDtoCopyWithImpl;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'template_id') String templateId,
    @JsonKey(name: 'envelope_id') String envelopeId,
    double percentage,
  });
}

/// @nodoc
class _$AllocationTemplateItemDtoCopyWithImpl<$Res>
    implements $AllocationTemplateItemDtoCopyWith<$Res> {
  _$AllocationTemplateItemDtoCopyWithImpl(this._self, this._then);

  final AllocationTemplateItemDto _self;
  final $Res Function(AllocationTemplateItemDto) _then;

  /// Create a copy of AllocationTemplateItemDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? templateId = null,
    Object? envelopeId = null,
    Object? percentage = null,
  }) {
    return _then(
      _self.copyWith(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        templateId: null == templateId
            ? _self.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        percentage: null == percentage
            ? _self.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AllocationTemplateItemDto].
extension AllocationTemplateItemDtoPatterns on AllocationTemplateItemDto {
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
    TResult Function(_AllocationTemplateItemDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItemDto() when $default != null:
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
    TResult Function(_AllocationTemplateItemDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItemDto():
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
    TResult? Function(_AllocationTemplateItemDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItemDto() when $default != null:
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
      @JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'envelope_id') String envelopeId,
      double percentage,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItemDto() when $default != null:
        return $default(
          _that.id,
          _that.templateId,
          _that.envelopeId,
          _that.percentage,
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
      @JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'envelope_id') String envelopeId,
      double percentage,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItemDto():
        return $default(
          _that.id,
          _that.templateId,
          _that.envelopeId,
          _that.percentage,
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
      @JsonKey(name: 'template_id') String templateId,
      @JsonKey(name: 'envelope_id') String envelopeId,
      double percentage,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItemDto() when $default != null:
        return $default(
          _that.id,
          _that.templateId,
          _that.envelopeId,
          _that.percentage,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AllocationTemplateItemDto implements AllocationTemplateItemDto {
  const _AllocationTemplateItemDto({
    required this.id,
    @JsonKey(name: 'template_id') required this.templateId,
    @JsonKey(name: 'envelope_id') required this.envelopeId,
    required this.percentage,
  });
  factory _AllocationTemplateItemDto.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateItemDtoFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'template_id')
  final String templateId;
  @override
  @JsonKey(name: 'envelope_id')
  final String envelopeId;
  @override
  final double percentage;

  /// Create a copy of AllocationTemplateItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AllocationTemplateItemDtoCopyWith<_AllocationTemplateItemDto>
  get copyWith =>
      __$AllocationTemplateItemDtoCopyWithImpl<_AllocationTemplateItemDto>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$AllocationTemplateItemDtoToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AllocationTemplateItemDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.templateId, templateId) ||
                other.templateId == templateId) &&
            (identical(other.envelopeId, envelopeId) ||
                other.envelopeId == envelopeId) &&
            (identical(other.percentage, percentage) ||
                other.percentage == percentage));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, templateId, envelopeId, percentage);

  @override
  String toString() {
    return 'AllocationTemplateItemDto(id: $id, templateId: $templateId, envelopeId: $envelopeId, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$AllocationTemplateItemDtoCopyWith<$Res>
    implements $AllocationTemplateItemDtoCopyWith<$Res> {
  factory _$AllocationTemplateItemDtoCopyWith(
    _AllocationTemplateItemDto value,
    $Res Function(_AllocationTemplateItemDto) _then,
  ) = __$AllocationTemplateItemDtoCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'template_id') String templateId,
    @JsonKey(name: 'envelope_id') String envelopeId,
    double percentage,
  });
}

/// @nodoc
class __$AllocationTemplateItemDtoCopyWithImpl<$Res>
    implements _$AllocationTemplateItemDtoCopyWith<$Res> {
  __$AllocationTemplateItemDtoCopyWithImpl(this._self, this._then);

  final _AllocationTemplateItemDto _self;
  final $Res Function(_AllocationTemplateItemDto) _then;

  /// Create a copy of AllocationTemplateItemDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? templateId = null,
    Object? envelopeId = null,
    Object? percentage = null,
  }) {
    return _then(
      _AllocationTemplateItemDto(
        id: null == id
            ? _self.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        templateId: null == templateId
            ? _self.templateId
            : templateId // ignore: cast_nullable_to_non_nullable
                  as String,
        envelopeId: null == envelopeId
            ? _self.envelopeId
            : envelopeId // ignore: cast_nullable_to_non_nullable
                  as String,
        percentage: null == percentage
            ? _self.percentage
            : percentage // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}
