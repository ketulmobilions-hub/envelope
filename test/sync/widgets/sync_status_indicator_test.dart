import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:envelope/sync/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sync_repository/sync_repository.dart';

import '../../helpers/helpers.dart';

class _MockSyncBloc extends MockBloc<SyncEvent, SyncBlocState>
    implements SyncBloc {}

void main() {
  late SyncBloc syncBloc;

  setUp(() {
    syncBloc = _MockSyncBloc();
  });

  Widget buildSubject() {
    return BlocProvider<SyncBloc>.value(
      value: syncBloc,
      child: const SyncStatusIndicator(),
    );
  }

  group('SyncStatusIndicator', () {
    testWidgets('renders cloud icon for idle state', (tester) async {
      when(() => syncBloc.state).thenReturn(const SyncBlocState());
      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.cloud_outlined), findsOneWidget);
    });

    testWidgets('renders progress indicator for syncing state',
        (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(
          syncStatus: SyncStatus(state: SyncState.syncing),
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('renders cloud done icon for synced state', (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(
          syncStatus: SyncStatus(state: SyncState.synced),
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.cloud_done), findsOneWidget);
    });

    testWidgets('renders cloud off icon for error state', (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(
          syncStatus: SyncStatus(
            state: SyncState.error,
            errorMessage: 'Network error',
          ),
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });

    testWidgets('renders cloud off icon when offline', (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(isOnline: false),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byIcon(Icons.cloud_off), findsOneWidget);
    });

    testWidgets('shows pending count badge when > 0', (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(
          syncStatus: SyncStatus(pendingChanges: 3),
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('3 pending changes'), findsOneWidget);
    });

    testWidgets('shows singular pending change badge', (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(
          syncStatus: SyncStatus(pendingChanges: 1),
        ),
      );
      await tester.pumpApp(buildSubject());

      expect(find.byType(Badge), findsOneWidget);
      expect(find.text('1 pending change'), findsOneWidget);
    });

    testWidgets('does not show badge when pending count is 0',
        (tester) async {
      when(() => syncBloc.state).thenReturn(const SyncBlocState());
      await tester.pumpApp(buildSubject());

      expect(find.byType(Badge), findsNothing);
    });

    testWidgets('dispatches SyncRequested on tap', (tester) async {
      when(() => syncBloc.state).thenReturn(const SyncBlocState());
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.cloud_outlined));

      verify(() => syncBloc.add(const SyncRequested())).called(1);
    });

    testWidgets('does not dispatch SyncRequested when offline',
        (tester) async {
      when(() => syncBloc.state).thenReturn(
        const SyncBlocState(isOnline: false),
      );
      await tester.pumpApp(buildSubject());

      await tester.tap(find.byIcon(Icons.cloud_off));

      verifyNever(() => syncBloc.add(const SyncRequested()));
    });
  });
}
