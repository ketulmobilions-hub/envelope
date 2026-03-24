part of 'envelope_detail_cubit.dart';

final class EnvelopeDetailState extends Equatable {
  const EnvelopeDetailState({
    required this.envelope,
    this.allocation,
  });

  final Envelope envelope;
  final EnvelopeAllocation? allocation;

  int get allocated => allocation?.allocatedAmount ?? 0;
  int get spent => allocation?.spentAmount ?? 0;
  int get available =>
      allocated - spent + (allocation?.rolloverAmount ?? 0);

  EnvelopeDetailState copyWith({
    Envelope? envelope,
    Object? allocation = _sentinel,
  }) {
    return EnvelopeDetailState(
      envelope: envelope ?? this.envelope,
      allocation: allocation == _sentinel
          ? this.allocation
          : allocation as EnvelopeAllocation?,
    );
  }

  static const Object _sentinel = Object();

  @override
  List<Object?> get props => [envelope, allocation];
}
