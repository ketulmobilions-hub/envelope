import 'package:auth_repository/auth_repository.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/dashboard.dart';
import 'package:envelope/sync/bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:transaction_repository/transaction_repository.dart';

import '../../helpers/helpers.dart';

class _MockSyncBloc extends MockBloc<SyncEvent, SyncBlocState>
    implements SyncBloc {}

class _MockAuthBloc extends MockBloc<AuthEvent, AuthState>
    implements AuthBloc {}

class _MockTransactionRepository extends Mock
    implements TransactionRepository {}

void main() {
  late SyncBloc syncBloc;
  late AuthBloc authBloc;
  late TransactionRepository transactionRepository;

  final now = DateTime(2024);

  setUp(() {
    syncBloc = _MockSyncBloc();
    authBloc = _MockAuthBloc();
    transactionRepository = _MockTransactionRepository();

    when(() => syncBloc.state).thenReturn(const SyncBlocState());
    when(() => authBloc.state).thenReturn(
      AuthState.authenticated(
        User(
          id: 'user-1',
          email: 'test@test.com',
          displayName: 'Test',
          createdAt: now,
          updatedAt: now,
        ),
      ),
    );
    when(() => transactionRepository.watchRecurringRules(any()))
        .thenAnswer((_) => Stream.value([]));
    when(() => transactionRepository.watchBillReminders(any()))
        .thenAnswer((_) => Stream.value([]));
  });

  group('HomePage', () {
    testWidgets('renders home title', (tester) async {
      await tester.pumpApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<SyncBloc>.value(value: syncBloc),
            BlocProvider<AuthBloc>.value(value: authBloc),
          ],
          child: RepositoryProvider<TransactionRepository>.value(
            value: transactionRepository,
            child: const HomePage(),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Home'), findsWidgets);
    });
  });
}
