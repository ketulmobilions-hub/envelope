part of 'sync_bloc.dart';

sealed class SyncEvent extends Equatable {
  const SyncEvent();

  @override
  List<Object?> get props => [];
}

final class SyncStarted extends SyncEvent {
  const SyncStarted();
}

final class SyncRequested extends SyncEvent {
  const SyncRequested();
}

final class _SyncStatusChanged extends SyncEvent {
  const _SyncStatusChanged(this.syncStatus);

  final SyncStatus syncStatus;

  @override
  List<Object?> get props => [syncStatus];
}

final class _ConnectivityChanged extends SyncEvent {
  const _ConnectivityChanged({required this.isOnline});

  final bool isOnline;

  @override
  List<Object?> get props => [isOnline];
}
