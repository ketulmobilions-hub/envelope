// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $UsersTable extends Users with TableInfo<$UsersTable, User> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UsersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _themeModeMeta = const VerificationMeta(
    'themeMode',
  );
  @override
  late final GeneratedColumn<String> themeMode = GeneratedColumn<String>(
    'theme_mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('system'),
  );
  static const VerificationMeta _accentColorMeta = const VerificationMeta(
    'accentColor',
  );
  @override
  late final GeneratedColumn<String> accentColor = GeneratedColumn<String>(
    'accent_color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    email,
    displayName,
    baseCurrency,
    themeMode,
    accentColor,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'users';
  @override
  VerificationContext validateIntegrity(
    Insertable<User> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_displayNameMeta);
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    }
    if (data.containsKey('theme_mode')) {
      context.handle(
        _themeModeMeta,
        themeMode.isAcceptableOrUnknown(data['theme_mode']!, _themeModeMeta),
      );
    }
    if (data.containsKey('accent_color')) {
      context.handle(
        _accentColorMeta,
        accentColor.isAcceptableOrUnknown(
          data['accent_color']!,
          _accentColorMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  User map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return User(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      )!,
      themeMode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}theme_mode'],
      )!,
      accentColor: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}accent_color'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $UsersTable createAlias(String alias) {
    return $UsersTable(attachedDatabase, alias);
  }
}

class User extends DataClass implements Insertable<User> {
  final String id;
  final String email;
  final String displayName;
  final String baseCurrency;
  final String themeMode;
  final String? accentColor;
  final DateTime createdAt;
  final DateTime updatedAt;
  const User({
    required this.id,
    required this.email,
    required this.displayName,
    required this.baseCurrency,
    required this.themeMode,
    this.accentColor,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['display_name'] = Variable<String>(displayName);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['theme_mode'] = Variable<String>(themeMode);
    if (!nullToAbsent || accentColor != null) {
      map['accent_color'] = Variable<String>(accentColor);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  UsersCompanion toCompanion(bool nullToAbsent) {
    return UsersCompanion(
      id: Value(id),
      email: Value(email),
      displayName: Value(displayName),
      baseCurrency: Value(baseCurrency),
      themeMode: Value(themeMode),
      accentColor: accentColor == null && nullToAbsent
          ? const Value.absent()
          : Value(accentColor),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory User.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return User(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      displayName: serializer.fromJson<String>(json['displayName']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      themeMode: serializer.fromJson<String>(json['themeMode']),
      accentColor: serializer.fromJson<String?>(json['accentColor']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'displayName': serializer.toJson<String>(displayName),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'themeMode': serializer.toJson<String>(themeMode),
      'accentColor': serializer.toJson<String?>(accentColor),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  User copyWith({
    String? id,
    String? email,
    String? displayName,
    String? baseCurrency,
    String? themeMode,
    Value<String?> accentColor = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => User(
    id: id ?? this.id,
    email: email ?? this.email,
    displayName: displayName ?? this.displayName,
    baseCurrency: baseCurrency ?? this.baseCurrency,
    themeMode: themeMode ?? this.themeMode,
    accentColor: accentColor.present ? accentColor.value : this.accentColor,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  User copyWithCompanion(UsersCompanion data) {
    return User(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      accentColor: data.accentColor.present
          ? data.accentColor.value
          : this.accentColor,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('User(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColor: $accentColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    email,
    displayName,
    baseCurrency,
    themeMode,
    accentColor,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is User &&
          other.id == this.id &&
          other.email == this.email &&
          other.displayName == this.displayName &&
          other.baseCurrency == this.baseCurrency &&
          other.themeMode == this.themeMode &&
          other.accentColor == this.accentColor &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class UsersCompanion extends UpdateCompanion<User> {
  final Value<String> id;
  final Value<String> email;
  final Value<String> displayName;
  final Value<String> baseCurrency;
  final Value<String> themeMode;
  final Value<String?> accentColor;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const UsersCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.displayName = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColor = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  UsersCompanion.insert({
    required String id,
    required String email,
    required String displayName,
    this.baseCurrency = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.accentColor = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       displayName = Value(displayName),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<User> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<String>? displayName,
    Expression<String>? baseCurrency,
    Expression<String>? themeMode,
    Expression<String>? accentColor,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (displayName != null) 'display_name': displayName,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (themeMode != null) 'theme_mode': themeMode,
      if (accentColor != null) 'accent_color': accentColor,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  UsersCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<String>? displayName,
    Value<String>? baseCurrency,
    Value<String>? themeMode,
    Value<String?>? accentColor,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return UsersCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      themeMode: themeMode ?? this.themeMode,
      accentColor: accentColor ?? this.accentColor,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<String>(themeMode.value);
    }
    if (accentColor.present) {
      map['accent_color'] = Variable<String>(accentColor.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UsersCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('displayName: $displayName, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('themeMode: $themeMode, ')
          ..write('accentColor: $accentColor, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetsTable extends Budgets with TableInfo<$BudgetsTable, Budget> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ownerIdMeta = const VerificationMeta(
    'ownerId',
  );
  @override
  late final GeneratedColumn<String> ownerId = GeneratedColumn<String>(
    'owner_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _periodTypeMeta = const VerificationMeta(
    'periodType',
  );
  @override
  late final GeneratedColumn<String> periodType = GeneratedColumn<String>(
    'period_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('monthly'),
  );
  static const VerificationMeta _periodStartDayMeta = const VerificationMeta(
    'periodStartDay',
  );
  @override
  late final GeneratedColumn<int> periodStartDay = GeneratedColumn<int>(
    'period_start_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _baseCurrencyMeta = const VerificationMeta(
    'baseCurrency',
  );
  @override
  late final GeneratedColumn<String> baseCurrency = GeneratedColumn<String>(
    'base_currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    ownerId,
    name,
    periodType,
    periodStartDay,
    baseCurrency,
    isArchived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budgets';
  @override
  VerificationContext validateIntegrity(
    Insertable<Budget> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('owner_id')) {
      context.handle(
        _ownerIdMeta,
        ownerId.isAcceptableOrUnknown(data['owner_id']!, _ownerIdMeta),
      );
    } else if (isInserting) {
      context.missing(_ownerIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('period_type')) {
      context.handle(
        _periodTypeMeta,
        periodType.isAcceptableOrUnknown(data['period_type']!, _periodTypeMeta),
      );
    }
    if (data.containsKey('period_start_day')) {
      context.handle(
        _periodStartDayMeta,
        periodStartDay.isAcceptableOrUnknown(
          data['period_start_day']!,
          _periodStartDayMeta,
        ),
      );
    }
    if (data.containsKey('base_currency')) {
      context.handle(
        _baseCurrencyMeta,
        baseCurrency.isAcceptableOrUnknown(
          data['base_currency']!,
          _baseCurrencyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_baseCurrencyMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Budget map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Budget(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      ownerId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}owner_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      periodType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}period_type'],
      )!,
      periodStartDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}period_start_day'],
      )!,
      baseCurrency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}base_currency'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $BudgetsTable createAlias(String alias) {
    return $BudgetsTable(attachedDatabase, alias);
  }
}

class Budget extends DataClass implements Insertable<Budget> {
  final String id;
  final String ownerId;
  final String name;
  final String periodType;
  final int periodStartDay;
  final String baseCurrency;
  final bool isArchived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Budget({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.periodType,
    required this.periodStartDay,
    required this.baseCurrency,
    required this.isArchived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['owner_id'] = Variable<String>(ownerId);
    map['name'] = Variable<String>(name);
    map['period_type'] = Variable<String>(periodType);
    map['period_start_day'] = Variable<int>(periodStartDay);
    map['base_currency'] = Variable<String>(baseCurrency);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  BudgetsCompanion toCompanion(bool nullToAbsent) {
    return BudgetsCompanion(
      id: Value(id),
      ownerId: Value(ownerId),
      name: Value(name),
      periodType: Value(periodType),
      periodStartDay: Value(periodStartDay),
      baseCurrency: Value(baseCurrency),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Budget.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Budget(
      id: serializer.fromJson<String>(json['id']),
      ownerId: serializer.fromJson<String>(json['ownerId']),
      name: serializer.fromJson<String>(json['name']),
      periodType: serializer.fromJson<String>(json['periodType']),
      periodStartDay: serializer.fromJson<int>(json['periodStartDay']),
      baseCurrency: serializer.fromJson<String>(json['baseCurrency']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'ownerId': serializer.toJson<String>(ownerId),
      'name': serializer.toJson<String>(name),
      'periodType': serializer.toJson<String>(periodType),
      'periodStartDay': serializer.toJson<int>(periodStartDay),
      'baseCurrency': serializer.toJson<String>(baseCurrency),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Budget copyWith({
    String? id,
    String? ownerId,
    String? name,
    String? periodType,
    int? periodStartDay,
    String? baseCurrency,
    bool? isArchived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Budget(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    name: name ?? this.name,
    periodType: periodType ?? this.periodType,
    periodStartDay: periodStartDay ?? this.periodStartDay,
    baseCurrency: baseCurrency ?? this.baseCurrency,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Budget copyWithCompanion(BudgetsCompanion data) {
    return Budget(
      id: data.id.present ? data.id.value : this.id,
      ownerId: data.ownerId.present ? data.ownerId.value : this.ownerId,
      name: data.name.present ? data.name.value : this.name,
      periodType: data.periodType.present
          ? data.periodType.value
          : this.periodType,
      periodStartDay: data.periodStartDay.present
          ? data.periodStartDay.value
          : this.periodStartDay,
      baseCurrency: data.baseCurrency.present
          ? data.baseCurrency.value
          : this.baseCurrency,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Budget(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('periodType: $periodType, ')
          ..write('periodStartDay: $periodStartDay, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    ownerId,
    name,
    periodType,
    periodStartDay,
    baseCurrency,
    isArchived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Budget &&
          other.id == this.id &&
          other.ownerId == this.ownerId &&
          other.name == this.name &&
          other.periodType == this.periodType &&
          other.periodStartDay == this.periodStartDay &&
          other.baseCurrency == this.baseCurrency &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class BudgetsCompanion extends UpdateCompanion<Budget> {
  final Value<String> id;
  final Value<String> ownerId;
  final Value<String> name;
  final Value<String> periodType;
  final Value<int> periodStartDay;
  final Value<String> baseCurrency;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const BudgetsCompanion({
    this.id = const Value.absent(),
    this.ownerId = const Value.absent(),
    this.name = const Value.absent(),
    this.periodType = const Value.absent(),
    this.periodStartDay = const Value.absent(),
    this.baseCurrency = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetsCompanion.insert({
    required String id,
    required String ownerId,
    required String name,
    this.periodType = const Value.absent(),
    this.periodStartDay = const Value.absent(),
    required String baseCurrency,
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       ownerId = Value(ownerId),
       name = Value(name),
       baseCurrency = Value(baseCurrency),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Budget> custom({
    Expression<String>? id,
    Expression<String>? ownerId,
    Expression<String>? name,
    Expression<String>? periodType,
    Expression<int>? periodStartDay,
    Expression<String>? baseCurrency,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (ownerId != null) 'owner_id': ownerId,
      if (name != null) 'name': name,
      if (periodType != null) 'period_type': periodType,
      if (periodStartDay != null) 'period_start_day': periodStartDay,
      if (baseCurrency != null) 'base_currency': baseCurrency,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetsCompanion copyWith({
    Value<String>? id,
    Value<String>? ownerId,
    Value<String>? name,
    Value<String>? periodType,
    Value<int>? periodStartDay,
    Value<String>? baseCurrency,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return BudgetsCompanion(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      name: name ?? this.name,
      periodType: periodType ?? this.periodType,
      periodStartDay: periodStartDay ?? this.periodStartDay,
      baseCurrency: baseCurrency ?? this.baseCurrency,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (ownerId.present) {
      map['owner_id'] = Variable<String>(ownerId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (periodType.present) {
      map['period_type'] = Variable<String>(periodType.value);
    }
    if (periodStartDay.present) {
      map['period_start_day'] = Variable<int>(periodStartDay.value);
    }
    if (baseCurrency.present) {
      map['base_currency'] = Variable<String>(baseCurrency.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetsCompanion(')
          ..write('id: $id, ')
          ..write('ownerId: $ownerId, ')
          ..write('name: $name, ')
          ..write('periodType: $periodType, ')
          ..write('periodStartDay: $periodStartDay, ')
          ..write('baseCurrency: $baseCurrency, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetMembersTable extends BudgetMembers
    with TableInfo<$BudgetMembersTable, BudgetMember> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetMembersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _roleMeta = const VerificationMeta('role');
  @override
  late final GeneratedColumn<String> role = GeneratedColumn<String>(
    'role',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('viewer'),
  );
  static const VerificationMeta _invitedViaMeta = const VerificationMeta(
    'invitedVia',
  );
  @override
  late final GeneratedColumn<String> invitedVia = GeneratedColumn<String>(
    'invited_via',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _acceptedAtMeta = const VerificationMeta(
    'acceptedAt',
  );
  @override
  late final GeneratedColumn<DateTime> acceptedAt = GeneratedColumn<DateTime>(
    'accepted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    userId,
    role,
    invitedVia,
    acceptedAt,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_members';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetMember> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    }
    if (data.containsKey('role')) {
      context.handle(
        _roleMeta,
        role.isAcceptableOrUnknown(data['role']!, _roleMeta),
      );
    }
    if (data.containsKey('invited_via')) {
      context.handle(
        _invitedViaMeta,
        invitedVia.isAcceptableOrUnknown(data['invited_via']!, _invitedViaMeta),
      );
    } else if (isInserting) {
      context.missing(_invitedViaMeta);
    }
    if (data.containsKey('accepted_at')) {
      context.handle(
        _acceptedAtMeta,
        acceptedAt.isAcceptableOrUnknown(data['accepted_at']!, _acceptedAtMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetMember map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetMember(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      ),
      role: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}role'],
      )!,
      invitedVia: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}invited_via'],
      )!,
      acceptedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}accepted_at'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetMembersTable createAlias(String alias) {
    return $BudgetMembersTable(attachedDatabase, alias);
  }
}

class BudgetMember extends DataClass implements Insertable<BudgetMember> {
  final String id;
  final String budgetId;
  final String? userId;
  final String role;
  final String invitedVia;
  final DateTime? acceptedAt;
  final DateTime createdAt;
  const BudgetMember({
    required this.id,
    required this.budgetId,
    this.userId,
    required this.role,
    required this.invitedVia,
    this.acceptedAt,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    if (!nullToAbsent || userId != null) {
      map['user_id'] = Variable<String>(userId);
    }
    map['role'] = Variable<String>(role);
    map['invited_via'] = Variable<String>(invitedVia);
    if (!nullToAbsent || acceptedAt != null) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetMembersCompanion toCompanion(bool nullToAbsent) {
    return BudgetMembersCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      userId: userId == null && nullToAbsent
          ? const Value.absent()
          : Value(userId),
      role: Value(role),
      invitedVia: Value(invitedVia),
      acceptedAt: acceptedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(acceptedAt),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetMember.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetMember(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      userId: serializer.fromJson<String?>(json['userId']),
      role: serializer.fromJson<String>(json['role']),
      invitedVia: serializer.fromJson<String>(json['invitedVia']),
      acceptedAt: serializer.fromJson<DateTime?>(json['acceptedAt']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'userId': serializer.toJson<String?>(userId),
      'role': serializer.toJson<String>(role),
      'invitedVia': serializer.toJson<String>(invitedVia),
      'acceptedAt': serializer.toJson<DateTime?>(acceptedAt),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetMember copyWith({
    String? id,
    String? budgetId,
    Value<String?> userId = const Value.absent(),
    String? role,
    String? invitedVia,
    Value<DateTime?> acceptedAt = const Value.absent(),
    DateTime? createdAt,
  }) => BudgetMember(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    userId: userId.present ? userId.value : this.userId,
    role: role ?? this.role,
    invitedVia: invitedVia ?? this.invitedVia,
    acceptedAt: acceptedAt.present ? acceptedAt.value : this.acceptedAt,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetMember copyWithCompanion(BudgetMembersCompanion data) {
    return BudgetMember(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      userId: data.userId.present ? data.userId.value : this.userId,
      role: data.role.present ? data.role.value : this.role,
      invitedVia: data.invitedVia.present
          ? data.invitedVia.value
          : this.invitedVia,
      acceptedAt: data.acceptedAt.present
          ? data.acceptedAt.value
          : this.acceptedAt,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetMember(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('invitedVia: $invitedVia, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    userId,
    role,
    invitedVia,
    acceptedAt,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetMember &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.userId == this.userId &&
          other.role == this.role &&
          other.invitedVia == this.invitedVia &&
          other.acceptedAt == this.acceptedAt &&
          other.createdAt == this.createdAt);
}

class BudgetMembersCompanion extends UpdateCompanion<BudgetMember> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String?> userId;
  final Value<String> role;
  final Value<String> invitedVia;
  final Value<DateTime?> acceptedAt;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetMembersCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    this.invitedVia = const Value.absent(),
    this.acceptedAt = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetMembersCompanion.insert({
    required String id,
    required String budgetId,
    this.userId = const Value.absent(),
    this.role = const Value.absent(),
    required String invitedVia,
    this.acceptedAt = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       invitedVia = Value(invitedVia),
       createdAt = Value(createdAt);
  static Insertable<BudgetMember> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? userId,
    Expression<String>? role,
    Expression<String>? invitedVia,
    Expression<DateTime>? acceptedAt,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (userId != null) 'user_id': userId,
      if (role != null) 'role': role,
      if (invitedVia != null) 'invited_via': invitedVia,
      if (acceptedAt != null) 'accepted_at': acceptedAt,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetMembersCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String?>? userId,
    Value<String>? role,
    Value<String>? invitedVia,
    Value<DateTime?>? acceptedAt,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetMembersCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      invitedVia: invitedVia ?? this.invitedVia,
      acceptedAt: acceptedAt ?? this.acceptedAt,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (role.present) {
      map['role'] = Variable<String>(role.value);
    }
    if (invitedVia.present) {
      map['invited_via'] = Variable<String>(invitedVia.value);
    }
    if (acceptedAt.present) {
      map['accepted_at'] = Variable<DateTime>(acceptedAt.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetMembersCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('userId: $userId, ')
          ..write('role: $role, ')
          ..write('invitedVia: $invitedVia, ')
          ..write('acceptedAt: $acceptedAt, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BudgetPeriodsTable extends BudgetPeriods
    with TableInfo<$BudgetPeriodsTable, BudgetPeriod> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BudgetPeriodsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalIncomeMeta = const VerificationMeta(
    'totalIncome',
  );
  @override
  late final GeneratedColumn<int> totalIncome = GeneratedColumn<int>(
    'total_income',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalAllocatedMeta = const VerificationMeta(
    'totalAllocated',
  );
  @override
  late final GeneratedColumn<int> totalAllocated = GeneratedColumn<int>(
    'total_allocated',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isClosedMeta = const VerificationMeta(
    'isClosed',
  );
  @override
  late final GeneratedColumn<bool> isClosed = GeneratedColumn<bool>(
    'is_closed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_closed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    startDate,
    endDate,
    totalIncome,
    totalAllocated,
    isClosed,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'budget_periods';
  @override
  VerificationContext validateIntegrity(
    Insertable<BudgetPeriod> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    } else if (isInserting) {
      context.missing(_endDateMeta);
    }
    if (data.containsKey('total_income')) {
      context.handle(
        _totalIncomeMeta,
        totalIncome.isAcceptableOrUnknown(
          data['total_income']!,
          _totalIncomeMeta,
        ),
      );
    }
    if (data.containsKey('total_allocated')) {
      context.handle(
        _totalAllocatedMeta,
        totalAllocated.isAcceptableOrUnknown(
          data['total_allocated']!,
          _totalAllocatedMeta,
        ),
      );
    }
    if (data.containsKey('is_closed')) {
      context.handle(
        _isClosedMeta,
        isClosed.isAcceptableOrUnknown(data['is_closed']!, _isClosedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BudgetPeriod map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BudgetPeriod(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      )!,
      totalIncome: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_income'],
      )!,
      totalAllocated: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_allocated'],
      )!,
      isClosed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_closed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BudgetPeriodsTable createAlias(String alias) {
    return $BudgetPeriodsTable(attachedDatabase, alias);
  }
}

class BudgetPeriod extends DataClass implements Insertable<BudgetPeriod> {
  final String id;
  final String budgetId;
  final DateTime startDate;
  final DateTime endDate;
  final int totalIncome;
  final int totalAllocated;
  final bool isClosed;
  final DateTime createdAt;
  const BudgetPeriod({
    required this.id,
    required this.budgetId,
    required this.startDate,
    required this.endDate,
    required this.totalIncome,
    required this.totalAllocated,
    required this.isClosed,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['start_date'] = Variable<DateTime>(startDate);
    map['end_date'] = Variable<DateTime>(endDate);
    map['total_income'] = Variable<int>(totalIncome);
    map['total_allocated'] = Variable<int>(totalAllocated);
    map['is_closed'] = Variable<bool>(isClosed);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BudgetPeriodsCompanion toCompanion(bool nullToAbsent) {
    return BudgetPeriodsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      startDate: Value(startDate),
      endDate: Value(endDate),
      totalIncome: Value(totalIncome),
      totalAllocated: Value(totalAllocated),
      isClosed: Value(isClosed),
      createdAt: Value(createdAt),
    );
  }

  factory BudgetPeriod.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BudgetPeriod(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime>(json['endDate']),
      totalIncome: serializer.fromJson<int>(json['totalIncome']),
      totalAllocated: serializer.fromJson<int>(json['totalAllocated']),
      isClosed: serializer.fromJson<bool>(json['isClosed']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime>(endDate),
      'totalIncome': serializer.toJson<int>(totalIncome),
      'totalAllocated': serializer.toJson<int>(totalAllocated),
      'isClosed': serializer.toJson<bool>(isClosed),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BudgetPeriod copyWith({
    String? id,
    String? budgetId,
    DateTime? startDate,
    DateTime? endDate,
    int? totalIncome,
    int? totalAllocated,
    bool? isClosed,
    DateTime? createdAt,
  }) => BudgetPeriod(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
    totalIncome: totalIncome ?? this.totalIncome,
    totalAllocated: totalAllocated ?? this.totalAllocated,
    isClosed: isClosed ?? this.isClosed,
    createdAt: createdAt ?? this.createdAt,
  );
  BudgetPeriod copyWithCompanion(BudgetPeriodsCompanion data) {
    return BudgetPeriod(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      totalIncome: data.totalIncome.present
          ? data.totalIncome.value
          : this.totalIncome,
      totalAllocated: data.totalAllocated.present
          ? data.totalAllocated.value
          : this.totalAllocated,
      isClosed: data.isClosed.present ? data.isClosed.value : this.isClosed,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BudgetPeriod(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('totalIncome: $totalIncome, ')
          ..write('totalAllocated: $totalAllocated, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    startDate,
    endDate,
    totalIncome,
    totalAllocated,
    isClosed,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BudgetPeriod &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.totalIncome == this.totalIncome &&
          other.totalAllocated == this.totalAllocated &&
          other.isClosed == this.isClosed &&
          other.createdAt == this.createdAt);
}

class BudgetPeriodsCompanion extends UpdateCompanion<BudgetPeriod> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<DateTime> startDate;
  final Value<DateTime> endDate;
  final Value<int> totalIncome;
  final Value<int> totalAllocated;
  final Value<bool> isClosed;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BudgetPeriodsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.totalIncome = const Value.absent(),
    this.totalAllocated = const Value.absent(),
    this.isClosed = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BudgetPeriodsCompanion.insert({
    required String id,
    required String budgetId,
    required DateTime startDate,
    required DateTime endDate,
    this.totalIncome = const Value.absent(),
    this.totalAllocated = const Value.absent(),
    this.isClosed = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       startDate = Value(startDate),
       endDate = Value(endDate),
       createdAt = Value(createdAt);
  static Insertable<BudgetPeriod> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<int>? totalIncome,
    Expression<int>? totalAllocated,
    Expression<bool>? isClosed,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (totalIncome != null) 'total_income': totalIncome,
      if (totalAllocated != null) 'total_allocated': totalAllocated,
      if (isClosed != null) 'is_closed': isClosed,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BudgetPeriodsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<DateTime>? startDate,
    Value<DateTime>? endDate,
    Value<int>? totalIncome,
    Value<int>? totalAllocated,
    Value<bool>? isClosed,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BudgetPeriodsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      totalIncome: totalIncome ?? this.totalIncome,
      totalAllocated: totalAllocated ?? this.totalAllocated,
      isClosed: isClosed ?? this.isClosed,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (totalIncome.present) {
      map['total_income'] = Variable<int>(totalIncome.value);
    }
    if (totalAllocated.present) {
      map['total_allocated'] = Variable<int>(totalAllocated.value);
    }
    if (isClosed.present) {
      map['is_closed'] = Variable<bool>(isClosed.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BudgetPeriodsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('totalIncome: $totalIncome, ')
          ..write('totalAllocated: $totalAllocated, ')
          ..write('isClosed: $isClosed, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AccountsTable extends Accounts with TableInfo<$AccountsTable, Account> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startingBalanceMeta = const VerificationMeta(
    'startingBalance',
  );
  @override
  late final GeneratedColumn<int> startingBalance = GeneratedColumn<int>(
    'starting_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currentBalanceMeta = const VerificationMeta(
    'currentBalance',
  );
  @override
  late final GeneratedColumn<int> currentBalance = GeneratedColumn<int>(
    'current_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isOnBudgetMeta = const VerificationMeta(
    'isOnBudget',
  );
  @override
  late final GeneratedColumn<bool> isOnBudget = GeneratedColumn<bool>(
    'is_on_budget',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_on_budget" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    name,
    type,
    startingBalance,
    currentBalance,
    currency,
    isArchived,
    isOnBudget,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<Account> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('starting_balance')) {
      context.handle(
        _startingBalanceMeta,
        startingBalance.isAcceptableOrUnknown(
          data['starting_balance']!,
          _startingBalanceMeta,
        ),
      );
    }
    if (data.containsKey('current_balance')) {
      context.handle(
        _currentBalanceMeta,
        currentBalance.isAcceptableOrUnknown(
          data['current_balance']!,
          _currentBalanceMeta,
        ),
      );
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('is_on_budget')) {
      context.handle(
        _isOnBudgetMeta,
        isOnBudget.isAcceptableOrUnknown(
          data['is_on_budget']!,
          _isOnBudgetMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Account map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Account(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      startingBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}starting_balance'],
      )!,
      currentBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_balance'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      isOnBudget: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_on_budget'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AccountsTable createAlias(String alias) {
    return $AccountsTable(attachedDatabase, alias);
  }
}

class Account extends DataClass implements Insertable<Account> {
  final String id;
  final String budgetId;
  final String name;
  final String type;
  final int startingBalance;
  final int currentBalance;
  final String currency;
  final bool isArchived;
  final bool isOnBudget;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Account({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.type,
    required this.startingBalance,
    required this.currentBalance,
    required this.currency,
    required this.isArchived,
    required this.isOnBudget,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['starting_balance'] = Variable<int>(startingBalance);
    map['current_balance'] = Variable<int>(currentBalance);
    map['currency'] = Variable<String>(currency);
    map['is_archived'] = Variable<bool>(isArchived);
    map['is_on_budget'] = Variable<bool>(isOnBudget);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AccountsCompanion toCompanion(bool nullToAbsent) {
    return AccountsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      type: Value(type),
      startingBalance: Value(startingBalance),
      currentBalance: Value(currentBalance),
      currency: Value(currency),
      isArchived: Value(isArchived),
      isOnBudget: Value(isOnBudget),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Account.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Account(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      startingBalance: serializer.fromJson<int>(json['startingBalance']),
      currentBalance: serializer.fromJson<int>(json['currentBalance']),
      currency: serializer.fromJson<String>(json['currency']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      isOnBudget: serializer.fromJson<bool>(json['isOnBudget']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'startingBalance': serializer.toJson<int>(startingBalance),
      'currentBalance': serializer.toJson<int>(currentBalance),
      'currency': serializer.toJson<String>(currency),
      'isArchived': serializer.toJson<bool>(isArchived),
      'isOnBudget': serializer.toJson<bool>(isOnBudget),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Account copyWith({
    String? id,
    String? budgetId,
    String? name,
    String? type,
    int? startingBalance,
    int? currentBalance,
    String? currency,
    bool? isArchived,
    bool? isOnBudget,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Account(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    type: type ?? this.type,
    startingBalance: startingBalance ?? this.startingBalance,
    currentBalance: currentBalance ?? this.currentBalance,
    currency: currency ?? this.currency,
    isArchived: isArchived ?? this.isArchived,
    isOnBudget: isOnBudget ?? this.isOnBudget,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Account copyWithCompanion(AccountsCompanion data) {
    return Account(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      startingBalance: data.startingBalance.present
          ? data.startingBalance.value
          : this.startingBalance,
      currentBalance: data.currentBalance.present
          ? data.currentBalance.value
          : this.currentBalance,
      currency: data.currency.present ? data.currency.value : this.currency,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      isOnBudget: data.isOnBudget.present
          ? data.isOnBudget.value
          : this.isOnBudget,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Account(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('startingBalance: $startingBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('currency: $currency, ')
          ..write('isArchived: $isArchived, ')
          ..write('isOnBudget: $isOnBudget, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    name,
    type,
    startingBalance,
    currentBalance,
    currency,
    isArchived,
    isOnBudget,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Account &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.type == this.type &&
          other.startingBalance == this.startingBalance &&
          other.currentBalance == this.currentBalance &&
          other.currency == this.currency &&
          other.isArchived == this.isArchived &&
          other.isOnBudget == this.isOnBudget &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AccountsCompanion extends UpdateCompanion<Account> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<String> type;
  final Value<int> startingBalance;
  final Value<int> currentBalance;
  final Value<String> currency;
  final Value<bool> isArchived;
  final Value<bool> isOnBudget;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AccountsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.startingBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    this.currency = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.isOnBudget = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AccountsCompanion.insert({
    required String id,
    required String budgetId,
    required String name,
    required String type,
    this.startingBalance = const Value.absent(),
    this.currentBalance = const Value.absent(),
    required String currency,
    this.isArchived = const Value.absent(),
    this.isOnBudget = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       name = Value(name),
       type = Value(type),
       currency = Value(currency),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Account> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<String>? type,
    Expression<int>? startingBalance,
    Expression<int>? currentBalance,
    Expression<String>? currency,
    Expression<bool>? isArchived,
    Expression<bool>? isOnBudget,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (startingBalance != null) 'starting_balance': startingBalance,
      if (currentBalance != null) 'current_balance': currentBalance,
      if (currency != null) 'currency': currency,
      if (isArchived != null) 'is_archived': isArchived,
      if (isOnBudget != null) 'is_on_budget': isOnBudget,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? name,
    Value<String>? type,
    Value<int>? startingBalance,
    Value<int>? currentBalance,
    Value<String>? currency,
    Value<bool>? isArchived,
    Value<bool>? isOnBudget,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AccountsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      type: type ?? this.type,
      startingBalance: startingBalance ?? this.startingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      currency: currency ?? this.currency,
      isArchived: isArchived ?? this.isArchived,
      isOnBudget: isOnBudget ?? this.isOnBudget,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (startingBalance.present) {
      map['starting_balance'] = Variable<int>(startingBalance.value);
    }
    if (currentBalance.present) {
      map['current_balance'] = Variable<int>(currentBalance.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (isOnBudget.present) {
      map['is_on_budget'] = Variable<bool>(isOnBudget.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AccountsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('startingBalance: $startingBalance, ')
          ..write('currentBalance: $currentBalance, ')
          ..write('currency: $currency, ')
          ..write('isArchived: $isArchived, ')
          ..write('isOnBudget: $isOnBudget, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CategoryGroupsTable extends CategoryGroups
    with TableInfo<$CategoryGroupsTable, CategoryGroup> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoryGroupsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    name,
    sortOrder,
    isDefault,
    isArchived,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'category_groups';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryGroup> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryGroup map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryGroup(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $CategoryGroupsTable createAlias(String alias) {
    return $CategoryGroupsTable(attachedDatabase, alias);
  }
}

class CategoryGroup extends DataClass implements Insertable<CategoryGroup> {
  final String id;
  final String budgetId;
  final String name;
  final int sortOrder;
  final bool isDefault;
  final bool isArchived;
  final DateTime createdAt;
  const CategoryGroup({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.sortOrder,
    required this.isDefault,
    required this.isArchived,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_default'] = Variable<bool>(isDefault);
    map['is_archived'] = Variable<bool>(isArchived);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  CategoryGroupsCompanion toCompanion(bool nullToAbsent) {
    return CategoryGroupsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isDefault: Value(isDefault),
      isArchived: Value(isArchived),
      createdAt: Value(createdAt),
    );
  }

  factory CategoryGroup.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryGroup(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isDefault': serializer.toJson<bool>(isDefault),
      'isArchived': serializer.toJson<bool>(isArchived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  CategoryGroup copyWith({
    String? id,
    String? budgetId,
    String? name,
    int? sortOrder,
    bool? isDefault,
    bool? isArchived,
    DateTime? createdAt,
  }) => CategoryGroup(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isDefault: isDefault ?? this.isDefault,
    isArchived: isArchived ?? this.isArchived,
    createdAt: createdAt ?? this.createdAt,
  );
  CategoryGroup copyWithCompanion(CategoryGroupsCompanion data) {
    return CategoryGroup(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryGroup(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    name,
    sortOrder,
    isDefault,
    isArchived,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryGroup &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isDefault == this.isDefault &&
          other.isArchived == this.isArchived &&
          other.createdAt == this.createdAt);
}

class CategoryGroupsCompanion extends UpdateCompanion<CategoryGroup> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isDefault;
  final Value<bool> isArchived;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const CategoryGroupsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoryGroupsCompanion.insert({
    required String id,
    required String budgetId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.isArchived = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<CategoryGroup> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isDefault,
    Expression<bool>? isArchived,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isDefault != null) 'is_default': isDefault,
      if (isArchived != null) 'is_archived': isArchived,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoryGroupsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isDefault,
    Value<bool>? isArchived,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return CategoryGroupsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isDefault: isDefault ?? this.isDefault,
      isArchived: isArchived ?? this.isArchived,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoryGroupsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isDefault: $isDefault, ')
          ..write('isArchived: $isArchived, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnvelopesTable extends Envelopes
    with TableInfo<$EnvelopesTable, Envelope> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryGroupIdMeta = const VerificationMeta(
    'categoryGroupId',
  );
  @override
  late final GeneratedColumn<String> categoryGroupId = GeneratedColumn<String>(
    'category_group_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isArchivedMeta = const VerificationMeta(
    'isArchived',
  );
  @override
  late final GeneratedColumn<bool> isArchived = GeneratedColumn<bool>(
    'is_archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<String> color = GeneratedColumn<String>(
    'color',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _linkedAccountIdMeta = const VerificationMeta(
    'linkedAccountId',
  );
  @override
  late final GeneratedColumn<String> linkedAccountId = GeneratedColumn<String>(
    'linked_account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryGroupId,
    budgetId,
    name,
    sortOrder,
    isArchived,
    color,
    linkedAccountId,
    createdAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelopes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Envelope> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_group_id')) {
      context.handle(
        _categoryGroupIdMeta,
        categoryGroupId.isAcceptableOrUnknown(
          data['category_group_id']!,
          _categoryGroupIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_categoryGroupIdMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('is_archived')) {
      context.handle(
        _isArchivedMeta,
        isArchived.isAcceptableOrUnknown(data['is_archived']!, _isArchivedMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    }
    if (data.containsKey('linked_account_id')) {
      context.handle(
        _linkedAccountIdMeta,
        linkedAccountId.isAcceptableOrUnknown(
          data['linked_account_id']!,
          _linkedAccountIdMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Envelope map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Envelope(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryGroupId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_group_id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      isArchived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_archived'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}color'],
      ),
      linkedAccountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}linked_account_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $EnvelopesTable createAlias(String alias) {
    return $EnvelopesTable(attachedDatabase, alias);
  }
}

class Envelope extends DataClass implements Insertable<Envelope> {
  final String id;
  final String categoryGroupId;
  final String budgetId;
  final String name;
  final int sortOrder;
  final bool isArchived;
  final String? color;
  final String? linkedAccountId;
  final DateTime createdAt;
  final DateTime? deletedAt;
  const Envelope({
    required this.id,
    required this.categoryGroupId,
    required this.budgetId,
    required this.name,
    required this.sortOrder,
    required this.isArchived,
    this.color,
    this.linkedAccountId,
    required this.createdAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_group_id'] = Variable<String>(categoryGroupId);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    map['is_archived'] = Variable<bool>(isArchived);
    if (!nullToAbsent || color != null) {
      map['color'] = Variable<String>(color);
    }
    if (!nullToAbsent || linkedAccountId != null) {
      map['linked_account_id'] = Variable<String>(linkedAccountId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  EnvelopesCompanion toCompanion(bool nullToAbsent) {
    return EnvelopesCompanion(
      id: Value(id),
      categoryGroupId: Value(categoryGroupId),
      budgetId: Value(budgetId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      isArchived: Value(isArchived),
      color: color == null && nullToAbsent
          ? const Value.absent()
          : Value(color),
      linkedAccountId: linkedAccountId == null && nullToAbsent
          ? const Value.absent()
          : Value(linkedAccountId),
      createdAt: Value(createdAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Envelope.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Envelope(
      id: serializer.fromJson<String>(json['id']),
      categoryGroupId: serializer.fromJson<String>(json['categoryGroupId']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isArchived: serializer.fromJson<bool>(json['isArchived']),
      color: serializer.fromJson<String?>(json['color']),
      linkedAccountId: serializer.fromJson<String?>(json['linkedAccountId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryGroupId': serializer.toJson<String>(categoryGroupId),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'isArchived': serializer.toJson<bool>(isArchived),
      'color': serializer.toJson<String?>(color),
      'linkedAccountId': serializer.toJson<String?>(linkedAccountId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Envelope copyWith({
    String? id,
    String? categoryGroupId,
    String? budgetId,
    String? name,
    int? sortOrder,
    bool? isArchived,
    Value<String?> color = const Value.absent(),
    Value<String?> linkedAccountId = const Value.absent(),
    DateTime? createdAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Envelope(
    id: id ?? this.id,
    categoryGroupId: categoryGroupId ?? this.categoryGroupId,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    isArchived: isArchived ?? this.isArchived,
    color: color.present ? color.value : this.color,
    linkedAccountId: linkedAccountId.present
        ? linkedAccountId.value
        : this.linkedAccountId,
    createdAt: createdAt ?? this.createdAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Envelope copyWithCompanion(EnvelopesCompanion data) {
    return Envelope(
      id: data.id.present ? data.id.value : this.id,
      categoryGroupId: data.categoryGroupId.present
          ? data.categoryGroupId.value
          : this.categoryGroupId,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isArchived: data.isArchived.present
          ? data.isArchived.value
          : this.isArchived,
      color: data.color.present ? data.color.value : this.color,
      linkedAccountId: data.linkedAccountId.present
          ? data.linkedAccountId.value
          : this.linkedAccountId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Envelope(')
          ..write('id: $id, ')
          ..write('categoryGroupId: $categoryGroupId, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('color: $color, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryGroupId,
    budgetId,
    name,
    sortOrder,
    isArchived,
    color,
    linkedAccountId,
    createdAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Envelope &&
          other.id == this.id &&
          other.categoryGroupId == this.categoryGroupId &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.isArchived == this.isArchived &&
          other.color == this.color &&
          other.linkedAccountId == this.linkedAccountId &&
          other.createdAt == this.createdAt &&
          other.deletedAt == this.deletedAt);
}

class EnvelopesCompanion extends UpdateCompanion<Envelope> {
  final Value<String> id;
  final Value<String> categoryGroupId;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<bool> isArchived;
  final Value<String?> color;
  final Value<String?> linkedAccountId;
  final Value<DateTime> createdAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const EnvelopesCompanion({
    this.id = const Value.absent(),
    this.categoryGroupId = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.color = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvelopesCompanion.insert({
    required String id,
    required String categoryGroupId,
    required String budgetId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.isArchived = const Value.absent(),
    this.color = const Value.absent(),
    this.linkedAccountId = const Value.absent(),
    required DateTime createdAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryGroupId = Value(categoryGroupId),
       budgetId = Value(budgetId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Envelope> custom({
    Expression<String>? id,
    Expression<String>? categoryGroupId,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<bool>? isArchived,
    Expression<String>? color,
    Expression<String>? linkedAccountId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryGroupId != null) 'category_group_id': categoryGroupId,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isArchived != null) 'is_archived': isArchived,
      if (color != null) 'color': color,
      if (linkedAccountId != null) 'linked_account_id': linkedAccountId,
      if (createdAt != null) 'created_at': createdAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvelopesCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryGroupId,
    Value<String>? budgetId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<bool>? isArchived,
    Value<String?>? color,
    Value<String?>? linkedAccountId,
    Value<DateTime>? createdAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return EnvelopesCompanion(
      id: id ?? this.id,
      categoryGroupId: categoryGroupId ?? this.categoryGroupId,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      isArchived: isArchived ?? this.isArchived,
      color: color ?? this.color,
      linkedAccountId: linkedAccountId ?? this.linkedAccountId,
      createdAt: createdAt ?? this.createdAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryGroupId.present) {
      map['category_group_id'] = Variable<String>(categoryGroupId.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (isArchived.present) {
      map['is_archived'] = Variable<bool>(isArchived.value);
    }
    if (color.present) {
      map['color'] = Variable<String>(color.value);
    }
    if (linkedAccountId.present) {
      map['linked_account_id'] = Variable<String>(linkedAccountId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopesCompanion(')
          ..write('id: $id, ')
          ..write('categoryGroupId: $categoryGroupId, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isArchived: $isArchived, ')
          ..write('color: $color, ')
          ..write('linkedAccountId: $linkedAccountId, ')
          ..write('createdAt: $createdAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $EnvelopeAllocationsTable extends EnvelopeAllocations
    with TableInfo<$EnvelopeAllocationsTable, EnvelopeAllocation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $EnvelopeAllocationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetPeriodIdMeta = const VerificationMeta(
    'budgetPeriodId',
  );
  @override
  late final GeneratedColumn<String> budgetPeriodId = GeneratedColumn<String>(
    'budget_period_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allocatedAmountMeta = const VerificationMeta(
    'allocatedAmount',
  );
  @override
  late final GeneratedColumn<int> allocatedAmount = GeneratedColumn<int>(
    'allocated_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _spentAmountMeta = const VerificationMeta(
    'spentAmount',
  );
  @override
  late final GeneratedColumn<int> spentAmount = GeneratedColumn<int>(
    'spent_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _rolloverAmountMeta = const VerificationMeta(
    'rolloverAmount',
  );
  @override
  late final GeneratedColumn<int> rolloverAmount = GeneratedColumn<int>(
    'rollover_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    envelopeId,
    budgetPeriodId,
    allocatedAmount,
    spentAmount,
    rolloverAmount,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'envelope_allocations';
  @override
  VerificationContext validateIntegrity(
    Insertable<EnvelopeAllocation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('budget_period_id')) {
      context.handle(
        _budgetPeriodIdMeta,
        budgetPeriodId.isAcceptableOrUnknown(
          data['budget_period_id']!,
          _budgetPeriodIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_budgetPeriodIdMeta);
    }
    if (data.containsKey('allocated_amount')) {
      context.handle(
        _allocatedAmountMeta,
        allocatedAmount.isAcceptableOrUnknown(
          data['allocated_amount']!,
          _allocatedAmountMeta,
        ),
      );
    }
    if (data.containsKey('spent_amount')) {
      context.handle(
        _spentAmountMeta,
        spentAmount.isAcceptableOrUnknown(
          data['spent_amount']!,
          _spentAmountMeta,
        ),
      );
    }
    if (data.containsKey('rollover_amount')) {
      context.handle(
        _rolloverAmountMeta,
        rolloverAmount.isAcceptableOrUnknown(
          data['rollover_amount']!,
          _rolloverAmountMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  EnvelopeAllocation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return EnvelopeAllocation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      )!,
      budgetPeriodId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_period_id'],
      )!,
      allocatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}allocated_amount'],
      )!,
      spentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}spent_amount'],
      )!,
      rolloverAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rollover_amount'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $EnvelopeAllocationsTable createAlias(String alias) {
    return $EnvelopeAllocationsTable(attachedDatabase, alias);
  }
}

class EnvelopeAllocation extends DataClass
    implements Insertable<EnvelopeAllocation> {
  final String id;
  final String envelopeId;
  final String budgetPeriodId;
  final int allocatedAmount;
  final int spentAmount;
  final int rolloverAmount;
  final DateTime createdAt;
  const EnvelopeAllocation({
    required this.id,
    required this.envelopeId,
    required this.budgetPeriodId,
    required this.allocatedAmount,
    required this.spentAmount,
    required this.rolloverAmount,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['envelope_id'] = Variable<String>(envelopeId);
    map['budget_period_id'] = Variable<String>(budgetPeriodId);
    map['allocated_amount'] = Variable<int>(allocatedAmount);
    map['spent_amount'] = Variable<int>(spentAmount);
    map['rollover_amount'] = Variable<int>(rolloverAmount);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  EnvelopeAllocationsCompanion toCompanion(bool nullToAbsent) {
    return EnvelopeAllocationsCompanion(
      id: Value(id),
      envelopeId: Value(envelopeId),
      budgetPeriodId: Value(budgetPeriodId),
      allocatedAmount: Value(allocatedAmount),
      spentAmount: Value(spentAmount),
      rolloverAmount: Value(rolloverAmount),
      createdAt: Value(createdAt),
    );
  }

  factory EnvelopeAllocation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return EnvelopeAllocation(
      id: serializer.fromJson<String>(json['id']),
      envelopeId: serializer.fromJson<String>(json['envelopeId']),
      budgetPeriodId: serializer.fromJson<String>(json['budgetPeriodId']),
      allocatedAmount: serializer.fromJson<int>(json['allocatedAmount']),
      spentAmount: serializer.fromJson<int>(json['spentAmount']),
      rolloverAmount: serializer.fromJson<int>(json['rolloverAmount']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'envelopeId': serializer.toJson<String>(envelopeId),
      'budgetPeriodId': serializer.toJson<String>(budgetPeriodId),
      'allocatedAmount': serializer.toJson<int>(allocatedAmount),
      'spentAmount': serializer.toJson<int>(spentAmount),
      'rolloverAmount': serializer.toJson<int>(rolloverAmount),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  EnvelopeAllocation copyWith({
    String? id,
    String? envelopeId,
    String? budgetPeriodId,
    int? allocatedAmount,
    int? spentAmount,
    int? rolloverAmount,
    DateTime? createdAt,
  }) => EnvelopeAllocation(
    id: id ?? this.id,
    envelopeId: envelopeId ?? this.envelopeId,
    budgetPeriodId: budgetPeriodId ?? this.budgetPeriodId,
    allocatedAmount: allocatedAmount ?? this.allocatedAmount,
    spentAmount: spentAmount ?? this.spentAmount,
    rolloverAmount: rolloverAmount ?? this.rolloverAmount,
    createdAt: createdAt ?? this.createdAt,
  );
  EnvelopeAllocation copyWithCompanion(EnvelopeAllocationsCompanion data) {
    return EnvelopeAllocation(
      id: data.id.present ? data.id.value : this.id,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      budgetPeriodId: data.budgetPeriodId.present
          ? data.budgetPeriodId.value
          : this.budgetPeriodId,
      allocatedAmount: data.allocatedAmount.present
          ? data.allocatedAmount.value
          : this.allocatedAmount,
      spentAmount: data.spentAmount.present
          ? data.spentAmount.value
          : this.spentAmount,
      rolloverAmount: data.rolloverAmount.present
          ? data.rolloverAmount.value
          : this.rolloverAmount,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeAllocation(')
          ..write('id: $id, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('budgetPeriodId: $budgetPeriodId, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('rolloverAmount: $rolloverAmount, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    envelopeId,
    budgetPeriodId,
    allocatedAmount,
    spentAmount,
    rolloverAmount,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is EnvelopeAllocation &&
          other.id == this.id &&
          other.envelopeId == this.envelopeId &&
          other.budgetPeriodId == this.budgetPeriodId &&
          other.allocatedAmount == this.allocatedAmount &&
          other.spentAmount == this.spentAmount &&
          other.rolloverAmount == this.rolloverAmount &&
          other.createdAt == this.createdAt);
}

class EnvelopeAllocationsCompanion extends UpdateCompanion<EnvelopeAllocation> {
  final Value<String> id;
  final Value<String> envelopeId;
  final Value<String> budgetPeriodId;
  final Value<int> allocatedAmount;
  final Value<int> spentAmount;
  final Value<int> rolloverAmount;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const EnvelopeAllocationsCompanion({
    this.id = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.budgetPeriodId = const Value.absent(),
    this.allocatedAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.rolloverAmount = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  EnvelopeAllocationsCompanion.insert({
    required String id,
    required String envelopeId,
    required String budgetPeriodId,
    this.allocatedAmount = const Value.absent(),
    this.spentAmount = const Value.absent(),
    this.rolloverAmount = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       envelopeId = Value(envelopeId),
       budgetPeriodId = Value(budgetPeriodId),
       createdAt = Value(createdAt);
  static Insertable<EnvelopeAllocation> custom({
    Expression<String>? id,
    Expression<String>? envelopeId,
    Expression<String>? budgetPeriodId,
    Expression<int>? allocatedAmount,
    Expression<int>? spentAmount,
    Expression<int>? rolloverAmount,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (budgetPeriodId != null) 'budget_period_id': budgetPeriodId,
      if (allocatedAmount != null) 'allocated_amount': allocatedAmount,
      if (spentAmount != null) 'spent_amount': spentAmount,
      if (rolloverAmount != null) 'rollover_amount': rolloverAmount,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  EnvelopeAllocationsCompanion copyWith({
    Value<String>? id,
    Value<String>? envelopeId,
    Value<String>? budgetPeriodId,
    Value<int>? allocatedAmount,
    Value<int>? spentAmount,
    Value<int>? rolloverAmount,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return EnvelopeAllocationsCompanion(
      id: id ?? this.id,
      envelopeId: envelopeId ?? this.envelopeId,
      budgetPeriodId: budgetPeriodId ?? this.budgetPeriodId,
      allocatedAmount: allocatedAmount ?? this.allocatedAmount,
      spentAmount: spentAmount ?? this.spentAmount,
      rolloverAmount: rolloverAmount ?? this.rolloverAmount,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (budgetPeriodId.present) {
      map['budget_period_id'] = Variable<String>(budgetPeriodId.value);
    }
    if (allocatedAmount.present) {
      map['allocated_amount'] = Variable<int>(allocatedAmount.value);
    }
    if (spentAmount.present) {
      map['spent_amount'] = Variable<int>(spentAmount.value);
    }
    if (rolloverAmount.present) {
      map['rollover_amount'] = Variable<int>(rolloverAmount.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('EnvelopeAllocationsCompanion(')
          ..write('id: $id, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('budgetPeriodId: $budgetPeriodId, ')
          ..write('allocatedAmount: $allocatedAmount, ')
          ..write('spentAmount: $spentAmount, ')
          ..write('rolloverAmount: $rolloverAmount, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionsTable extends Transactions
    with TableInfo<$TransactionsTable, Transaction> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _exchangeRateMeta = const VerificationMeta(
    'exchangeRate',
  );
  @override
  late final GeneratedColumn<double> exchangeRate = GeneratedColumn<double>(
    'exchange_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _baseCurrencyAmountMeta =
      const VerificationMeta('baseCurrencyAmount');
  @override
  late final GeneratedColumn<int> baseCurrencyAmount = GeneratedColumn<int>(
    'base_currency_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isReconciledMeta = const VerificationMeta(
    'isReconciled',
  );
  @override
  late final GeneratedColumn<bool> isReconciled = GeneratedColumn<bool>(
    'is_reconciled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_reconciled" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _recurringRuleIdMeta = const VerificationMeta(
    'recurringRuleId',
  );
  @override
  late final GeneratedColumn<String> recurringRuleId = GeneratedColumn<String>(
    'recurring_rule_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _transferPairIdMeta = const VerificationMeta(
    'transferPairId',
  );
  @override
  late final GeneratedColumn<String> transferPairId = GeneratedColumn<String>(
    'transfer_pair_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdByMeta = const VerificationMeta(
    'createdBy',
  );
  @override
  late final GeneratedColumn<String> createdBy = GeneratedColumn<String>(
    'created_by',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<DateTime> deletedAt = GeneratedColumn<DateTime>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    accountId,
    envelopeId,
    type,
    amount,
    currency,
    exchangeRate,
    baseCurrencyAmount,
    payee,
    notes,
    date,
    isReconciled,
    recurringRuleId,
    transferPairId,
    createdBy,
    createdAt,
    updatedAt,
    deletedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transactions';
  @override
  VerificationContext validateIntegrity(
    Insertable<Transaction> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('exchange_rate')) {
      context.handle(
        _exchangeRateMeta,
        exchangeRate.isAcceptableOrUnknown(
          data['exchange_rate']!,
          _exchangeRateMeta,
        ),
      );
    }
    if (data.containsKey('base_currency_amount')) {
      context.handle(
        _baseCurrencyAmountMeta,
        baseCurrencyAmount.isAcceptableOrUnknown(
          data['base_currency_amount']!,
          _baseCurrencyAmountMeta,
        ),
      );
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_reconciled')) {
      context.handle(
        _isReconciledMeta,
        isReconciled.isAcceptableOrUnknown(
          data['is_reconciled']!,
          _isReconciledMeta,
        ),
      );
    }
    if (data.containsKey('recurring_rule_id')) {
      context.handle(
        _recurringRuleIdMeta,
        recurringRuleId.isAcceptableOrUnknown(
          data['recurring_rule_id']!,
          _recurringRuleIdMeta,
        ),
      );
    }
    if (data.containsKey('transfer_pair_id')) {
      context.handle(
        _transferPairIdMeta,
        transferPairId.isAcceptableOrUnknown(
          data['transfer_pair_id']!,
          _transferPairIdMeta,
        ),
      );
    }
    if (data.containsKey('created_by')) {
      context.handle(
        _createdByMeta,
        createdBy.isAcceptableOrUnknown(data['created_by']!, _createdByMeta),
      );
    } else if (isInserting) {
      context.missing(_createdByMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Transaction map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Transaction(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      exchangeRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}exchange_rate'],
      )!,
      baseCurrencyAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_currency_amount'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isReconciled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_reconciled'],
      )!,
      recurringRuleId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_rule_id'],
      ),
      transferPairId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transfer_pair_id'],
      ),
      createdBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}created_by'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}deleted_at'],
      ),
    );
  }

  @override
  $TransactionsTable createAlias(String alias) {
    return $TransactionsTable(attachedDatabase, alias);
  }
}

class Transaction extends DataClass implements Insertable<Transaction> {
  final String id;
  final String budgetId;
  final String accountId;
  final String? envelopeId;
  final String type;
  final int amount;
  final String currency;
  final double exchangeRate;
  final int baseCurrencyAmount;
  final String? payee;
  final String? notes;
  final DateTime date;
  final bool isReconciled;
  final String? recurringRuleId;
  final String? transferPairId;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;
  const Transaction({
    required this.id,
    required this.budgetId,
    required this.accountId,
    this.envelopeId,
    required this.type,
    required this.amount,
    required this.currency,
    required this.exchangeRate,
    required this.baseCurrencyAmount,
    this.payee,
    this.notes,
    required this.date,
    required this.isReconciled,
    this.recurringRuleId,
    this.transferPairId,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || envelopeId != null) {
      map['envelope_id'] = Variable<String>(envelopeId);
    }
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['currency'] = Variable<String>(currency);
    map['exchange_rate'] = Variable<double>(exchangeRate);
    map['base_currency_amount'] = Variable<int>(baseCurrencyAmount);
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_reconciled'] = Variable<bool>(isReconciled);
    if (!nullToAbsent || recurringRuleId != null) {
      map['recurring_rule_id'] = Variable<String>(recurringRuleId);
    }
    if (!nullToAbsent || transferPairId != null) {
      map['transfer_pair_id'] = Variable<String>(transferPairId);
    }
    map['created_by'] = Variable<String>(createdBy);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<DateTime>(deletedAt);
    }
    return map;
  }

  TransactionsCompanion toCompanion(bool nullToAbsent) {
    return TransactionsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      accountId: Value(accountId),
      envelopeId: envelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(envelopeId),
      type: Value(type),
      amount: Value(amount),
      currency: Value(currency),
      exchangeRate: Value(exchangeRate),
      baseCurrencyAmount: Value(baseCurrencyAmount),
      payee: payee == null && nullToAbsent
          ? const Value.absent()
          : Value(payee),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      date: Value(date),
      isReconciled: Value(isReconciled),
      recurringRuleId: recurringRuleId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringRuleId),
      transferPairId: transferPairId == null && nullToAbsent
          ? const Value.absent()
          : Value(transferPairId),
      createdBy: Value(createdBy),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
    );
  }

  factory Transaction.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Transaction(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      envelopeId: serializer.fromJson<String?>(json['envelopeId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      exchangeRate: serializer.fromJson<double>(json['exchangeRate']),
      baseCurrencyAmount: serializer.fromJson<int>(json['baseCurrencyAmount']),
      payee: serializer.fromJson<String?>(json['payee']),
      notes: serializer.fromJson<String?>(json['notes']),
      date: serializer.fromJson<DateTime>(json['date']),
      isReconciled: serializer.fromJson<bool>(json['isReconciled']),
      recurringRuleId: serializer.fromJson<String?>(json['recurringRuleId']),
      transferPairId: serializer.fromJson<String?>(json['transferPairId']),
      createdBy: serializer.fromJson<String>(json['createdBy']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
      deletedAt: serializer.fromJson<DateTime?>(json['deletedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'accountId': serializer.toJson<String>(accountId),
      'envelopeId': serializer.toJson<String?>(envelopeId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'currency': serializer.toJson<String>(currency),
      'exchangeRate': serializer.toJson<double>(exchangeRate),
      'baseCurrencyAmount': serializer.toJson<int>(baseCurrencyAmount),
      'payee': serializer.toJson<String?>(payee),
      'notes': serializer.toJson<String?>(notes),
      'date': serializer.toJson<DateTime>(date),
      'isReconciled': serializer.toJson<bool>(isReconciled),
      'recurringRuleId': serializer.toJson<String?>(recurringRuleId),
      'transferPairId': serializer.toJson<String?>(transferPairId),
      'createdBy': serializer.toJson<String>(createdBy),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
      'deletedAt': serializer.toJson<DateTime?>(deletedAt),
    };
  }

  Transaction copyWith({
    String? id,
    String? budgetId,
    String? accountId,
    Value<String?> envelopeId = const Value.absent(),
    String? type,
    int? amount,
    String? currency,
    double? exchangeRate,
    int? baseCurrencyAmount,
    Value<String?> payee = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    DateTime? date,
    bool? isReconciled,
    Value<String?> recurringRuleId = const Value.absent(),
    Value<String?> transferPairId = const Value.absent(),
    String? createdBy,
    DateTime? createdAt,
    DateTime? updatedAt,
    Value<DateTime?> deletedAt = const Value.absent(),
  }) => Transaction(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    accountId: accountId ?? this.accountId,
    envelopeId: envelopeId.present ? envelopeId.value : this.envelopeId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    exchangeRate: exchangeRate ?? this.exchangeRate,
    baseCurrencyAmount: baseCurrencyAmount ?? this.baseCurrencyAmount,
    payee: payee.present ? payee.value : this.payee,
    notes: notes.present ? notes.value : this.notes,
    date: date ?? this.date,
    isReconciled: isReconciled ?? this.isReconciled,
    recurringRuleId: recurringRuleId.present
        ? recurringRuleId.value
        : this.recurringRuleId,
    transferPairId: transferPairId.present
        ? transferPairId.value
        : this.transferPairId,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
  );
  Transaction copyWithCompanion(TransactionsCompanion data) {
    return Transaction(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      exchangeRate: data.exchangeRate.present
          ? data.exchangeRate.value
          : this.exchangeRate,
      baseCurrencyAmount: data.baseCurrencyAmount.present
          ? data.baseCurrencyAmount.value
          : this.baseCurrencyAmount,
      payee: data.payee.present ? data.payee.value : this.payee,
      notes: data.notes.present ? data.notes.value : this.notes,
      date: data.date.present ? data.date.value : this.date,
      isReconciled: data.isReconciled.present
          ? data.isReconciled.value
          : this.isReconciled,
      recurringRuleId: data.recurringRuleId.present
          ? data.recurringRuleId.value
          : this.recurringRuleId,
      transferPairId: data.transferPairId.present
          ? data.transferPairId.value
          : this.transferPairId,
      createdBy: data.createdBy.present ? data.createdBy.value : this.createdBy,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Transaction(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('baseCurrencyAmount: $baseCurrencyAmount, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('isReconciled: $isReconciled, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('transferPairId: $transferPairId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    accountId,
    envelopeId,
    type,
    amount,
    currency,
    exchangeRate,
    baseCurrencyAmount,
    payee,
    notes,
    date,
    isReconciled,
    recurringRuleId,
    transferPairId,
    createdBy,
    createdAt,
    updatedAt,
    deletedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Transaction &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.accountId == this.accountId &&
          other.envelopeId == this.envelopeId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.exchangeRate == this.exchangeRate &&
          other.baseCurrencyAmount == this.baseCurrencyAmount &&
          other.payee == this.payee &&
          other.notes == this.notes &&
          other.date == this.date &&
          other.isReconciled == this.isReconciled &&
          other.recurringRuleId == this.recurringRuleId &&
          other.transferPairId == this.transferPairId &&
          other.createdBy == this.createdBy &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt);
}

class TransactionsCompanion extends UpdateCompanion<Transaction> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> accountId;
  final Value<String?> envelopeId;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> currency;
  final Value<double> exchangeRate;
  final Value<int> baseCurrencyAmount;
  final Value<String?> payee;
  final Value<String?> notes;
  final Value<DateTime> date;
  final Value<bool> isReconciled;
  final Value<String?> recurringRuleId;
  final Value<String?> transferPairId;
  final Value<String> createdBy;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<DateTime?> deletedAt;
  final Value<int> rowid;
  const TransactionsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.exchangeRate = const Value.absent(),
    this.baseCurrencyAmount = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.date = const Value.absent(),
    this.isReconciled = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.transferPairId = const Value.absent(),
    this.createdBy = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionsCompanion.insert({
    required String id,
    required String budgetId,
    required String accountId,
    this.envelopeId = const Value.absent(),
    required String type,
    required int amount,
    required String currency,
    this.exchangeRate = const Value.absent(),
    this.baseCurrencyAmount = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    required DateTime date,
    this.isReconciled = const Value.absent(),
    this.recurringRuleId = const Value.absent(),
    this.transferPairId = const Value.absent(),
    required String createdBy,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.deletedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       accountId = Value(accountId),
       type = Value(type),
       amount = Value(amount),
       currency = Value(currency),
       date = Value(date),
       createdBy = Value(createdBy),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Transaction> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? accountId,
    Expression<String>? envelopeId,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<double>? exchangeRate,
    Expression<int>? baseCurrencyAmount,
    Expression<String>? payee,
    Expression<String>? notes,
    Expression<DateTime>? date,
    Expression<bool>? isReconciled,
    Expression<String>? recurringRuleId,
    Expression<String>? transferPairId,
    Expression<String>? createdBy,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<DateTime>? deletedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (accountId != null) 'account_id': accountId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (exchangeRate != null) 'exchange_rate': exchangeRate,
      if (baseCurrencyAmount != null)
        'base_currency_amount': baseCurrencyAmount,
      if (payee != null) 'payee': payee,
      if (notes != null) 'notes': notes,
      if (date != null) 'date': date,
      if (isReconciled != null) 'is_reconciled': isReconciled,
      if (recurringRuleId != null) 'recurring_rule_id': recurringRuleId,
      if (transferPairId != null) 'transfer_pair_id': transferPairId,
      if (createdBy != null) 'created_by': createdBy,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? accountId,
    Value<String?>? envelopeId,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? currency,
    Value<double>? exchangeRate,
    Value<int>? baseCurrencyAmount,
    Value<String?>? payee,
    Value<String?>? notes,
    Value<DateTime>? date,
    Value<bool>? isReconciled,
    Value<String?>? recurringRuleId,
    Value<String?>? transferPairId,
    Value<String>? createdBy,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<DateTime?>? deletedAt,
    Value<int>? rowid,
  }) {
    return TransactionsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      accountId: accountId ?? this.accountId,
      envelopeId: envelopeId ?? this.envelopeId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      exchangeRate: exchangeRate ?? this.exchangeRate,
      baseCurrencyAmount: baseCurrencyAmount ?? this.baseCurrencyAmount,
      payee: payee ?? this.payee,
      notes: notes ?? this.notes,
      date: date ?? this.date,
      isReconciled: isReconciled ?? this.isReconciled,
      recurringRuleId: recurringRuleId ?? this.recurringRuleId,
      transferPairId: transferPairId ?? this.transferPairId,
      createdBy: createdBy ?? this.createdBy,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (exchangeRate.present) {
      map['exchange_rate'] = Variable<double>(exchangeRate.value);
    }
    if (baseCurrencyAmount.present) {
      map['base_currency_amount'] = Variable<int>(baseCurrencyAmount.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isReconciled.present) {
      map['is_reconciled'] = Variable<bool>(isReconciled.value);
    }
    if (recurringRuleId.present) {
      map['recurring_rule_id'] = Variable<String>(recurringRuleId.value);
    }
    if (transferPairId.present) {
      map['transfer_pair_id'] = Variable<String>(transferPairId.value);
    }
    if (createdBy.present) {
      map['created_by'] = Variable<String>(createdBy.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<DateTime>(deletedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('exchangeRate: $exchangeRate, ')
          ..write('baseCurrencyAmount: $baseCurrencyAmount, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('date: $date, ')
          ..write('isReconciled: $isReconciled, ')
          ..write('recurringRuleId: $recurringRuleId, ')
          ..write('transferPairId: $transferPairId, ')
          ..write('createdBy: $createdBy, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionSplitsTable extends TransactionSplits
    with TableInfo<$TransactionSplitsTable, TransactionSplit> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionSplitsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<double> amount = GeneratedColumn<double>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, transactionId, envelopeId, amount];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_splits';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionSplit> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TransactionSplit map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionSplit(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount'],
      )!,
    );
  }

  @override
  $TransactionSplitsTable createAlias(String alias) {
    return $TransactionSplitsTable(attachedDatabase, alias);
  }
}

class TransactionSplit extends DataClass
    implements Insertable<TransactionSplit> {
  final String id;
  final String transactionId;
  final String envelopeId;
  final double amount;
  const TransactionSplit({
    required this.id,
    required this.transactionId,
    required this.envelopeId,
    required this.amount,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['transaction_id'] = Variable<String>(transactionId);
    map['envelope_id'] = Variable<String>(envelopeId);
    map['amount'] = Variable<double>(amount);
    return map;
  }

  TransactionSplitsCompanion toCompanion(bool nullToAbsent) {
    return TransactionSplitsCompanion(
      id: Value(id),
      transactionId: Value(transactionId),
      envelopeId: Value(envelopeId),
      amount: Value(amount),
    );
  }

  factory TransactionSplit.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionSplit(
      id: serializer.fromJson<String>(json['id']),
      transactionId: serializer.fromJson<String>(json['transactionId']),
      envelopeId: serializer.fromJson<String>(json['envelopeId']),
      amount: serializer.fromJson<double>(json['amount']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'transactionId': serializer.toJson<String>(transactionId),
      'envelopeId': serializer.toJson<String>(envelopeId),
      'amount': serializer.toJson<double>(amount),
    };
  }

  TransactionSplit copyWith({
    String? id,
    String? transactionId,
    String? envelopeId,
    double? amount,
  }) => TransactionSplit(
    id: id ?? this.id,
    transactionId: transactionId ?? this.transactionId,
    envelopeId: envelopeId ?? this.envelopeId,
    amount: amount ?? this.amount,
  );
  TransactionSplit copyWithCompanion(TransactionSplitsCompanion data) {
    return TransactionSplit(
      id: data.id.present ? data.id.value : this.id,
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      amount: data.amount.present ? data.amount.value : this.amount,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSplit(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('amount: $amount')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, transactionId, envelopeId, amount);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionSplit &&
          other.id == this.id &&
          other.transactionId == this.transactionId &&
          other.envelopeId == this.envelopeId &&
          other.amount == this.amount);
}

class TransactionSplitsCompanion extends UpdateCompanion<TransactionSplit> {
  final Value<String> id;
  final Value<String> transactionId;
  final Value<String> envelopeId;
  final Value<double> amount;
  final Value<int> rowid;
  const TransactionSplitsCompanion({
    this.id = const Value.absent(),
    this.transactionId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.amount = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionSplitsCompanion.insert({
    required String id,
    required String transactionId,
    required String envelopeId,
    required double amount,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       transactionId = Value(transactionId),
       envelopeId = Value(envelopeId),
       amount = Value(amount);
  static Insertable<TransactionSplit> custom({
    Expression<String>? id,
    Expression<String>? transactionId,
    Expression<String>? envelopeId,
    Expression<double>? amount,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (transactionId != null) 'transaction_id': transactionId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (amount != null) 'amount': amount,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionSplitsCompanion copyWith({
    Value<String>? id,
    Value<String>? transactionId,
    Value<String>? envelopeId,
    Value<double>? amount,
    Value<int>? rowid,
  }) {
    return TransactionSplitsCompanion(
      id: id ?? this.id,
      transactionId: transactionId ?? this.transactionId,
      envelopeId: envelopeId ?? this.envelopeId,
      amount: amount ?? this.amount,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (amount.present) {
      map['amount'] = Variable<double>(amount.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionSplitsCompanion(')
          ..write('id: $id, ')
          ..write('transactionId: $transactionId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('amount: $amount, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TagsTable extends Tags with TableInfo<$TagsTable, Tag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, name];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<Tag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Tag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Tag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
    );
  }

  @override
  $TagsTable createAlias(String alias) {
    return $TagsTable(attachedDatabase, alias);
  }
}

class Tag extends DataClass implements Insertable<Tag> {
  final String id;
  final String budgetId;
  final String name;
  const Tag({required this.id, required this.budgetId, required this.name});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    return map;
  }

  TagsCompanion toCompanion(bool nullToAbsent) {
    return TagsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
    );
  }

  factory Tag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Tag(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
    };
  }

  Tag copyWith({String? id, String? budgetId, String? name}) => Tag(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
  );
  Tag copyWithCompanion(TagsCompanion data) {
    return Tag(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Tag(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, name);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Tag &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name);
}

class TagsCompanion extends UpdateCompanion<Tag> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<int> rowid;
  const TagsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TagsCompanion.insert({
    required String id,
    required String budgetId,
    required String name,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       name = Value(name);
  static Insertable<Tag> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TagsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? name,
    Value<int>? rowid,
  }) {
    return TagsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TagsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TransactionTagsTable extends TransactionTags
    with TableInfo<$TransactionTagsTable, TransactionTag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TransactionTagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _transactionIdMeta = const VerificationMeta(
    'transactionId',
  );
  @override
  late final GeneratedColumn<String> transactionId = GeneratedColumn<String>(
    'transaction_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tagIdMeta = const VerificationMeta('tagId');
  @override
  late final GeneratedColumn<String> tagId = GeneratedColumn<String>(
    'tag_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [transactionId, tagId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'transaction_tags';
  @override
  VerificationContext validateIntegrity(
    Insertable<TransactionTag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('transaction_id')) {
      context.handle(
        _transactionIdMeta,
        transactionId.isAcceptableOrUnknown(
          data['transaction_id']!,
          _transactionIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_transactionIdMeta);
    }
    if (data.containsKey('tag_id')) {
      context.handle(
        _tagIdMeta,
        tagId.isAcceptableOrUnknown(data['tag_id']!, _tagIdMeta),
      );
    } else if (isInserting) {
      context.missing(_tagIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {transactionId, tagId};
  @override
  TransactionTag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TransactionTag(
      transactionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}transaction_id'],
      )!,
      tagId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tag_id'],
      )!,
    );
  }

  @override
  $TransactionTagsTable createAlias(String alias) {
    return $TransactionTagsTable(attachedDatabase, alias);
  }
}

class TransactionTag extends DataClass implements Insertable<TransactionTag> {
  final String transactionId;
  final String tagId;
  const TransactionTag({required this.transactionId, required this.tagId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['transaction_id'] = Variable<String>(transactionId);
    map['tag_id'] = Variable<String>(tagId);
    return map;
  }

  TransactionTagsCompanion toCompanion(bool nullToAbsent) {
    return TransactionTagsCompanion(
      transactionId: Value(transactionId),
      tagId: Value(tagId),
    );
  }

  factory TransactionTag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TransactionTag(
      transactionId: serializer.fromJson<String>(json['transactionId']),
      tagId: serializer.fromJson<String>(json['tagId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'transactionId': serializer.toJson<String>(transactionId),
      'tagId': serializer.toJson<String>(tagId),
    };
  }

  TransactionTag copyWith({String? transactionId, String? tagId}) =>
      TransactionTag(
        transactionId: transactionId ?? this.transactionId,
        tagId: tagId ?? this.tagId,
      );
  TransactionTag copyWithCompanion(TransactionTagsCompanion data) {
    return TransactionTag(
      transactionId: data.transactionId.present
          ? data.transactionId.value
          : this.transactionId,
      tagId: data.tagId.present ? data.tagId.value : this.tagId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTag(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(transactionId, tagId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TransactionTag &&
          other.transactionId == this.transactionId &&
          other.tagId == this.tagId);
}

class TransactionTagsCompanion extends UpdateCompanion<TransactionTag> {
  final Value<String> transactionId;
  final Value<String> tagId;
  final Value<int> rowid;
  const TransactionTagsCompanion({
    this.transactionId = const Value.absent(),
    this.tagId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TransactionTagsCompanion.insert({
    required String transactionId,
    required String tagId,
    this.rowid = const Value.absent(),
  }) : transactionId = Value(transactionId),
       tagId = Value(tagId);
  static Insertable<TransactionTag> custom({
    Expression<String>? transactionId,
    Expression<String>? tagId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (transactionId != null) 'transaction_id': transactionId,
      if (tagId != null) 'tag_id': tagId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TransactionTagsCompanion copyWith({
    Value<String>? transactionId,
    Value<String>? tagId,
    Value<int>? rowid,
  }) {
    return TransactionTagsCompanion(
      transactionId: transactionId ?? this.transactionId,
      tagId: tagId ?? this.tagId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (transactionId.present) {
      map['transaction_id'] = Variable<String>(transactionId.value);
    }
    if (tagId.present) {
      map['tag_id'] = Variable<String>(tagId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TransactionTagsCompanion(')
          ..write('transactionId: $transactionId, ')
          ..write('tagId: $tagId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecurringRulesTable extends RecurringRules
    with TableInfo<$RecurringRulesTable, RecurringRule> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecurringRulesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountMeta = const VerificationMeta('amount');
  @override
  late final GeneratedColumn<int> amount = GeneratedColumn<int>(
    'amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyMeta = const VerificationMeta(
    'currency',
  );
  @override
  late final GeneratedColumn<String> currency = GeneratedColumn<String>(
    'currency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payeeMeta = const VerificationMeta('payee');
  @override
  late final GeneratedColumn<String> payee = GeneratedColumn<String>(
    'payee',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customIntervalMeta = const VerificationMeta(
    'customInterval',
  );
  @override
  late final GeneratedColumn<int> customInterval = GeneratedColumn<int>(
    'custom_interval',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _customUnitMeta = const VerificationMeta(
    'customUnit',
  );
  @override
  late final GeneratedColumn<String> customUnit = GeneratedColumn<String>(
    'custom_unit',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startDateMeta = const VerificationMeta(
    'startDate',
  );
  @override
  late final GeneratedColumn<DateTime> startDate = GeneratedColumn<DateTime>(
    'start_date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endDateMeta = const VerificationMeta(
    'endDate',
  );
  @override
  late final GeneratedColumn<DateTime> endDate = GeneratedColumn<DateTime>(
    'end_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nextOccurrenceMeta = const VerificationMeta(
    'nextOccurrence',
  );
  @override
  late final GeneratedColumn<DateTime> nextOccurrence =
      GeneratedColumn<DateTime>(
        'next_occurrence',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _autoPostMeta = const VerificationMeta(
    'autoPost',
  );
  @override
  late final GeneratedColumn<bool> autoPost = GeneratedColumn<bool>(
    'auto_post',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("auto_post" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isPausedMeta = const VerificationMeta(
    'isPaused',
  );
  @override
  late final GeneratedColumn<bool> isPaused = GeneratedColumn<bool>(
    'is_paused',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paused" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    accountId,
    envelopeId,
    type,
    amount,
    currency,
    payee,
    notes,
    frequency,
    customInterval,
    customUnit,
    startDate,
    endDate,
    nextOccurrence,
    autoPost,
    isPaused,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recurring_rules';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecurringRule> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('amount')) {
      context.handle(
        _amountMeta,
        amount.isAcceptableOrUnknown(data['amount']!, _amountMeta),
      );
    } else if (isInserting) {
      context.missing(_amountMeta);
    }
    if (data.containsKey('currency')) {
      context.handle(
        _currencyMeta,
        currency.isAcceptableOrUnknown(data['currency']!, _currencyMeta),
      );
    } else if (isInserting) {
      context.missing(_currencyMeta);
    }
    if (data.containsKey('payee')) {
      context.handle(
        _payeeMeta,
        payee.isAcceptableOrUnknown(data['payee']!, _payeeMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('custom_interval')) {
      context.handle(
        _customIntervalMeta,
        customInterval.isAcceptableOrUnknown(
          data['custom_interval']!,
          _customIntervalMeta,
        ),
      );
    }
    if (data.containsKey('custom_unit')) {
      context.handle(
        _customUnitMeta,
        customUnit.isAcceptableOrUnknown(data['custom_unit']!, _customUnitMeta),
      );
    }
    if (data.containsKey('start_date')) {
      context.handle(
        _startDateMeta,
        startDate.isAcceptableOrUnknown(data['start_date']!, _startDateMeta),
      );
    } else if (isInserting) {
      context.missing(_startDateMeta);
    }
    if (data.containsKey('end_date')) {
      context.handle(
        _endDateMeta,
        endDate.isAcceptableOrUnknown(data['end_date']!, _endDateMeta),
      );
    }
    if (data.containsKey('next_occurrence')) {
      context.handle(
        _nextOccurrenceMeta,
        nextOccurrence.isAcceptableOrUnknown(
          data['next_occurrence']!,
          _nextOccurrenceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_nextOccurrenceMeta);
    }
    if (data.containsKey('auto_post')) {
      context.handle(
        _autoPostMeta,
        autoPost.isAcceptableOrUnknown(data['auto_post']!, _autoPostMeta),
      );
    }
    if (data.containsKey('is_paused')) {
      context.handle(
        _isPausedMeta,
        isPaused.isAcceptableOrUnknown(data['is_paused']!, _isPausedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecurringRule map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecurringRule(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      amount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount'],
      )!,
      currency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency'],
      )!,
      payee: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payee'],
      ),
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      customInterval: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}custom_interval'],
      ),
      customUnit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_unit'],
      ),
      startDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_date'],
      )!,
      endDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_date'],
      ),
      nextOccurrence: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}next_occurrence'],
      )!,
      autoPost: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}auto_post'],
      )!,
      isPaused: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_paused'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $RecurringRulesTable createAlias(String alias) {
    return $RecurringRulesTable(attachedDatabase, alias);
  }
}

class RecurringRule extends DataClass implements Insertable<RecurringRule> {
  final String id;
  final String budgetId;
  final String accountId;
  final String? envelopeId;
  final String type;
  final int amount;
  final String currency;
  final String? payee;
  final String? notes;
  final String frequency;
  final int? customInterval;
  final String? customUnit;
  final DateTime startDate;
  final DateTime? endDate;
  final DateTime nextOccurrence;
  final bool autoPost;
  final bool isPaused;
  final DateTime createdAt;
  const RecurringRule({
    required this.id,
    required this.budgetId,
    required this.accountId,
    this.envelopeId,
    required this.type,
    required this.amount,
    required this.currency,
    this.payee,
    this.notes,
    required this.frequency,
    this.customInterval,
    this.customUnit,
    required this.startDate,
    this.endDate,
    required this.nextOccurrence,
    required this.autoPost,
    required this.isPaused,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['account_id'] = Variable<String>(accountId);
    if (!nullToAbsent || envelopeId != null) {
      map['envelope_id'] = Variable<String>(envelopeId);
    }
    map['type'] = Variable<String>(type);
    map['amount'] = Variable<int>(amount);
    map['currency'] = Variable<String>(currency);
    if (!nullToAbsent || payee != null) {
      map['payee'] = Variable<String>(payee);
    }
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || customInterval != null) {
      map['custom_interval'] = Variable<int>(customInterval);
    }
    if (!nullToAbsent || customUnit != null) {
      map['custom_unit'] = Variable<String>(customUnit);
    }
    map['start_date'] = Variable<DateTime>(startDate);
    if (!nullToAbsent || endDate != null) {
      map['end_date'] = Variable<DateTime>(endDate);
    }
    map['next_occurrence'] = Variable<DateTime>(nextOccurrence);
    map['auto_post'] = Variable<bool>(autoPost);
    map['is_paused'] = Variable<bool>(isPaused);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  RecurringRulesCompanion toCompanion(bool nullToAbsent) {
    return RecurringRulesCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      accountId: Value(accountId),
      envelopeId: envelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(envelopeId),
      type: Value(type),
      amount: Value(amount),
      currency: Value(currency),
      payee: payee == null && nullToAbsent
          ? const Value.absent()
          : Value(payee),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
      frequency: Value(frequency),
      customInterval: customInterval == null && nullToAbsent
          ? const Value.absent()
          : Value(customInterval),
      customUnit: customUnit == null && nullToAbsent
          ? const Value.absent()
          : Value(customUnit),
      startDate: Value(startDate),
      endDate: endDate == null && nullToAbsent
          ? const Value.absent()
          : Value(endDate),
      nextOccurrence: Value(nextOccurrence),
      autoPost: Value(autoPost),
      isPaused: Value(isPaused),
      createdAt: Value(createdAt),
    );
  }

  factory RecurringRule.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecurringRule(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      accountId: serializer.fromJson<String>(json['accountId']),
      envelopeId: serializer.fromJson<String?>(json['envelopeId']),
      type: serializer.fromJson<String>(json['type']),
      amount: serializer.fromJson<int>(json['amount']),
      currency: serializer.fromJson<String>(json['currency']),
      payee: serializer.fromJson<String?>(json['payee']),
      notes: serializer.fromJson<String?>(json['notes']),
      frequency: serializer.fromJson<String>(json['frequency']),
      customInterval: serializer.fromJson<int?>(json['customInterval']),
      customUnit: serializer.fromJson<String?>(json['customUnit']),
      startDate: serializer.fromJson<DateTime>(json['startDate']),
      endDate: serializer.fromJson<DateTime?>(json['endDate']),
      nextOccurrence: serializer.fromJson<DateTime>(json['nextOccurrence']),
      autoPost: serializer.fromJson<bool>(json['autoPost']),
      isPaused: serializer.fromJson<bool>(json['isPaused']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'accountId': serializer.toJson<String>(accountId),
      'envelopeId': serializer.toJson<String?>(envelopeId),
      'type': serializer.toJson<String>(type),
      'amount': serializer.toJson<int>(amount),
      'currency': serializer.toJson<String>(currency),
      'payee': serializer.toJson<String?>(payee),
      'notes': serializer.toJson<String?>(notes),
      'frequency': serializer.toJson<String>(frequency),
      'customInterval': serializer.toJson<int?>(customInterval),
      'customUnit': serializer.toJson<String?>(customUnit),
      'startDate': serializer.toJson<DateTime>(startDate),
      'endDate': serializer.toJson<DateTime?>(endDate),
      'nextOccurrence': serializer.toJson<DateTime>(nextOccurrence),
      'autoPost': serializer.toJson<bool>(autoPost),
      'isPaused': serializer.toJson<bool>(isPaused),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  RecurringRule copyWith({
    String? id,
    String? budgetId,
    String? accountId,
    Value<String?> envelopeId = const Value.absent(),
    String? type,
    int? amount,
    String? currency,
    Value<String?> payee = const Value.absent(),
    Value<String?> notes = const Value.absent(),
    String? frequency,
    Value<int?> customInterval = const Value.absent(),
    Value<String?> customUnit = const Value.absent(),
    DateTime? startDate,
    Value<DateTime?> endDate = const Value.absent(),
    DateTime? nextOccurrence,
    bool? autoPost,
    bool? isPaused,
    DateTime? createdAt,
  }) => RecurringRule(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    accountId: accountId ?? this.accountId,
    envelopeId: envelopeId.present ? envelopeId.value : this.envelopeId,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    currency: currency ?? this.currency,
    payee: payee.present ? payee.value : this.payee,
    notes: notes.present ? notes.value : this.notes,
    frequency: frequency ?? this.frequency,
    customInterval: customInterval.present
        ? customInterval.value
        : this.customInterval,
    customUnit: customUnit.present ? customUnit.value : this.customUnit,
    startDate: startDate ?? this.startDate,
    endDate: endDate.present ? endDate.value : this.endDate,
    nextOccurrence: nextOccurrence ?? this.nextOccurrence,
    autoPost: autoPost ?? this.autoPost,
    isPaused: isPaused ?? this.isPaused,
    createdAt: createdAt ?? this.createdAt,
  );
  RecurringRule copyWithCompanion(RecurringRulesCompanion data) {
    return RecurringRule(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      type: data.type.present ? data.type.value : this.type,
      amount: data.amount.present ? data.amount.value : this.amount,
      currency: data.currency.present ? data.currency.value : this.currency,
      payee: data.payee.present ? data.payee.value : this.payee,
      notes: data.notes.present ? data.notes.value : this.notes,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      customInterval: data.customInterval.present
          ? data.customInterval.value
          : this.customInterval,
      customUnit: data.customUnit.present
          ? data.customUnit.value
          : this.customUnit,
      startDate: data.startDate.present ? data.startDate.value : this.startDate,
      endDate: data.endDate.present ? data.endDate.value : this.endDate,
      nextOccurrence: data.nextOccurrence.present
          ? data.nextOccurrence.value
          : this.nextOccurrence,
      autoPost: data.autoPost.present ? data.autoPost.value : this.autoPost,
      isPaused: data.isPaused.present ? data.isPaused.value : this.isPaused,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRule(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('frequency: $frequency, ')
          ..write('customInterval: $customInterval, ')
          ..write('customUnit: $customUnit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('nextOccurrence: $nextOccurrence, ')
          ..write('autoPost: $autoPost, ')
          ..write('isPaused: $isPaused, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    accountId,
    envelopeId,
    type,
    amount,
    currency,
    payee,
    notes,
    frequency,
    customInterval,
    customUnit,
    startDate,
    endDate,
    nextOccurrence,
    autoPost,
    isPaused,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecurringRule &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.accountId == this.accountId &&
          other.envelopeId == this.envelopeId &&
          other.type == this.type &&
          other.amount == this.amount &&
          other.currency == this.currency &&
          other.payee == this.payee &&
          other.notes == this.notes &&
          other.frequency == this.frequency &&
          other.customInterval == this.customInterval &&
          other.customUnit == this.customUnit &&
          other.startDate == this.startDate &&
          other.endDate == this.endDate &&
          other.nextOccurrence == this.nextOccurrence &&
          other.autoPost == this.autoPost &&
          other.isPaused == this.isPaused &&
          other.createdAt == this.createdAt);
}

class RecurringRulesCompanion extends UpdateCompanion<RecurringRule> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> accountId;
  final Value<String?> envelopeId;
  final Value<String> type;
  final Value<int> amount;
  final Value<String> currency;
  final Value<String?> payee;
  final Value<String?> notes;
  final Value<String> frequency;
  final Value<int?> customInterval;
  final Value<String?> customUnit;
  final Value<DateTime> startDate;
  final Value<DateTime?> endDate;
  final Value<DateTime> nextOccurrence;
  final Value<bool> autoPost;
  final Value<bool> isPaused;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const RecurringRulesCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.type = const Value.absent(),
    this.amount = const Value.absent(),
    this.currency = const Value.absent(),
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    this.frequency = const Value.absent(),
    this.customInterval = const Value.absent(),
    this.customUnit = const Value.absent(),
    this.startDate = const Value.absent(),
    this.endDate = const Value.absent(),
    this.nextOccurrence = const Value.absent(),
    this.autoPost = const Value.absent(),
    this.isPaused = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecurringRulesCompanion.insert({
    required String id,
    required String budgetId,
    required String accountId,
    this.envelopeId = const Value.absent(),
    required String type,
    required int amount,
    required String currency,
    this.payee = const Value.absent(),
    this.notes = const Value.absent(),
    required String frequency,
    this.customInterval = const Value.absent(),
    this.customUnit = const Value.absent(),
    required DateTime startDate,
    this.endDate = const Value.absent(),
    required DateTime nextOccurrence,
    this.autoPost = const Value.absent(),
    this.isPaused = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       accountId = Value(accountId),
       type = Value(type),
       amount = Value(amount),
       currency = Value(currency),
       frequency = Value(frequency),
       startDate = Value(startDate),
       nextOccurrence = Value(nextOccurrence),
       createdAt = Value(createdAt);
  static Insertable<RecurringRule> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? accountId,
    Expression<String>? envelopeId,
    Expression<String>? type,
    Expression<int>? amount,
    Expression<String>? currency,
    Expression<String>? payee,
    Expression<String>? notes,
    Expression<String>? frequency,
    Expression<int>? customInterval,
    Expression<String>? customUnit,
    Expression<DateTime>? startDate,
    Expression<DateTime>? endDate,
    Expression<DateTime>? nextOccurrence,
    Expression<bool>? autoPost,
    Expression<bool>? isPaused,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (accountId != null) 'account_id': accountId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (type != null) 'type': type,
      if (amount != null) 'amount': amount,
      if (currency != null) 'currency': currency,
      if (payee != null) 'payee': payee,
      if (notes != null) 'notes': notes,
      if (frequency != null) 'frequency': frequency,
      if (customInterval != null) 'custom_interval': customInterval,
      if (customUnit != null) 'custom_unit': customUnit,
      if (startDate != null) 'start_date': startDate,
      if (endDate != null) 'end_date': endDate,
      if (nextOccurrence != null) 'next_occurrence': nextOccurrence,
      if (autoPost != null) 'auto_post': autoPost,
      if (isPaused != null) 'is_paused': isPaused,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecurringRulesCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? accountId,
    Value<String?>? envelopeId,
    Value<String>? type,
    Value<int>? amount,
    Value<String>? currency,
    Value<String?>? payee,
    Value<String?>? notes,
    Value<String>? frequency,
    Value<int?>? customInterval,
    Value<String?>? customUnit,
    Value<DateTime>? startDate,
    Value<DateTime?>? endDate,
    Value<DateTime>? nextOccurrence,
    Value<bool>? autoPost,
    Value<bool>? isPaused,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return RecurringRulesCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      accountId: accountId ?? this.accountId,
      envelopeId: envelopeId ?? this.envelopeId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      payee: payee ?? this.payee,
      notes: notes ?? this.notes,
      frequency: frequency ?? this.frequency,
      customInterval: customInterval ?? this.customInterval,
      customUnit: customUnit ?? this.customUnit,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      nextOccurrence: nextOccurrence ?? this.nextOccurrence,
      autoPost: autoPost ?? this.autoPost,
      isPaused: isPaused ?? this.isPaused,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (amount.present) {
      map['amount'] = Variable<int>(amount.value);
    }
    if (currency.present) {
      map['currency'] = Variable<String>(currency.value);
    }
    if (payee.present) {
      map['payee'] = Variable<String>(payee.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (customInterval.present) {
      map['custom_interval'] = Variable<int>(customInterval.value);
    }
    if (customUnit.present) {
      map['custom_unit'] = Variable<String>(customUnit.value);
    }
    if (startDate.present) {
      map['start_date'] = Variable<DateTime>(startDate.value);
    }
    if (endDate.present) {
      map['end_date'] = Variable<DateTime>(endDate.value);
    }
    if (nextOccurrence.present) {
      map['next_occurrence'] = Variable<DateTime>(nextOccurrence.value);
    }
    if (autoPost.present) {
      map['auto_post'] = Variable<bool>(autoPost.value);
    }
    if (isPaused.present) {
      map['is_paused'] = Variable<bool>(isPaused.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecurringRulesCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('accountId: $accountId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('type: $type, ')
          ..write('amount: $amount, ')
          ..write('currency: $currency, ')
          ..write('payee: $payee, ')
          ..write('notes: $notes, ')
          ..write('frequency: $frequency, ')
          ..write('customInterval: $customInterval, ')
          ..write('customUnit: $customUnit, ')
          ..write('startDate: $startDate, ')
          ..write('endDate: $endDate, ')
          ..write('nextOccurrence: $nextOccurrence, ')
          ..write('autoPost: $autoPost, ')
          ..write('isPaused: $isPaused, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BillRemindersTable extends BillReminders
    with TableInfo<$BillRemindersTable, BillReminder> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BillRemindersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _estimatedAmountMeta = const VerificationMeta(
    'estimatedAmount',
  );
  @override
  late final GeneratedColumn<int> estimatedAmount = GeneratedColumn<int>(
    'estimated_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueDayMeta = const VerificationMeta('dueDay');
  @override
  late final GeneratedColumn<int> dueDay = GeneratedColumn<int>(
    'due_day',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _frequencyMeta = const VerificationMeta(
    'frequency',
  );
  @override
  late final GeneratedColumn<String> frequency = GeneratedColumn<String>(
    'frequency',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reminderDaysBeforeMeta =
      const VerificationMeta('reminderDaysBefore');
  @override
  late final GeneratedColumn<int> reminderDaysBefore = GeneratedColumn<int>(
    'reminder_days_before',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    name,
    estimatedAmount,
    dueDay,
    frequency,
    envelopeId,
    reminderDaysBefore,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'bill_reminders';
  @override
  VerificationContext validateIntegrity(
    Insertable<BillReminder> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('estimated_amount')) {
      context.handle(
        _estimatedAmountMeta,
        estimatedAmount.isAcceptableOrUnknown(
          data['estimated_amount']!,
          _estimatedAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_estimatedAmountMeta);
    }
    if (data.containsKey('due_day')) {
      context.handle(
        _dueDayMeta,
        dueDay.isAcceptableOrUnknown(data['due_day']!, _dueDayMeta),
      );
    } else if (isInserting) {
      context.missing(_dueDayMeta);
    }
    if (data.containsKey('frequency')) {
      context.handle(
        _frequencyMeta,
        frequency.isAcceptableOrUnknown(data['frequency']!, _frequencyMeta),
      );
    } else if (isInserting) {
      context.missing(_frequencyMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    }
    if (data.containsKey('reminder_days_before')) {
      context.handle(
        _reminderDaysBeforeMeta,
        reminderDaysBefore.isAcceptableOrUnknown(
          data['reminder_days_before']!,
          _reminderDaysBeforeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BillReminder map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BillReminder(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      estimatedAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}estimated_amount'],
      )!,
      dueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due_day'],
      )!,
      frequency: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}frequency'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      ),
      reminderDaysBefore: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reminder_days_before'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BillRemindersTable createAlias(String alias) {
    return $BillRemindersTable(attachedDatabase, alias);
  }
}

class BillReminder extends DataClass implements Insertable<BillReminder> {
  final String id;
  final String budgetId;
  final String name;
  final int estimatedAmount;
  final int dueDay;
  final String frequency;
  final String? envelopeId;
  final int reminderDaysBefore;
  final DateTime createdAt;
  const BillReminder({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.estimatedAmount,
    required this.dueDay,
    required this.frequency,
    this.envelopeId,
    required this.reminderDaysBefore,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['estimated_amount'] = Variable<int>(estimatedAmount);
    map['due_day'] = Variable<int>(dueDay);
    map['frequency'] = Variable<String>(frequency);
    if (!nullToAbsent || envelopeId != null) {
      map['envelope_id'] = Variable<String>(envelopeId);
    }
    map['reminder_days_before'] = Variable<int>(reminderDaysBefore);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BillRemindersCompanion toCompanion(bool nullToAbsent) {
    return BillRemindersCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      estimatedAmount: Value(estimatedAmount),
      dueDay: Value(dueDay),
      frequency: Value(frequency),
      envelopeId: envelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(envelopeId),
      reminderDaysBefore: Value(reminderDaysBefore),
      createdAt: Value(createdAt),
    );
  }

  factory BillReminder.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BillReminder(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      estimatedAmount: serializer.fromJson<int>(json['estimatedAmount']),
      dueDay: serializer.fromJson<int>(json['dueDay']),
      frequency: serializer.fromJson<String>(json['frequency']),
      envelopeId: serializer.fromJson<String?>(json['envelopeId']),
      reminderDaysBefore: serializer.fromJson<int>(json['reminderDaysBefore']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'estimatedAmount': serializer.toJson<int>(estimatedAmount),
      'dueDay': serializer.toJson<int>(dueDay),
      'frequency': serializer.toJson<String>(frequency),
      'envelopeId': serializer.toJson<String?>(envelopeId),
      'reminderDaysBefore': serializer.toJson<int>(reminderDaysBefore),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BillReminder copyWith({
    String? id,
    String? budgetId,
    String? name,
    int? estimatedAmount,
    int? dueDay,
    String? frequency,
    Value<String?> envelopeId = const Value.absent(),
    int? reminderDaysBefore,
    DateTime? createdAt,
  }) => BillReminder(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    estimatedAmount: estimatedAmount ?? this.estimatedAmount,
    dueDay: dueDay ?? this.dueDay,
    frequency: frequency ?? this.frequency,
    envelopeId: envelopeId.present ? envelopeId.value : this.envelopeId,
    reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
    createdAt: createdAt ?? this.createdAt,
  );
  BillReminder copyWithCompanion(BillRemindersCompanion data) {
    return BillReminder(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      estimatedAmount: data.estimatedAmount.present
          ? data.estimatedAmount.value
          : this.estimatedAmount,
      dueDay: data.dueDay.present ? data.dueDay.value : this.dueDay,
      frequency: data.frequency.present ? data.frequency.value : this.frequency,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      reminderDaysBefore: data.reminderDaysBefore.present
          ? data.reminderDaysBefore.value
          : this.reminderDaysBefore,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BillReminder(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('estimatedAmount: $estimatedAmount, ')
          ..write('dueDay: $dueDay, ')
          ..write('frequency: $frequency, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    name,
    estimatedAmount,
    dueDay,
    frequency,
    envelopeId,
    reminderDaysBefore,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BillReminder &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.estimatedAmount == this.estimatedAmount &&
          other.dueDay == this.dueDay &&
          other.frequency == this.frequency &&
          other.envelopeId == this.envelopeId &&
          other.reminderDaysBefore == this.reminderDaysBefore &&
          other.createdAt == this.createdAt);
}

class BillRemindersCompanion extends UpdateCompanion<BillReminder> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<int> estimatedAmount;
  final Value<int> dueDay;
  final Value<String> frequency;
  final Value<String?> envelopeId;
  final Value<int> reminderDaysBefore;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BillRemindersCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.estimatedAmount = const Value.absent(),
    this.dueDay = const Value.absent(),
    this.frequency = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.reminderDaysBefore = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BillRemindersCompanion.insert({
    required String id,
    required String budgetId,
    required String name,
    required int estimatedAmount,
    required int dueDay,
    required String frequency,
    this.envelopeId = const Value.absent(),
    this.reminderDaysBefore = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       name = Value(name),
       estimatedAmount = Value(estimatedAmount),
       dueDay = Value(dueDay),
       frequency = Value(frequency),
       createdAt = Value(createdAt);
  static Insertable<BillReminder> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<int>? estimatedAmount,
    Expression<int>? dueDay,
    Expression<String>? frequency,
    Expression<String>? envelopeId,
    Expression<int>? reminderDaysBefore,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (estimatedAmount != null) 'estimated_amount': estimatedAmount,
      if (dueDay != null) 'due_day': dueDay,
      if (frequency != null) 'frequency': frequency,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (reminderDaysBefore != null)
        'reminder_days_before': reminderDaysBefore,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BillRemindersCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? name,
    Value<int>? estimatedAmount,
    Value<int>? dueDay,
    Value<String>? frequency,
    Value<String?>? envelopeId,
    Value<int>? reminderDaysBefore,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BillRemindersCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      estimatedAmount: estimatedAmount ?? this.estimatedAmount,
      dueDay: dueDay ?? this.dueDay,
      frequency: frequency ?? this.frequency,
      envelopeId: envelopeId ?? this.envelopeId,
      reminderDaysBefore: reminderDaysBefore ?? this.reminderDaysBefore,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (estimatedAmount.present) {
      map['estimated_amount'] = Variable<int>(estimatedAmount.value);
    }
    if (dueDay.present) {
      map['due_day'] = Variable<int>(dueDay.value);
    }
    if (frequency.present) {
      map['frequency'] = Variable<String>(frequency.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (reminderDaysBefore.present) {
      map['reminder_days_before'] = Variable<int>(reminderDaysBefore.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BillRemindersCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('estimatedAmount: $estimatedAmount, ')
          ..write('dueDay: $dueDay, ')
          ..write('frequency: $frequency, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('reminderDaysBefore: $reminderDaysBefore, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllocationTemplatesTable extends AllocationTemplates
    with TableInfo<$AllocationTemplatesTable, AllocationTemplate> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationTemplatesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, budgetId, name, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocation_templates';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllocationTemplate> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllocationTemplate map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllocationTemplate(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $AllocationTemplatesTable createAlias(String alias) {
    return $AllocationTemplatesTable(attachedDatabase, alias);
  }
}

class AllocationTemplate extends DataClass
    implements Insertable<AllocationTemplate> {
  final String id;
  final String budgetId;
  final String name;
  final DateTime createdAt;
  const AllocationTemplate({
    required this.id,
    required this.budgetId,
    required this.name,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['name'] = Variable<String>(name);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  AllocationTemplatesCompanion toCompanion(bool nullToAbsent) {
    return AllocationTemplatesCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      name: Value(name),
      createdAt: Value(createdAt),
    );
  }

  factory AllocationTemplate.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllocationTemplate(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      name: serializer.fromJson<String>(json['name']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'name': serializer.toJson<String>(name),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  AllocationTemplate copyWith({
    String? id,
    String? budgetId,
    String? name,
    DateTime? createdAt,
  }) => AllocationTemplate(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    name: name ?? this.name,
    createdAt: createdAt ?? this.createdAt,
  );
  AllocationTemplate copyWithCompanion(AllocationTemplatesCompanion data) {
    return AllocationTemplate(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      name: data.name.present ? data.name.value : this.name,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllocationTemplate(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, budgetId, name, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllocationTemplate &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.name == this.name &&
          other.createdAt == this.createdAt);
}

class AllocationTemplatesCompanion extends UpdateCompanion<AllocationTemplate> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> name;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const AllocationTemplatesCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.name = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllocationTemplatesCompanion.insert({
    required String id,
    required String budgetId,
    required String name,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<AllocationTemplate> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? name,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (name != null) 'name': name,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllocationTemplatesCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? name,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return AllocationTemplatesCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationTemplatesCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('name: $name, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AllocationTemplateItemsTable extends AllocationTemplateItems
    with TableInfo<$AllocationTemplateItemsTable, AllocationTemplateItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllocationTemplateItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _templateIdMeta = const VerificationMeta(
    'templateId',
  );
  @override
  late final GeneratedColumn<String> templateId = GeneratedColumn<String>(
    'template_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _percentageMeta = const VerificationMeta(
    'percentage',
  );
  @override
  late final GeneratedColumn<double> percentage = GeneratedColumn<double>(
    'percentage',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    templateId,
    envelopeId,
    percentage,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allocation_template_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<AllocationTemplateItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('template_id')) {
      context.handle(
        _templateIdMeta,
        templateId.isAcceptableOrUnknown(data['template_id']!, _templateIdMeta),
      );
    } else if (isInserting) {
      context.missing(_templateIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_envelopeIdMeta);
    }
    if (data.containsKey('percentage')) {
      context.handle(
        _percentageMeta,
        percentage.isAcceptableOrUnknown(data['percentage']!, _percentageMeta),
      );
    } else if (isInserting) {
      context.missing(_percentageMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AllocationTemplateItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AllocationTemplateItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      templateId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}template_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      )!,
      percentage: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}percentage'],
      )!,
    );
  }

  @override
  $AllocationTemplateItemsTable createAlias(String alias) {
    return $AllocationTemplateItemsTable(attachedDatabase, alias);
  }
}

class AllocationTemplateItem extends DataClass
    implements Insertable<AllocationTemplateItem> {
  final String id;
  final String templateId;
  final String envelopeId;
  final double percentage;
  const AllocationTemplateItem({
    required this.id,
    required this.templateId,
    required this.envelopeId,
    required this.percentage,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['template_id'] = Variable<String>(templateId);
    map['envelope_id'] = Variable<String>(envelopeId);
    map['percentage'] = Variable<double>(percentage);
    return map;
  }

  AllocationTemplateItemsCompanion toCompanion(bool nullToAbsent) {
    return AllocationTemplateItemsCompanion(
      id: Value(id),
      templateId: Value(templateId),
      envelopeId: Value(envelopeId),
      percentage: Value(percentage),
    );
  }

  factory AllocationTemplateItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AllocationTemplateItem(
      id: serializer.fromJson<String>(json['id']),
      templateId: serializer.fromJson<String>(json['templateId']),
      envelopeId: serializer.fromJson<String>(json['envelopeId']),
      percentage: serializer.fromJson<double>(json['percentage']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'templateId': serializer.toJson<String>(templateId),
      'envelopeId': serializer.toJson<String>(envelopeId),
      'percentage': serializer.toJson<double>(percentage),
    };
  }

  AllocationTemplateItem copyWith({
    String? id,
    String? templateId,
    String? envelopeId,
    double? percentage,
  }) => AllocationTemplateItem(
    id: id ?? this.id,
    templateId: templateId ?? this.templateId,
    envelopeId: envelopeId ?? this.envelopeId,
    percentage: percentage ?? this.percentage,
  );
  AllocationTemplateItem copyWithCompanion(
    AllocationTemplateItemsCompanion data,
  ) {
    return AllocationTemplateItem(
      id: data.id.present ? data.id.value : this.id,
      templateId: data.templateId.present
          ? data.templateId.value
          : this.templateId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      percentage: data.percentage.present
          ? data.percentage.value
          : this.percentage,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AllocationTemplateItem(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('percentage: $percentage')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, templateId, envelopeId, percentage);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AllocationTemplateItem &&
          other.id == this.id &&
          other.templateId == this.templateId &&
          other.envelopeId == this.envelopeId &&
          other.percentage == this.percentage);
}

class AllocationTemplateItemsCompanion
    extends UpdateCompanion<AllocationTemplateItem> {
  final Value<String> id;
  final Value<String> templateId;
  final Value<String> envelopeId;
  final Value<double> percentage;
  final Value<int> rowid;
  const AllocationTemplateItemsCompanion({
    this.id = const Value.absent(),
    this.templateId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.percentage = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AllocationTemplateItemsCompanion.insert({
    required String id,
    required String templateId,
    required String envelopeId,
    required double percentage,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       templateId = Value(templateId),
       envelopeId = Value(envelopeId),
       percentage = Value(percentage);
  static Insertable<AllocationTemplateItem> custom({
    Expression<String>? id,
    Expression<String>? templateId,
    Expression<String>? envelopeId,
    Expression<double>? percentage,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (templateId != null) 'template_id': templateId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (percentage != null) 'percentage': percentage,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AllocationTemplateItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? templateId,
    Value<String>? envelopeId,
    Value<double>? percentage,
    Value<int>? rowid,
  }) {
    return AllocationTemplateItemsCompanion(
      id: id ?? this.id,
      templateId: templateId ?? this.templateId,
      envelopeId: envelopeId ?? this.envelopeId,
      percentage: percentage ?? this.percentage,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (templateId.present) {
      map['template_id'] = Variable<String>(templateId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (percentage.present) {
      map['percentage'] = Variable<double>(percentage.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllocationTemplateItemsCompanion(')
          ..write('id: $id, ')
          ..write('templateId: $templateId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('percentage: $percentage, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalsTable extends Goals with TableInfo<$GoalsTable, Goal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _envelopeIdMeta = const VerificationMeta(
    'envelopeId',
  );
  @override
  late final GeneratedColumn<String> envelopeId = GeneratedColumn<String>(
    'envelope_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetAmountMeta = const VerificationMeta(
    'targetAmount',
  );
  @override
  late final GeneratedColumn<int> targetAmount = GeneratedColumn<int>(
    'target_amount',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _targetDateMeta = const VerificationMeta(
    'targetDate',
  );
  @override
  late final GeneratedColumn<DateTime> targetDate = GeneratedColumn<DateTime>(
    'target_date',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyContributionMeta =
      const VerificationMeta('monthlyContribution');
  @override
  late final GeneratedColumn<int> monthlyContribution = GeneratedColumn<int>(
    'monthly_contribution',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _currentAmountMeta = const VerificationMeta(
    'currentAmount',
  );
  @override
  late final GeneratedColumn<int> currentAmount = GeneratedColumn<int>(
    'current_amount',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _isCompletedMeta = const VerificationMeta(
    'isCompleted',
  );
  @override
  late final GeneratedColumn<bool> isCompleted = GeneratedColumn<bool>(
    'is_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    envelopeId,
    accountId,
    type,
    name,
    targetAmount,
    targetDate,
    monthlyContribution,
    currentAmount,
    isCompleted,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Goal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('envelope_id')) {
      context.handle(
        _envelopeIdMeta,
        envelopeId.isAcceptableOrUnknown(data['envelope_id']!, _envelopeIdMeta),
      );
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('target_amount')) {
      context.handle(
        _targetAmountMeta,
        targetAmount.isAcceptableOrUnknown(
          data['target_amount']!,
          _targetAmountMeta,
        ),
      );
    }
    if (data.containsKey('target_date')) {
      context.handle(
        _targetDateMeta,
        targetDate.isAcceptableOrUnknown(data['target_date']!, _targetDateMeta),
      );
    }
    if (data.containsKey('monthly_contribution')) {
      context.handle(
        _monthlyContributionMeta,
        monthlyContribution.isAcceptableOrUnknown(
          data['monthly_contribution']!,
          _monthlyContributionMeta,
        ),
      );
    }
    if (data.containsKey('current_amount')) {
      context.handle(
        _currentAmountMeta,
        currentAmount.isAcceptableOrUnknown(
          data['current_amount']!,
          _currentAmountMeta,
        ),
      );
    }
    if (data.containsKey('is_completed')) {
      context.handle(
        _isCompletedMeta,
        isCompleted.isAcceptableOrUnknown(
          data['is_completed']!,
          _isCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Goal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Goal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      envelopeId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}envelope_id'],
      ),
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      ),
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      targetAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}target_amount'],
      ),
      targetDate: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}target_date'],
      ),
      monthlyContribution: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}monthly_contribution'],
      ),
      currentAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}current_amount'],
      )!,
      isCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GoalsTable createAlias(String alias) {
    return $GoalsTable(attachedDatabase, alias);
  }
}

class Goal extends DataClass implements Insertable<Goal> {
  final String id;
  final String budgetId;
  final String? envelopeId;
  final String? accountId;
  final String type;
  final String name;
  final int? targetAmount;
  final DateTime? targetDate;
  final int? monthlyContribution;
  final int currentAmount;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  const Goal({
    required this.id,
    required this.budgetId,
    this.envelopeId,
    this.accountId,
    required this.type,
    required this.name,
    this.targetAmount,
    this.targetDate,
    this.monthlyContribution,
    required this.currentAmount,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    if (!nullToAbsent || envelopeId != null) {
      map['envelope_id'] = Variable<String>(envelopeId);
    }
    if (!nullToAbsent || accountId != null) {
      map['account_id'] = Variable<String>(accountId);
    }
    map['type'] = Variable<String>(type);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || targetAmount != null) {
      map['target_amount'] = Variable<int>(targetAmount);
    }
    if (!nullToAbsent || targetDate != null) {
      map['target_date'] = Variable<DateTime>(targetDate);
    }
    if (!nullToAbsent || monthlyContribution != null) {
      map['monthly_contribution'] = Variable<int>(monthlyContribution);
    }
    map['current_amount'] = Variable<int>(currentAmount);
    map['is_completed'] = Variable<bool>(isCompleted);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GoalsCompanion toCompanion(bool nullToAbsent) {
    return GoalsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      envelopeId: envelopeId == null && nullToAbsent
          ? const Value.absent()
          : Value(envelopeId),
      accountId: accountId == null && nullToAbsent
          ? const Value.absent()
          : Value(accountId),
      type: Value(type),
      name: Value(name),
      targetAmount: targetAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(targetAmount),
      targetDate: targetDate == null && nullToAbsent
          ? const Value.absent()
          : Value(targetDate),
      monthlyContribution: monthlyContribution == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyContribution),
      currentAmount: Value(currentAmount),
      isCompleted: Value(isCompleted),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory Goal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Goal(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      envelopeId: serializer.fromJson<String?>(json['envelopeId']),
      accountId: serializer.fromJson<String?>(json['accountId']),
      type: serializer.fromJson<String>(json['type']),
      name: serializer.fromJson<String>(json['name']),
      targetAmount: serializer.fromJson<int?>(json['targetAmount']),
      targetDate: serializer.fromJson<DateTime?>(json['targetDate']),
      monthlyContribution: serializer.fromJson<int?>(
        json['monthlyContribution'],
      ),
      currentAmount: serializer.fromJson<int>(json['currentAmount']),
      isCompleted: serializer.fromJson<bool>(json['isCompleted']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'envelopeId': serializer.toJson<String?>(envelopeId),
      'accountId': serializer.toJson<String?>(accountId),
      'type': serializer.toJson<String>(type),
      'name': serializer.toJson<String>(name),
      'targetAmount': serializer.toJson<int?>(targetAmount),
      'targetDate': serializer.toJson<DateTime?>(targetDate),
      'monthlyContribution': serializer.toJson<int?>(monthlyContribution),
      'currentAmount': serializer.toJson<int>(currentAmount),
      'isCompleted': serializer.toJson<bool>(isCompleted),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  Goal copyWith({
    String? id,
    String? budgetId,
    Value<String?> envelopeId = const Value.absent(),
    Value<String?> accountId = const Value.absent(),
    String? type,
    String? name,
    Value<int?> targetAmount = const Value.absent(),
    Value<DateTime?> targetDate = const Value.absent(),
    Value<int?> monthlyContribution = const Value.absent(),
    int? currentAmount,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => Goal(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    envelopeId: envelopeId.present ? envelopeId.value : this.envelopeId,
    accountId: accountId.present ? accountId.value : this.accountId,
    type: type ?? this.type,
    name: name ?? this.name,
    targetAmount: targetAmount.present ? targetAmount.value : this.targetAmount,
    targetDate: targetDate.present ? targetDate.value : this.targetDate,
    monthlyContribution: monthlyContribution.present
        ? monthlyContribution.value
        : this.monthlyContribution,
    currentAmount: currentAmount ?? this.currentAmount,
    isCompleted: isCompleted ?? this.isCompleted,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  Goal copyWithCompanion(GoalsCompanion data) {
    return Goal(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      envelopeId: data.envelopeId.present
          ? data.envelopeId.value
          : this.envelopeId,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      type: data.type.present ? data.type.value : this.type,
      name: data.name.present ? data.name.value : this.name,
      targetAmount: data.targetAmount.present
          ? data.targetAmount.value
          : this.targetAmount,
      targetDate: data.targetDate.present
          ? data.targetDate.value
          : this.targetDate,
      monthlyContribution: data.monthlyContribution.present
          ? data.monthlyContribution.value
          : this.monthlyContribution,
      currentAmount: data.currentAmount.present
          ? data.currentAmount.value
          : this.currentAmount,
      isCompleted: data.isCompleted.present
          ? data.isCompleted.value
          : this.isCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Goal(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('accountId: $accountId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('monthlyContribution: $monthlyContribution, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    envelopeId,
    accountId,
    type,
    name,
    targetAmount,
    targetDate,
    monthlyContribution,
    currentAmount,
    isCompleted,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Goal &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.envelopeId == this.envelopeId &&
          other.accountId == this.accountId &&
          other.type == this.type &&
          other.name == this.name &&
          other.targetAmount == this.targetAmount &&
          other.targetDate == this.targetDate &&
          other.monthlyContribution == this.monthlyContribution &&
          other.currentAmount == this.currentAmount &&
          other.isCompleted == this.isCompleted &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class GoalsCompanion extends UpdateCompanion<Goal> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String?> envelopeId;
  final Value<String?> accountId;
  final Value<String> type;
  final Value<String> name;
  final Value<int?> targetAmount;
  final Value<DateTime?> targetDate;
  final Value<int?> monthlyContribution;
  final Value<int> currentAmount;
  final Value<bool> isCompleted;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GoalsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.envelopeId = const Value.absent(),
    this.accountId = const Value.absent(),
    this.type = const Value.absent(),
    this.name = const Value.absent(),
    this.targetAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.monthlyContribution = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.isCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalsCompanion.insert({
    required String id,
    required String budgetId,
    this.envelopeId = const Value.absent(),
    this.accountId = const Value.absent(),
    required String type,
    required String name,
    this.targetAmount = const Value.absent(),
    this.targetDate = const Value.absent(),
    this.monthlyContribution = const Value.absent(),
    this.currentAmount = const Value.absent(),
    this.isCompleted = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       type = Value(type),
       name = Value(name),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<Goal> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? envelopeId,
    Expression<String>? accountId,
    Expression<String>? type,
    Expression<String>? name,
    Expression<int>? targetAmount,
    Expression<DateTime>? targetDate,
    Expression<int>? monthlyContribution,
    Expression<int>? currentAmount,
    Expression<bool>? isCompleted,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (envelopeId != null) 'envelope_id': envelopeId,
      if (accountId != null) 'account_id': accountId,
      if (type != null) 'type': type,
      if (name != null) 'name': name,
      if (targetAmount != null) 'target_amount': targetAmount,
      if (targetDate != null) 'target_date': targetDate,
      if (monthlyContribution != null)
        'monthly_contribution': monthlyContribution,
      if (currentAmount != null) 'current_amount': currentAmount,
      if (isCompleted != null) 'is_completed': isCompleted,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String?>? envelopeId,
    Value<String?>? accountId,
    Value<String>? type,
    Value<String>? name,
    Value<int?>? targetAmount,
    Value<DateTime?>? targetDate,
    Value<int?>? monthlyContribution,
    Value<int>? currentAmount,
    Value<bool>? isCompleted,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GoalsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      envelopeId: envelopeId ?? this.envelopeId,
      accountId: accountId ?? this.accountId,
      type: type ?? this.type,
      name: name ?? this.name,
      targetAmount: targetAmount ?? this.targetAmount,
      targetDate: targetDate ?? this.targetDate,
      monthlyContribution: monthlyContribution ?? this.monthlyContribution,
      currentAmount: currentAmount ?? this.currentAmount,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (envelopeId.present) {
      map['envelope_id'] = Variable<String>(envelopeId.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (targetAmount.present) {
      map['target_amount'] = Variable<int>(targetAmount.value);
    }
    if (targetDate.present) {
      map['target_date'] = Variable<DateTime>(targetDate.value);
    }
    if (monthlyContribution.present) {
      map['monthly_contribution'] = Variable<int>(monthlyContribution.value);
    }
    if (currentAmount.present) {
      map['current_amount'] = Variable<int>(currentAmount.value);
    }
    if (isCompleted.present) {
      map['is_completed'] = Variable<bool>(isCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('envelopeId: $envelopeId, ')
          ..write('accountId: $accountId, ')
          ..write('type: $type, ')
          ..write('name: $name, ')
          ..write('targetAmount: $targetAmount, ')
          ..write('targetDate: $targetDate, ')
          ..write('monthlyContribution: $monthlyContribution, ')
          ..write('currentAmount: $currentAmount, ')
          ..write('isCompleted: $isCompleted, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GoalContributionsTable extends GoalContributions
    with TableInfo<$GoalContributionsTable, GoalContribution> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GoalContributionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _goalIdMeta = const VerificationMeta('goalId');
  @override
  late final GeneratedColumn<String> goalId = GeneratedColumn<String>(
    'goal_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountCentsMeta = const VerificationMeta(
    'amountCents',
  );
  @override
  late final GeneratedColumn<int> amountCents = GeneratedColumn<int>(
    'amount_cents',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _noteMeta = const VerificationMeta('note');
  @override
  late final GeneratedColumn<String> note = GeneratedColumn<String>(
    'note',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    goalId,
    amountCents,
    note,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'goal_contributions';
  @override
  VerificationContext validateIntegrity(
    Insertable<GoalContribution> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('goal_id')) {
      context.handle(
        _goalIdMeta,
        goalId.isAcceptableOrUnknown(data['goal_id']!, _goalIdMeta),
      );
    } else if (isInserting) {
      context.missing(_goalIdMeta);
    }
    if (data.containsKey('amount_cents')) {
      context.handle(
        _amountCentsMeta,
        amountCents.isAcceptableOrUnknown(
          data['amount_cents']!,
          _amountCentsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountCentsMeta);
    }
    if (data.containsKey('note')) {
      context.handle(
        _noteMeta,
        note.isAcceptableOrUnknown(data['note']!, _noteMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GoalContribution map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GoalContribution(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      goalId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}goal_id'],
      )!,
      amountCents: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}amount_cents'],
      )!,
      note: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $GoalContributionsTable createAlias(String alias) {
    return $GoalContributionsTable(attachedDatabase, alias);
  }
}

class GoalContribution extends DataClass
    implements Insertable<GoalContribution> {
  final String id;
  final String goalId;
  final int amountCents;
  final String? note;
  final DateTime createdAt;
  const GoalContribution({
    required this.id,
    required this.goalId,
    required this.amountCents,
    this.note,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['goal_id'] = Variable<String>(goalId);
    map['amount_cents'] = Variable<int>(amountCents);
    if (!nullToAbsent || note != null) {
      map['note'] = Variable<String>(note);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  GoalContributionsCompanion toCompanion(bool nullToAbsent) {
    return GoalContributionsCompanion(
      id: Value(id),
      goalId: Value(goalId),
      amountCents: Value(amountCents),
      note: note == null && nullToAbsent ? const Value.absent() : Value(note),
      createdAt: Value(createdAt),
    );
  }

  factory GoalContribution.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GoalContribution(
      id: serializer.fromJson<String>(json['id']),
      goalId: serializer.fromJson<String>(json['goalId']),
      amountCents: serializer.fromJson<int>(json['amountCents']),
      note: serializer.fromJson<String?>(json['note']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'goalId': serializer.toJson<String>(goalId),
      'amountCents': serializer.toJson<int>(amountCents),
      'note': serializer.toJson<String?>(note),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  GoalContribution copyWith({
    String? id,
    String? goalId,
    int? amountCents,
    Value<String?> note = const Value.absent(),
    DateTime? createdAt,
  }) => GoalContribution(
    id: id ?? this.id,
    goalId: goalId ?? this.goalId,
    amountCents: amountCents ?? this.amountCents,
    note: note.present ? note.value : this.note,
    createdAt: createdAt ?? this.createdAt,
  );
  GoalContribution copyWithCompanion(GoalContributionsCompanion data) {
    return GoalContribution(
      id: data.id.present ? data.id.value : this.id,
      goalId: data.goalId.present ? data.goalId.value : this.goalId,
      amountCents: data.amountCents.present
          ? data.amountCents.value
          : this.amountCents,
      note: data.note.present ? data.note.value : this.note,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GoalContribution(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amountCents: $amountCents, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, goalId, amountCents, note, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GoalContribution &&
          other.id == this.id &&
          other.goalId == this.goalId &&
          other.amountCents == this.amountCents &&
          other.note == this.note &&
          other.createdAt == this.createdAt);
}

class GoalContributionsCompanion extends UpdateCompanion<GoalContribution> {
  final Value<String> id;
  final Value<String> goalId;
  final Value<int> amountCents;
  final Value<String?> note;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const GoalContributionsCompanion({
    this.id = const Value.absent(),
    this.goalId = const Value.absent(),
    this.amountCents = const Value.absent(),
    this.note = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GoalContributionsCompanion.insert({
    required String id,
    required String goalId,
    required int amountCents,
    this.note = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       goalId = Value(goalId),
       amountCents = Value(amountCents),
       createdAt = Value(createdAt);
  static Insertable<GoalContribution> custom({
    Expression<String>? id,
    Expression<String>? goalId,
    Expression<int>? amountCents,
    Expression<String>? note,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (goalId != null) 'goal_id': goalId,
      if (amountCents != null) 'amount_cents': amountCents,
      if (note != null) 'note': note,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GoalContributionsCompanion copyWith({
    Value<String>? id,
    Value<String>? goalId,
    Value<int>? amountCents,
    Value<String?>? note,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return GoalContributionsCompanion(
      id: id ?? this.id,
      goalId: goalId ?? this.goalId,
      amountCents: amountCents ?? this.amountCents,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (goalId.present) {
      map['goal_id'] = Variable<String>(goalId.value);
    }
    if (amountCents.present) {
      map['amount_cents'] = Variable<int>(amountCents.value);
    }
    if (note.present) {
      map['note'] = Variable<String>(note.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GoalContributionsCompanion(')
          ..write('id: $id, ')
          ..write('goalId: $goalId, ')
          ..write('amountCents: $amountCents, ')
          ..write('note: $note, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DebtAccountsTable extends DebtAccounts
    with TableInfo<$DebtAccountsTable, DebtAccount> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _interestRateMeta = const VerificationMeta(
    'interestRate',
  );
  @override
  late final GeneratedColumn<double> interestRate = GeneratedColumn<double>(
    'interest_rate',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minimumPaymentMeta = const VerificationMeta(
    'minimumPayment',
  );
  @override
  late final GeneratedColumn<int> minimumPayment = GeneratedColumn<int>(
    'minimum_payment',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _originalBalanceMeta = const VerificationMeta(
    'originalBalance',
  );
  @override
  late final GeneratedColumn<int> originalBalance = GeneratedColumn<int>(
    'original_balance',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payoffStrategyMeta = const VerificationMeta(
    'payoffStrategy',
  );
  @override
  late final GeneratedColumn<String> payoffStrategy = GeneratedColumn<String>(
    'payoff_strategy',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<int> creditLimit = GeneratedColumn<int>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    accountId,
    interestRate,
    minimumPayment,
    originalBalance,
    payoffStrategy,
    creditLimit,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debt_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<DebtAccount> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('interest_rate')) {
      context.handle(
        _interestRateMeta,
        interestRate.isAcceptableOrUnknown(
          data['interest_rate']!,
          _interestRateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_interestRateMeta);
    }
    if (data.containsKey('minimum_payment')) {
      context.handle(
        _minimumPaymentMeta,
        minimumPayment.isAcceptableOrUnknown(
          data['minimum_payment']!,
          _minimumPaymentMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_minimumPaymentMeta);
    }
    if (data.containsKey('original_balance')) {
      context.handle(
        _originalBalanceMeta,
        originalBalance.isAcceptableOrUnknown(
          data['original_balance']!,
          _originalBalanceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_originalBalanceMeta);
    }
    if (data.containsKey('payoff_strategy')) {
      context.handle(
        _payoffStrategyMeta,
        payoffStrategy.isAcceptableOrUnknown(
          data['payoff_strategy']!,
          _payoffStrategyMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {accountId};
  @override
  DebtAccount map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DebtAccount(
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      interestRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}interest_rate'],
      )!,
      minimumPayment: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minimum_payment'],
      )!,
      originalBalance: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}original_balance'],
      )!,
      payoffStrategy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payoff_strategy'],
      ),
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}credit_limit'],
      ),
    );
  }

  @override
  $DebtAccountsTable createAlias(String alias) {
    return $DebtAccountsTable(attachedDatabase, alias);
  }
}

class DebtAccount extends DataClass implements Insertable<DebtAccount> {
  final String accountId;
  final double interestRate;
  final int minimumPayment;
  final int originalBalance;
  final String? payoffStrategy;
  final int? creditLimit;
  const DebtAccount({
    required this.accountId,
    required this.interestRate,
    required this.minimumPayment,
    required this.originalBalance,
    this.payoffStrategy,
    this.creditLimit,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['account_id'] = Variable<String>(accountId);
    map['interest_rate'] = Variable<double>(interestRate);
    map['minimum_payment'] = Variable<int>(minimumPayment);
    map['original_balance'] = Variable<int>(originalBalance);
    if (!nullToAbsent || payoffStrategy != null) {
      map['payoff_strategy'] = Variable<String>(payoffStrategy);
    }
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<int>(creditLimit);
    }
    return map;
  }

  DebtAccountsCompanion toCompanion(bool nullToAbsent) {
    return DebtAccountsCompanion(
      accountId: Value(accountId),
      interestRate: Value(interestRate),
      minimumPayment: Value(minimumPayment),
      originalBalance: Value(originalBalance),
      payoffStrategy: payoffStrategy == null && nullToAbsent
          ? const Value.absent()
          : Value(payoffStrategy),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
    );
  }

  factory DebtAccount.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DebtAccount(
      accountId: serializer.fromJson<String>(json['accountId']),
      interestRate: serializer.fromJson<double>(json['interestRate']),
      minimumPayment: serializer.fromJson<int>(json['minimumPayment']),
      originalBalance: serializer.fromJson<int>(json['originalBalance']),
      payoffStrategy: serializer.fromJson<String?>(json['payoffStrategy']),
      creditLimit: serializer.fromJson<int?>(json['creditLimit']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'accountId': serializer.toJson<String>(accountId),
      'interestRate': serializer.toJson<double>(interestRate),
      'minimumPayment': serializer.toJson<int>(minimumPayment),
      'originalBalance': serializer.toJson<int>(originalBalance),
      'payoffStrategy': serializer.toJson<String?>(payoffStrategy),
      'creditLimit': serializer.toJson<int?>(creditLimit),
    };
  }

  DebtAccount copyWith({
    String? accountId,
    double? interestRate,
    int? minimumPayment,
    int? originalBalance,
    Value<String?> payoffStrategy = const Value.absent(),
    Value<int?> creditLimit = const Value.absent(),
  }) => DebtAccount(
    accountId: accountId ?? this.accountId,
    interestRate: interestRate ?? this.interestRate,
    minimumPayment: minimumPayment ?? this.minimumPayment,
    originalBalance: originalBalance ?? this.originalBalance,
    payoffStrategy: payoffStrategy.present
        ? payoffStrategy.value
        : this.payoffStrategy,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
  );
  DebtAccount copyWithCompanion(DebtAccountsCompanion data) {
    return DebtAccount(
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      interestRate: data.interestRate.present
          ? data.interestRate.value
          : this.interestRate,
      minimumPayment: data.minimumPayment.present
          ? data.minimumPayment.value
          : this.minimumPayment,
      originalBalance: data.originalBalance.present
          ? data.originalBalance.value
          : this.originalBalance,
      payoffStrategy: data.payoffStrategy.present
          ? data.payoffStrategy.value
          : this.payoffStrategy,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DebtAccount(')
          ..write('accountId: $accountId, ')
          ..write('interestRate: $interestRate, ')
          ..write('minimumPayment: $minimumPayment, ')
          ..write('originalBalance: $originalBalance, ')
          ..write('payoffStrategy: $payoffStrategy, ')
          ..write('creditLimit: $creditLimit')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    accountId,
    interestRate,
    minimumPayment,
    originalBalance,
    payoffStrategy,
    creditLimit,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DebtAccount &&
          other.accountId == this.accountId &&
          other.interestRate == this.interestRate &&
          other.minimumPayment == this.minimumPayment &&
          other.originalBalance == this.originalBalance &&
          other.payoffStrategy == this.payoffStrategy &&
          other.creditLimit == this.creditLimit);
}

class DebtAccountsCompanion extends UpdateCompanion<DebtAccount> {
  final Value<String> accountId;
  final Value<double> interestRate;
  final Value<int> minimumPayment;
  final Value<int> originalBalance;
  final Value<String?> payoffStrategy;
  final Value<int?> creditLimit;
  final Value<int> rowid;
  const DebtAccountsCompanion({
    this.accountId = const Value.absent(),
    this.interestRate = const Value.absent(),
    this.minimumPayment = const Value.absent(),
    this.originalBalance = const Value.absent(),
    this.payoffStrategy = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DebtAccountsCompanion.insert({
    required String accountId,
    required double interestRate,
    required int minimumPayment,
    required int originalBalance,
    this.payoffStrategy = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : accountId = Value(accountId),
       interestRate = Value(interestRate),
       minimumPayment = Value(minimumPayment),
       originalBalance = Value(originalBalance);
  static Insertable<DebtAccount> custom({
    Expression<String>? accountId,
    Expression<double>? interestRate,
    Expression<int>? minimumPayment,
    Expression<int>? originalBalance,
    Expression<String>? payoffStrategy,
    Expression<int>? creditLimit,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (accountId != null) 'account_id': accountId,
      if (interestRate != null) 'interest_rate': interestRate,
      if (minimumPayment != null) 'minimum_payment': minimumPayment,
      if (originalBalance != null) 'original_balance': originalBalance,
      if (payoffStrategy != null) 'payoff_strategy': payoffStrategy,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DebtAccountsCompanion copyWith({
    Value<String>? accountId,
    Value<double>? interestRate,
    Value<int>? minimumPayment,
    Value<int>? originalBalance,
    Value<String?>? payoffStrategy,
    Value<int?>? creditLimit,
    Value<int>? rowid,
  }) {
    return DebtAccountsCompanion(
      accountId: accountId ?? this.accountId,
      interestRate: interestRate ?? this.interestRate,
      minimumPayment: minimumPayment ?? this.minimumPayment,
      originalBalance: originalBalance ?? this.originalBalance,
      payoffStrategy: payoffStrategy ?? this.payoffStrategy,
      creditLimit: creditLimit ?? this.creditLimit,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (interestRate.present) {
      map['interest_rate'] = Variable<double>(interestRate.value);
    }
    if (minimumPayment.present) {
      map['minimum_payment'] = Variable<int>(minimumPayment.value);
    }
    if (originalBalance.present) {
      map['original_balance'] = Variable<int>(originalBalance.value);
    }
    if (payoffStrategy.present) {
      map['payoff_strategy'] = Variable<String>(payoffStrategy.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<int>(creditLimit.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtAccountsCompanion(')
          ..write('accountId: $accountId, ')
          ..write('interestRate: $interestRate, ')
          ..write('minimumPayment: $minimumPayment, ')
          ..write('originalBalance: $originalBalance, ')
          ..write('payoffStrategy: $payoffStrategy, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ActivityLogTable extends ActivityLog
    with TableInfo<$ActivityLogTable, ActivityLogData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ActivityLogTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _actionMeta = const VerificationMeta('action');
  @override
  late final GeneratedColumn<String> action = GeneratedColumn<String>(
    'action',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _detailsMeta = const VerificationMeta(
    'details',
  );
  @override
  late final GeneratedColumn<String> details = GeneratedColumn<String>(
    'details',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    userId,
    action,
    entityType,
    entityId,
    details,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'activity_log';
  @override
  VerificationContext validateIntegrity(
    Insertable<ActivityLogData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('action')) {
      context.handle(
        _actionMeta,
        action.isAcceptableOrUnknown(data['action']!, _actionMeta),
      );
    } else if (isInserting) {
      context.missing(_actionMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('details')) {
      context.handle(
        _detailsMeta,
        details.isAcceptableOrUnknown(data['details']!, _detailsMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ActivityLogData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ActivityLogData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      action: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}action'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      details: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}details'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $ActivityLogTable createAlias(String alias) {
    return $ActivityLogTable(attachedDatabase, alias);
  }
}

class ActivityLogData extends DataClass implements Insertable<ActivityLogData> {
  final String id;
  final String budgetId;
  final String userId;
  final String action;
  final String entityType;
  final String entityId;
  final String? details;
  final DateTime createdAt;
  const ActivityLogData({
    required this.id,
    required this.budgetId,
    required this.userId,
    required this.action,
    required this.entityType,
    required this.entityId,
    this.details,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['user_id'] = Variable<String>(userId);
    map['action'] = Variable<String>(action);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    if (!nullToAbsent || details != null) {
      map['details'] = Variable<String>(details);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ActivityLogCompanion toCompanion(bool nullToAbsent) {
    return ActivityLogCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      userId: Value(userId),
      action: Value(action),
      entityType: Value(entityType),
      entityId: Value(entityId),
      details: details == null && nullToAbsent
          ? const Value.absent()
          : Value(details),
      createdAt: Value(createdAt),
    );
  }

  factory ActivityLogData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ActivityLogData(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      userId: serializer.fromJson<String>(json['userId']),
      action: serializer.fromJson<String>(json['action']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      details: serializer.fromJson<String?>(json['details']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'userId': serializer.toJson<String>(userId),
      'action': serializer.toJson<String>(action),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'details': serializer.toJson<String?>(details),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  ActivityLogData copyWith({
    String? id,
    String? budgetId,
    String? userId,
    String? action,
    String? entityType,
    String? entityId,
    Value<String?> details = const Value.absent(),
    DateTime? createdAt,
  }) => ActivityLogData(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    userId: userId ?? this.userId,
    action: action ?? this.action,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    details: details.present ? details.value : this.details,
    createdAt: createdAt ?? this.createdAt,
  );
  ActivityLogData copyWithCompanion(ActivityLogCompanion data) {
    return ActivityLogData(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      userId: data.userId.present ? data.userId.value : this.userId,
      action: data.action.present ? data.action.value : this.action,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      details: data.details.present ? data.details.value : this.details,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogData(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    budgetId,
    userId,
    action,
    entityType,
    entityId,
    details,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ActivityLogData &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.userId == this.userId &&
          other.action == this.action &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.details == this.details &&
          other.createdAt == this.createdAt);
}

class ActivityLogCompanion extends UpdateCompanion<ActivityLogData> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<String> userId;
  final Value<String> action;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String?> details;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ActivityLogCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.userId = const Value.absent(),
    this.action = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.details = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ActivityLogCompanion.insert({
    required String id,
    required String budgetId,
    required String userId,
    required String action,
    required String entityType,
    required String entityId,
    this.details = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       userId = Value(userId),
       action = Value(action),
       entityType = Value(entityType),
       entityId = Value(entityId),
       createdAt = Value(createdAt);
  static Insertable<ActivityLogData> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<String>? userId,
    Expression<String>? action,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? details,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (userId != null) 'user_id': userId,
      if (action != null) 'action': action,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (details != null) 'details': details,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ActivityLogCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<String>? userId,
    Value<String>? action,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String?>? details,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return ActivityLogCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      userId: userId ?? this.userId,
      action: action ?? this.action,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      details: details ?? this.details,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (action.present) {
      map['action'] = Variable<String>(action.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (details.present) {
      map['details'] = Variable<String>(details.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ActivityLogCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('userId: $userId, ')
          ..write('action: $action, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('details: $details, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotificationPreferencesTable extends NotificationPreferences
    with TableInfo<$NotificationPreferencesTable, NotificationPreference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotificationPreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pushEnabledMeta = const VerificationMeta(
    'pushEnabled',
  );
  @override
  late final GeneratedColumn<bool> pushEnabled = GeneratedColumn<bool>(
    'push_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("push_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _emailEnabledMeta = const VerificationMeta(
    'emailEnabled',
  );
  @override
  late final GeneratedColumn<bool> emailEnabled = GeneratedColumn<bool>(
    'email_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _overspendAlertsMeta = const VerificationMeta(
    'overspendAlerts',
  );
  @override
  late final GeneratedColumn<bool> overspendAlerts = GeneratedColumn<bool>(
    'overspend_alerts',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("overspend_alerts" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _billRemindersMeta = const VerificationMeta(
    'billReminders',
  );
  @override
  late final GeneratedColumn<bool> billReminders = GeneratedColumn<bool>(
    'bill_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("bill_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _emailBillRemindersMeta =
      const VerificationMeta('emailBillReminders');
  @override
  late final GeneratedColumn<bool> emailBillReminders = GeneratedColumn<bool>(
    'email_bill_reminders',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("email_bill_reminders" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _dailyLoggingReminderMeta =
      const VerificationMeta('dailyLoggingReminder');
  @override
  late final GeneratedColumn<bool> dailyLoggingReminder = GeneratedColumn<bool>(
    'daily_logging_reminder',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("daily_logging_reminder" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _recurringTransactionAlertsMeta =
      const VerificationMeta('recurringTransactionAlerts');
  @override
  late final GeneratedColumn<bool> recurringTransactionAlerts =
      GeneratedColumn<bool>(
        'recurring_transaction_alerts',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("recurring_transaction_alerts" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _sharedBudgetActivityMeta =
      const VerificationMeta('sharedBudgetActivity');
  @override
  late final GeneratedColumn<bool> sharedBudgetActivity = GeneratedColumn<bool>(
    'shared_budget_activity',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("shared_budget_activity" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _weeklySummaryMeta = const VerificationMeta(
    'weeklySummary',
  );
  @override
  late final GeneratedColumn<bool> weeklySummary = GeneratedColumn<bool>(
    'weekly_summary',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("weekly_summary" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    userId,
    pushEnabled,
    emailEnabled,
    overspendAlerts,
    billReminders,
    emailBillReminders,
    dailyLoggingReminder,
    recurringTransactionAlerts,
    sharedBudgetActivity,
    weeklySummary,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notification_preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotificationPreference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('push_enabled')) {
      context.handle(
        _pushEnabledMeta,
        pushEnabled.isAcceptableOrUnknown(
          data['push_enabled']!,
          _pushEnabledMeta,
        ),
      );
    }
    if (data.containsKey('email_enabled')) {
      context.handle(
        _emailEnabledMeta,
        emailEnabled.isAcceptableOrUnknown(
          data['email_enabled']!,
          _emailEnabledMeta,
        ),
      );
    }
    if (data.containsKey('overspend_alerts')) {
      context.handle(
        _overspendAlertsMeta,
        overspendAlerts.isAcceptableOrUnknown(
          data['overspend_alerts']!,
          _overspendAlertsMeta,
        ),
      );
    }
    if (data.containsKey('bill_reminders')) {
      context.handle(
        _billRemindersMeta,
        billReminders.isAcceptableOrUnknown(
          data['bill_reminders']!,
          _billRemindersMeta,
        ),
      );
    }
    if (data.containsKey('email_bill_reminders')) {
      context.handle(
        _emailBillRemindersMeta,
        emailBillReminders.isAcceptableOrUnknown(
          data['email_bill_reminders']!,
          _emailBillRemindersMeta,
        ),
      );
    }
    if (data.containsKey('daily_logging_reminder')) {
      context.handle(
        _dailyLoggingReminderMeta,
        dailyLoggingReminder.isAcceptableOrUnknown(
          data['daily_logging_reminder']!,
          _dailyLoggingReminderMeta,
        ),
      );
    }
    if (data.containsKey('recurring_transaction_alerts')) {
      context.handle(
        _recurringTransactionAlertsMeta,
        recurringTransactionAlerts.isAcceptableOrUnknown(
          data['recurring_transaction_alerts']!,
          _recurringTransactionAlertsMeta,
        ),
      );
    }
    if (data.containsKey('shared_budget_activity')) {
      context.handle(
        _sharedBudgetActivityMeta,
        sharedBudgetActivity.isAcceptableOrUnknown(
          data['shared_budget_activity']!,
          _sharedBudgetActivityMeta,
        ),
      );
    }
    if (data.containsKey('weekly_summary')) {
      context.handle(
        _weeklySummaryMeta,
        weeklySummary.isAcceptableOrUnknown(
          data['weekly_summary']!,
          _weeklySummaryMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {userId};
  @override
  NotificationPreference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotificationPreference(
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      pushEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}push_enabled'],
      )!,
      emailEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_enabled'],
      )!,
      overspendAlerts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}overspend_alerts'],
      )!,
      billReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}bill_reminders'],
      )!,
      emailBillReminders: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}email_bill_reminders'],
      )!,
      dailyLoggingReminder: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}daily_logging_reminder'],
      )!,
      recurringTransactionAlerts: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}recurring_transaction_alerts'],
      )!,
      sharedBudgetActivity: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}shared_budget_activity'],
      )!,
      weeklySummary: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}weekly_summary'],
      )!,
    );
  }

  @override
  $NotificationPreferencesTable createAlias(String alias) {
    return $NotificationPreferencesTable(attachedDatabase, alias);
  }
}

class NotificationPreference extends DataClass
    implements Insertable<NotificationPreference> {
  final String userId;
  final bool pushEnabled;
  final bool emailEnabled;
  final bool overspendAlerts;
  final bool billReminders;
  final bool emailBillReminders;
  final bool dailyLoggingReminder;
  final bool recurringTransactionAlerts;
  final bool sharedBudgetActivity;
  final bool weeklySummary;
  const NotificationPreference({
    required this.userId,
    required this.pushEnabled,
    required this.emailEnabled,
    required this.overspendAlerts,
    required this.billReminders,
    required this.emailBillReminders,
    required this.dailyLoggingReminder,
    required this.recurringTransactionAlerts,
    required this.sharedBudgetActivity,
    required this.weeklySummary,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['user_id'] = Variable<String>(userId);
    map['push_enabled'] = Variable<bool>(pushEnabled);
    map['email_enabled'] = Variable<bool>(emailEnabled);
    map['overspend_alerts'] = Variable<bool>(overspendAlerts);
    map['bill_reminders'] = Variable<bool>(billReminders);
    map['email_bill_reminders'] = Variable<bool>(emailBillReminders);
    map['daily_logging_reminder'] = Variable<bool>(dailyLoggingReminder);
    map['recurring_transaction_alerts'] = Variable<bool>(
      recurringTransactionAlerts,
    );
    map['shared_budget_activity'] = Variable<bool>(sharedBudgetActivity);
    map['weekly_summary'] = Variable<bool>(weeklySummary);
    return map;
  }

  NotificationPreferencesCompanion toCompanion(bool nullToAbsent) {
    return NotificationPreferencesCompanion(
      userId: Value(userId),
      pushEnabled: Value(pushEnabled),
      emailEnabled: Value(emailEnabled),
      overspendAlerts: Value(overspendAlerts),
      billReminders: Value(billReminders),
      emailBillReminders: Value(emailBillReminders),
      dailyLoggingReminder: Value(dailyLoggingReminder),
      recurringTransactionAlerts: Value(recurringTransactionAlerts),
      sharedBudgetActivity: Value(sharedBudgetActivity),
      weeklySummary: Value(weeklySummary),
    );
  }

  factory NotificationPreference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotificationPreference(
      userId: serializer.fromJson<String>(json['userId']),
      pushEnabled: serializer.fromJson<bool>(json['pushEnabled']),
      emailEnabled: serializer.fromJson<bool>(json['emailEnabled']),
      overspendAlerts: serializer.fromJson<bool>(json['overspendAlerts']),
      billReminders: serializer.fromJson<bool>(json['billReminders']),
      emailBillReminders: serializer.fromJson<bool>(json['emailBillReminders']),
      dailyLoggingReminder: serializer.fromJson<bool>(
        json['dailyLoggingReminder'],
      ),
      recurringTransactionAlerts: serializer.fromJson<bool>(
        json['recurringTransactionAlerts'],
      ),
      sharedBudgetActivity: serializer.fromJson<bool>(
        json['sharedBudgetActivity'],
      ),
      weeklySummary: serializer.fromJson<bool>(json['weeklySummary']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'userId': serializer.toJson<String>(userId),
      'pushEnabled': serializer.toJson<bool>(pushEnabled),
      'emailEnabled': serializer.toJson<bool>(emailEnabled),
      'overspendAlerts': serializer.toJson<bool>(overspendAlerts),
      'billReminders': serializer.toJson<bool>(billReminders),
      'emailBillReminders': serializer.toJson<bool>(emailBillReminders),
      'dailyLoggingReminder': serializer.toJson<bool>(dailyLoggingReminder),
      'recurringTransactionAlerts': serializer.toJson<bool>(
        recurringTransactionAlerts,
      ),
      'sharedBudgetActivity': serializer.toJson<bool>(sharedBudgetActivity),
      'weeklySummary': serializer.toJson<bool>(weeklySummary),
    };
  }

  NotificationPreference copyWith({
    String? userId,
    bool? pushEnabled,
    bool? emailEnabled,
    bool? overspendAlerts,
    bool? billReminders,
    bool? emailBillReminders,
    bool? dailyLoggingReminder,
    bool? recurringTransactionAlerts,
    bool? sharedBudgetActivity,
    bool? weeklySummary,
  }) => NotificationPreference(
    userId: userId ?? this.userId,
    pushEnabled: pushEnabled ?? this.pushEnabled,
    emailEnabled: emailEnabled ?? this.emailEnabled,
    overspendAlerts: overspendAlerts ?? this.overspendAlerts,
    billReminders: billReminders ?? this.billReminders,
    emailBillReminders: emailBillReminders ?? this.emailBillReminders,
    dailyLoggingReminder: dailyLoggingReminder ?? this.dailyLoggingReminder,
    recurringTransactionAlerts:
        recurringTransactionAlerts ?? this.recurringTransactionAlerts,
    sharedBudgetActivity: sharedBudgetActivity ?? this.sharedBudgetActivity,
    weeklySummary: weeklySummary ?? this.weeklySummary,
  );
  NotificationPreference copyWithCompanion(
    NotificationPreferencesCompanion data,
  ) {
    return NotificationPreference(
      userId: data.userId.present ? data.userId.value : this.userId,
      pushEnabled: data.pushEnabled.present
          ? data.pushEnabled.value
          : this.pushEnabled,
      emailEnabled: data.emailEnabled.present
          ? data.emailEnabled.value
          : this.emailEnabled,
      overspendAlerts: data.overspendAlerts.present
          ? data.overspendAlerts.value
          : this.overspendAlerts,
      billReminders: data.billReminders.present
          ? data.billReminders.value
          : this.billReminders,
      emailBillReminders: data.emailBillReminders.present
          ? data.emailBillReminders.value
          : this.emailBillReminders,
      dailyLoggingReminder: data.dailyLoggingReminder.present
          ? data.dailyLoggingReminder.value
          : this.dailyLoggingReminder,
      recurringTransactionAlerts: data.recurringTransactionAlerts.present
          ? data.recurringTransactionAlerts.value
          : this.recurringTransactionAlerts,
      sharedBudgetActivity: data.sharedBudgetActivity.present
          ? data.sharedBudgetActivity.value
          : this.sharedBudgetActivity,
      weeklySummary: data.weeklySummary.present
          ? data.weeklySummary.value
          : this.weeklySummary,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreference(')
          ..write('userId: $userId, ')
          ..write('pushEnabled: $pushEnabled, ')
          ..write('emailEnabled: $emailEnabled, ')
          ..write('overspendAlerts: $overspendAlerts, ')
          ..write('billReminders: $billReminders, ')
          ..write('emailBillReminders: $emailBillReminders, ')
          ..write('dailyLoggingReminder: $dailyLoggingReminder, ')
          ..write('recurringTransactionAlerts: $recurringTransactionAlerts, ')
          ..write('sharedBudgetActivity: $sharedBudgetActivity, ')
          ..write('weeklySummary: $weeklySummary')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    userId,
    pushEnabled,
    emailEnabled,
    overspendAlerts,
    billReminders,
    emailBillReminders,
    dailyLoggingReminder,
    recurringTransactionAlerts,
    sharedBudgetActivity,
    weeklySummary,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotificationPreference &&
          other.userId == this.userId &&
          other.pushEnabled == this.pushEnabled &&
          other.emailEnabled == this.emailEnabled &&
          other.overspendAlerts == this.overspendAlerts &&
          other.billReminders == this.billReminders &&
          other.emailBillReminders == this.emailBillReminders &&
          other.dailyLoggingReminder == this.dailyLoggingReminder &&
          other.recurringTransactionAlerts == this.recurringTransactionAlerts &&
          other.sharedBudgetActivity == this.sharedBudgetActivity &&
          other.weeklySummary == this.weeklySummary);
}

class NotificationPreferencesCompanion
    extends UpdateCompanion<NotificationPreference> {
  final Value<String> userId;
  final Value<bool> pushEnabled;
  final Value<bool> emailEnabled;
  final Value<bool> overspendAlerts;
  final Value<bool> billReminders;
  final Value<bool> emailBillReminders;
  final Value<bool> dailyLoggingReminder;
  final Value<bool> recurringTransactionAlerts;
  final Value<bool> sharedBudgetActivity;
  final Value<bool> weeklySummary;
  final Value<int> rowid;
  const NotificationPreferencesCompanion({
    this.userId = const Value.absent(),
    this.pushEnabled = const Value.absent(),
    this.emailEnabled = const Value.absent(),
    this.overspendAlerts = const Value.absent(),
    this.billReminders = const Value.absent(),
    this.emailBillReminders = const Value.absent(),
    this.dailyLoggingReminder = const Value.absent(),
    this.recurringTransactionAlerts = const Value.absent(),
    this.sharedBudgetActivity = const Value.absent(),
    this.weeklySummary = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotificationPreferencesCompanion.insert({
    required String userId,
    this.pushEnabled = const Value.absent(),
    this.emailEnabled = const Value.absent(),
    this.overspendAlerts = const Value.absent(),
    this.billReminders = const Value.absent(),
    this.emailBillReminders = const Value.absent(),
    this.dailyLoggingReminder = const Value.absent(),
    this.recurringTransactionAlerts = const Value.absent(),
    this.sharedBudgetActivity = const Value.absent(),
    this.weeklySummary = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : userId = Value(userId);
  static Insertable<NotificationPreference> custom({
    Expression<String>? userId,
    Expression<bool>? pushEnabled,
    Expression<bool>? emailEnabled,
    Expression<bool>? overspendAlerts,
    Expression<bool>? billReminders,
    Expression<bool>? emailBillReminders,
    Expression<bool>? dailyLoggingReminder,
    Expression<bool>? recurringTransactionAlerts,
    Expression<bool>? sharedBudgetActivity,
    Expression<bool>? weeklySummary,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (userId != null) 'user_id': userId,
      if (pushEnabled != null) 'push_enabled': pushEnabled,
      if (emailEnabled != null) 'email_enabled': emailEnabled,
      if (overspendAlerts != null) 'overspend_alerts': overspendAlerts,
      if (billReminders != null) 'bill_reminders': billReminders,
      if (emailBillReminders != null)
        'email_bill_reminders': emailBillReminders,
      if (dailyLoggingReminder != null)
        'daily_logging_reminder': dailyLoggingReminder,
      if (recurringTransactionAlerts != null)
        'recurring_transaction_alerts': recurringTransactionAlerts,
      if (sharedBudgetActivity != null)
        'shared_budget_activity': sharedBudgetActivity,
      if (weeklySummary != null) 'weekly_summary': weeklySummary,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotificationPreferencesCompanion copyWith({
    Value<String>? userId,
    Value<bool>? pushEnabled,
    Value<bool>? emailEnabled,
    Value<bool>? overspendAlerts,
    Value<bool>? billReminders,
    Value<bool>? emailBillReminders,
    Value<bool>? dailyLoggingReminder,
    Value<bool>? recurringTransactionAlerts,
    Value<bool>? sharedBudgetActivity,
    Value<bool>? weeklySummary,
    Value<int>? rowid,
  }) {
    return NotificationPreferencesCompanion(
      userId: userId ?? this.userId,
      pushEnabled: pushEnabled ?? this.pushEnabled,
      emailEnabled: emailEnabled ?? this.emailEnabled,
      overspendAlerts: overspendAlerts ?? this.overspendAlerts,
      billReminders: billReminders ?? this.billReminders,
      emailBillReminders: emailBillReminders ?? this.emailBillReminders,
      dailyLoggingReminder: dailyLoggingReminder ?? this.dailyLoggingReminder,
      recurringTransactionAlerts:
          recurringTransactionAlerts ?? this.recurringTransactionAlerts,
      sharedBudgetActivity: sharedBudgetActivity ?? this.sharedBudgetActivity,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (pushEnabled.present) {
      map['push_enabled'] = Variable<bool>(pushEnabled.value);
    }
    if (emailEnabled.present) {
      map['email_enabled'] = Variable<bool>(emailEnabled.value);
    }
    if (overspendAlerts.present) {
      map['overspend_alerts'] = Variable<bool>(overspendAlerts.value);
    }
    if (billReminders.present) {
      map['bill_reminders'] = Variable<bool>(billReminders.value);
    }
    if (emailBillReminders.present) {
      map['email_bill_reminders'] = Variable<bool>(emailBillReminders.value);
    }
    if (dailyLoggingReminder.present) {
      map['daily_logging_reminder'] = Variable<bool>(
        dailyLoggingReminder.value,
      );
    }
    if (recurringTransactionAlerts.present) {
      map['recurring_transaction_alerts'] = Variable<bool>(
        recurringTransactionAlerts.value,
      );
    }
    if (sharedBudgetActivity.present) {
      map['shared_budget_activity'] = Variable<bool>(
        sharedBudgetActivity.value,
      );
    }
    if (weeklySummary.present) {
      map['weekly_summary'] = Variable<bool>(weeklySummary.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotificationPreferencesCompanion(')
          ..write('userId: $userId, ')
          ..write('pushEnabled: $pushEnabled, ')
          ..write('emailEnabled: $emailEnabled, ')
          ..write('overspendAlerts: $overspendAlerts, ')
          ..write('billReminders: $billReminders, ')
          ..write('emailBillReminders: $emailBillReminders, ')
          ..write('dailyLoggingReminder: $dailyLoggingReminder, ')
          ..write('recurringTransactionAlerts: $recurringTransactionAlerts, ')
          ..write('sharedBudgetActivity: $sharedBudgetActivity, ')
          ..write('weeklySummary: $weeklySummary, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PushTokensTable extends PushTokens
    with TableInfo<$PushTokensTable, PushToken> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PushTokensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
    'token',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _platformMeta = const VerificationMeta(
    'platform',
  );
  @override
  late final GeneratedColumn<String> platform = GeneratedColumn<String>(
    'platform',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    userId,
    token,
    platform,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'push_tokens';
  @override
  VerificationContext validateIntegrity(
    Insertable<PushToken> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('token')) {
      context.handle(
        _tokenMeta,
        token.isAcceptableOrUnknown(data['token']!, _tokenMeta),
      );
    } else if (isInserting) {
      context.missing(_tokenMeta);
    }
    if (data.containsKey('platform')) {
      context.handle(
        _platformMeta,
        platform.isAcceptableOrUnknown(data['platform']!, _platformMeta),
      );
    } else if (isInserting) {
      context.missing(_platformMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PushToken map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PushToken(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      token: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}token'],
      )!,
      platform: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $PushTokensTable createAlias(String alias) {
    return $PushTokensTable(attachedDatabase, alias);
  }
}

class PushToken extends DataClass implements Insertable<PushToken> {
  final String id;
  final String userId;
  final String token;
  final String platform;
  final DateTime createdAt;
  final DateTime updatedAt;
  const PushToken({
    required this.id,
    required this.userId,
    required this.token,
    required this.platform,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['user_id'] = Variable<String>(userId);
    map['token'] = Variable<String>(token);
    map['platform'] = Variable<String>(platform);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  PushTokensCompanion toCompanion(bool nullToAbsent) {
    return PushTokensCompanion(
      id: Value(id),
      userId: Value(userId),
      token: Value(token),
      platform: Value(platform),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory PushToken.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PushToken(
      id: serializer.fromJson<String>(json['id']),
      userId: serializer.fromJson<String>(json['userId']),
      token: serializer.fromJson<String>(json['token']),
      platform: serializer.fromJson<String>(json['platform']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'userId': serializer.toJson<String>(userId),
      'token': serializer.toJson<String>(token),
      'platform': serializer.toJson<String>(platform),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  PushToken copyWith({
    String? id,
    String? userId,
    String? token,
    String? platform,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => PushToken(
    id: id ?? this.id,
    userId: userId ?? this.userId,
    token: token ?? this.token,
    platform: platform ?? this.platform,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  PushToken copyWithCompanion(PushTokensCompanion data) {
    return PushToken(
      id: data.id.present ? data.id.value : this.id,
      userId: data.userId.present ? data.userId.value : this.userId,
      token: data.token.present ? data.token.value : this.token,
      platform: data.platform.present ? data.platform.value : this.platform,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PushToken(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('token: $token, ')
          ..write('platform: $platform, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, userId, token, platform, createdAt, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PushToken &&
          other.id == this.id &&
          other.userId == this.userId &&
          other.token == this.token &&
          other.platform == this.platform &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class PushTokensCompanion extends UpdateCompanion<PushToken> {
  final Value<String> id;
  final Value<String> userId;
  final Value<String> token;
  final Value<String> platform;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const PushTokensCompanion({
    this.id = const Value.absent(),
    this.userId = const Value.absent(),
    this.token = const Value.absent(),
    this.platform = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PushTokensCompanion.insert({
    required String id,
    required String userId,
    required String token,
    required String platform,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       userId = Value(userId),
       token = Value(token),
       platform = Value(platform),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<PushToken> custom({
    Expression<String>? id,
    Expression<String>? userId,
    Expression<String>? token,
    Expression<String>? platform,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (userId != null) 'user_id': userId,
      if (token != null) 'token': token,
      if (platform != null) 'platform': platform,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PushTokensCompanion copyWith({
    Value<String>? id,
    Value<String>? userId,
    Value<String>? token,
    Value<String>? platform,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return PushTokensCompanion(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      token: token ?? this.token,
      platform: platform ?? this.platform,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (platform.present) {
      map['platform'] = Variable<String>(platform.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PushTokensCompanion(')
          ..write('id: $id, ')
          ..write('userId: $userId, ')
          ..write('token: $token, ')
          ..write('platform: $platform, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NetWorthSnapshotsTable extends NetWorthSnapshots
    with TableInfo<$NetWorthSnapshotsTable, NetWorthSnapshot> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NetWorthSnapshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _budgetIdMeta = const VerificationMeta(
    'budgetId',
  );
  @override
  late final GeneratedColumn<String> budgetId = GeneratedColumn<String>(
    'budget_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _assetsMeta = const VerificationMeta('assets');
  @override
  late final GeneratedColumn<int> assets = GeneratedColumn<int>(
    'assets',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _liabilitiesMeta = const VerificationMeta(
    'liabilities',
  );
  @override
  late final GeneratedColumn<int> liabilities = GeneratedColumn<int>(
    'liabilities',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _netWorthMeta = const VerificationMeta(
    'netWorth',
  );
  @override
  late final GeneratedColumn<int> netWorth = GeneratedColumn<int>(
    'net_worth',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    budgetId,
    date,
    assets,
    liabilities,
    netWorth,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'net_worth_snapshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<NetWorthSnapshot> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('budget_id')) {
      context.handle(
        _budgetIdMeta,
        budgetId.isAcceptableOrUnknown(data['budget_id']!, _budgetIdMeta),
      );
    } else if (isInserting) {
      context.missing(_budgetIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('assets')) {
      context.handle(
        _assetsMeta,
        assets.isAcceptableOrUnknown(data['assets']!, _assetsMeta),
      );
    } else if (isInserting) {
      context.missing(_assetsMeta);
    }
    if (data.containsKey('liabilities')) {
      context.handle(
        _liabilitiesMeta,
        liabilities.isAcceptableOrUnknown(
          data['liabilities']!,
          _liabilitiesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_liabilitiesMeta);
    }
    if (data.containsKey('net_worth')) {
      context.handle(
        _netWorthMeta,
        netWorth.isAcceptableOrUnknown(data['net_worth']!, _netWorthMeta),
      );
    } else if (isInserting) {
      context.missing(_netWorthMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NetWorthSnapshot map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NetWorthSnapshot(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      budgetId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}budget_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      assets: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}assets'],
      )!,
      liabilities: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}liabilities'],
      )!,
      netWorth: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}net_worth'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $NetWorthSnapshotsTable createAlias(String alias) {
    return $NetWorthSnapshotsTable(attachedDatabase, alias);
  }
}

class NetWorthSnapshot extends DataClass
    implements Insertable<NetWorthSnapshot> {
  final String id;
  final String budgetId;
  final DateTime date;
  final int assets;
  final int liabilities;
  final int netWorth;
  final DateTime createdAt;
  const NetWorthSnapshot({
    required this.id,
    required this.budgetId,
    required this.date,
    required this.assets,
    required this.liabilities,
    required this.netWorth,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['budget_id'] = Variable<String>(budgetId);
    map['date'] = Variable<DateTime>(date);
    map['assets'] = Variable<int>(assets);
    map['liabilities'] = Variable<int>(liabilities);
    map['net_worth'] = Variable<int>(netWorth);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  NetWorthSnapshotsCompanion toCompanion(bool nullToAbsent) {
    return NetWorthSnapshotsCompanion(
      id: Value(id),
      budgetId: Value(budgetId),
      date: Value(date),
      assets: Value(assets),
      liabilities: Value(liabilities),
      netWorth: Value(netWorth),
      createdAt: Value(createdAt),
    );
  }

  factory NetWorthSnapshot.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NetWorthSnapshot(
      id: serializer.fromJson<String>(json['id']),
      budgetId: serializer.fromJson<String>(json['budgetId']),
      date: serializer.fromJson<DateTime>(json['date']),
      assets: serializer.fromJson<int>(json['assets']),
      liabilities: serializer.fromJson<int>(json['liabilities']),
      netWorth: serializer.fromJson<int>(json['netWorth']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'budgetId': serializer.toJson<String>(budgetId),
      'date': serializer.toJson<DateTime>(date),
      'assets': serializer.toJson<int>(assets),
      'liabilities': serializer.toJson<int>(liabilities),
      'netWorth': serializer.toJson<int>(netWorth),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  NetWorthSnapshot copyWith({
    String? id,
    String? budgetId,
    DateTime? date,
    int? assets,
    int? liabilities,
    int? netWorth,
    DateTime? createdAt,
  }) => NetWorthSnapshot(
    id: id ?? this.id,
    budgetId: budgetId ?? this.budgetId,
    date: date ?? this.date,
    assets: assets ?? this.assets,
    liabilities: liabilities ?? this.liabilities,
    netWorth: netWorth ?? this.netWorth,
    createdAt: createdAt ?? this.createdAt,
  );
  NetWorthSnapshot copyWithCompanion(NetWorthSnapshotsCompanion data) {
    return NetWorthSnapshot(
      id: data.id.present ? data.id.value : this.id,
      budgetId: data.budgetId.present ? data.budgetId.value : this.budgetId,
      date: data.date.present ? data.date.value : this.date,
      assets: data.assets.present ? data.assets.value : this.assets,
      liabilities: data.liabilities.present
          ? data.liabilities.value
          : this.liabilities,
      netWorth: data.netWorth.present ? data.netWorth.value : this.netWorth,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NetWorthSnapshot(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('date: $date, ')
          ..write('assets: $assets, ')
          ..write('liabilities: $liabilities, ')
          ..write('netWorth: $netWorth, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, budgetId, date, assets, liabilities, netWorth, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NetWorthSnapshot &&
          other.id == this.id &&
          other.budgetId == this.budgetId &&
          other.date == this.date &&
          other.assets == this.assets &&
          other.liabilities == this.liabilities &&
          other.netWorth == this.netWorth &&
          other.createdAt == this.createdAt);
}

class NetWorthSnapshotsCompanion extends UpdateCompanion<NetWorthSnapshot> {
  final Value<String> id;
  final Value<String> budgetId;
  final Value<DateTime> date;
  final Value<int> assets;
  final Value<int> liabilities;
  final Value<int> netWorth;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const NetWorthSnapshotsCompanion({
    this.id = const Value.absent(),
    this.budgetId = const Value.absent(),
    this.date = const Value.absent(),
    this.assets = const Value.absent(),
    this.liabilities = const Value.absent(),
    this.netWorth = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NetWorthSnapshotsCompanion.insert({
    required String id,
    required String budgetId,
    required DateTime date,
    required int assets,
    required int liabilities,
    required int netWorth,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       budgetId = Value(budgetId),
       date = Value(date),
       assets = Value(assets),
       liabilities = Value(liabilities),
       netWorth = Value(netWorth),
       createdAt = Value(createdAt);
  static Insertable<NetWorthSnapshot> custom({
    Expression<String>? id,
    Expression<String>? budgetId,
    Expression<DateTime>? date,
    Expression<int>? assets,
    Expression<int>? liabilities,
    Expression<int>? netWorth,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (budgetId != null) 'budget_id': budgetId,
      if (date != null) 'date': date,
      if (assets != null) 'assets': assets,
      if (liabilities != null) 'liabilities': liabilities,
      if (netWorth != null) 'net_worth': netWorth,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NetWorthSnapshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? budgetId,
    Value<DateTime>? date,
    Value<int>? assets,
    Value<int>? liabilities,
    Value<int>? netWorth,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return NetWorthSnapshotsCompanion(
      id: id ?? this.id,
      budgetId: budgetId ?? this.budgetId,
      date: date ?? this.date,
      assets: assets ?? this.assets,
      liabilities: liabilities ?? this.liabilities,
      netWorth: netWorth ?? this.netWorth,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (budgetId.present) {
      map['budget_id'] = Variable<String>(budgetId.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (assets.present) {
      map['assets'] = Variable<int>(assets.value);
    }
    if (liabilities.present) {
      map['liabilities'] = Variable<int>(liabilities.value);
    }
    if (netWorth.present) {
      map['net_worth'] = Variable<int>(netWorth.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NetWorthSnapshotsCompanion(')
          ..write('id: $id, ')
          ..write('budgetId: $budgetId, ')
          ..write('date: $date, ')
          ..write('assets: $assets, ')
          ..write('liabilities: $liabilities, ')
          ..write('netWorth: $netWorth, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SyncMetadataTable extends SyncMetadata
    with TableInfo<$SyncMetadataTable, SyncMetadataData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SyncMetadataTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncTableNameMeta = const VerificationMeta(
    'syncTableName',
  );
  @override
  late final GeneratedColumn<String> syncTableName = GeneratedColumn<String>(
    'table_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordIdMeta = const VerificationMeta(
    'recordId',
  );
  @override
  late final GeneratedColumn<String> recordId = GeneratedColumn<String>(
    'record_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastModifiedMeta = const VerificationMeta(
    'lastModified',
  );
  @override
  late final GeneratedColumn<DateTime> lastModified = GeneratedColumn<DateTime>(
    'last_modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isDeletedMeta = const VerificationMeta(
    'isDeleted',
  );
  @override
  late final GeneratedColumn<bool> isDeleted = GeneratedColumn<bool>(
    'is_deleted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_deleted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _deviceIdMeta = const VerificationMeta(
    'deviceId',
  );
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
    'device_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    syncTableName,
    recordId,
    lastModified,
    isDeleted,
    deviceId,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sync_metadata';
  @override
  VerificationContext validateIntegrity(
    Insertable<SyncMetadataData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('table_name')) {
      context.handle(
        _syncTableNameMeta,
        syncTableName.isAcceptableOrUnknown(
          data['table_name']!,
          _syncTableNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_syncTableNameMeta);
    }
    if (data.containsKey('record_id')) {
      context.handle(
        _recordIdMeta,
        recordId.isAcceptableOrUnknown(data['record_id']!, _recordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recordIdMeta);
    }
    if (data.containsKey('last_modified')) {
      context.handle(
        _lastModifiedMeta,
        lastModified.isAcceptableOrUnknown(
          data['last_modified']!,
          _lastModifiedMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_lastModifiedMeta);
    }
    if (data.containsKey('is_deleted')) {
      context.handle(
        _isDeletedMeta,
        isDeleted.isAcceptableOrUnknown(data['is_deleted']!, _isDeletedMeta),
      );
    }
    if (data.containsKey('device_id')) {
      context.handle(
        _deviceIdMeta,
        deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SyncMetadataData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SyncMetadataData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      syncTableName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}table_name'],
      )!,
      recordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}record_id'],
      )!,
      lastModified: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_modified'],
      )!,
      isDeleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_deleted'],
      )!,
      deviceId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}device_id'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $SyncMetadataTable createAlias(String alias) {
    return $SyncMetadataTable(attachedDatabase, alias);
  }
}

class SyncMetadataData extends DataClass
    implements Insertable<SyncMetadataData> {
  final String id;
  final String syncTableName;
  final String recordId;
  final DateTime lastModified;
  final bool isDeleted;
  final String deviceId;
  final String syncStatus;
  const SyncMetadataData({
    required this.id,
    required this.syncTableName,
    required this.recordId,
    required this.lastModified,
    required this.isDeleted,
    required this.deviceId,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['table_name'] = Variable<String>(syncTableName);
    map['record_id'] = Variable<String>(recordId);
    map['last_modified'] = Variable<DateTime>(lastModified);
    map['is_deleted'] = Variable<bool>(isDeleted);
    map['device_id'] = Variable<String>(deviceId);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  SyncMetadataCompanion toCompanion(bool nullToAbsent) {
    return SyncMetadataCompanion(
      id: Value(id),
      syncTableName: Value(syncTableName),
      recordId: Value(recordId),
      lastModified: Value(lastModified),
      isDeleted: Value(isDeleted),
      deviceId: Value(deviceId),
      syncStatus: Value(syncStatus),
    );
  }

  factory SyncMetadataData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SyncMetadataData(
      id: serializer.fromJson<String>(json['id']),
      syncTableName: serializer.fromJson<String>(json['syncTableName']),
      recordId: serializer.fromJson<String>(json['recordId']),
      lastModified: serializer.fromJson<DateTime>(json['lastModified']),
      isDeleted: serializer.fromJson<bool>(json['isDeleted']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'syncTableName': serializer.toJson<String>(syncTableName),
      'recordId': serializer.toJson<String>(recordId),
      'lastModified': serializer.toJson<DateTime>(lastModified),
      'isDeleted': serializer.toJson<bool>(isDeleted),
      'deviceId': serializer.toJson<String>(deviceId),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  SyncMetadataData copyWith({
    String? id,
    String? syncTableName,
    String? recordId,
    DateTime? lastModified,
    bool? isDeleted,
    String? deviceId,
    String? syncStatus,
  }) => SyncMetadataData(
    id: id ?? this.id,
    syncTableName: syncTableName ?? this.syncTableName,
    recordId: recordId ?? this.recordId,
    lastModified: lastModified ?? this.lastModified,
    isDeleted: isDeleted ?? this.isDeleted,
    deviceId: deviceId ?? this.deviceId,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  SyncMetadataData copyWithCompanion(SyncMetadataCompanion data) {
    return SyncMetadataData(
      id: data.id.present ? data.id.value : this.id,
      syncTableName: data.syncTableName.present
          ? data.syncTableName.value
          : this.syncTableName,
      recordId: data.recordId.present ? data.recordId.value : this.recordId,
      lastModified: data.lastModified.present
          ? data.lastModified.value
          : this.lastModified,
      isDeleted: data.isDeleted.present ? data.isDeleted.value : this.isDeleted,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataData(')
          ..write('id: $id, ')
          ..write('syncTableName: $syncTableName, ')
          ..write('recordId: $recordId, ')
          ..write('lastModified: $lastModified, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    syncTableName,
    recordId,
    lastModified,
    isDeleted,
    deviceId,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SyncMetadataData &&
          other.id == this.id &&
          other.syncTableName == this.syncTableName &&
          other.recordId == this.recordId &&
          other.lastModified == this.lastModified &&
          other.isDeleted == this.isDeleted &&
          other.deviceId == this.deviceId &&
          other.syncStatus == this.syncStatus);
}

class SyncMetadataCompanion extends UpdateCompanion<SyncMetadataData> {
  final Value<String> id;
  final Value<String> syncTableName;
  final Value<String> recordId;
  final Value<DateTime> lastModified;
  final Value<bool> isDeleted;
  final Value<String> deviceId;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const SyncMetadataCompanion({
    this.id = const Value.absent(),
    this.syncTableName = const Value.absent(),
    this.recordId = const Value.absent(),
    this.lastModified = const Value.absent(),
    this.isDeleted = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SyncMetadataCompanion.insert({
    required String id,
    required String syncTableName,
    required String recordId,
    required DateTime lastModified,
    this.isDeleted = const Value.absent(),
    required String deviceId,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       syncTableName = Value(syncTableName),
       recordId = Value(recordId),
       lastModified = Value(lastModified),
       deviceId = Value(deviceId);
  static Insertable<SyncMetadataData> custom({
    Expression<String>? id,
    Expression<String>? syncTableName,
    Expression<String>? recordId,
    Expression<DateTime>? lastModified,
    Expression<bool>? isDeleted,
    Expression<String>? deviceId,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (syncTableName != null) 'table_name': syncTableName,
      if (recordId != null) 'record_id': recordId,
      if (lastModified != null) 'last_modified': lastModified,
      if (isDeleted != null) 'is_deleted': isDeleted,
      if (deviceId != null) 'device_id': deviceId,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SyncMetadataCompanion copyWith({
    Value<String>? id,
    Value<String>? syncTableName,
    Value<String>? recordId,
    Value<DateTime>? lastModified,
    Value<bool>? isDeleted,
    Value<String>? deviceId,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return SyncMetadataCompanion(
      id: id ?? this.id,
      syncTableName: syncTableName ?? this.syncTableName,
      recordId: recordId ?? this.recordId,
      lastModified: lastModified ?? this.lastModified,
      isDeleted: isDeleted ?? this.isDeleted,
      deviceId: deviceId ?? this.deviceId,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (syncTableName.present) {
      map['table_name'] = Variable<String>(syncTableName.value);
    }
    if (recordId.present) {
      map['record_id'] = Variable<String>(recordId.value);
    }
    if (lastModified.present) {
      map['last_modified'] = Variable<DateTime>(lastModified.value);
    }
    if (isDeleted.present) {
      map['is_deleted'] = Variable<bool>(isDeleted.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SyncMetadataCompanion(')
          ..write('id: $id, ')
          ..write('syncTableName: $syncTableName, ')
          ..write('recordId: $recordId, ')
          ..write('lastModified: $lastModified, ')
          ..write('isDeleted: $isDeleted, ')
          ..write('deviceId: $deviceId, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UsersTable users = $UsersTable(this);
  late final $BudgetsTable budgets = $BudgetsTable(this);
  late final $BudgetMembersTable budgetMembers = $BudgetMembersTable(this);
  late final $BudgetPeriodsTable budgetPeriods = $BudgetPeriodsTable(this);
  late final $AccountsTable accounts = $AccountsTable(this);
  late final $CategoryGroupsTable categoryGroups = $CategoryGroupsTable(this);
  late final $EnvelopesTable envelopes = $EnvelopesTable(this);
  late final $EnvelopeAllocationsTable envelopeAllocations =
      $EnvelopeAllocationsTable(this);
  late final $TransactionsTable transactions = $TransactionsTable(this);
  late final $TransactionSplitsTable transactionSplits =
      $TransactionSplitsTable(this);
  late final $TagsTable tags = $TagsTable(this);
  late final $TransactionTagsTable transactionTags = $TransactionTagsTable(
    this,
  );
  late final $RecurringRulesTable recurringRules = $RecurringRulesTable(this);
  late final $BillRemindersTable billReminders = $BillRemindersTable(this);
  late final $AllocationTemplatesTable allocationTemplates =
      $AllocationTemplatesTable(this);
  late final $AllocationTemplateItemsTable allocationTemplateItems =
      $AllocationTemplateItemsTable(this);
  late final $GoalsTable goals = $GoalsTable(this);
  late final $GoalContributionsTable goalContributions =
      $GoalContributionsTable(this);
  late final $DebtAccountsTable debtAccounts = $DebtAccountsTable(this);
  late final $ActivityLogTable activityLog = $ActivityLogTable(this);
  late final $NotificationPreferencesTable notificationPreferences =
      $NotificationPreferencesTable(this);
  late final $PushTokensTable pushTokens = $PushTokensTable(this);
  late final $NetWorthSnapshotsTable netWorthSnapshots =
      $NetWorthSnapshotsTable(this);
  late final $SyncMetadataTable syncMetadata = $SyncMetadataTable(this);
  late final UsersDao usersDao = UsersDao(this as AppDatabase);
  late final BudgetsDao budgetsDao = BudgetsDao(this as AppDatabase);
  late final AccountsDao accountsDao = AccountsDao(this as AppDatabase);
  late final EnvelopesDao envelopesDao = EnvelopesDao(this as AppDatabase);
  late final TransactionsDao transactionsDao = TransactionsDao(
    this as AppDatabase,
  );
  late final RecurringDao recurringDao = RecurringDao(this as AppDatabase);
  late final GoalsDao goalsDao = GoalsDao(this as AppDatabase);
  late final ReportsDao reportsDao = ReportsDao(this as AppDatabase);
  late final SyncDao syncDao = SyncDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    users,
    budgets,
    budgetMembers,
    budgetPeriods,
    accounts,
    categoryGroups,
    envelopes,
    envelopeAllocations,
    transactions,
    transactionSplits,
    tags,
    transactionTags,
    recurringRules,
    billReminders,
    allocationTemplates,
    allocationTemplateItems,
    goals,
    goalContributions,
    debtAccounts,
    activityLog,
    notificationPreferences,
    pushTokens,
    netWorthSnapshots,
    syncMetadata,
  ];
}

typedef $$UsersTableCreateCompanionBuilder =
    UsersCompanion Function({
      required String id,
      required String email,
      required String displayName,
      Value<String> baseCurrency,
      Value<String> themeMode,
      Value<String?> accentColor,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$UsersTableUpdateCompanionBuilder =
    UsersCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<String> displayName,
      Value<String> baseCurrency,
      Value<String> themeMode,
      Value<String?> accentColor,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$UsersTableFilterComposer extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UsersTableOrderingComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UsersTableAnnotationComposer
    extends Composer<_$AppDatabase, $UsersTable> {
  $$UsersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<String> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumn<String> get accentColor => $composableBuilder(
    column: $table.accentColor,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$UsersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UsersTable,
          User,
          $$UsersTableFilterComposer,
          $$UsersTableOrderingComposer,
          $$UsersTableAnnotationComposer,
          $$UsersTableCreateCompanionBuilder,
          $$UsersTableUpdateCompanionBuilder,
          (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
          User,
          PrefetchHooks Function()
        > {
  $$UsersTableTableManager(_$AppDatabase db, $UsersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UsersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UsersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UsersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> displayName = const Value.absent(),
                Value<String> baseCurrency = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> accentColor = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion(
                id: id,
                email: email,
                displayName: displayName,
                baseCurrency: baseCurrency,
                themeMode: themeMode,
                accentColor: accentColor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required String displayName,
                Value<String> baseCurrency = const Value.absent(),
                Value<String> themeMode = const Value.absent(),
                Value<String?> accentColor = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => UsersCompanion.insert(
                id: id,
                email: email,
                displayName: displayName,
                baseCurrency: baseCurrency,
                themeMode: themeMode,
                accentColor: accentColor,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UsersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UsersTable,
      User,
      $$UsersTableFilterComposer,
      $$UsersTableOrderingComposer,
      $$UsersTableAnnotationComposer,
      $$UsersTableCreateCompanionBuilder,
      $$UsersTableUpdateCompanionBuilder,
      (User, BaseReferences<_$AppDatabase, $UsersTable, User>),
      User,
      PrefetchHooks Function()
    >;
typedef $$BudgetsTableCreateCompanionBuilder =
    BudgetsCompanion Function({
      required String id,
      required String ownerId,
      required String name,
      Value<String> periodType,
      Value<int> periodStartDay,
      required String baseCurrency,
      Value<bool> isArchived,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$BudgetsTableUpdateCompanionBuilder =
    BudgetsCompanion Function({
      Value<String> id,
      Value<String> ownerId,
      Value<String> name,
      Value<String> periodType,
      Value<int> periodStartDay,
      Value<String> baseCurrency,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$BudgetsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get periodStartDay => $composableBuilder(
    column: $table.periodStartDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get ownerId => $composableBuilder(
    column: $table.ownerId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get periodStartDay => $composableBuilder(
    column: $table.periodStartDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetsTable> {
  $$BudgetsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get ownerId =>
      $composableBuilder(column: $table.ownerId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get periodType => $composableBuilder(
    column: $table.periodType,
    builder: (column) => column,
  );

  GeneratedColumn<int> get periodStartDay => $composableBuilder(
    column: $table.periodStartDay,
    builder: (column) => column,
  );

  GeneratedColumn<String> get baseCurrency => $composableBuilder(
    column: $table.baseCurrency,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$BudgetsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetsTable,
          Budget,
          $$BudgetsTableFilterComposer,
          $$BudgetsTableOrderingComposer,
          $$BudgetsTableAnnotationComposer,
          $$BudgetsTableCreateCompanionBuilder,
          $$BudgetsTableUpdateCompanionBuilder,
          (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
          Budget,
          PrefetchHooks Function()
        > {
  $$BudgetsTableTableManager(_$AppDatabase db, $BudgetsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> ownerId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> periodType = const Value.absent(),
                Value<int> periodStartDay = const Value.absent(),
                Value<String> baseCurrency = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion(
                id: id,
                ownerId: ownerId,
                name: name,
                periodType: periodType,
                periodStartDay: periodStartDay,
                baseCurrency: baseCurrency,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String ownerId,
                required String name,
                Value<String> periodType = const Value.absent(),
                Value<int> periodStartDay = const Value.absent(),
                required String baseCurrency,
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetsCompanion.insert(
                id: id,
                ownerId: ownerId,
                name: name,
                periodType: periodType,
                periodStartDay: periodStartDay,
                baseCurrency: baseCurrency,
                isArchived: isArchived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetsTable,
      Budget,
      $$BudgetsTableFilterComposer,
      $$BudgetsTableOrderingComposer,
      $$BudgetsTableAnnotationComposer,
      $$BudgetsTableCreateCompanionBuilder,
      $$BudgetsTableUpdateCompanionBuilder,
      (Budget, BaseReferences<_$AppDatabase, $BudgetsTable, Budget>),
      Budget,
      PrefetchHooks Function()
    >;
typedef $$BudgetMembersTableCreateCompanionBuilder =
    BudgetMembersCompanion Function({
      required String id,
      required String budgetId,
      Value<String?> userId,
      Value<String> role,
      required String invitedVia,
      Value<DateTime?> acceptedAt,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BudgetMembersTableUpdateCompanionBuilder =
    BudgetMembersCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String?> userId,
      Value<String> role,
      Value<String> invitedVia,
      Value<DateTime?> acceptedAt,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BudgetMembersTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetMembersTable> {
  $$BudgetMembersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get invitedVia => $composableBuilder(
    column: $table.invitedVia,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetMembersTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetMembersTable> {
  $$BudgetMembersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get role => $composableBuilder(
    column: $table.role,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get invitedVia => $composableBuilder(
    column: $table.invitedVia,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetMembersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetMembersTable> {
  $$BudgetMembersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get role =>
      $composableBuilder(column: $table.role, builder: (column) => column);

  GeneratedColumn<String> get invitedVia => $composableBuilder(
    column: $table.invitedVia,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get acceptedAt => $composableBuilder(
    column: $table.acceptedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BudgetMembersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetMembersTable,
          BudgetMember,
          $$BudgetMembersTableFilterComposer,
          $$BudgetMembersTableOrderingComposer,
          $$BudgetMembersTableAnnotationComposer,
          $$BudgetMembersTableCreateCompanionBuilder,
          $$BudgetMembersTableUpdateCompanionBuilder,
          (
            BudgetMember,
            BaseReferences<_$AppDatabase, $BudgetMembersTable, BudgetMember>,
          ),
          BudgetMember,
          PrefetchHooks Function()
        > {
  $$BudgetMembersTableTableManager(_$AppDatabase db, $BudgetMembersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetMembersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetMembersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetMembersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String?> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                Value<String> invitedVia = const Value.absent(),
                Value<DateTime?> acceptedAt = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetMembersCompanion(
                id: id,
                budgetId: budgetId,
                userId: userId,
                role: role,
                invitedVia: invitedVia,
                acceptedAt: acceptedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                Value<String?> userId = const Value.absent(),
                Value<String> role = const Value.absent(),
                required String invitedVia,
                Value<DateTime?> acceptedAt = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetMembersCompanion.insert(
                id: id,
                budgetId: budgetId,
                userId: userId,
                role: role,
                invitedVia: invitedVia,
                acceptedAt: acceptedAt,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetMembersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetMembersTable,
      BudgetMember,
      $$BudgetMembersTableFilterComposer,
      $$BudgetMembersTableOrderingComposer,
      $$BudgetMembersTableAnnotationComposer,
      $$BudgetMembersTableCreateCompanionBuilder,
      $$BudgetMembersTableUpdateCompanionBuilder,
      (
        BudgetMember,
        BaseReferences<_$AppDatabase, $BudgetMembersTable, BudgetMember>,
      ),
      BudgetMember,
      PrefetchHooks Function()
    >;
typedef $$BudgetPeriodsTableCreateCompanionBuilder =
    BudgetPeriodsCompanion Function({
      required String id,
      required String budgetId,
      required DateTime startDate,
      required DateTime endDate,
      Value<int> totalIncome,
      Value<int> totalAllocated,
      Value<bool> isClosed,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BudgetPeriodsTableUpdateCompanionBuilder =
    BudgetPeriodsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<DateTime> startDate,
      Value<DateTime> endDate,
      Value<int> totalIncome,
      Value<int> totalAllocated,
      Value<bool> isClosed,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BudgetPeriodsTableFilterComposer
    extends Composer<_$AppDatabase, $BudgetPeriodsTable> {
  $$BudgetPeriodsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalAllocated => $composableBuilder(
    column: $table.totalAllocated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BudgetPeriodsTableOrderingComposer
    extends Composer<_$AppDatabase, $BudgetPeriodsTable> {
  $$BudgetPeriodsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalAllocated => $composableBuilder(
    column: $table.totalAllocated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isClosed => $composableBuilder(
    column: $table.isClosed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BudgetPeriodsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BudgetPeriodsTable> {
  $$BudgetPeriodsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<int> get totalIncome => $composableBuilder(
    column: $table.totalIncome,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalAllocated => $composableBuilder(
    column: $table.totalAllocated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isClosed =>
      $composableBuilder(column: $table.isClosed, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BudgetPeriodsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BudgetPeriodsTable,
          BudgetPeriod,
          $$BudgetPeriodsTableFilterComposer,
          $$BudgetPeriodsTableOrderingComposer,
          $$BudgetPeriodsTableAnnotationComposer,
          $$BudgetPeriodsTableCreateCompanionBuilder,
          $$BudgetPeriodsTableUpdateCompanionBuilder,
          (
            BudgetPeriod,
            BaseReferences<_$AppDatabase, $BudgetPeriodsTable, BudgetPeriod>,
          ),
          BudgetPeriod,
          PrefetchHooks Function()
        > {
  $$BudgetPeriodsTableTableManager(_$AppDatabase db, $BudgetPeriodsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BudgetPeriodsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BudgetPeriodsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BudgetPeriodsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime> endDate = const Value.absent(),
                Value<int> totalIncome = const Value.absent(),
                Value<int> totalAllocated = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BudgetPeriodsCompanion(
                id: id,
                budgetId: budgetId,
                startDate: startDate,
                endDate: endDate,
                totalIncome: totalIncome,
                totalAllocated: totalAllocated,
                isClosed: isClosed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required DateTime startDate,
                required DateTime endDate,
                Value<int> totalIncome = const Value.absent(),
                Value<int> totalAllocated = const Value.absent(),
                Value<bool> isClosed = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BudgetPeriodsCompanion.insert(
                id: id,
                budgetId: budgetId,
                startDate: startDate,
                endDate: endDate,
                totalIncome: totalIncome,
                totalAllocated: totalAllocated,
                isClosed: isClosed,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BudgetPeriodsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BudgetPeriodsTable,
      BudgetPeriod,
      $$BudgetPeriodsTableFilterComposer,
      $$BudgetPeriodsTableOrderingComposer,
      $$BudgetPeriodsTableAnnotationComposer,
      $$BudgetPeriodsTableCreateCompanionBuilder,
      $$BudgetPeriodsTableUpdateCompanionBuilder,
      (
        BudgetPeriod,
        BaseReferences<_$AppDatabase, $BudgetPeriodsTable, BudgetPeriod>,
      ),
      BudgetPeriod,
      PrefetchHooks Function()
    >;
typedef $$AccountsTableCreateCompanionBuilder =
    AccountsCompanion Function({
      required String id,
      required String budgetId,
      required String name,
      required String type,
      Value<int> startingBalance,
      Value<int> currentBalance,
      required String currency,
      Value<bool> isArchived,
      Value<bool> isOnBudget,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AccountsTableUpdateCompanionBuilder =
    AccountsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> name,
      Value<String> type,
      Value<int> startingBalance,
      Value<int> currentBalance,
      Value<String> currency,
      Value<bool> isArchived,
      Value<bool> isOnBudget,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AccountsTableFilterComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startingBalance => $composableBuilder(
    column: $table.startingBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnBudget => $composableBuilder(
    column: $table.isOnBudget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startingBalance => $composableBuilder(
    column: $table.startingBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnBudget => $composableBuilder(
    column: $table.isOnBudget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AccountsTable> {
  $$AccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get startingBalance => $composableBuilder(
    column: $table.startingBalance,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentBalance => $composableBuilder(
    column: $table.currentBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isOnBudget => $composableBuilder(
    column: $table.isOnBudget,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AccountsTable,
          Account,
          $$AccountsTableFilterComposer,
          $$AccountsTableOrderingComposer,
          $$AccountsTableAnnotationComposer,
          $$AccountsTableCreateCompanionBuilder,
          $$AccountsTableUpdateCompanionBuilder,
          (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
          Account,
          PrefetchHooks Function()
        > {
  $$AccountsTableTableManager(_$AppDatabase db, $AccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> startingBalance = const Value.absent(),
                Value<int> currentBalance = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isOnBudget = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion(
                id: id,
                budgetId: budgetId,
                name: name,
                type: type,
                startingBalance: startingBalance,
                currentBalance: currentBalance,
                currency: currency,
                isArchived: isArchived,
                isOnBudget: isOnBudget,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String name,
                required String type,
                Value<int> startingBalance = const Value.absent(),
                Value<int> currentBalance = const Value.absent(),
                required String currency,
                Value<bool> isArchived = const Value.absent(),
                Value<bool> isOnBudget = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AccountsCompanion.insert(
                id: id,
                budgetId: budgetId,
                name: name,
                type: type,
                startingBalance: startingBalance,
                currentBalance: currentBalance,
                currency: currency,
                isArchived: isArchived,
                isOnBudget: isOnBudget,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AccountsTable,
      Account,
      $$AccountsTableFilterComposer,
      $$AccountsTableOrderingComposer,
      $$AccountsTableAnnotationComposer,
      $$AccountsTableCreateCompanionBuilder,
      $$AccountsTableUpdateCompanionBuilder,
      (Account, BaseReferences<_$AppDatabase, $AccountsTable, Account>),
      Account,
      PrefetchHooks Function()
    >;
typedef $$CategoryGroupsTableCreateCompanionBuilder =
    CategoryGroupsCompanion Function({
      required String id,
      required String budgetId,
      required String name,
      Value<int> sortOrder,
      Value<bool> isDefault,
      Value<bool> isArchived,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$CategoryGroupsTableUpdateCompanionBuilder =
    CategoryGroupsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isDefault,
      Value<bool> isArchived,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$CategoryGroupsTableFilterComposer
    extends Composer<_$AppDatabase, $CategoryGroupsTable> {
  $$CategoryGroupsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CategoryGroupsTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoryGroupsTable> {
  $$CategoryGroupsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoryGroupsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoryGroupsTable> {
  $$CategoryGroupsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$CategoryGroupsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoryGroupsTable,
          CategoryGroup,
          $$CategoryGroupsTableFilterComposer,
          $$CategoryGroupsTableOrderingComposer,
          $$CategoryGroupsTableAnnotationComposer,
          $$CategoryGroupsTableCreateCompanionBuilder,
          $$CategoryGroupsTableUpdateCompanionBuilder,
          (
            CategoryGroup,
            BaseReferences<_$AppDatabase, $CategoryGroupsTable, CategoryGroup>,
          ),
          CategoryGroup,
          PrefetchHooks Function()
        > {
  $$CategoryGroupsTableTableManager(
    _$AppDatabase db,
    $CategoryGroupsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoryGroupsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoryGroupsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoryGroupsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoryGroupsCompanion(
                id: id,
                budgetId: budgetId,
                name: name,
                sortOrder: sortOrder,
                isDefault: isDefault,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => CategoryGroupsCompanion.insert(
                id: id,
                budgetId: budgetId,
                name: name,
                sortOrder: sortOrder,
                isDefault: isDefault,
                isArchived: isArchived,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CategoryGroupsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoryGroupsTable,
      CategoryGroup,
      $$CategoryGroupsTableFilterComposer,
      $$CategoryGroupsTableOrderingComposer,
      $$CategoryGroupsTableAnnotationComposer,
      $$CategoryGroupsTableCreateCompanionBuilder,
      $$CategoryGroupsTableUpdateCompanionBuilder,
      (
        CategoryGroup,
        BaseReferences<_$AppDatabase, $CategoryGroupsTable, CategoryGroup>,
      ),
      CategoryGroup,
      PrefetchHooks Function()
    >;
typedef $$EnvelopesTableCreateCompanionBuilder =
    EnvelopesCompanion Function({
      required String id,
      required String categoryGroupId,
      required String budgetId,
      required String name,
      Value<int> sortOrder,
      Value<bool> isArchived,
      Value<String?> color,
      Value<String?> linkedAccountId,
      required DateTime createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$EnvelopesTableUpdateCompanionBuilder =
    EnvelopesCompanion Function({
      Value<String> id,
      Value<String> categoryGroupId,
      Value<String> budgetId,
      Value<String> name,
      Value<int> sortOrder,
      Value<bool> isArchived,
      Value<String?> color,
      Value<String?> linkedAccountId,
      Value<DateTime> createdAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$EnvelopesTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopesTable> {
  $$EnvelopesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnvelopesTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopesTable> {
  $$EnvelopesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnvelopesTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopesTable> {
  $$EnvelopesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get categoryGroupId => $composableBuilder(
    column: $table.categoryGroupId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<bool> get isArchived => $composableBuilder(
    column: $table.isArchived,
    builder: (column) => column,
  );

  GeneratedColumn<String> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<String> get linkedAccountId => $composableBuilder(
    column: $table.linkedAccountId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$EnvelopesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopesTable,
          Envelope,
          $$EnvelopesTableFilterComposer,
          $$EnvelopesTableOrderingComposer,
          $$EnvelopesTableAnnotationComposer,
          $$EnvelopesTableCreateCompanionBuilder,
          $$EnvelopesTableUpdateCompanionBuilder,
          (Envelope, BaseReferences<_$AppDatabase, $EnvelopesTable, Envelope>),
          Envelope,
          PrefetchHooks Function()
        > {
  $$EnvelopesTableTableManager(_$AppDatabase db, $EnvelopesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$EnvelopesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryGroupId = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> linkedAccountId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvelopesCompanion(
                id: id,
                categoryGroupId: categoryGroupId,
                budgetId: budgetId,
                name: name,
                sortOrder: sortOrder,
                isArchived: isArchived,
                color: color,
                linkedAccountId: linkedAccountId,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryGroupId,
                required String budgetId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isArchived = const Value.absent(),
                Value<String?> color = const Value.absent(),
                Value<String?> linkedAccountId = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvelopesCompanion.insert(
                id: id,
                categoryGroupId: categoryGroupId,
                budgetId: budgetId,
                name: name,
                sortOrder: sortOrder,
                isArchived: isArchived,
                color: color,
                linkedAccountId: linkedAccountId,
                createdAt: createdAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnvelopesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopesTable,
      Envelope,
      $$EnvelopesTableFilterComposer,
      $$EnvelopesTableOrderingComposer,
      $$EnvelopesTableAnnotationComposer,
      $$EnvelopesTableCreateCompanionBuilder,
      $$EnvelopesTableUpdateCompanionBuilder,
      (Envelope, BaseReferences<_$AppDatabase, $EnvelopesTable, Envelope>),
      Envelope,
      PrefetchHooks Function()
    >;
typedef $$EnvelopeAllocationsTableCreateCompanionBuilder =
    EnvelopeAllocationsCompanion Function({
      required String id,
      required String envelopeId,
      required String budgetPeriodId,
      Value<int> allocatedAmount,
      Value<int> spentAmount,
      Value<int> rolloverAmount,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$EnvelopeAllocationsTableUpdateCompanionBuilder =
    EnvelopeAllocationsCompanion Function({
      Value<String> id,
      Value<String> envelopeId,
      Value<String> budgetPeriodId,
      Value<int> allocatedAmount,
      Value<int> spentAmount,
      Value<int> rolloverAmount,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$EnvelopeAllocationsTableFilterComposer
    extends Composer<_$AppDatabase, $EnvelopeAllocationsTable> {
  $$EnvelopeAllocationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetPeriodId => $composableBuilder(
    column: $table.budgetPeriodId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rolloverAmount => $composableBuilder(
    column: $table.rolloverAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$EnvelopeAllocationsTableOrderingComposer
    extends Composer<_$AppDatabase, $EnvelopeAllocationsTable> {
  $$EnvelopeAllocationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetPeriodId => $composableBuilder(
    column: $table.budgetPeriodId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rolloverAmount => $composableBuilder(
    column: $table.rolloverAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$EnvelopeAllocationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $EnvelopeAllocationsTable> {
  $$EnvelopeAllocationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get budgetPeriodId => $composableBuilder(
    column: $table.budgetPeriodId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get allocatedAmount => $composableBuilder(
    column: $table.allocatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get spentAmount => $composableBuilder(
    column: $table.spentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get rolloverAmount => $composableBuilder(
    column: $table.rolloverAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$EnvelopeAllocationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $EnvelopeAllocationsTable,
          EnvelopeAllocation,
          $$EnvelopeAllocationsTableFilterComposer,
          $$EnvelopeAllocationsTableOrderingComposer,
          $$EnvelopeAllocationsTableAnnotationComposer,
          $$EnvelopeAllocationsTableCreateCompanionBuilder,
          $$EnvelopeAllocationsTableUpdateCompanionBuilder,
          (
            EnvelopeAllocation,
            BaseReferences<
              _$AppDatabase,
              $EnvelopeAllocationsTable,
              EnvelopeAllocation
            >,
          ),
          EnvelopeAllocation,
          PrefetchHooks Function()
        > {
  $$EnvelopeAllocationsTableTableManager(
    _$AppDatabase db,
    $EnvelopeAllocationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$EnvelopeAllocationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$EnvelopeAllocationsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$EnvelopeAllocationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> envelopeId = const Value.absent(),
                Value<String> budgetPeriodId = const Value.absent(),
                Value<int> allocatedAmount = const Value.absent(),
                Value<int> spentAmount = const Value.absent(),
                Value<int> rolloverAmount = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => EnvelopeAllocationsCompanion(
                id: id,
                envelopeId: envelopeId,
                budgetPeriodId: budgetPeriodId,
                allocatedAmount: allocatedAmount,
                spentAmount: spentAmount,
                rolloverAmount: rolloverAmount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String envelopeId,
                required String budgetPeriodId,
                Value<int> allocatedAmount = const Value.absent(),
                Value<int> spentAmount = const Value.absent(),
                Value<int> rolloverAmount = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => EnvelopeAllocationsCompanion.insert(
                id: id,
                envelopeId: envelopeId,
                budgetPeriodId: budgetPeriodId,
                allocatedAmount: allocatedAmount,
                spentAmount: spentAmount,
                rolloverAmount: rolloverAmount,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$EnvelopeAllocationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $EnvelopeAllocationsTable,
      EnvelopeAllocation,
      $$EnvelopeAllocationsTableFilterComposer,
      $$EnvelopeAllocationsTableOrderingComposer,
      $$EnvelopeAllocationsTableAnnotationComposer,
      $$EnvelopeAllocationsTableCreateCompanionBuilder,
      $$EnvelopeAllocationsTableUpdateCompanionBuilder,
      (
        EnvelopeAllocation,
        BaseReferences<
          _$AppDatabase,
          $EnvelopeAllocationsTable,
          EnvelopeAllocation
        >,
      ),
      EnvelopeAllocation,
      PrefetchHooks Function()
    >;
typedef $$TransactionsTableCreateCompanionBuilder =
    TransactionsCompanion Function({
      required String id,
      required String budgetId,
      required String accountId,
      Value<String?> envelopeId,
      required String type,
      required int amount,
      required String currency,
      Value<double> exchangeRate,
      Value<int> baseCurrencyAmount,
      Value<String?> payee,
      Value<String?> notes,
      required DateTime date,
      Value<bool> isReconciled,
      Value<String?> recurringRuleId,
      Value<String?> transferPairId,
      required String createdBy,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });
typedef $$TransactionsTableUpdateCompanionBuilder =
    TransactionsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> accountId,
      Value<String?> envelopeId,
      Value<String> type,
      Value<int> amount,
      Value<String> currency,
      Value<double> exchangeRate,
      Value<int> baseCurrencyAmount,
      Value<String?> payee,
      Value<String?> notes,
      Value<DateTime> date,
      Value<bool> isReconciled,
      Value<String?> recurringRuleId,
      Value<String?> transferPairId,
      Value<String> createdBy,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<DateTime?> deletedAt,
      Value<int> rowid,
    });

class $$TransactionsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseCurrencyAmount => $composableBuilder(
    column: $table.baseCurrencyAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isReconciled => $composableBuilder(
    column: $table.isReconciled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurringRuleId => $composableBuilder(
    column: $table.recurringRuleId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transferPairId => $composableBuilder(
    column: $table.transferPairId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseCurrencyAmount => $composableBuilder(
    column: $table.baseCurrencyAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isReconciled => $composableBuilder(
    column: $table.isReconciled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurringRuleId => $composableBuilder(
    column: $table.recurringRuleId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transferPairId => $composableBuilder(
    column: $table.transferPairId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get createdBy => $composableBuilder(
    column: $table.createdBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionsTable> {
  $$TransactionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<double> get exchangeRate => $composableBuilder(
    column: $table.exchangeRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseCurrencyAmount => $composableBuilder(
    column: $table.baseCurrencyAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isReconciled => $composableBuilder(
    column: $table.isReconciled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurringRuleId => $composableBuilder(
    column: $table.recurringRuleId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get transferPairId => $composableBuilder(
    column: $table.transferPairId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get createdBy =>
      $composableBuilder(column: $table.createdBy, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);
}

class $$TransactionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionsTable,
          Transaction,
          $$TransactionsTableFilterComposer,
          $$TransactionsTableOrderingComposer,
          $$TransactionsTableAnnotationComposer,
          $$TransactionsTableCreateCompanionBuilder,
          $$TransactionsTableUpdateCompanionBuilder,
          (
            Transaction,
            BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
          ),
          Transaction,
          PrefetchHooks Function()
        > {
  $$TransactionsTableTableManager(_$AppDatabase db, $TransactionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> envelopeId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<double> exchangeRate = const Value.absent(),
                Value<int> baseCurrencyAmount = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isReconciled = const Value.absent(),
                Value<String?> recurringRuleId = const Value.absent(),
                Value<String?> transferPairId = const Value.absent(),
                Value<String> createdBy = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion(
                id: id,
                budgetId: budgetId,
                accountId: accountId,
                envelopeId: envelopeId,
                type: type,
                amount: amount,
                currency: currency,
                exchangeRate: exchangeRate,
                baseCurrencyAmount: baseCurrencyAmount,
                payee: payee,
                notes: notes,
                date: date,
                isReconciled: isReconciled,
                recurringRuleId: recurringRuleId,
                transferPairId: transferPairId,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String accountId,
                Value<String?> envelopeId = const Value.absent(),
                required String type,
                required int amount,
                required String currency,
                Value<double> exchangeRate = const Value.absent(),
                Value<int> baseCurrencyAmount = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required DateTime date,
                Value<bool> isReconciled = const Value.absent(),
                Value<String?> recurringRuleId = const Value.absent(),
                Value<String?> transferPairId = const Value.absent(),
                required String createdBy,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<DateTime?> deletedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionsCompanion.insert(
                id: id,
                budgetId: budgetId,
                accountId: accountId,
                envelopeId: envelopeId,
                type: type,
                amount: amount,
                currency: currency,
                exchangeRate: exchangeRate,
                baseCurrencyAmount: baseCurrencyAmount,
                payee: payee,
                notes: notes,
                date: date,
                isReconciled: isReconciled,
                recurringRuleId: recurringRuleId,
                transferPairId: transferPairId,
                createdBy: createdBy,
                createdAt: createdAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionsTable,
      Transaction,
      $$TransactionsTableFilterComposer,
      $$TransactionsTableOrderingComposer,
      $$TransactionsTableAnnotationComposer,
      $$TransactionsTableCreateCompanionBuilder,
      $$TransactionsTableUpdateCompanionBuilder,
      (
        Transaction,
        BaseReferences<_$AppDatabase, $TransactionsTable, Transaction>,
      ),
      Transaction,
      PrefetchHooks Function()
    >;
typedef $$TransactionSplitsTableCreateCompanionBuilder =
    TransactionSplitsCompanion Function({
      required String id,
      required String transactionId,
      required String envelopeId,
      required double amount,
      Value<int> rowid,
    });
typedef $$TransactionSplitsTableUpdateCompanionBuilder =
    TransactionSplitsCompanion Function({
      Value<String> id,
      Value<String> transactionId,
      Value<String> envelopeId,
      Value<double> amount,
      Value<int> rowid,
    });

class $$TransactionSplitsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTable> {
  $$TransactionSplitsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionSplitsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTable> {
  $$TransactionSplitsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionSplitsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionSplitsTable> {
  $$TransactionSplitsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);
}

class $$TransactionSplitsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionSplitsTable,
          TransactionSplit,
          $$TransactionSplitsTableFilterComposer,
          $$TransactionSplitsTableOrderingComposer,
          $$TransactionSplitsTableAnnotationComposer,
          $$TransactionSplitsTableCreateCompanionBuilder,
          $$TransactionSplitsTableUpdateCompanionBuilder,
          (
            TransactionSplit,
            BaseReferences<
              _$AppDatabase,
              $TransactionSplitsTable,
              TransactionSplit
            >,
          ),
          TransactionSplit,
          PrefetchHooks Function()
        > {
  $$TransactionSplitsTableTableManager(
    _$AppDatabase db,
    $TransactionSplitsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionSplitsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionSplitsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionSplitsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> transactionId = const Value.absent(),
                Value<String> envelopeId = const Value.absent(),
                Value<double> amount = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionSplitsCompanion(
                id: id,
                transactionId: transactionId,
                envelopeId: envelopeId,
                amount: amount,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String transactionId,
                required String envelopeId,
                required double amount,
                Value<int> rowid = const Value.absent(),
              }) => TransactionSplitsCompanion.insert(
                id: id,
                transactionId: transactionId,
                envelopeId: envelopeId,
                amount: amount,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionSplitsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionSplitsTable,
      TransactionSplit,
      $$TransactionSplitsTableFilterComposer,
      $$TransactionSplitsTableOrderingComposer,
      $$TransactionSplitsTableAnnotationComposer,
      $$TransactionSplitsTableCreateCompanionBuilder,
      $$TransactionSplitsTableUpdateCompanionBuilder,
      (
        TransactionSplit,
        BaseReferences<
          _$AppDatabase,
          $TransactionSplitsTable,
          TransactionSplit
        >,
      ),
      TransactionSplit,
      PrefetchHooks Function()
    >;
typedef $$TagsTableCreateCompanionBuilder =
    TagsCompanion Function({
      required String id,
      required String budgetId,
      required String name,
      Value<int> rowid,
    });
typedef $$TagsTableUpdateCompanionBuilder =
    TagsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> name,
      Value<int> rowid,
    });

class $$TagsTableFilterComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TagsTableOrderingComposer extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TagsTable> {
  $$TagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);
}

class $$TagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TagsTable,
          Tag,
          $$TagsTableFilterComposer,
          $$TagsTableOrderingComposer,
          $$TagsTableAnnotationComposer,
          $$TagsTableCreateCompanionBuilder,
          $$TagsTableUpdateCompanionBuilder,
          (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
          Tag,
          PrefetchHooks Function()
        > {
  $$TagsTableTableManager(_$AppDatabase db, $TagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion(
                id: id,
                budgetId: budgetId,
                name: name,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String name,
                Value<int> rowid = const Value.absent(),
              }) => TagsCompanion.insert(
                id: id,
                budgetId: budgetId,
                name: name,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TagsTable,
      Tag,
      $$TagsTableFilterComposer,
      $$TagsTableOrderingComposer,
      $$TagsTableAnnotationComposer,
      $$TagsTableCreateCompanionBuilder,
      $$TagsTableUpdateCompanionBuilder,
      (Tag, BaseReferences<_$AppDatabase, $TagsTable, Tag>),
      Tag,
      PrefetchHooks Function()
    >;
typedef $$TransactionTagsTableCreateCompanionBuilder =
    TransactionTagsCompanion Function({
      required String transactionId,
      required String tagId,
      Value<int> rowid,
    });
typedef $$TransactionTagsTableUpdateCompanionBuilder =
    TransactionTagsCompanion Function({
      Value<String> transactionId,
      Value<String> tagId,
      Value<int> rowid,
    });

class $$TransactionTagsTableFilterComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnFilters(column),
  );
}

class $$TransactionTagsTableOrderingComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tagId => $composableBuilder(
    column: $table.tagId,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TransactionTagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TransactionTagsTable> {
  $$TransactionTagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get transactionId => $composableBuilder(
    column: $table.transactionId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get tagId =>
      $composableBuilder(column: $table.tagId, builder: (column) => column);
}

class $$TransactionTagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TransactionTagsTable,
          TransactionTag,
          $$TransactionTagsTableFilterComposer,
          $$TransactionTagsTableOrderingComposer,
          $$TransactionTagsTableAnnotationComposer,
          $$TransactionTagsTableCreateCompanionBuilder,
          $$TransactionTagsTableUpdateCompanionBuilder,
          (
            TransactionTag,
            BaseReferences<
              _$AppDatabase,
              $TransactionTagsTable,
              TransactionTag
            >,
          ),
          TransactionTag,
          PrefetchHooks Function()
        > {
  $$TransactionTagsTableTableManager(
    _$AppDatabase db,
    $TransactionTagsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TransactionTagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TransactionTagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TransactionTagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> transactionId = const Value.absent(),
                Value<String> tagId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TransactionTagsCompanion(
                transactionId: transactionId,
                tagId: tagId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String transactionId,
                required String tagId,
                Value<int> rowid = const Value.absent(),
              }) => TransactionTagsCompanion.insert(
                transactionId: transactionId,
                tagId: tagId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$TransactionTagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TransactionTagsTable,
      TransactionTag,
      $$TransactionTagsTableFilterComposer,
      $$TransactionTagsTableOrderingComposer,
      $$TransactionTagsTableAnnotationComposer,
      $$TransactionTagsTableCreateCompanionBuilder,
      $$TransactionTagsTableUpdateCompanionBuilder,
      (
        TransactionTag,
        BaseReferences<_$AppDatabase, $TransactionTagsTable, TransactionTag>,
      ),
      TransactionTag,
      PrefetchHooks Function()
    >;
typedef $$RecurringRulesTableCreateCompanionBuilder =
    RecurringRulesCompanion Function({
      required String id,
      required String budgetId,
      required String accountId,
      Value<String?> envelopeId,
      required String type,
      required int amount,
      required String currency,
      Value<String?> payee,
      Value<String?> notes,
      required String frequency,
      Value<int?> customInterval,
      Value<String?> customUnit,
      required DateTime startDate,
      Value<DateTime?> endDate,
      required DateTime nextOccurrence,
      Value<bool> autoPost,
      Value<bool> isPaused,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$RecurringRulesTableUpdateCompanionBuilder =
    RecurringRulesCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> accountId,
      Value<String?> envelopeId,
      Value<String> type,
      Value<int> amount,
      Value<String> currency,
      Value<String?> payee,
      Value<String?> notes,
      Value<String> frequency,
      Value<int?> customInterval,
      Value<String?> customUnit,
      Value<DateTime> startDate,
      Value<DateTime?> endDate,
      Value<DateTime> nextOccurrence,
      Value<bool> autoPost,
      Value<bool> isPaused,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$RecurringRulesTableFilterComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get customInterval => $composableBuilder(
    column: $table.customInterval,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get nextOccurrence => $composableBuilder(
    column: $table.nextOccurrence,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get autoPost => $composableBuilder(
    column: $table.autoPost,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$RecurringRulesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amount => $composableBuilder(
    column: $table.amount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currency => $composableBuilder(
    column: $table.currency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payee => $composableBuilder(
    column: $table.payee,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get customInterval => $composableBuilder(
    column: $table.customInterval,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startDate => $composableBuilder(
    column: $table.startDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endDate => $composableBuilder(
    column: $table.endDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get nextOccurrence => $composableBuilder(
    column: $table.nextOccurrence,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get autoPost => $composableBuilder(
    column: $table.autoPost,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaused => $composableBuilder(
    column: $table.isPaused,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecurringRulesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecurringRulesTable> {
  $$RecurringRulesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<int> get amount =>
      $composableBuilder(column: $table.amount, builder: (column) => column);

  GeneratedColumn<String> get currency =>
      $composableBuilder(column: $table.currency, builder: (column) => column);

  GeneratedColumn<String> get payee =>
      $composableBuilder(column: $table.payee, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<int> get customInterval => $composableBuilder(
    column: $table.customInterval,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customUnit => $composableBuilder(
    column: $table.customUnit,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startDate =>
      $composableBuilder(column: $table.startDate, builder: (column) => column);

  GeneratedColumn<DateTime> get endDate =>
      $composableBuilder(column: $table.endDate, builder: (column) => column);

  GeneratedColumn<DateTime> get nextOccurrence => $composableBuilder(
    column: $table.nextOccurrence,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get autoPost =>
      $composableBuilder(column: $table.autoPost, builder: (column) => column);

  GeneratedColumn<bool> get isPaused =>
      $composableBuilder(column: $table.isPaused, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$RecurringRulesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecurringRulesTable,
          RecurringRule,
          $$RecurringRulesTableFilterComposer,
          $$RecurringRulesTableOrderingComposer,
          $$RecurringRulesTableAnnotationComposer,
          $$RecurringRulesTableCreateCompanionBuilder,
          $$RecurringRulesTableUpdateCompanionBuilder,
          (
            RecurringRule,
            BaseReferences<_$AppDatabase, $RecurringRulesTable, RecurringRule>,
          ),
          RecurringRule,
          PrefetchHooks Function()
        > {
  $$RecurringRulesTableTableManager(
    _$AppDatabase db,
    $RecurringRulesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecurringRulesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecurringRulesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecurringRulesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String?> envelopeId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<int> amount = const Value.absent(),
                Value<String> currency = const Value.absent(),
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<int?> customInterval = const Value.absent(),
                Value<String?> customUnit = const Value.absent(),
                Value<DateTime> startDate = const Value.absent(),
                Value<DateTime?> endDate = const Value.absent(),
                Value<DateTime> nextOccurrence = const Value.absent(),
                Value<bool> autoPost = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesCompanion(
                id: id,
                budgetId: budgetId,
                accountId: accountId,
                envelopeId: envelopeId,
                type: type,
                amount: amount,
                currency: currency,
                payee: payee,
                notes: notes,
                frequency: frequency,
                customInterval: customInterval,
                customUnit: customUnit,
                startDate: startDate,
                endDate: endDate,
                nextOccurrence: nextOccurrence,
                autoPost: autoPost,
                isPaused: isPaused,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String accountId,
                Value<String?> envelopeId = const Value.absent(),
                required String type,
                required int amount,
                required String currency,
                Value<String?> payee = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                required String frequency,
                Value<int?> customInterval = const Value.absent(),
                Value<String?> customUnit = const Value.absent(),
                required DateTime startDate,
                Value<DateTime?> endDate = const Value.absent(),
                required DateTime nextOccurrence,
                Value<bool> autoPost = const Value.absent(),
                Value<bool> isPaused = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => RecurringRulesCompanion.insert(
                id: id,
                budgetId: budgetId,
                accountId: accountId,
                envelopeId: envelopeId,
                type: type,
                amount: amount,
                currency: currency,
                payee: payee,
                notes: notes,
                frequency: frequency,
                customInterval: customInterval,
                customUnit: customUnit,
                startDate: startDate,
                endDate: endDate,
                nextOccurrence: nextOccurrence,
                autoPost: autoPost,
                isPaused: isPaused,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$RecurringRulesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecurringRulesTable,
      RecurringRule,
      $$RecurringRulesTableFilterComposer,
      $$RecurringRulesTableOrderingComposer,
      $$RecurringRulesTableAnnotationComposer,
      $$RecurringRulesTableCreateCompanionBuilder,
      $$RecurringRulesTableUpdateCompanionBuilder,
      (
        RecurringRule,
        BaseReferences<_$AppDatabase, $RecurringRulesTable, RecurringRule>,
      ),
      RecurringRule,
      PrefetchHooks Function()
    >;
typedef $$BillRemindersTableCreateCompanionBuilder =
    BillRemindersCompanion Function({
      required String id,
      required String budgetId,
      required String name,
      required int estimatedAmount,
      required int dueDay,
      required String frequency,
      Value<String?> envelopeId,
      Value<int> reminderDaysBefore,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BillRemindersTableUpdateCompanionBuilder =
    BillRemindersCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> name,
      Value<int> estimatedAmount,
      Value<int> dueDay,
      Value<String> frequency,
      Value<String?> envelopeId,
      Value<int> reminderDaysBefore,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BillRemindersTableFilterComposer
    extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reminderDaysBefore => $composableBuilder(
    column: $table.reminderDaysBefore,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BillRemindersTableOrderingComposer
    extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dueDay => $composableBuilder(
    column: $table.dueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get frequency => $composableBuilder(
    column: $table.frequency,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reminderDaysBefore => $composableBuilder(
    column: $table.reminderDaysBefore,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BillRemindersTableAnnotationComposer
    extends Composer<_$AppDatabase, $BillRemindersTable> {
  $$BillRemindersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get estimatedAmount => $composableBuilder(
    column: $table.estimatedAmount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dueDay =>
      $composableBuilder(column: $table.dueDay, builder: (column) => column);

  GeneratedColumn<String> get frequency =>
      $composableBuilder(column: $table.frequency, builder: (column) => column);

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reminderDaysBefore => $composableBuilder(
    column: $table.reminderDaysBefore,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BillRemindersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BillRemindersTable,
          BillReminder,
          $$BillRemindersTableFilterComposer,
          $$BillRemindersTableOrderingComposer,
          $$BillRemindersTableAnnotationComposer,
          $$BillRemindersTableCreateCompanionBuilder,
          $$BillRemindersTableUpdateCompanionBuilder,
          (
            BillReminder,
            BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminder>,
          ),
          BillReminder,
          PrefetchHooks Function()
        > {
  $$BillRemindersTableTableManager(_$AppDatabase db, $BillRemindersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BillRemindersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BillRemindersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BillRemindersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> estimatedAmount = const Value.absent(),
                Value<int> dueDay = const Value.absent(),
                Value<String> frequency = const Value.absent(),
                Value<String?> envelopeId = const Value.absent(),
                Value<int> reminderDaysBefore = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BillRemindersCompanion(
                id: id,
                budgetId: budgetId,
                name: name,
                estimatedAmount: estimatedAmount,
                dueDay: dueDay,
                frequency: frequency,
                envelopeId: envelopeId,
                reminderDaysBefore: reminderDaysBefore,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String name,
                required int estimatedAmount,
                required int dueDay,
                required String frequency,
                Value<String?> envelopeId = const Value.absent(),
                Value<int> reminderDaysBefore = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BillRemindersCompanion.insert(
                id: id,
                budgetId: budgetId,
                name: name,
                estimatedAmount: estimatedAmount,
                dueDay: dueDay,
                frequency: frequency,
                envelopeId: envelopeId,
                reminderDaysBefore: reminderDaysBefore,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BillRemindersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BillRemindersTable,
      BillReminder,
      $$BillRemindersTableFilterComposer,
      $$BillRemindersTableOrderingComposer,
      $$BillRemindersTableAnnotationComposer,
      $$BillRemindersTableCreateCompanionBuilder,
      $$BillRemindersTableUpdateCompanionBuilder,
      (
        BillReminder,
        BaseReferences<_$AppDatabase, $BillRemindersTable, BillReminder>,
      ),
      BillReminder,
      PrefetchHooks Function()
    >;
typedef $$AllocationTemplatesTableCreateCompanionBuilder =
    AllocationTemplatesCompanion Function({
      required String id,
      required String budgetId,
      required String name,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$AllocationTemplatesTableUpdateCompanionBuilder =
    AllocationTemplatesCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> name,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$AllocationTemplatesTableFilterComposer
    extends Composer<_$AppDatabase, $AllocationTemplatesTable> {
  $$AllocationTemplatesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllocationTemplatesTableOrderingComposer
    extends Composer<_$AppDatabase, $AllocationTemplatesTable> {
  $$AllocationTemplatesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllocationTemplatesTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllocationTemplatesTable> {
  $$AllocationTemplatesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$AllocationTemplatesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllocationTemplatesTable,
          AllocationTemplate,
          $$AllocationTemplatesTableFilterComposer,
          $$AllocationTemplatesTableOrderingComposer,
          $$AllocationTemplatesTableAnnotationComposer,
          $$AllocationTemplatesTableCreateCompanionBuilder,
          $$AllocationTemplatesTableUpdateCompanionBuilder,
          (
            AllocationTemplate,
            BaseReferences<
              _$AppDatabase,
              $AllocationTemplatesTable,
              AllocationTemplate
            >,
          ),
          AllocationTemplate,
          PrefetchHooks Function()
        > {
  $$AllocationTemplatesTableTableManager(
    _$AppDatabase db,
    $AllocationTemplatesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationTemplatesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllocationTemplatesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AllocationTemplatesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllocationTemplatesCompanion(
                id: id,
                budgetId: budgetId,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String name,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => AllocationTemplatesCompanion.insert(
                id: id,
                budgetId: budgetId,
                name: name,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AllocationTemplatesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllocationTemplatesTable,
      AllocationTemplate,
      $$AllocationTemplatesTableFilterComposer,
      $$AllocationTemplatesTableOrderingComposer,
      $$AllocationTemplatesTableAnnotationComposer,
      $$AllocationTemplatesTableCreateCompanionBuilder,
      $$AllocationTemplatesTableUpdateCompanionBuilder,
      (
        AllocationTemplate,
        BaseReferences<
          _$AppDatabase,
          $AllocationTemplatesTable,
          AllocationTemplate
        >,
      ),
      AllocationTemplate,
      PrefetchHooks Function()
    >;
typedef $$AllocationTemplateItemsTableCreateCompanionBuilder =
    AllocationTemplateItemsCompanion Function({
      required String id,
      required String templateId,
      required String envelopeId,
      required double percentage,
      Value<int> rowid,
    });
typedef $$AllocationTemplateItemsTableUpdateCompanionBuilder =
    AllocationTemplateItemsCompanion Function({
      Value<String> id,
      Value<String> templateId,
      Value<String> envelopeId,
      Value<double> percentage,
      Value<int> rowid,
    });

class $$AllocationTemplateItemsTableFilterComposer
    extends Composer<_$AppDatabase, $AllocationTemplateItemsTable> {
  $$AllocationTemplateItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AllocationTemplateItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $AllocationTemplateItemsTable> {
  $$AllocationTemplateItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AllocationTemplateItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllocationTemplateItemsTable> {
  $$AllocationTemplateItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get templateId => $composableBuilder(
    column: $table.templateId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<double> get percentage => $composableBuilder(
    column: $table.percentage,
    builder: (column) => column,
  );
}

class $$AllocationTemplateItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AllocationTemplateItemsTable,
          AllocationTemplateItem,
          $$AllocationTemplateItemsTableFilterComposer,
          $$AllocationTemplateItemsTableOrderingComposer,
          $$AllocationTemplateItemsTableAnnotationComposer,
          $$AllocationTemplateItemsTableCreateCompanionBuilder,
          $$AllocationTemplateItemsTableUpdateCompanionBuilder,
          (
            AllocationTemplateItem,
            BaseReferences<
              _$AppDatabase,
              $AllocationTemplateItemsTable,
              AllocationTemplateItem
            >,
          ),
          AllocationTemplateItem,
          PrefetchHooks Function()
        > {
  $$AllocationTemplateItemsTableTableManager(
    _$AppDatabase db,
    $AllocationTemplateItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllocationTemplateItemsTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$AllocationTemplateItemsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$AllocationTemplateItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> templateId = const Value.absent(),
                Value<String> envelopeId = const Value.absent(),
                Value<double> percentage = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AllocationTemplateItemsCompanion(
                id: id,
                templateId: templateId,
                envelopeId: envelopeId,
                percentage: percentage,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String templateId,
                required String envelopeId,
                required double percentage,
                Value<int> rowid = const Value.absent(),
              }) => AllocationTemplateItemsCompanion.insert(
                id: id,
                templateId: templateId,
                envelopeId: envelopeId,
                percentage: percentage,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AllocationTemplateItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AllocationTemplateItemsTable,
      AllocationTemplateItem,
      $$AllocationTemplateItemsTableFilterComposer,
      $$AllocationTemplateItemsTableOrderingComposer,
      $$AllocationTemplateItemsTableAnnotationComposer,
      $$AllocationTemplateItemsTableCreateCompanionBuilder,
      $$AllocationTemplateItemsTableUpdateCompanionBuilder,
      (
        AllocationTemplateItem,
        BaseReferences<
          _$AppDatabase,
          $AllocationTemplateItemsTable,
          AllocationTemplateItem
        >,
      ),
      AllocationTemplateItem,
      PrefetchHooks Function()
    >;
typedef $$GoalsTableCreateCompanionBuilder =
    GoalsCompanion Function({
      required String id,
      required String budgetId,
      Value<String?> envelopeId,
      Value<String?> accountId,
      required String type,
      required String name,
      Value<int?> targetAmount,
      Value<DateTime?> targetDate,
      Value<int?> monthlyContribution,
      Value<int> currentAmount,
      Value<bool> isCompleted,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GoalsTableUpdateCompanionBuilder =
    GoalsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String?> envelopeId,
      Value<String?> accountId,
      Value<String> type,
      Value<String> name,
      Value<int?> targetAmount,
      Value<DateTime?> targetDate,
      Value<int?> monthlyContribution,
      Value<int> currentAmount,
      Value<bool> isCompleted,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$GoalsTableFilterComposer extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get monthlyContribution => $composableBuilder(
    column: $table.monthlyContribution,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get monthlyContribution => $composableBuilder(
    column: $table.monthlyContribution,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalsTable> {
  $$GoalsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get envelopeId => $composableBuilder(
    column: $table.envelopeId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get targetAmount => $composableBuilder(
    column: $table.targetAmount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get targetDate => $composableBuilder(
    column: $table.targetDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get monthlyContribution => $composableBuilder(
    column: $table.monthlyContribution,
    builder: (column) => column,
  );

  GeneratedColumn<int> get currentAmount => $composableBuilder(
    column: $table.currentAmount,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isCompleted => $composableBuilder(
    column: $table.isCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$GoalsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalsTable,
          Goal,
          $$GoalsTableFilterComposer,
          $$GoalsTableOrderingComposer,
          $$GoalsTableAnnotationComposer,
          $$GoalsTableCreateCompanionBuilder,
          $$GoalsTableUpdateCompanionBuilder,
          (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
          Goal,
          PrefetchHooks Function()
        > {
  $$GoalsTableTableManager(_$AppDatabase db, $GoalsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String?> envelopeId = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int?> targetAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> monthlyContribution = const Value.absent(),
                Value<int> currentAmount = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion(
                id: id,
                budgetId: budgetId,
                envelopeId: envelopeId,
                accountId: accountId,
                type: type,
                name: name,
                targetAmount: targetAmount,
                targetDate: targetDate,
                monthlyContribution: monthlyContribution,
                currentAmount: currentAmount,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                Value<String?> envelopeId = const Value.absent(),
                Value<String?> accountId = const Value.absent(),
                required String type,
                required String name,
                Value<int?> targetAmount = const Value.absent(),
                Value<DateTime?> targetDate = const Value.absent(),
                Value<int?> monthlyContribution = const Value.absent(),
                Value<int> currentAmount = const Value.absent(),
                Value<bool> isCompleted = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalsCompanion.insert(
                id: id,
                budgetId: budgetId,
                envelopeId: envelopeId,
                accountId: accountId,
                type: type,
                name: name,
                targetAmount: targetAmount,
                targetDate: targetDate,
                monthlyContribution: monthlyContribution,
                currentAmount: currentAmount,
                isCompleted: isCompleted,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalsTable,
      Goal,
      $$GoalsTableFilterComposer,
      $$GoalsTableOrderingComposer,
      $$GoalsTableAnnotationComposer,
      $$GoalsTableCreateCompanionBuilder,
      $$GoalsTableUpdateCompanionBuilder,
      (Goal, BaseReferences<_$AppDatabase, $GoalsTable, Goal>),
      Goal,
      PrefetchHooks Function()
    >;
typedef $$GoalContributionsTableCreateCompanionBuilder =
    GoalContributionsCompanion Function({
      required String id,
      required String goalId,
      required int amountCents,
      Value<String?> note,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$GoalContributionsTableUpdateCompanionBuilder =
    GoalContributionsCompanion Function({
      Value<String> id,
      Value<String> goalId,
      Value<int> amountCents,
      Value<String?> note,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$GoalContributionsTableFilterComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$GoalContributionsTableOrderingComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get goalId => $composableBuilder(
    column: $table.goalId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get note => $composableBuilder(
    column: $table.note,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GoalContributionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GoalContributionsTable> {
  $$GoalContributionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get goalId =>
      $composableBuilder(column: $table.goalId, builder: (column) => column);

  GeneratedColumn<int> get amountCents => $composableBuilder(
    column: $table.amountCents,
    builder: (column) => column,
  );

  GeneratedColumn<String> get note =>
      $composableBuilder(column: $table.note, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$GoalContributionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GoalContributionsTable,
          GoalContribution,
          $$GoalContributionsTableFilterComposer,
          $$GoalContributionsTableOrderingComposer,
          $$GoalContributionsTableAnnotationComposer,
          $$GoalContributionsTableCreateCompanionBuilder,
          $$GoalContributionsTableUpdateCompanionBuilder,
          (
            GoalContribution,
            BaseReferences<
              _$AppDatabase,
              $GoalContributionsTable,
              GoalContribution
            >,
          ),
          GoalContribution,
          PrefetchHooks Function()
        > {
  $$GoalContributionsTableTableManager(
    _$AppDatabase db,
    $GoalContributionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GoalContributionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GoalContributionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GoalContributionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> goalId = const Value.absent(),
                Value<int> amountCents = const Value.absent(),
                Value<String?> note = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GoalContributionsCompanion(
                id: id,
                goalId: goalId,
                amountCents: amountCents,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String goalId,
                required int amountCents,
                Value<String?> note = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => GoalContributionsCompanion.insert(
                id: id,
                goalId: goalId,
                amountCents: amountCents,
                note: note,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$GoalContributionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GoalContributionsTable,
      GoalContribution,
      $$GoalContributionsTableFilterComposer,
      $$GoalContributionsTableOrderingComposer,
      $$GoalContributionsTableAnnotationComposer,
      $$GoalContributionsTableCreateCompanionBuilder,
      $$GoalContributionsTableUpdateCompanionBuilder,
      (
        GoalContribution,
        BaseReferences<
          _$AppDatabase,
          $GoalContributionsTable,
          GoalContribution
        >,
      ),
      GoalContribution,
      PrefetchHooks Function()
    >;
typedef $$DebtAccountsTableCreateCompanionBuilder =
    DebtAccountsCompanion Function({
      required String accountId,
      required double interestRate,
      required int minimumPayment,
      required int originalBalance,
      Value<String?> payoffStrategy,
      Value<int?> creditLimit,
      Value<int> rowid,
    });
typedef $$DebtAccountsTableUpdateCompanionBuilder =
    DebtAccountsCompanion Function({
      Value<String> accountId,
      Value<double> interestRate,
      Value<int> minimumPayment,
      Value<int> originalBalance,
      Value<String?> payoffStrategy,
      Value<int?> creditLimit,
      Value<int> rowid,
    });

class $$DebtAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtAccountsTable> {
  $$DebtAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minimumPayment => $composableBuilder(
    column: $table.minimumPayment,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get originalBalance => $composableBuilder(
    column: $table.originalBalance,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payoffStrategy => $composableBuilder(
    column: $table.payoffStrategy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtAccountsTable> {
  $$DebtAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get accountId => $composableBuilder(
    column: $table.accountId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minimumPayment => $composableBuilder(
    column: $table.minimumPayment,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get originalBalance => $composableBuilder(
    column: $table.originalBalance,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payoffStrategy => $composableBuilder(
    column: $table.payoffStrategy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtAccountsTable> {
  $$DebtAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get accountId =>
      $composableBuilder(column: $table.accountId, builder: (column) => column);

  GeneratedColumn<double> get interestRate => $composableBuilder(
    column: $table.interestRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minimumPayment => $composableBuilder(
    column: $table.minimumPayment,
    builder: (column) => column,
  );

  GeneratedColumn<int> get originalBalance => $composableBuilder(
    column: $table.originalBalance,
    builder: (column) => column,
  );

  GeneratedColumn<String> get payoffStrategy => $composableBuilder(
    column: $table.payoffStrategy,
    builder: (column) => column,
  );

  GeneratedColumn<int> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );
}

class $$DebtAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtAccountsTable,
          DebtAccount,
          $$DebtAccountsTableFilterComposer,
          $$DebtAccountsTableOrderingComposer,
          $$DebtAccountsTableAnnotationComposer,
          $$DebtAccountsTableCreateCompanionBuilder,
          $$DebtAccountsTableUpdateCompanionBuilder,
          (
            DebtAccount,
            BaseReferences<_$AppDatabase, $DebtAccountsTable, DebtAccount>,
          ),
          DebtAccount,
          PrefetchHooks Function()
        > {
  $$DebtAccountsTableTableManager(_$AppDatabase db, $DebtAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DebtAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DebtAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DebtAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> accountId = const Value.absent(),
                Value<double> interestRate = const Value.absent(),
                Value<int> minimumPayment = const Value.absent(),
                Value<int> originalBalance = const Value.absent(),
                Value<String?> payoffStrategy = const Value.absent(),
                Value<int?> creditLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtAccountsCompanion(
                accountId: accountId,
                interestRate: interestRate,
                minimumPayment: minimumPayment,
                originalBalance: originalBalance,
                payoffStrategy: payoffStrategy,
                creditLimit: creditLimit,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String accountId,
                required double interestRate,
                required int minimumPayment,
                required int originalBalance,
                Value<String?> payoffStrategy = const Value.absent(),
                Value<int?> creditLimit = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DebtAccountsCompanion.insert(
                accountId: accountId,
                interestRate: interestRate,
                minimumPayment: minimumPayment,
                originalBalance: originalBalance,
                payoffStrategy: payoffStrategy,
                creditLimit: creditLimit,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtAccountsTable,
      DebtAccount,
      $$DebtAccountsTableFilterComposer,
      $$DebtAccountsTableOrderingComposer,
      $$DebtAccountsTableAnnotationComposer,
      $$DebtAccountsTableCreateCompanionBuilder,
      $$DebtAccountsTableUpdateCompanionBuilder,
      (
        DebtAccount,
        BaseReferences<_$AppDatabase, $DebtAccountsTable, DebtAccount>,
      ),
      DebtAccount,
      PrefetchHooks Function()
    >;
typedef $$ActivityLogTableCreateCompanionBuilder =
    ActivityLogCompanion Function({
      required String id,
      required String budgetId,
      required String userId,
      required String action,
      required String entityType,
      required String entityId,
      Value<String?> details,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$ActivityLogTableUpdateCompanionBuilder =
    ActivityLogCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<String> userId,
      Value<String> action,
      Value<String> entityType,
      Value<String> entityId,
      Value<String?> details,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$ActivityLogTableFilterComposer
    extends Composer<_$AppDatabase, $ActivityLogTable> {
  $$ActivityLogTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ActivityLogTableOrderingComposer
    extends Composer<_$AppDatabase, $ActivityLogTable> {
  $$ActivityLogTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get action => $composableBuilder(
    column: $table.action,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get details => $composableBuilder(
    column: $table.details,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ActivityLogTableAnnotationComposer
    extends Composer<_$AppDatabase, $ActivityLogTable> {
  $$ActivityLogTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get action =>
      $composableBuilder(column: $table.action, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get details =>
      $composableBuilder(column: $table.details, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ActivityLogTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ActivityLogTable,
          ActivityLogData,
          $$ActivityLogTableFilterComposer,
          $$ActivityLogTableOrderingComposer,
          $$ActivityLogTableAnnotationComposer,
          $$ActivityLogTableCreateCompanionBuilder,
          $$ActivityLogTableUpdateCompanionBuilder,
          (
            ActivityLogData,
            BaseReferences<_$AppDatabase, $ActivityLogTable, ActivityLogData>,
          ),
          ActivityLogData,
          PrefetchHooks Function()
        > {
  $$ActivityLogTableTableManager(_$AppDatabase db, $ActivityLogTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ActivityLogTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ActivityLogTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ActivityLogTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> action = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String?> details = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogCompanion(
                id: id,
                budgetId: budgetId,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required String userId,
                required String action,
                required String entityType,
                required String entityId,
                Value<String?> details = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => ActivityLogCompanion.insert(
                id: id,
                budgetId: budgetId,
                userId: userId,
                action: action,
                entityType: entityType,
                entityId: entityId,
                details: details,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ActivityLogTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ActivityLogTable,
      ActivityLogData,
      $$ActivityLogTableFilterComposer,
      $$ActivityLogTableOrderingComposer,
      $$ActivityLogTableAnnotationComposer,
      $$ActivityLogTableCreateCompanionBuilder,
      $$ActivityLogTableUpdateCompanionBuilder,
      (
        ActivityLogData,
        BaseReferences<_$AppDatabase, $ActivityLogTable, ActivityLogData>,
      ),
      ActivityLogData,
      PrefetchHooks Function()
    >;
typedef $$NotificationPreferencesTableCreateCompanionBuilder =
    NotificationPreferencesCompanion Function({
      required String userId,
      Value<bool> pushEnabled,
      Value<bool> emailEnabled,
      Value<bool> overspendAlerts,
      Value<bool> billReminders,
      Value<bool> emailBillReminders,
      Value<bool> dailyLoggingReminder,
      Value<bool> recurringTransactionAlerts,
      Value<bool> sharedBudgetActivity,
      Value<bool> weeklySummary,
      Value<int> rowid,
    });
typedef $$NotificationPreferencesTableUpdateCompanionBuilder =
    NotificationPreferencesCompanion Function({
      Value<String> userId,
      Value<bool> pushEnabled,
      Value<bool> emailEnabled,
      Value<bool> overspendAlerts,
      Value<bool> billReminders,
      Value<bool> emailBillReminders,
      Value<bool> dailyLoggingReminder,
      Value<bool> recurringTransactionAlerts,
      Value<bool> sharedBudgetActivity,
      Value<bool> weeklySummary,
      Value<int> rowid,
    });

class $$NotificationPreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get pushEnabled => $composableBuilder(
    column: $table.pushEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailEnabled => $composableBuilder(
    column: $table.emailEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get overspendAlerts => $composableBuilder(
    column: $table.overspendAlerts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get billReminders => $composableBuilder(
    column: $table.billReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get emailBillReminders => $composableBuilder(
    column: $table.emailBillReminders,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dailyLoggingReminder => $composableBuilder(
    column: $table.dailyLoggingReminder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get recurringTransactionAlerts => $composableBuilder(
    column: $table.recurringTransactionAlerts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get sharedBudgetActivity => $composableBuilder(
    column: $table.sharedBudgetActivity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get weeklySummary => $composableBuilder(
    column: $table.weeklySummary,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NotificationPreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get pushEnabled => $composableBuilder(
    column: $table.pushEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get emailEnabled => $composableBuilder(
    column: $table.emailEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get overspendAlerts => $composableBuilder(
    column: $table.overspendAlerts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get billReminders => $composableBuilder(
    column: $table.billReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get emailBillReminders => $composableBuilder(
    column: $table.emailBillReminders,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dailyLoggingReminder => $composableBuilder(
    column: $table.dailyLoggingReminder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get recurringTransactionAlerts => $composableBuilder(
    column: $table.recurringTransactionAlerts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get sharedBudgetActivity => $composableBuilder(
    column: $table.sharedBudgetActivity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get weeklySummary => $composableBuilder(
    column: $table.weeklySummary,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotificationPreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotificationPreferencesTable> {
  $$NotificationPreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<bool> get pushEnabled => $composableBuilder(
    column: $table.pushEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get emailEnabled => $composableBuilder(
    column: $table.emailEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get overspendAlerts => $composableBuilder(
    column: $table.overspendAlerts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get billReminders => $composableBuilder(
    column: $table.billReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get emailBillReminders => $composableBuilder(
    column: $table.emailBillReminders,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get dailyLoggingReminder => $composableBuilder(
    column: $table.dailyLoggingReminder,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get recurringTransactionAlerts => $composableBuilder(
    column: $table.recurringTransactionAlerts,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get sharedBudgetActivity => $composableBuilder(
    column: $table.sharedBudgetActivity,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get weeklySummary => $composableBuilder(
    column: $table.weeklySummary,
    builder: (column) => column,
  );
}

class $$NotificationPreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotificationPreferencesTable,
          NotificationPreference,
          $$NotificationPreferencesTableFilterComposer,
          $$NotificationPreferencesTableOrderingComposer,
          $$NotificationPreferencesTableAnnotationComposer,
          $$NotificationPreferencesTableCreateCompanionBuilder,
          $$NotificationPreferencesTableUpdateCompanionBuilder,
          (
            NotificationPreference,
            BaseReferences<
              _$AppDatabase,
              $NotificationPreferencesTable,
              NotificationPreference
            >,
          ),
          NotificationPreference,
          PrefetchHooks Function()
        > {
  $$NotificationPreferencesTableTableManager(
    _$AppDatabase db,
    $NotificationPreferencesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotificationPreferencesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$NotificationPreferencesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$NotificationPreferencesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> userId = const Value.absent(),
                Value<bool> pushEnabled = const Value.absent(),
                Value<bool> emailEnabled = const Value.absent(),
                Value<bool> overspendAlerts = const Value.absent(),
                Value<bool> billReminders = const Value.absent(),
                Value<bool> emailBillReminders = const Value.absent(),
                Value<bool> dailyLoggingReminder = const Value.absent(),
                Value<bool> recurringTransactionAlerts = const Value.absent(),
                Value<bool> sharedBudgetActivity = const Value.absent(),
                Value<bool> weeklySummary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationPreferencesCompanion(
                userId: userId,
                pushEnabled: pushEnabled,
                emailEnabled: emailEnabled,
                overspendAlerts: overspendAlerts,
                billReminders: billReminders,
                emailBillReminders: emailBillReminders,
                dailyLoggingReminder: dailyLoggingReminder,
                recurringTransactionAlerts: recurringTransactionAlerts,
                sharedBudgetActivity: sharedBudgetActivity,
                weeklySummary: weeklySummary,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String userId,
                Value<bool> pushEnabled = const Value.absent(),
                Value<bool> emailEnabled = const Value.absent(),
                Value<bool> overspendAlerts = const Value.absent(),
                Value<bool> billReminders = const Value.absent(),
                Value<bool> emailBillReminders = const Value.absent(),
                Value<bool> dailyLoggingReminder = const Value.absent(),
                Value<bool> recurringTransactionAlerts = const Value.absent(),
                Value<bool> sharedBudgetActivity = const Value.absent(),
                Value<bool> weeklySummary = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotificationPreferencesCompanion.insert(
                userId: userId,
                pushEnabled: pushEnabled,
                emailEnabled: emailEnabled,
                overspendAlerts: overspendAlerts,
                billReminders: billReminders,
                emailBillReminders: emailBillReminders,
                dailyLoggingReminder: dailyLoggingReminder,
                recurringTransactionAlerts: recurringTransactionAlerts,
                sharedBudgetActivity: sharedBudgetActivity,
                weeklySummary: weeklySummary,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NotificationPreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotificationPreferencesTable,
      NotificationPreference,
      $$NotificationPreferencesTableFilterComposer,
      $$NotificationPreferencesTableOrderingComposer,
      $$NotificationPreferencesTableAnnotationComposer,
      $$NotificationPreferencesTableCreateCompanionBuilder,
      $$NotificationPreferencesTableUpdateCompanionBuilder,
      (
        NotificationPreference,
        BaseReferences<
          _$AppDatabase,
          $NotificationPreferencesTable,
          NotificationPreference
        >,
      ),
      NotificationPreference,
      PrefetchHooks Function()
    >;
typedef $$PushTokensTableCreateCompanionBuilder =
    PushTokensCompanion Function({
      required String id,
      required String userId,
      required String token,
      required String platform,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$PushTokensTableUpdateCompanionBuilder =
    PushTokensCompanion Function({
      Value<String> id,
      Value<String> userId,
      Value<String> token,
      Value<String> platform,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$PushTokensTableFilterComposer
    extends Composer<_$AppDatabase, $PushTokensTable> {
  $$PushTokensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PushTokensTableOrderingComposer
    extends Composer<_$AppDatabase, $PushTokensTable> {
  $$PushTokensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get token => $composableBuilder(
    column: $table.token,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platform => $composableBuilder(
    column: $table.platform,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PushTokensTableAnnotationComposer
    extends Composer<_$AppDatabase, $PushTokensTable> {
  $$PushTokensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<String> get platform =>
      $composableBuilder(column: $table.platform, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$PushTokensTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PushTokensTable,
          PushToken,
          $$PushTokensTableFilterComposer,
          $$PushTokensTableOrderingComposer,
          $$PushTokensTableAnnotationComposer,
          $$PushTokensTableCreateCompanionBuilder,
          $$PushTokensTableUpdateCompanionBuilder,
          (
            PushToken,
            BaseReferences<_$AppDatabase, $PushTokensTable, PushToken>,
          ),
          PushToken,
          PrefetchHooks Function()
        > {
  $$PushTokensTableTableManager(_$AppDatabase db, $PushTokensTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PushTokensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PushTokensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PushTokensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String> token = const Value.absent(),
                Value<String> platform = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PushTokensCompanion(
                id: id,
                userId: userId,
                token: token,
                platform: platform,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String userId,
                required String token,
                required String platform,
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => PushTokensCompanion.insert(
                id: id,
                userId: userId,
                token: token,
                platform: platform,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PushTokensTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PushTokensTable,
      PushToken,
      $$PushTokensTableFilterComposer,
      $$PushTokensTableOrderingComposer,
      $$PushTokensTableAnnotationComposer,
      $$PushTokensTableCreateCompanionBuilder,
      $$PushTokensTableUpdateCompanionBuilder,
      (PushToken, BaseReferences<_$AppDatabase, $PushTokensTable, PushToken>),
      PushToken,
      PrefetchHooks Function()
    >;
typedef $$NetWorthSnapshotsTableCreateCompanionBuilder =
    NetWorthSnapshotsCompanion Function({
      required String id,
      required String budgetId,
      required DateTime date,
      required int assets,
      required int liabilities,
      required int netWorth,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$NetWorthSnapshotsTableUpdateCompanionBuilder =
    NetWorthSnapshotsCompanion Function({
      Value<String> id,
      Value<String> budgetId,
      Value<DateTime> date,
      Value<int> assets,
      Value<int> liabilities,
      Value<int> netWorth,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$NetWorthSnapshotsTableFilterComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get assets => $composableBuilder(
    column: $table.assets,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get liabilities => $composableBuilder(
    column: $table.liabilities,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get netWorth => $composableBuilder(
    column: $table.netWorth,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$NetWorthSnapshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get budgetId => $composableBuilder(
    column: $table.budgetId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get assets => $composableBuilder(
    column: $table.assets,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get liabilities => $composableBuilder(
    column: $table.liabilities,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get netWorth => $composableBuilder(
    column: $table.netWorth,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NetWorthSnapshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $NetWorthSnapshotsTable> {
  $$NetWorthSnapshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get budgetId =>
      $composableBuilder(column: $table.budgetId, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get assets =>
      $composableBuilder(column: $table.assets, builder: (column) => column);

  GeneratedColumn<int> get liabilities => $composableBuilder(
    column: $table.liabilities,
    builder: (column) => column,
  );

  GeneratedColumn<int> get netWorth =>
      $composableBuilder(column: $table.netWorth, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$NetWorthSnapshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NetWorthSnapshotsTable,
          NetWorthSnapshot,
          $$NetWorthSnapshotsTableFilterComposer,
          $$NetWorthSnapshotsTableOrderingComposer,
          $$NetWorthSnapshotsTableAnnotationComposer,
          $$NetWorthSnapshotsTableCreateCompanionBuilder,
          $$NetWorthSnapshotsTableUpdateCompanionBuilder,
          (
            NetWorthSnapshot,
            BaseReferences<
              _$AppDatabase,
              $NetWorthSnapshotsTable,
              NetWorthSnapshot
            >,
          ),
          NetWorthSnapshot,
          PrefetchHooks Function()
        > {
  $$NetWorthSnapshotsTableTableManager(
    _$AppDatabase db,
    $NetWorthSnapshotsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NetWorthSnapshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NetWorthSnapshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NetWorthSnapshotsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> budgetId = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<int> assets = const Value.absent(),
                Value<int> liabilities = const Value.absent(),
                Value<int> netWorth = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NetWorthSnapshotsCompanion(
                id: id,
                budgetId: budgetId,
                date: date,
                assets: assets,
                liabilities: liabilities,
                netWorth: netWorth,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String budgetId,
                required DateTime date,
                required int assets,
                required int liabilities,
                required int netWorth,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => NetWorthSnapshotsCompanion.insert(
                id: id,
                budgetId: budgetId,
                date: date,
                assets: assets,
                liabilities: liabilities,
                netWorth: netWorth,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$NetWorthSnapshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NetWorthSnapshotsTable,
      NetWorthSnapshot,
      $$NetWorthSnapshotsTableFilterComposer,
      $$NetWorthSnapshotsTableOrderingComposer,
      $$NetWorthSnapshotsTableAnnotationComposer,
      $$NetWorthSnapshotsTableCreateCompanionBuilder,
      $$NetWorthSnapshotsTableUpdateCompanionBuilder,
      (
        NetWorthSnapshot,
        BaseReferences<
          _$AppDatabase,
          $NetWorthSnapshotsTable,
          NetWorthSnapshot
        >,
      ),
      NetWorthSnapshot,
      PrefetchHooks Function()
    >;
typedef $$SyncMetadataTableCreateCompanionBuilder =
    SyncMetadataCompanion Function({
      required String id,
      required String syncTableName,
      required String recordId,
      required DateTime lastModified,
      Value<bool> isDeleted,
      required String deviceId,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$SyncMetadataTableUpdateCompanionBuilder =
    SyncMetadataCompanion Function({
      Value<String> id,
      Value<String> syncTableName,
      Value<String> recordId,
      Value<DateTime> lastModified,
      Value<bool> isDeleted,
      Value<String> deviceId,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$SyncMetadataTableFilterComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncTableName => $composableBuilder(
    column: $table.syncTableName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SyncMetadataTableOrderingComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncTableName => $composableBuilder(
    column: $table.syncTableName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recordId => $composableBuilder(
    column: $table.recordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDeleted => $composableBuilder(
    column: $table.isDeleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get deviceId => $composableBuilder(
    column: $table.deviceId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SyncMetadataTableAnnotationComposer
    extends Composer<_$AppDatabase, $SyncMetadataTable> {
  $$SyncMetadataTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get syncTableName => $composableBuilder(
    column: $table.syncTableName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recordId =>
      $composableBuilder(column: $table.recordId, builder: (column) => column);

  GeneratedColumn<DateTime> get lastModified => $composableBuilder(
    column: $table.lastModified,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isDeleted =>
      $composableBuilder(column: $table.isDeleted, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$SyncMetadataTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SyncMetadataTable,
          SyncMetadataData,
          $$SyncMetadataTableFilterComposer,
          $$SyncMetadataTableOrderingComposer,
          $$SyncMetadataTableAnnotationComposer,
          $$SyncMetadataTableCreateCompanionBuilder,
          $$SyncMetadataTableUpdateCompanionBuilder,
          (
            SyncMetadataData,
            BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
          ),
          SyncMetadataData,
          PrefetchHooks Function()
        > {
  $$SyncMetadataTableTableManager(_$AppDatabase db, $SyncMetadataTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SyncMetadataTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SyncMetadataTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SyncMetadataTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> syncTableName = const Value.absent(),
                Value<String> recordId = const Value.absent(),
                Value<DateTime> lastModified = const Value.absent(),
                Value<bool> isDeleted = const Value.absent(),
                Value<String> deviceId = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion(
                id: id,
                syncTableName: syncTableName,
                recordId: recordId,
                lastModified: lastModified,
                isDeleted: isDeleted,
                deviceId: deviceId,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String syncTableName,
                required String recordId,
                required DateTime lastModified,
                Value<bool> isDeleted = const Value.absent(),
                required String deviceId,
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SyncMetadataCompanion.insert(
                id: id,
                syncTableName: syncTableName,
                recordId: recordId,
                lastModified: lastModified,
                isDeleted: isDeleted,
                deviceId: deviceId,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SyncMetadataTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SyncMetadataTable,
      SyncMetadataData,
      $$SyncMetadataTableFilterComposer,
      $$SyncMetadataTableOrderingComposer,
      $$SyncMetadataTableAnnotationComposer,
      $$SyncMetadataTableCreateCompanionBuilder,
      $$SyncMetadataTableUpdateCompanionBuilder,
      (
        SyncMetadataData,
        BaseReferences<_$AppDatabase, $SyncMetadataTable, SyncMetadataData>,
      ),
      SyncMetadataData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db, _db.users);
  $$BudgetsTableTableManager get budgets =>
      $$BudgetsTableTableManager(_db, _db.budgets);
  $$BudgetMembersTableTableManager get budgetMembers =>
      $$BudgetMembersTableTableManager(_db, _db.budgetMembers);
  $$BudgetPeriodsTableTableManager get budgetPeriods =>
      $$BudgetPeriodsTableTableManager(_db, _db.budgetPeriods);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db, _db.accounts);
  $$CategoryGroupsTableTableManager get categoryGroups =>
      $$CategoryGroupsTableTableManager(_db, _db.categoryGroups);
  $$EnvelopesTableTableManager get envelopes =>
      $$EnvelopesTableTableManager(_db, _db.envelopes);
  $$EnvelopeAllocationsTableTableManager get envelopeAllocations =>
      $$EnvelopeAllocationsTableTableManager(_db, _db.envelopeAllocations);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db, _db.transactions);
  $$TransactionSplitsTableTableManager get transactionSplits =>
      $$TransactionSplitsTableTableManager(_db, _db.transactionSplits);
  $$TagsTableTableManager get tags => $$TagsTableTableManager(_db, _db.tags);
  $$TransactionTagsTableTableManager get transactionTags =>
      $$TransactionTagsTableTableManager(_db, _db.transactionTags);
  $$RecurringRulesTableTableManager get recurringRules =>
      $$RecurringRulesTableTableManager(_db, _db.recurringRules);
  $$BillRemindersTableTableManager get billReminders =>
      $$BillRemindersTableTableManager(_db, _db.billReminders);
  $$AllocationTemplatesTableTableManager get allocationTemplates =>
      $$AllocationTemplatesTableTableManager(_db, _db.allocationTemplates);
  $$AllocationTemplateItemsTableTableManager get allocationTemplateItems =>
      $$AllocationTemplateItemsTableTableManager(
        _db,
        _db.allocationTemplateItems,
      );
  $$GoalsTableTableManager get goals =>
      $$GoalsTableTableManager(_db, _db.goals);
  $$GoalContributionsTableTableManager get goalContributions =>
      $$GoalContributionsTableTableManager(_db, _db.goalContributions);
  $$DebtAccountsTableTableManager get debtAccounts =>
      $$DebtAccountsTableTableManager(_db, _db.debtAccounts);
  $$ActivityLogTableTableManager get activityLog =>
      $$ActivityLogTableTableManager(_db, _db.activityLog);
  $$NotificationPreferencesTableTableManager get notificationPreferences =>
      $$NotificationPreferencesTableTableManager(
        _db,
        _db.notificationPreferences,
      );
  $$PushTokensTableTableManager get pushTokens =>
      $$PushTokensTableTableManager(_db, _db.pushTokens);
  $$NetWorthSnapshotsTableTableManager get netWorthSnapshots =>
      $$NetWorthSnapshotsTableTableManager(_db, _db.netWorthSnapshots);
  $$SyncMetadataTableTableManager get syncMetadata =>
      $$SyncMetadataTableTableManager(_db, _db.syncMetadata);
}
