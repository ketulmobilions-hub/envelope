import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../helpers/helpers.dart';

class _MockSyncBloc extends MockBloc<SyncEvent, SyncBlocState>
    implements SyncBloc {}

void main() {
  late SyncBloc syncBloc;

  setUp(() {
    syncBloc = _MockSyncBloc();
    when(() => syncBloc.state).thenReturn(const SyncBlocState());
  });

  group('HomePage', () {
    testWidgets('renders home title', (tester) async {
      await tester.pumpApp(
        BlocProvider<SyncBloc>.value(
          value: syncBloc,
          child: const HomePage(),
        ),
      );
      expect(find.text('Home'), findsWidgets);
    });
  });
}
