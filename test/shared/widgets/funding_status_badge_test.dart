import 'package:envelope/shared/services/funding_status_service.dart';
import 'package:envelope/shared/widgets/funding_status_badge.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  Container? findBadgeContainer(WidgetTester tester) {
    final containers = find.descendant(
      of: find.byType(FundingStatusBadge),
      matching: find.byType(Container),
    );
    if (tester.widgetList(containers).isEmpty) return null;
    return tester.widget<Container>(containers.first);
  }

  group('FundingStatusBadge', () {
    testWidgets('renders nothing when status is noTarget', (tester) async {
      await tester.pumpApp(
        const FundingStatusBadge(
          status: FundingStatus.noTarget,
          amountCents: 0,
          symbol: r'$',
        ),
      );

      expect(find.byType(Tooltip), findsNothing);
      expect(findBadgeContainer(tester), isNull);
    });

    testWidgets('underfunded shows shortfall amount + warning palette', (
      tester,
    ) async {
      await tester.pumpApp(
        const FundingStatusBadge(
          status: FundingStatus.underfunded,
          amountCents: 12000,
          symbol: r'$',
        ),
      );

      expect(find.text(r'Need $120.00'), findsOneWidget);
      final decoration = findBadgeContainer(tester)!.decoration! as BoxDecoration;
      expect(
        decoration.color,
        AppColors.warning.withValues(alpha: 0.2),
      );
    });

    testWidgets('fullyFunded shows funded label + income palette', (
      tester,
    ) async {
      await tester.pumpApp(
        const FundingStatusBadge(
          status: FundingStatus.fullyFunded,
          amountCents: 0,
          symbol: r'$',
        ),
      );

      expect(find.text('Funded'), findsOneWidget);
      final decoration = findBadgeContainer(tester)!.decoration! as BoxDecoration;
      expect(
        decoration.color,
        AppColors.income.withValues(alpha: 0.15),
      );
    });

    testWidgets('overspent shows overspent label + expense palette', (
      tester,
    ) async {
      await tester.pumpApp(
        const FundingStatusBadge(
          status: FundingStatus.overspent,
          amountCents: 0,
          symbol: r'$',
        ),
      );

      expect(find.text('Overspent'), findsOneWidget);
      final decoration = findBadgeContainer(tester)!.decoration! as BoxDecoration;
      expect(
        decoration.color,
        AppColors.expense.withValues(alpha: 0.15),
      );
    });
  });
}
