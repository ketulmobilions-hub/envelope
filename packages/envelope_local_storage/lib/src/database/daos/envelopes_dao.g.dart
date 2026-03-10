// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'envelopes_dao.dart';

// ignore_for_file: type=lint
mixin _$EnvelopesDaoMixin on DatabaseAccessor<AppDatabase> {
  $CategoryGroupsTable get categoryGroups => attachedDatabase.categoryGroups;
  $EnvelopesTable get envelopes => attachedDatabase.envelopes;
  $EnvelopeAllocationsTable get envelopeAllocations =>
      attachedDatabase.envelopeAllocations;
  $AllocationTemplatesTable get allocationTemplates =>
      attachedDatabase.allocationTemplates;
  $AllocationTemplateItemsTable get allocationTemplateItems =>
      attachedDatabase.allocationTemplateItems;
  EnvelopesDaoManager get managers => EnvelopesDaoManager(this);
}

class EnvelopesDaoManager {
  final _$EnvelopesDaoMixin _db;
  EnvelopesDaoManager(this._db);
  $$CategoryGroupsTableTableManager get categoryGroups =>
      $$CategoryGroupsTableTableManager(
        _db.attachedDatabase,
        _db.categoryGroups,
      );
  $$EnvelopesTableTableManager get envelopes =>
      $$EnvelopesTableTableManager(_db.attachedDatabase, _db.envelopes);
  $$EnvelopeAllocationsTableTableManager get envelopeAllocations =>
      $$EnvelopeAllocationsTableTableManager(
        _db.attachedDatabase,
        _db.envelopeAllocations,
      );
  $$AllocationTemplatesTableTableManager get allocationTemplates =>
      $$AllocationTemplatesTableTableManager(
        _db.attachedDatabase,
        _db.allocationTemplates,
      );
  $$AllocationTemplateItemsTableTableManager get allocationTemplateItems =>
      $$AllocationTemplateItemsTableTableManager(
        _db.attachedDatabase,
        _db.allocationTemplateItems,
      );
}
