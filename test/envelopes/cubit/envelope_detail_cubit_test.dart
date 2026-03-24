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

  final testAllocation = EnvelopeAllocation(
    id: 'alloc-1',
    envelopeId: 'env-1',
    budgetPeriodId: 'period-1',
    allocatedAmount: 100000,
    spentAmount: 25000,
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
      expect(cubit.state.allocation, isNull);
      expect(cubit.state.allocated, 0);
      expect(cubit.state.spent, 0);
      expect(cubit.state.available, 0);
      addTearDown(cubit.close);
    });

    test('initial state with allocation computes values', () {
      final cubit = EnvelopeDetailCubit(
        envelopeRepository: envelopeRepository,
        envelope: testEnvelope,
        allocation: testAllocation,
      );

      expect(cubit.state.allocation, equals(testAllocation));
      expect(cubit.state.allocated, 100000);
      expect(cubit.state.spent, 25000);
      expect(cubit.state.available, 75000);
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

    test('deleteEnvelope returns true on success', () async {
      when(() => envelopeRepository.deleteEnvelope('env-1'))
          .thenAnswer((_) async {});
      final cubit = EnvelopeDetailCubit(
        envelopeRepository: envelopeRepository,
        envelope: testEnvelope,
      );

      final result = await cubit.deleteEnvelope();

      expect(result, isTrue);
      verify(() => envelopeRepository.deleteEnvelope('env-1'))
          .called(1);
      addTearDown(cubit.close);
    });

    test('deleteEnvelope returns false on failure', () async {
      when(() => envelopeRepository.deleteEnvelope('env-1'))
          .thenThrow(const EnvelopeException('Error'));
      final cubit = EnvelopeDetailCubit(
        envelopeRepository: envelopeRepository,
        envelope: testEnvelope,
      );

      final result = await cubit.deleteEnvelope();

      expect(result, isFalse);
      addTearDown(cubit.close);
    });
  });
}
