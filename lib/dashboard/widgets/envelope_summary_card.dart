import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Displays a grid of envelope spending summaries on the dashboard.
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
                final cardWidth =
                    (constraints.maxWidth - 8) / 2;
                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: displaySummaries
                      .map(
                        (s) => _EnvelopeMiniCard(
                          summary: s,
                          width: cardWidth,
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

class _EnvelopeMiniCard extends StatelessWidget {
  const _EnvelopeMiniCard({
    required this.summary,
    required this.width,
  });

  final EnvelopeSummary summary;
  final double width;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = context.l10n;

    final allocated = summary.allocated;
    final spent = summary.spent;
    final available = summary.available;
    final progress = allocated > 0
        ? (spent / allocated).clamp(0.0, 1.0)
        : 0.0;

    final Color statusColor;
    if (summary.isOverspent) {
      statusColor = theme.colorScheme.error;
    } else if (allocated > 0 && spent / allocated >= 0.75) {
      statusColor = Colors.amber;
    } else {
      statusColor = Colors.green;
    }

    return SizedBox(
      width: width,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.05),
          border: Border.all(color: statusColor.withValues(alpha: 0.3)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              summary.envelope.name,
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: statusColor.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation(statusColor),
                minHeight: 4,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              summary.isOverspent
                  ? l10n.dashboardOverspent
                  : '${formatCents(available)} ${l10n.dashboardAvailable}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: statusColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
