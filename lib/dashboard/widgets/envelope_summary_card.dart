import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/envelopes/widgets/envelope_card.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Displays a grid of envelope spending summaries on the dashboard
/// using envelope-shaped cards.
class EnvelopeSummaryCard extends StatelessWidget {
  const EnvelopeSummaryCard({
    required this.summaries,
    this.onViewAll,
    super.key,
  });

  final List<EnvelopeSummary> summaries;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    if (summaries.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: [
                Icon(
                  Icons.mail_outline,
                  size: 40,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.dashboardNoEnvelopes,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final displaySummaries = summaries.take(8).toList();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.dashboardEnvelopes,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                if (onViewAll != null)
                  InkWell(
                    onTap: onViewAll,
                    borderRadius: BorderRadius.circular(4),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Text(
                        l10n.dashboardViewAll,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final cardWidth = (constraints.maxWidth - 8) / 2;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: displaySummaries
                      .map(
                        (s) => SizedBox(
                          width: cardWidth,
                          child: EnvelopeCard(
                            name: s.envelope.name,
                            availableCents: s.available,
                            allocatedCents: s.allocated,
                            spentCents: s.spent,
                            isOverspent: s.isOverspent,
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
