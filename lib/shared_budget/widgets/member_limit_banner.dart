import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Banner shown when the free tier member limit is reached.
class MemberLimitBanner extends StatelessWidget {
  const MemberLimitBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return MaterialBanner(
      content: Text(l10n.sharedBudgetErrorMemberLimit),
      leading: const Icon(Icons.group_off),
      actions: [
        // TODO(sharing): Replace with real upgrade navigation when
        // SubscriptionRepository is implemented.
        TextButton(
          onPressed: () {},
          child: Text(l10n.sharedBudgetUpgrade),
        ),
      ],
    );
  }
}
