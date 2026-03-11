part of 'sync_bloc.dart';

final class SyncBlocState extends Equatable {
  const SyncBlocState({
    this.syncStatus = const SyncStatus(),
    this.isOnline = true,
  });

  final SyncStatus syncStatus;
  final bool isOnline;

  SyncBlocState copyWith({
    SyncStatus? syncStatus,
    bool? isOnline,
  }) {
    return SyncBlocState(
      syncStatus: syncStatus ?? this.syncStatus,
      isOnline: isOnline ?? this.isOnline,
    );
  }

  @override
  List<Object?> get props => [syncStatus, isOnline];
}
