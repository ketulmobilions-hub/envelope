import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';

part 'envelopes_event.dart';
part 'envelopes_state.dart';

class EnvelopesBloc extends Bloc<EnvelopesEvent, EnvelopesState> {
  EnvelopesBloc({
    required EnvelopeRepository envelopeRepository,
    required String budgetId,
  })  : _envelopeRepository = envelopeRepository,
        _budgetId = budgetId,
        super(const EnvelopesState()) {
    on<EnvelopesStarted>(_onStarted);
    on<_CategoryGroupsUpdated>(_onCategoryGroupsUpdated);
    on<_EnvelopesUpdated>(_onEnvelopesUpdated);
    on<_EnvelopesStreamError>(_onStreamError);
    on<EnvelopesRefreshRequested>(_onRefreshRequested);
    on<CategoryGroupArchiveToggled>(_onCategoryGroupArchiveToggled);
    on<CategoryGroupDeleted>(_onCategoryGroupDeleted);
    on<EnvelopeArchiveToggled>(_onEnvelopeArchiveToggled);
    on<EnvelopeUndoArchiveRequested>(_onEnvelopeUndoArchiveRequested);
    on<EnvelopeDeleted>(_onEnvelopeDeleted);
    on<EnvelopeUndoDeleteRequested>(_onEnvelopeUndoDeleteRequested);
    on<CategoryGroupsReordered>(_onCategoryGroupsReordered);
    on<EnvelopesReordered>(_onEnvelopesReordered);
  }

  final EnvelopeRepository _envelopeRepository;
  final String _budgetId;
  StreamSubscription<List<CategoryGroup>>? _groupsSubscription;
  StreamSubscription<List<Envelope>>? _envelopesSubscription;

  /// Tracks the last archived/unarchived envelope for undo.
  Envelope? _lastArchivedEnvelope;

  /// Tracks the last deleted envelope ID for undo (soft-delete restore).
  String? _lastDeletedEnvelopeId;

  // Incremented on each EnvelopesStarted to discard in-flight events from
  // a prior subscription after the bloc is restarted.
  int _generation = 0;

  // Track whether both streams have emitted at least once in this generation.
  bool _groupsReceived = false;
  bool _envelopesReceived = false;

  /// The budget ID this bloc is watching.
  String get budgetId => _budgetId;

  Future<void> _onStarted(
    EnvelopesStarted event,
    Emitter<EnvelopesState> emit,
  ) async {
    emit(state.copyWith(status: EnvelopesStatus.loading));

    _generation++;
    _groupsReceived = false;
    _envelopesReceived = false;

    await _groupsSubscription?.cancel();
    await _envelopesSubscription?.cancel();

    final gen = _generation;

    _groupsSubscription = _envelopeRepository
        .watchCategoryGroups(_budgetId)
        .listen(
          (groups) => add(_CategoryGroupsUpdated(groups, gen)),
          onError: (Object _) => add(const _EnvelopesStreamError()),
        );

    _envelopesSubscription = _envelopeRepository
        .watchEnvelopes(_budgetId)
        .listen(
          (envelopes) => add(_EnvelopesUpdated(envelopes, gen)),
          onError: (Object _) => add(const _EnvelopesStreamError()),
        );

    try {
      await Future.wait([
        _envelopeRepository.refreshCategoryGroups(_budgetId),
        _envelopeRepository.refreshEnvelopes(_budgetId),
      ]);
    } on EnvelopeException {
      // Local watch will still show cached data.
    }
  }

  void _onCategoryGroupsUpdated(
    _CategoryGroupsUpdated event,
    Emitter<EnvelopesState> emit,
  ) {
    // Discard events from a prior subscription generation.
    if (event.generation != _generation) return;
    _groupsReceived = true;
    emit(
      state.copyWith(
        status: _groupsReceived && _envelopesReceived
            ? EnvelopesStatus.loaded
            : state.status,
        categoryGroups: event.categoryGroups,
      ),
    );
  }

  void _onEnvelopesUpdated(
    _EnvelopesUpdated event,
    Emitter<EnvelopesState> emit,
  ) {
    // Discard events from a prior subscription generation.
    if (event.generation != _generation) return;
    _envelopesReceived = true;
    emit(
      state.copyWith(
        status: _groupsReceived && _envelopesReceived
            ? EnvelopesStatus.loaded
            : state.status,
        envelopes: event.envelopes,
      ),
    );
  }

  void _onStreamError(
    _EnvelopesStreamError event,
    Emitter<EnvelopesState> emit,
  ) {
    emit(
      state.copyWith(
        status: EnvelopesStatus.error,
        error: EnvelopesError.loadFailed,
      ),
    );
    emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
  }

  Future<void> _onRefreshRequested(
    EnvelopesRefreshRequested event,
    Emitter<EnvelopesState> emit,
  ) async {
    // Emit loading so RefreshIndicator can await the transition back to loaded.
    emit(state.copyWith(status: EnvelopesStatus.loading));
    try {
      await Future.wait([
        _envelopeRepository.refreshCategoryGroups(_budgetId),
        _envelopeRepository.refreshEnvelopes(_budgetId),
      ]);
      // Streams will emit the updated data, transitioning back to loaded.
    } on EnvelopeException {
      // Restore loaded so the UI is not stuck on the loading spinner.
      emit(state.copyWith(status: EnvelopesStatus.loaded));
    }
  }

  Future<void> _onCategoryGroupArchiveToggled(
    CategoryGroupArchiveToggled event,
    Emitter<EnvelopesState> emit,
  ) async {
    try {
      if (event.categoryGroup.isArchived) {
        await _envelopeRepository
            .unarchiveCategoryGroup(event.categoryGroup.id);
      } else {
        await _envelopeRepository.archiveCategoryGroup(event.categoryGroup.id);
      }
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.updateFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onCategoryGroupDeleted(
    CategoryGroupDeleted event,
    Emitter<EnvelopesState> emit,
  ) async {
    try {
      await _envelopeRepository.deleteCategoryGroup(event.categoryGroupId);
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onEnvelopeArchiveToggled(
    EnvelopeArchiveToggled event,
    Emitter<EnvelopesState> emit,
  ) async {
    _lastArchivedEnvelope = event.envelope;
    try {
      if (event.envelope.isArchived) {
        await _envelopeRepository.unarchiveEnvelope(event.envelope.id);
      } else {
        await _envelopeRepository.archiveEnvelope(event.envelope.id);
      }
    } on EnvelopeException {
      _lastArchivedEnvelope = null;
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.updateFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onEnvelopeUndoArchiveRequested(
    EnvelopeUndoArchiveRequested event,
    Emitter<EnvelopesState> emit,
  ) async {
    final envelope = _lastArchivedEnvelope;
    if (envelope == null) return;
    _lastArchivedEnvelope = null;
    try {
      // Reverse the toggle: if it was archived, unarchive it; if not, archive.
      if (envelope.isArchived) {
        // It was archived before toggle → toggle made it unarchived → undo = archive again
        await _envelopeRepository.archiveEnvelope(envelope.id);
      } else {
        // It was not archived → toggle archived it → undo = unarchive
        await _envelopeRepository.unarchiveEnvelope(envelope.id);
      }
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.updateFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onEnvelopeDeleted(
    EnvelopeDeleted event,
    Emitter<EnvelopesState> emit,
  ) async {
    _lastDeletedEnvelopeId = event.envelopeId;
    try {
      await _envelopeRepository.deleteEnvelope(event.envelopeId);
    } on EnvelopeException {
      _lastDeletedEnvelopeId = null;
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onEnvelopeUndoDeleteRequested(
    EnvelopeUndoDeleteRequested event,
    Emitter<EnvelopesState> emit,
  ) async {
    final envelopeId = _lastDeletedEnvelopeId;
    if (envelopeId == null) return;
    _lastDeletedEnvelopeId = null;
    try {
      await _envelopeRepository.restoreEnvelope(envelopeId);
      await _envelopeRepository.refreshEnvelopes(_budgetId);
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.deleteFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onCategoryGroupsReordered(
    CategoryGroupsReordered event,
    Emitter<EnvelopesState> emit,
  ) async {
    try {
      await _envelopeRepository.reorderCategoryGroups(event.orderedIds);
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.reorderFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  Future<void> _onEnvelopesReordered(
    EnvelopesReordered event,
    Emitter<EnvelopesState> emit,
  ) async {
    try {
      await _envelopeRepository.reorderEnvelopes(event.orderedIds);
    } on EnvelopeException {
      emit(
        state.copyWith(
          status: EnvelopesStatus.error,
          error: EnvelopesError.reorderFailed,
        ),
      );
      emit(state.copyWith(status: EnvelopesStatus.loaded, error: null));
    }
  }

  @override
  Future<void> close() async {
    await _groupsSubscription?.cancel();
    await _envelopesSubscription?.cancel();
    return super.close();
  }
}
