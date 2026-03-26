import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:sharing_repository/sharing_repository.dart';

part 'activity_log_event.dart';
part 'activity_log_state.dart';

class ActivityLogBloc extends Bloc<ActivityLogEvent, ActivityLogState> {
  ActivityLogBloc({
    required SharingRepository sharingRepository,
    required String budgetId,
  })  : _sharingRepository = sharingRepository,
        _budgetId = budgetId,
        super(const ActivityLogState()) {
    on<ActivityLogStarted>(_onStarted);
    on<ActivityLogRefreshRequested>(_onRefreshRequested);
    on<ActivityLogFilterChanged>(_onFilterChanged);
    on<_ActivityLogUpdated>(_onUpdated);
    on<_ActivityLogStreamError>(_onStreamError);
  }

  final SharingRepository _sharingRepository;
  final String _budgetId;
  StreamSubscription<List<ActivityLogEntry>>? _activitySubscription;

  Future<void> _onStarted(
    ActivityLogStarted event,
    Emitter<ActivityLogState> emit,
  ) async {
    emit(state.copyWith(status: ActivityLogStatus.loading));

    await _activitySubscription?.cancel();
    _activitySubscription = _sharingRepository
        .watchActivityLog(_budgetId)
        .listen(
          (entries) => add(_ActivityLogUpdated(entries)),
          onError: (Object _) => add(const _ActivityLogStreamError()),
        );

    try {
      await _sharingRepository.refreshActivityLog(_budgetId);
    } on SharingException {
      // Local watch will still show cached data.
    }
  }

  void _onUpdated(
    _ActivityLogUpdated event,
    Emitter<ActivityLogState> emit,
  ) {
    emit(
      state.copyWith(
        status: ActivityLogStatus.loaded,
        entries: event.entries,
      ),
    );
  }

  void _onStreamError(
    _ActivityLogStreamError event,
    Emitter<ActivityLogState> emit,
  ) {
    emit(
      state.copyWith(
        status: ActivityLogStatus.error,
        error: ActivityLogError.loadFailed,
      ),
    );
    emit(state.copyWith(status: ActivityLogStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    ActivityLogRefreshRequested event,
    Emitter<ActivityLogState> emit,
  ) async {
    try {
      await _sharingRepository.refreshActivityLog(_budgetId);
    } on SharingException {
      // Stream will update on its own if data changes.
    }
  }

  void _onFilterChanged(
    ActivityLogFilterChanged event,
    Emitter<ActivityLogState> emit,
  ) {
    emit(
      state.copyWith(
        filterByUserId: event.userId,
        filterByAction: event.action,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _activitySubscription?.cancel();
    return super.close();
  }
}
