// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'allocation_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AllocationTemplate {
  String get id;
  String get budgetId;
  String get name;
  DateTime get createdAt;
  List<AllocationTemplateItem> get items;

  /// Create a copy of AllocationTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AllocationTemplateCopyWith<AllocationTemplate> get copyWith =>
      _$AllocationTemplateCopyWithImpl<AllocationTemplate>(
        this as AllocationTemplate,
        _$identity,
      );

  /// Serializes this AllocationTemplate to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AllocationTemplate &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other.items, items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    createdAt,
    const DeepCollectionEquality().hash(items),
  );

  @override
  String toString() {
    return 'AllocationTemplate(id: $id, budgetId: $budgetId, name: $name, createdAt: $createdAt, items: $items)';
  }
}

/// @nodoc
abstract mixin class $AllocationTemplateCopyWith<$Res> {
  factory $AllocationTemplateCopyWith(
    AllocationTemplate value,
    $Res Function(AllocationTemplate) _then,
  ) = _$AllocationTemplateCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    DateTime createdAt,
    List<AllocationTemplateItem> items,
  });
}

/// @nodoc
class _$AllocationTemplateCopyWithImpl<$Res>
    implements $AllocationTemplateCopyWith<$Res> {
  _$AllocationTemplateCopyWithImpl(this._self, this._then);

  final AllocationTemplate _self;
  final $Res Function(AllocationTemplate) _then;

  /// Create a copy of AllocationTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? items = null,
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
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        items: null == items
            ? _self.items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<AllocationTemplateItem>,
      ),
    );
  }
}

/// Adds pattern-matching-related methods to [AllocationTemplate].
extension AllocationTemplatePatterns on AllocationTemplate {
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
    TResult Function(_AllocationTemplate value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplate() when $default != null:
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
    TResult Function(_AllocationTemplate value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplate():
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
    TResult? Function(_AllocationTemplate value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplate() when $default != null:
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
      DateTime createdAt,
      List<AllocationTemplateItem> items,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplate() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.items,
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
      DateTime createdAt,
      List<AllocationTemplateItem> items,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplate():
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.items,
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
      DateTime createdAt,
      List<AllocationTemplateItem> items,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplate() when $default != null:
        return $default(
          _that.id,
          _that.budgetId,
          _that.name,
          _that.createdAt,
          _that.items,
        );
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _AllocationTemplate implements AllocationTemplate {
  const _AllocationTemplate({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.createdAt,
    final List<AllocationTemplateItem> items = const <AllocationTemplateItem>[],
  }) : _items = items;
  factory _AllocationTemplate.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateFromJson(json);

  @override
  final String id;
  @override
  final String budgetId;
  @override
  final String name;
  @override
  final DateTime createdAt;
  final List<AllocationTemplateItem> _items;
  @override
  @JsonKey()
  List<AllocationTemplateItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  /// Create a copy of AllocationTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AllocationTemplateCopyWith<_AllocationTemplate> get copyWith =>
      __$AllocationTemplateCopyWithImpl<_AllocationTemplate>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AllocationTemplateToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AllocationTemplate &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.budgetId, budgetId) ||
                other.budgetId == budgetId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            const DeepCollectionEquality().equals(other._items, _items));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    budgetId,
    name,
    createdAt,
    const DeepCollectionEquality().hash(_items),
  );

  @override
  String toString() {
    return 'AllocationTemplate(id: $id, budgetId: $budgetId, name: $name, createdAt: $createdAt, items: $items)';
  }
}

/// @nodoc
abstract mixin class _$AllocationTemplateCopyWith<$Res>
    implements $AllocationTemplateCopyWith<$Res> {
  factory _$AllocationTemplateCopyWith(
    _AllocationTemplate value,
    $Res Function(_AllocationTemplate) _then,
  ) = __$AllocationTemplateCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String budgetId,
    String name,
    DateTime createdAt,
    List<AllocationTemplateItem> items,
  });
}

/// @nodoc
class __$AllocationTemplateCopyWithImpl<$Res>
    implements _$AllocationTemplateCopyWith<$Res> {
  __$AllocationTemplateCopyWithImpl(this._self, this._then);

  final _AllocationTemplate _self;
  final $Res Function(_AllocationTemplate) _then;

  /// Create a copy of AllocationTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? budgetId = null,
    Object? name = null,
    Object? createdAt = null,
    Object? items = null,
  }) {
    return _then(
      _AllocationTemplate(
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
        createdAt: null == createdAt
            ? _self.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        items: null == items
            ? _self._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<AllocationTemplateItem>,
      ),
    );
  }
}

/// @nodoc
mixin _$AllocationTemplateItem {
  String get id;
  String get templateId;
  String get envelopeId;
  double get percentage;

  /// Create a copy of AllocationTemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AllocationTemplateItemCopyWith<AllocationTemplateItem> get copyWith =>
      _$AllocationTemplateItemCopyWithImpl<AllocationTemplateItem>(
        this as AllocationTemplateItem,
        _$identity,
      );

  /// Serializes this AllocationTemplateItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AllocationTemplateItem &&
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
    return 'AllocationTemplateItem(id: $id, templateId: $templateId, envelopeId: $envelopeId, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class $AllocationTemplateItemCopyWith<$Res> {
  factory $AllocationTemplateItemCopyWith(
    AllocationTemplateItem value,
    $Res Function(AllocationTemplateItem) _then,
  ) = _$AllocationTemplateItemCopyWithImpl;
  @useResult
  $Res call({
    String id,
    String templateId,
    String envelopeId,
    double percentage,
  });
}

/// @nodoc
class _$AllocationTemplateItemCopyWithImpl<$Res>
    implements $AllocationTemplateItemCopyWith<$Res> {
  _$AllocationTemplateItemCopyWithImpl(this._self, this._then);

  final AllocationTemplateItem _self;
  final $Res Function(AllocationTemplateItem) _then;

  /// Create a copy of AllocationTemplateItem
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

/// Adds pattern-matching-related methods to [AllocationTemplateItem].
extension AllocationTemplateItemPatterns on AllocationTemplateItem {
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
    TResult Function(_AllocationTemplateItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItem() when $default != null:
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
    TResult Function(_AllocationTemplateItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItem():
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
    TResult? Function(_AllocationTemplateItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItem() when $default != null:
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
      String templateId,
      String envelopeId,
      double percentage,
    )?
    $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItem() when $default != null:
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
      String templateId,
      String envelopeId,
      double percentage,
    )
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItem():
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
      String templateId,
      String envelopeId,
      double percentage,
    )?
    $default,
  ) {
    final _that = this;
    switch (_that) {
      case _AllocationTemplateItem() when $default != null:
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
class _AllocationTemplateItem implements AllocationTemplateItem {
  const _AllocationTemplateItem({
    required this.id,
    required this.templateId,
    required this.envelopeId,
    required this.percentage,
  });
  factory _AllocationTemplateItem.fromJson(Map<String, dynamic> json) =>
      _$AllocationTemplateItemFromJson(json);

  @override
  final String id;
  @override
  final String templateId;
  @override
  final String envelopeId;
  @override
  final double percentage;

  /// Create a copy of AllocationTemplateItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AllocationTemplateItemCopyWith<_AllocationTemplateItem> get copyWith =>
      __$AllocationTemplateItemCopyWithImpl<_AllocationTemplateItem>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$AllocationTemplateItemToJson(this);
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AllocationTemplateItem &&
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
    return 'AllocationTemplateItem(id: $id, templateId: $templateId, envelopeId: $envelopeId, percentage: $percentage)';
  }
}

/// @nodoc
abstract mixin class _$AllocationTemplateItemCopyWith<$Res>
    implements $AllocationTemplateItemCopyWith<$Res> {
  factory _$AllocationTemplateItemCopyWith(
    _AllocationTemplateItem value,
    $Res Function(_AllocationTemplateItem) _then,
  ) = __$AllocationTemplateItemCopyWithImpl;
  @override
  @useResult
  $Res call({
    String id,
    String templateId,
    String envelopeId,
    double percentage,
  });
}

/// @nodoc
class __$AllocationTemplateItemCopyWithImpl<$Res>
    implements _$AllocationTemplateItemCopyWith<$Res> {
  __$AllocationTemplateItemCopyWithImpl(this._self, this._then);

  final _AllocationTemplateItem _self;
  final $Res Function(_AllocationTemplateItem) _then;

  /// Create a copy of AllocationTemplateItem
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
      _AllocationTemplateItem(
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
