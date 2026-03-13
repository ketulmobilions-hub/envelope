import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';

part 'envelope_detail_state.dart';

class EnvelopeDetailCubit extends Cubit<EnvelopeDetailState> {
  EnvelopeDetailCubit({
    required EnvelopeRepository envelopeRepository,
    required Envelope envelope,
  })  : _envelopeRepository = envelopeRepository,
        super(EnvelopeDetailState(envelope: envelope));

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
}
