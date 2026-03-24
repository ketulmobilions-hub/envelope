import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';

part 'envelope_detail_state.dart';

class EnvelopeDetailCubit extends Cubit<EnvelopeDetailState> {
  EnvelopeDetailCubit({
    required EnvelopeRepository envelopeRepository,
    required Envelope envelope,
    EnvelopeAllocation? allocation,
  })  : _envelopeRepository = envelopeRepository,
        super(EnvelopeDetailState(
          envelope: envelope,
          allocation: allocation,
        ));

  final EnvelopeRepository _envelopeRepository;

  /// Refreshes the envelope data from the repository.
  Future<void> refresh() async {
    try {
      final updated =
          await _envelopeRepository.getEnvelope(state.envelope.id);
      emit(state.copyWith(envelope: updated));
    } on EnvelopeException {
      // Keep current data if refresh fails.
    }
  }

  /// Deletes the envelope from the repository.
  /// Returns `true` on success, `false` on failure.
  Future<bool> deleteEnvelope() async {
    try {
      await _envelopeRepository.deleteEnvelope(state.envelope.id);
      return true;
    } on EnvelopeException {
      return false;
    }
  }
}
