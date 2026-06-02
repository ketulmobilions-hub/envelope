import 'package:goal_repository/goal_repository.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime(2026, 5, 1);

  Goal goal({
    required String id,
    String? envelopeId,
    bool isCompleted = false,
    int sortOrder = 0,
  }) => Goal(
    id: id,
    budgetId: 'b',
    type: 'savings_target',
    name: 'Goal $id',
    envelopeId: envelopeId,
    isCompleted: isCompleted,
    sortOrder: sortOrder,
    createdAt: now,
    updatedAt: now,
  );

  const planner = AutoAssignPlanner();

  group('AutoAssignPlanner.plan', () {
    test('empty goals yields no actions', () {
      final actions = planner.plan(
        goalsByPriority: const [],
        neededByGoalId: const {},
        rtaCents: 50000,
      );
      expect(actions, isEmpty);
    });

    test('zero RTA yields no actions even when goals need funding', () {
      final g1 = goal(id: 'g1', envelopeId: 'env-1');
      final actions = planner.plan(
        goalsByPriority: [g1],
        neededByGoalId: const {'g1': 10000},
        rtaCents: 0,
      );
      expect(actions, isEmpty);
    });

    test('single goal under-needs RTA: action capped at needed', () {
      final g1 = goal(id: 'g1', envelopeId: 'env-1');
      final actions = planner.plan(
        goalsByPriority: [g1],
        neededByGoalId: const {'g1': 10000},
        rtaCents: 50000,
      );
      expect(actions, hasLength(1));
      expect(actions[0].addCents, 10000);
      expect(actions[0].envelopeId, 'env-1');
    });

    test('multiple goals exhaust RTA in priority order', () {
      final g1 = goal(id: 'g1', envelopeId: 'env-1', sortOrder: 0);
      final g2 = goal(id: 'g2', envelopeId: 'env-2', sortOrder: 1);
      final g3 = goal(id: 'g3', envelopeId: 'env-3', sortOrder: 2);
      // RTA = 25000. g1 needs 10000 (full), g2 needs 20000 (partial 15000),
      // g3 needs 5000 (skipped — RTA exhausted).
      final actions = planner.plan(
        goalsByPriority: [g1, g2, g3],
        neededByGoalId: const {'g1': 10000, 'g2': 20000, 'g3': 5000},
        rtaCents: 25000,
      );
      expect(actions, hasLength(2));
      expect(actions[0].goal.id, 'g1');
      expect(actions[0].addCents, 10000);
      expect(actions[1].goal.id, 'g2');
      expect(actions[1].addCents, 15000);
    });

    test('completed goals are skipped silently', () {
      final g1 = goal(id: 'g1', envelopeId: 'env-1', isCompleted: true);
      final g2 = goal(id: 'g2', envelopeId: 'env-2');
      final actions = planner.plan(
        goalsByPriority: [g1, g2],
        neededByGoalId: const {'g1': 10000, 'g2': 8000},
        rtaCents: 50000,
      );
      expect(actions, hasLength(1));
      expect(actions[0].goal.id, 'g2');
    });

    test('zero-need goals are skipped silently', () {
      final g1 = goal(id: 'g1', envelopeId: 'env-1');
      final g2 = goal(id: 'g2', envelopeId: 'env-2');
      final actions = planner.plan(
        goalsByPriority: [g1, g2],
        neededByGoalId: const {'g1': 0, 'g2': 8000},
        rtaCents: 50000,
      );
      expect(actions, hasLength(1));
      expect(actions[0].goal.id, 'g2');
    });

    test('unlinked goals produce contribution actions', () {
      final g1 = goal(id: 'g1');
      final actions = planner.plan(
        goalsByPriority: [g1],
        neededByGoalId: const {'g1': 7500},
        rtaCents: 50000,
      );
      expect(actions, hasLength(1));
      expect(actions[0].isContribution, true);
      expect(actions[0].envelopeId, isNull);
      expect(actions[0].addCents, 7500);
    });
  });
}
