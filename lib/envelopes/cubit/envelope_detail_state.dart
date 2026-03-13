part of 'envelope_detail_cubit.dart';

final class EnvelopeDetailState extends Equatable {
  const EnvelopeDetailState({required this.envelope});

  final Envelope envelope;

  EnvelopeDetailState copyWith({Envelope? envelope}) {
    return EnvelopeDetailState(envelope: envelope ?? this.envelope);
  }

  @override
  List<Object?> get props => [envelope];
}
