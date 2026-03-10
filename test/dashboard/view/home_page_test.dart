import 'package:envelope/dashboard/dashboard.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('HomePage', () {
    testWidgets('renders home title', (tester) async {
      await tester.pumpApp(const HomePage());
      expect(find.text('Home'), findsWidgets);
    });
  });
}
