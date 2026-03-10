import 'package:drift/drift.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get email => text()();
  TextColumn get displayName => text().named('display_name')();
  TextColumn get baseCurrency =>
      text().named('base_currency').withDefault(const Constant('USD'))();
  TextColumn get themeMode =>
      text().named('theme_mode').withDefault(const Constant('system'))();
  TextColumn get accentColor => text().named('accent_color').nullable()();
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();

  @override
  Set<Column> get primaryKey => {id};
}
