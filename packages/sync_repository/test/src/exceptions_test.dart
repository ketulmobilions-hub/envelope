import 'package:sync_repository/sync_repository.dart';
import 'package:test/test.dart';

void main() {
  group('SyncException', () {
    test('SyncPushException stores message', () {
      const exception = SyncPushException('Push failed');
      expect(exception.message, equals('Push failed'));
      expect(exception.toString(), equals('Push failed'));
    });

    test('SyncPullException stores message', () {
      const exception = SyncPullException('Pull failed');
      expect(exception.message, equals('Pull failed'));
      expect(exception.toString(), equals('Pull failed'));
    });

    test('SyncConflictException stores message', () {
      const exception = SyncConflictException('Conflict');
      expect(exception.message, equals('Conflict'));
      expect(exception.toString(), equals('Conflict'));
    });

    test('SyncException subtypes are distinct', () {
      const push = SyncPushException('error');
      const pull = SyncPullException('error');
      const conflict = SyncConflictException('error');

      expect(push, isA<SyncException>());
      expect(pull, isA<SyncException>());
      expect(conflict, isA<SyncException>());
      expect(push, isNot(isA<SyncPullException>()));
      expect(pull, isNot(isA<SyncConflictException>()));
    });
  });
}
