import 'dart:async';

import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_detail_page.dart';
import 'package:envelope/dashboard/widgets/quick_allocate_dialog.dart';
import 'package:envelope/envelopes/widgets/envelope_card.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Displays envelopes grouped by category on the dashboard.
class EnvelopeSummaryCard extends StatelessWidget {
  const EnvelopeSummaryCard({
    required this.summaries,
    this.categoryGroups = const [],
    this.onViewAll,
    super.key,
  });

  final List<EnvelopeSummary> summaries;
  final List<CategoryGroup> categoryGroups;
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

    // Group summaries by category group name.
    final grouped = <String, List<EnvelopeSummary>>{};
    for (final s in summaries) {
      grouped.putIfAbsent(s.categoryGroupName, () => []).add(s);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row with View All link.
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
          // Category groups.
          for (final entry in grouped.entries)
            _CategoryGroupSection(
              groupName: entry.key,
              summaries: entry.value,
              categoryGroups: categoryGroups,
              onViewAll: onViewAll,
            ),
        ],
      ),
    );
  }
}

class _CategoryGroupSection extends StatelessWidget {
  const _CategoryGroupSection({
    required this.groupName,
    required this.summaries,
    required this.categoryGroups,
    this.onViewAll,
  });

  final String groupName;
  final List<EnvelopeSummary> summaries;
  final List<CategoryGroup> categoryGroups;
  final VoidCallback? onViewAll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Compute group totals.
    final totalAllocated = summaries.fold(0, (sum, s) => sum + s.allocated);
    final totalAvailable = summaries.fold(0, (sum, s) => sum + s.available);
    final availColor = totalAvailable < 0
        ? AppColors.expense
        : AppColors.charcoal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category header with totals beside it.
          Row(
            children: [
              Expanded(
                child: Text(
                  groupName.toUpperCase(),
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.charcoal,
                    letterSpacing: 0.8,
                  ),
                ),
              ),
              Text(
                formatCents(totalAvailable),
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: availColor,
                ),
              ),
              Text(
                '/${formatCents(totalAllocated)}',
                style: theme.textTheme.labelMedium?.copyWith(
                  color: AppColors.secondaryText,
                ),
              ),
              if (onViewAll != null) ...[
                const SizedBox(width: 4),
                IconButton(
                  icon: const Icon(
                    Icons.edit_outlined,
                    size: 18,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  color: AppColors.secondaryText,
                  onPressed: onViewAll,
                ),
              ],
            ],
          ),
          const SizedBox(height: 8),
          // Envelope cards grid.
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: summaries
                    .map(
                      (s) => SizedBox(
                        width: cardWidth,
                        child: EnvelopeCard(
                          name: s.envelope.name,
                          availableCents: s.available,
                          allocatedCents: s.allocated,
                          spentCents: s.spent,
                          isOverspent: s.isOverspent,
                          color: AppColors.fromHex(s.envelope.color),
                          heroTag: 'envelope_${s.envelope.id}',
                          onTap: () => _openDetail(context, s),
                          onLongPress: () => _showQuickAllocate(context, s),
                        ),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _showQuickAllocate(
    BuildContext context,
    EnvelopeSummary summary,
  ) async {
    await HapticFeedback.mediumImpact();

    if (!context.mounted) return;

    final cents = await showDialog<int>(
      context: context,
      builder: (_) => QuickAllocateDialog(
        envelopeName: summary.envelope.name,
        currentAmountCents: summary.allocated,
      ),
    );
    if (cents == null || !context.mounted) return;

    context.read<DashboardBloc>().add(
      QuickAllocationRequested(
        envelopeId: summary.envelope.id,
        amount: cents,
      ),
    );
  }

  void _openDetail(BuildContext context, EnvelopeSummary summary) {
    unawaited(
      Navigator.of(context).push(
        PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 400),
          pageBuilder: (_, animation, secondaryAnimation) => BlocProvider(
            create: (_) => EnvelopeDetailCubit(
              envelopeRepository: context.read<EnvelopeRepository>(),
              envelope: summary.envelope,
              allocation: summary.allocation,
            ),
            child: EnvelopeDetailPage(
              categoryGroups: categoryGroups,
            ),
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeOut,
              ),
              child: child,
            );
          },
        ),
      ),
    );
  }
}
