import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockEnvelopeRepository extends Mock implements EnvelopeRepository {}

void main() {
  late MockEnvelopeRepository envelopeRepository;

  final now = DateTime(2024);
  final testEnvelope = Envelope(
    id: 'env-1',
    categoryGroupId: 'group-1',
    budgetId: 'budget-1',
    name: 'Rent',
    createdAt: now,
  );

  setUp(() {
    envelopeRepository = MockEnvelopeRepository();
  });

  group('EnvelopeDetailCubit', () {
    test('initial state has the provided envelope', () {
      final cubit = EnvelopeDetailCubit(
        envelopeRepository: envelopeRepository,
        envelope: testEnvelope,
      );

      expect(cubit.state.envelope, equals(testEnvelope));
      addTearDown(cubit.close);
    });

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'refresh updates envelope from repository',
      build: () {
        final updated = testEnvelope.copyWith(name: 'Updated Rent');
        when(() => envelopeRepository.getEnvelope('env-1'))
            .thenAnswer((_) async => updated);
        return EnvelopeDetailCubit(
          envelopeRepository: envelopeRepository,
          envelope: testEnvelope,
        );
      },
      act: (cubit) => cubit.refresh(),
      expect: () => [
        isA<EnvelopeDetailState>().having(
          (s) => s.envelope.name,
          'envelope name',
          'Updated Rent',
        ),
      ],
    );

    blocTest<EnvelopeDetailCubit, EnvelopeDetailState>(
      'refresh keeps current data on failure',
      build: () {
        when(() => envelopeRepository.getEnvelope('env-1'))
            .thenThrow(const EnvelopeException('Error'));
        return EnvelopeDetailCubit(
          envelopeRepository: envelopeRepository,
          envelope: testEnvelope,
        );
      },
      act: (cubit) => cubit.refresh(),
      expect: () => <EnvelopeDetailState>[],
    );
  });
}
