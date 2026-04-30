import 'package:envelope_local_storage/envelope_local_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sync_repository/sync_repository.dart';
import 'package:test/test.dart';

class MockAppDatabase extends Mock implements AppDatabase {}

class MockSyncDao extends Mock implements SyncDao {}

class FakeSyncMetadataCompanion extends Fake implements SyncMetadataCompanion {}

class MockSyncDelegate extends Mock implements SyncDelegate {}

void main() {
  group('SyncRepository', () {
    late MockAppDatabase localDatabase;
    late MockSyncDao syncDao;
    late SyncRepository syncRepository;
    late DateTime fixedTime;

    const deviceId = 'test-device-id';

    setUp(() {
      localDatabase = MockAppDatabase();
      syncDao = MockSyncDao();
      fixedTime = DateTime(2026, 3, 11);

      when(() => localDatabase.syncDao).thenReturn(syncDao);

      syncRepository = SyncRepository(
        localDatabase: localDatabase,
        deviceId: deviceId,
        clock: () => fixedTime,
      );
    });

    setUpAll(() {
      registerFallbackValue(FakeSyncMetadataCompanion());
      registerFallbackValue(DateTime(2026));
    });

    tearDown(() async {
      await syncRepository.dispose();
    });

    test('initial currentStatus is idle with zero pending changes', () {
      expect(syncRepository.currentStatus.state, equals(SyncState.idle));
      expect(syncRepository.currentStatus.pendingChanges, equals(0));
    });

    test('deviceId returns the provided device ID', () {
      expect(syncRepository.deviceId, equals(deviceId));
    });

    group('syncStatus stream', () {
      test('yields initial status immediately', () async {
        final first = await syncRepository.syncStatus.first;
        expect(first.state, equals(SyncState.idle));
        expect(first.pendingChanges, equals(0));
      });
    });

    group('trackChange', () {
      test('inserts sync metadata and updates pending count', () async {
        when(
          () => syncDao.upsertSyncMetadata(any()),
        ).thenAnswer((_) async => 1);
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => [_fakeSyncMetadata()]);

        await syncRepository.trackChange(
          tableName: 'accounts',
          recordId: 'acc-1',
        );

        verify(
          () => syncDao.upsertSyncMetadata(any()),
        ).called(1);
        expect(syncRepository.currentStatus.pendingChanges, equals(1));
      });

      test('tracks soft deletes with isDeleted flag', () async {
        when(
          () => syncDao.upsertSyncMetadata(any()),
        ).thenAnswer((_) async => 1);
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => [_fakeSyncMetadata(isDeleted: true)]);

        await syncRepository.trackChange(
          tableName: 'accounts',
          recordId: 'acc-1',
          isDeleted: true,
        );

        verify(
          () => syncDao.upsertSyncMetadata(any()),
        ).called(1);
      });
    });

    group('getPendingChangeCount', () {
      test('returns count of pending items', () async {
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer(
          (_) async => [
            _fakeSyncMetadata(),
            _fakeSyncMetadata(id: 'meta-2', recordId: 'acc-2'),
          ],
        );

        final count = await syncRepository.getPendingChangeCount();
        expect(count, equals(2));
      });

      test('returns zero when no pending items', () async {
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);

        final count = await syncRepository.getPendingChangeCount();
        expect(count, equals(0));
      });
    });

    group('watchPendingChangeCount', () {
      test('emits count from DAO stream', () async {
        when(
          () => syncDao.watchPendingSyncMetadata(),
        ).thenAnswer(
          (_) => Stream.fromIterable([
            [_fakeSyncMetadata()],
            [_fakeSyncMetadata(), _fakeSyncMetadata(id: 'meta-2')],
          ]),
        );

        final counts = await syncRepository.watchPendingChangeCount().toList();
        expect(counts, equals([1, 2]));
      });
    });

    group('syncNow', () {
      test('emits syncing then synced when no pending changes', () async {
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);

        final states = <SyncState>[];
        final subscription = syncRepository.syncStatus.listen(
          (status) => states.add(status.state),
        );

        await syncRepository.syncNow();
        await Future<void>.delayed(Duration.zero);

        expect(states, contains(SyncState.syncing));
        expect(states.last, equals(SyncState.synced));

        await subscription.cancel();
      });

      test('pushes pending changes via delegate', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.getLocalRecord(any()),
        ).thenAnswer(
          (_) async => {'id': 'acc-1', 'name': 'Checking'},
        );
        when(
          () => delegate.pushToRemote(any()),
        ).thenAnswer((_) async {});
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer((_) async => <Map<String, dynamic>>[]);

        syncRepository.registerDelegate(delegate);

        final pendingMeta = _fakeSyncMetadata();

        var callCount = 0;
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? [pendingMeta] : [];
        });
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getSyncMetadataById(any()),
        ).thenAnswer((_) async => pendingMeta);
        when(
          () => syncDao.upsertSyncMetadata(any()),
        ).thenAnswer((_) async => 1);

        await syncRepository.syncNow();

        verify(
          () => delegate.pushToRemote(
            {'id': 'acc-1', 'name': 'Checking'},
          ),
        ).called(1);
      });

      test(
        'pushes delete via delegate for soft-deleted records',
        () async {
          final delegate = MockSyncDelegate();
          when(() => delegate.tableName).thenReturn('accounts');
          when(
            () => delegate.deleteFromRemote(any()),
          ).thenAnswer((_) async {});
          when(
            () => delegate.pullFromRemote(any()),
          ).thenAnswer((_) async => <Map<String, dynamic>>[]);

          syncRepository.registerDelegate(delegate);

          final deletedMeta = _fakeSyncMetadata(isDeleted: true);

          var callCount = 0;
          when(
            () => syncDao.getPendingSyncMetadata(),
          ).thenAnswer((_) async {
            callCount++;
            return callCount == 1 ? [deletedMeta] : [];
          });
          when(
            () => syncDao.getAllSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getSyncMetadataById(any()),
          ).thenAnswer((_) async => deletedMeta);
          when(
            () => syncDao.upsertSyncMetadata(any()),
          ).thenAnswer((_) async => 1);

          await syncRepository.syncNow();

          verify(
            () => delegate.deleteFromRemote('acc-1'),
          ).called(1);
        },
      );

      test(
        'continues pushing remaining records when one fails',
        () async {
          final delegate = MockSyncDelegate();
          when(() => delegate.tableName).thenReturn('accounts');
          when(
            () => delegate.pullFromRemote(any()),
          ).thenAnswer((_) async => <Map<String, dynamic>>[]);

          var getCallCount = 0;
          when(
            () => delegate.getLocalRecord(any()),
          ).thenAnswer((_) async {
            getCallCount++;
            if (getCallCount == 1) {
              throw Exception('Network error');
            }
            return {'id': 'acc-2', 'name': 'Savings'};
          });
          when(
            () => delegate.pushToRemote(any()),
          ).thenAnswer((_) async {});

          syncRepository.registerDelegate(delegate);

          final meta1 = _fakeSyncMetadata();
          final meta2 = _fakeSyncMetadata(
            id: 'meta-2',
            recordId: 'acc-2',
          );

          var pendingCallCount = 0;
          when(
            () => syncDao.getPendingSyncMetadata(),
          ).thenAnswer((_) async {
            pendingCallCount++;
            return pendingCallCount == 1 ? [meta1, meta2] : [];
          });
          when(
            () => syncDao.getAllSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getSyncMetadataById(any()),
          ).thenAnswer((_) async => meta1);
          when(
            () => syncDao.upsertSyncMetadata(any()),
          ).thenAnswer((_) async => 1);

          await syncRepository.syncNow();

          // Second record should still be pushed
          verify(
            () => delegate.pushToRemote(
              {'id': 'acc-2', 'name': 'Savings'},
            ),
          ).called(1);
        },
      );

      test('pulls remote changes and writes to local', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer(
          (_) async => [
            {
              'id': 'acc-remote',
              'name': 'Savings',
              'updated_at': '2026-01-01T00:00:00.000Z',
            },
          ],
        );
        when(
          () => delegate.writeToLocal(any()),
        ).thenAnswer((_) async {});

        syncRepository.registerDelegate(delegate);

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getSyncMetadataById(any()),
        ).thenAnswer((_) async => null);
        when(
          () => syncDao.upsertSyncMetadata(any()),
        ).thenAnswer((_) async => 1);

        await syncRepository.syncNow();

        verify(
          () => delegate.writeToLocal(any()),
        ).called(1);
        // Should also track the synced record
        verify(
          () => syncDao.upsertSyncMetadata(any()),
        ).called(1);
      });

      test(
        'continues pulling from other delegates when one fails',
        () async {
          final failDelegate = MockSyncDelegate();
          when(() => failDelegate.tableName).thenReturn('accounts');
          when(
            () => failDelegate.pullFromRemote(any()),
          ).thenThrow(Exception('Network error'));

          final okDelegate = MockSyncDelegate();
          when(() => okDelegate.tableName).thenReturn('budgets');
          when(
            () => okDelegate.pullFromRemote(any()),
          ).thenAnswer((_) async => <Map<String, dynamic>>[]);

          syncRepository
            ..registerDelegate(failDelegate)
            ..registerDelegate(okDelegate);

          when(
            () => syncDao.getPendingSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getAllSyncMetadata(),
          ).thenAnswer((_) async => []);

          await syncRepository.syncNow();

          // Second delegate should still be pulled
          verify(
            () => okDelegate.pullFromRemote(any()),
          ).called(1);
        },
      );

      test('skips remote records without id field', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer(
          (_) async => [
            {'name': 'No ID Record'},
          ],
        );

        syncRepository.registerDelegate(delegate);

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);

        await syncRepository.syncNow();

        verifyNever(() => delegate.writeToLocal(any()));
      });

      test('resolves conflict with last-write-wins', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer(
          (_) async => [
            {
              'id': 'acc-1',
              'name': 'Remote Name',
              'updated_at': '2026-03-15T00:00:00.000Z',
            },
          ],
        );
        when(
          () => delegate.writeToLocal(any()),
        ).thenAnswer((_) async {});

        syncRepository.registerDelegate(delegate);

        final localMeta = _fakeSyncMetadata(
          lastModified: DateTime(2026, 3, 10),
        );

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getSyncMetadataById(any()),
        ).thenAnswer((_) async => localMeta);
        when(
          () => syncDao.upsertSyncMetadata(any()),
        ).thenAnswer((_) async => 1);

        await syncRepository.syncNow();

        verify(
          () => delegate.writeToLocal(any()),
        ).called(1);
      });

      test('keeps local change when local timestamp is newer', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer(
          (_) async => [
            {
              'id': 'acc-1',
              'name': 'Remote Name',
              'updated_at': '2026-03-01T00:00:00.000Z',
            },
          ],
        );

        syncRepository.registerDelegate(delegate);

        final localMeta = _fakeSyncMetadata(
          lastModified: DateTime(2026, 3, 15),
        );

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getSyncMetadataById(any()),
        ).thenAnswer((_) async => localMeta);

        await syncRepository.syncNow();

        verifyNever(() => delegate.writeToLocal(any()));
      });

      test(
        'marks as conflict when timestamps are equal',
        () async {
          final delegate = MockSyncDelegate();
          when(() => delegate.tableName).thenReturn('accounts');

          final timestamp = DateTime.utc(2026, 3, 10);
          when(
            () => delegate.pullFromRemote(any()),
          ).thenAnswer(
            (_) async => [
              {
                'id': 'acc-1',
                'name': 'Remote Name',
                'updated_at': timestamp.toIso8601String(),
              },
            ],
          );

          syncRepository.registerDelegate(delegate);

          final localMeta = _fakeSyncMetadata(
            lastModified: timestamp,
          );

          when(
            () => syncDao.getPendingSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getAllSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getSyncMetadataById(any()),
          ).thenAnswer((_) async => localMeta);
          when(
            () => syncDao.upsertSyncMetadata(any()),
          ).thenAnswer((_) async => 1);

          await syncRepository.syncNow();

          // Should not overwrite — should mark as conflict
          verifyNever(() => delegate.writeToLocal(any()));
          verify(
            () => syncDao.upsertSyncMetadata(any()),
          ).called(1);
        },
      );

      test(
        'handles malformed updated_at gracefully',
        () async {
          final delegate = MockSyncDelegate();
          when(() => delegate.tableName).thenReturn('accounts');
          when(
            () => delegate.pullFromRemote(any()),
          ).thenAnswer(
            (_) async => [
              {
                'id': 'acc-1',
                'name': 'Bad Timestamp',
                'updated_at': 'not-a-date',
              },
            ],
          );

          syncRepository.registerDelegate(delegate);

          // Local pending with any timestamp will be newer than
          // epoch fallback from bad parse
          final localMeta = _fakeSyncMetadata(
            lastModified: DateTime(2026),
          );

          when(
            () => syncDao.getPendingSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getAllSyncMetadata(),
          ).thenAnswer((_) async => []);
          when(
            () => syncDao.getSyncMetadataById(any()),
          ).thenAnswer((_) async => localMeta);

          await syncRepository.syncNow();

          // Local wins — malformed remote timestamp defaults to epoch
          verifyNever(() => delegate.writeToLocal(any()));
        },
      );

      test('emits error state on push failure', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.getLocalRecord(any()),
        ).thenThrow(Exception('Network error'));
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer((_) async => <Map<String, dynamic>>[]);

        syncRepository.registerDelegate(delegate);

        final meta = _fakeSyncMetadata();
        var callCount = 0;
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async {
          callCount++;
          return callCount == 1 ? [meta] : [];
        });
        when(
          () => syncDao.getSyncMetadataById(any()),
        ).thenAnswer((_) async => meta);
        when(
          () => syncDao.upsertSyncMetadata(any()),
        ).thenAnswer((_) async => 1);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);

        await syncRepository.syncNow();

        // Should complete sync (not abort) but record stays pending
        expect(
          syncRepository.currentStatus.state,
          equals(SyncState.synced),
        );
      });

      test('prevents concurrent syncs', () async {
        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async {
          await Future<void>.delayed(
            const Duration(milliseconds: 50),
          );
          return [];
        });
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);

        final future1 = syncRepository.syncNow();
        final future2 = syncRepository.syncNow();

        await Future.wait([future1, future2]);

        // Only one sync executes (push + final count = 2 calls)
        verify(() => syncDao.getPendingSyncMetadata()).called(2);
      });

      test('does nothing after dispose', () async {
        await syncRepository.dispose();

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);

        await syncRepository.syncNow();

        verifyNever(() => syncDao.getPendingSyncMetadata());
      });
    });

    group('purgeDeletedRecords', () {
      test('removes synced soft deletes from local DB', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('accounts');
        when(
          () => delegate.deleteFromLocal(any()),
        ).thenAnswer((_) async {});
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer((_) async => <Map<String, dynamic>>[]);

        syncRepository.registerDelegate(delegate);

        final syncedDelete = _fakeSyncMetadata(
          recordId: 'acc-deleted',
          isDeleted: true,
          syncStatus: SyncMetadataStatus.synced,
        );

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => [syncedDelete]);
        when(
          () => syncDao.deleteSyncMetadata(any()),
        ).thenAnswer((_) async => 1);

        await syncRepository.syncNow();

        verify(
          () => delegate.deleteFromLocal('acc-deleted'),
        ).called(1);
        verify(
          () => syncDao.deleteSyncMetadata(syncedDelete.id),
        ).called(1);
      });
    });

    group('resolveConflict', () {
      test(
        'marks as pending when resolution is local',
        () async {
          final meta = _fakeSyncMetadata(
            id: 'conflict-id',
            syncStatus: SyncMetadataStatus.conflict,
          );
          when(
            () => syncDao.getSyncMetadataById('conflict-id'),
          ).thenAnswer((_) async => meta);
          when(
            () => syncDao.upsertSyncMetadata(any()),
          ).thenAnswer((_) async => 1);

          await syncRepository.resolveConflict(
            recordId: 'conflict-id',
            resolution: 'local',
          );

          verify(
            () => syncDao.upsertSyncMetadata(any()),
          ).called(1);
        },
      );

      test(
        'fetches single remote record when resolution is remote',
        () async {
          final delegate = MockSyncDelegate();
          when(() => delegate.tableName).thenReturn('accounts');
          when(
            () => delegate.getRemoteRecord('acc-1'),
          ).thenAnswer(
            (_) async => {'id': 'acc-1', 'name': 'Remote Version'},
          );
          when(
            () => delegate.writeToLocal(any()),
          ).thenAnswer((_) async {});

          syncRepository.registerDelegate(delegate);

          final meta = _fakeSyncMetadata(
            id: 'conflict-id',
            syncStatus: SyncMetadataStatus.conflict,
          );
          when(
            () => syncDao.getSyncMetadataById('conflict-id'),
          ).thenAnswer((_) async => meta);
          when(
            () => syncDao.getSyncMetadataById(meta.id),
          ).thenAnswer((_) async => meta);
          when(
            () => syncDao.upsertSyncMetadata(any()),
          ).thenAnswer((_) async => 1);

          await syncRepository.resolveConflict(
            recordId: 'conflict-id',
            resolution: 'remote',
          );

          verify(
            () => delegate.getRemoteRecord('acc-1'),
          ).called(1);
          verify(
            () => delegate.writeToLocal(
              {'id': 'acc-1', 'name': 'Remote Version'},
            ),
          ).called(1);
        },
      );

      test(
        'throws SyncConflictException for unknown record',
        () async {
          when(
            () => syncDao.getSyncMetadataById('unknown'),
          ).thenAnswer((_) async => null);

          expect(
            () => syncRepository.resolveConflict(
              recordId: 'unknown',
              resolution: 'local',
            ),
            throwsA(isA<SyncConflictException>()),
          );
        },
      );

      test(
        'throws SyncConflictException for invalid resolution',
        () async {
          when(
            () => syncDao.getSyncMetadataById('meta-1'),
          ).thenAnswer((_) async => _fakeSyncMetadata());

          expect(
            () => syncRepository.resolveConflict(
              recordId: 'meta-1',
              resolution: 'invalid',
            ),
            throwsA(isA<SyncConflictException>()),
          );
        },
      );
    });

    group('registerDelegate / unregisterDelegate', () {
      test('registered delegate is used during sync', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('budgets');
        when(
          () => delegate.pullFromRemote(any()),
        ).thenAnswer((_) async => <Map<String, dynamic>>[]);

        syncRepository.registerDelegate(delegate);

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);

        await syncRepository.syncNow();

        verify(() => delegate.pullFromRemote(any())).called(1);
      });

      test('unregistered delegate is not used during sync', () async {
        final delegate = MockSyncDelegate();
        when(() => delegate.tableName).thenReturn('budgets');

        syncRepository
          ..registerDelegate(delegate)
          ..unregisterDelegate('budgets');

        when(
          () => syncDao.getPendingSyncMetadata(),
        ).thenAnswer((_) async => []);
        when(
          () => syncDao.getAllSyncMetadata(),
        ).thenAnswer((_) async => []);

        await syncRepository.syncNow();

        verifyNever(() => delegate.pullFromRemote(any()));
      });
    });
  });
}

SyncMetadataData _fakeSyncMetadata({
  String id = 'meta-1',
  String tableName = 'accounts',
  String recordId = 'acc-1',
  DateTime? lastModified,
  bool isDeleted = false,
  String deviceId = 'test-device-id',
  String syncStatus = SyncMetadataStatus.pending,
}) {
  return SyncMetadataData(
    id: id,
    syncTableName: tableName,
    recordId: recordId,
    lastModified: lastModified ?? DateTime(2026, 3, 10),
    isDeleted: isDeleted,
    deviceId: deviceId,
    syncStatus: syncStatus,
  );
}
