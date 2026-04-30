import 'package:bloc/bloc.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:equatable/equatable.dart';

part 'envelope_form_state.dart';

class EnvelopeFormCubit extends Cubit<EnvelopeFormState> {
  EnvelopeFormCubit({
    required EnvelopeRepository envelopeRepository,
    required this.budgetId,
    this.envelope,
  }) : _envelopeRepository = envelopeRepository,
       super(const EnvelopeFormState());

  final EnvelopeRepository _envelopeRepository;
  final String budgetId;
  final Envelope? envelope;

  bool get isEditing => envelope != null;

  Future<void> submit({
    required String name,
    required String categoryGroupId,
    String? color,
  }) async {
    emit(state.copyWith(status: EnvelopeFormStatus.submitting));
    try {
      if (isEditing) {
        final updated = envelope!.copyWith(
          name: name,
          categoryGroupId: categoryGroupId,
          color: color,
        );
        await _envelopeRepository.updateEnvelope(updated);
      } else {
        await _envelopeRepository.createEnvelope(
          budgetId: budgetId,
          categoryGroupId: categoryGroupId,
          name: name,
          color: color,
        );
      }
      emit(state.copyWith(status: EnvelopeFormStatus.success));
    } on EnvelopeException catch (e) {
      emit(
        state.copyWith(
          status: EnvelopeFormStatus.failure,
          errorMessage: e.message,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          status: EnvelopeFormStatus.failure,
          errorMessage: 'An unexpected error occurred.',
        ),
      );
    }
  }
}
