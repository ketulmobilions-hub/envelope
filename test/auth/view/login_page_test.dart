import 'package:envelope/auth/auth.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    testWidgets('renders login title', (tester) async {
      await tester.pumpApp(const LoginPage());
      expect(find.text('Sign In'), findsWidgets);
    });
  });
}
