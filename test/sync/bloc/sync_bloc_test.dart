import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sync_repository/sync_repository.dart';

class _MockSyncRepository extends Mock implements SyncRepository {}

class _MockConnectivity extends Mock implements Connectivity {}

void main() {
  late SyncRepository syncRepository;
  late Connectivity connectivity;
  late StreamController<SyncStatus> syncStatusController;
  late StreamController<List<ConnectivityResult>> connectivityController;

  setUp(() {
    syncRepository = _MockSyncRepository();
    connectivity = _MockConnectivity();
    syncStatusController = StreamController<SyncStatus>.broadcast();
    connectivityController =
        StreamController<List<ConnectivityResult>>.broadcast();

    when(() => syncRepository.syncStatus)
        .thenAnswer((_) => syncStatusController.stream);
    when(() => syncRepository.syncNow()).thenAnswer((_) async {});
    when(() => syncRepository.dispose()).thenAnswer((_) async {});
    when(() => connectivity.onConnectivityChanged)
        .thenAnswer((_) => connectivityController.stream);
    when(() => connectivity.checkConnectivity())
        .thenAnswer((_) async => [ConnectivityResult.wifi]);
  });

  tearDown(() async {
    await syncStatusController.close();
    await connectivityController.close();
  });

  group('SyncBloc', () {
    test('has correct initial state', () async {
      final bloc = SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      );
      expect(bloc.state, equals(const SyncBlocState()));
      await bloc.close();
    });

    blocTest<SyncBloc, SyncBlocState>(
      'subscribes to streams and checks connectivity on SyncStarted',
      build: () => SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      ),
      act: (bloc) => bloc.add(const SyncStarted()),
      expect: () => [
        const SyncBlocState(),
      ],
      verify: (_) {
        verify(() => syncRepository.syncStatus).called(1);
        verify(() => connectivity.onConnectivityChanged).called(1);
        verify(() => connectivity.checkConnectivity()).called(1);
      },
    );

    blocTest<SyncBloc, SyncBlocState>(
      'updates state when sync status changes',
      build: () => SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      ),
      act: (bloc) async {
        bloc.add(const SyncStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        syncStatusController.add(
          const SyncStatus(state: SyncState.syncing),
        );
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SyncBlocState(),
        const SyncBlocState(
          syncStatus: SyncStatus(state: SyncState.syncing),
        ),
      ],
    );

    blocTest<SyncBloc, SyncBlocState>(
      'updates connectivity state when connectivity changes',
      build: () => SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      ),
      act: (bloc) async {
        bloc.add(const SyncStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        connectivityController.add([ConnectivityResult.none]);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SyncBlocState(),
        const SyncBlocState(isOnline: false),
      ],
    );

    blocTest<SyncBloc, SyncBlocState>(
      'triggers syncNow on offline to online transition',
      build: () {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);
        return SyncBloc(
          syncRepository: syncRepository,
          connectivity: connectivity,
        );
      },
      act: (bloc) async {
        bloc.add(const SyncStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        connectivityController.add([ConnectivityResult.wifi]);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SyncBlocState(isOnline: false),
        const SyncBlocState(),
      ],
      verify: (_) {
        verify(() => syncRepository.syncNow()).called(1);
      },
    );

    blocTest<SyncBloc, SyncBlocState>(
      'does NOT trigger syncNow on online to online (no transition)',
      build: () => SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      ),
      act: (bloc) async {
        bloc.add(const SyncStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        connectivityController.add([ConnectivityResult.mobile]);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SyncBlocState(),
      ],
      verify: (_) {
        verifyNever(() => syncRepository.syncNow());
      },
    );

    blocTest<SyncBloc, SyncBlocState>(
      'triggers syncNow on SyncRequested',
      build: () => SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      ),
      act: (bloc) => bloc.add(const SyncRequested()),
      verify: (_) {
        verify(() => syncRepository.syncNow()).called(1);
      },
    );

    blocTest<SyncBloc, SyncBlocState>(
      'sets isOnline to false when initial check returns none',
      build: () {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);
        return SyncBloc(
          syncRepository: syncRepository,
          connectivity: connectivity,
        );
      },
      act: (bloc) => bloc.add(const SyncStarted()),
      expect: () => [
        const SyncBlocState(isOnline: false),
      ],
    );

    blocTest<SyncBloc, SyncBlocState>(
      'defaults to online when checkConnectivity throws',
      build: () {
        when(() => connectivity.checkConnectivity())
            .thenThrow(Exception('Platform not supported'));
        return SyncBloc(
          syncRepository: syncRepository,
          connectivity: connectivity,
        );
      },
      act: (bloc) => bloc.add(const SyncStarted()),
      expect: () => [
        const SyncBlocState(),
      ],
    );

    blocTest<SyncBloc, SyncBlocState>(
      'handles syncNow failure on offline to online transition',
      build: () {
        when(() => connectivity.checkConnectivity())
            .thenAnswer((_) async => [ConnectivityResult.none]);
        when(() => syncRepository.syncNow())
            .thenAnswer((_) async => throw Exception('Sync failed'));
        return SyncBloc(
          syncRepository: syncRepository,
          connectivity: connectivity,
        );
      },
      act: (bloc) async {
        bloc.add(const SyncStarted());
        await Future<void>.delayed(const Duration(milliseconds: 10));
        connectivityController.add([ConnectivityResult.wifi]);
      },
      wait: const Duration(milliseconds: 10),
      expect: () => [
        const SyncBlocState(isOnline: false),
        const SyncBlocState(),
      ],
    );

    test('cancels subscriptions and disposes repository on close', () async {
      final bloc = SyncBloc(
        syncRepository: syncRepository,
        connectivity: connectivity,
      )..add(const SyncStarted());
      await Future<void>.delayed(const Duration(milliseconds: 10));
      await bloc.close();

      expect(bloc.isClosed, isTrue);
      verify(() => syncRepository.dispose()).called(1);
    });
  });
}
