import 'package:drift/drift.dart';

class AllocationTemplateItems extends Table {
  TextColumn get id => text()();
  TextColumn get templateId => text().named('template_id')();
  TextColumn get envelopeId => text().named('envelope_id')();
  RealColumn get percentage => real()();

  @override
  Set<Column> get primaryKey => {id};
}
