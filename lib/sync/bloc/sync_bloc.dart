import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:sync_repository/sync_repository.dart';

part 'sync_event.dart';
part 'sync_state.dart';

class SyncBloc extends Bloc<SyncEvent, SyncBlocState> {
  SyncBloc({
    required SyncRepository syncRepository,
    Connectivity? connectivity,
  }) : _syncRepository = syncRepository,
       _connectivity = connectivity ?? Connectivity(),
       super(const SyncBlocState()) {
    on<SyncStarted>(_onStarted);
    on<SyncRequested>(_onRequested);
    on<_SyncStatusChanged>(_onSyncStatusChanged);
    on<_ConnectivityChanged>(_onConnectivityChanged);
  }

  final SyncRepository _syncRepository;
  final Connectivity _connectivity;
  StreamSubscription<SyncStatus>? _syncStatusSubscription;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  Future<void> _onStarted(
    SyncStarted event,
    Emitter<SyncBlocState> emit,
  ) async {
    _syncStatusSubscription = _syncRepository.syncStatus.listen(
      (status) => add(_SyncStatusChanged(status)),
    );

    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (results) {
        final isOnline = !results.contains(ConnectivityResult.none);
        add(_ConnectivityChanged(isOnline: isOnline));
      },
    );

    // Check initial connectivity
    try {
      final results = await _connectivity.checkConnectivity();
      final isOnline = !results.contains(ConnectivityResult.none);
      emit(state.copyWith(isOnline: isOnline));
    } on Exception {
      // Default to online if connectivity check fails
      emit(state.copyWith(isOnline: true));
    }
  }

  void _onSyncStatusChanged(
    _SyncStatusChanged event,
    Emitter<SyncBlocState> emit,
  ) {
    emit(state.copyWith(syncStatus: event.syncStatus));
  }

  void _onConnectivityChanged(
    _ConnectivityChanged event,
    Emitter<SyncBlocState> emit,
  ) {
    final wasOffline = !state.isOnline;
    emit(state.copyWith(isOnline: event.isOnline));

    // Auto-sync on offline → online transition
    if (wasOffline && event.isOnline) {
      unawaited(
        _syncRepository.syncNow().catchError((Object _) {
          // syncNow handles errors internally via the status stream
        }),
      );
    }
  }

  Future<void> _onRequested(
    SyncRequested event,
    Emitter<SyncBlocState> emit,
  ) async {
    emit(
      state.copyWith(
        syncStatus: state.syncStatus.copyWith(state: SyncState.syncing),
      ),
    );
    // Run the sync but hold the spinner for at least 800 ms. Without this
    // minimum, Device B's syncNow() completes in < 16 ms (nothing to push,
    // Realtime already cached the data), so the syncing→synced state changes
    // both land before Flutter paints a frame — the spinner is never visible.
    await Future.wait([
      _syncRepository.syncNow(),
      Future<void>.delayed(const Duration(milliseconds: 800)),
    ]);
  }

  @override
  Future<void> close() async {
    await _syncStatusSubscription?.cancel();
    await _connectivitySubscription?.cancel();
    await _syncRepository.dispose();
    return super.close();
  }
}
