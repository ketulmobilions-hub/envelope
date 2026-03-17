import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

/// Detail page for a single envelope with terracotta header.
class EnvelopeDetailPage extends StatelessWidget {
  const EnvelopeDetailPage({
    required this.categoryGroups,
    super.key,
  });

  final List<CategoryGroup> categoryGroups;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<EnvelopeDetailCubit, EnvelopeDetailState>(
      builder: (context, state) {
        final envelope = state.envelope;

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              // Terracotta header.
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                backgroundColor: AppColors.primary,
                iconTheme: const IconThemeData(color: AppColors.onPrimary),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    tooltip: l10n.envelopesEditEnvelope,
                    onPressed: () => _openEdit(context, envelope),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
                  title: Text(
                    envelope.name,
                    style: const TextStyle(
                      color: AppColors.onPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  background: Container(
                    color: AppColors.primary,
                    padding: const EdgeInsets.fromLTRB(24, 80, 24, 48),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          l10n.envelopesDetailAvailable,
                          style: const TextStyle(
                            color: AppColors.onPrimary,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          formatCents(0),
                          style: GoogleFonts.playfairDisplay(
                            color: AppColors.onPrimary,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _HeaderDetail(
                              label: l10n.envelopesDetailAllocated,
                              amount: 0,
                            ),
                            const SizedBox(width: 32),
                            _HeaderDetail(
                              label: l10n.envelopesDetailSpent,
                              amount: 0,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Content.
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Envelope info card.
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (envelope.isArchived) ...[
                                _InfoRow(
                                  label: l10n.envelopesStatusLabel,
                                  value: l10n.envelopesStatusArchived,
                                ),
                                const Divider(),
                              ],
                              _InfoRow(
                                label: l10n.envelopesCreatedAtLabel,
                                value: DateFormat.yMd()
                                    .format(envelope.createdAt),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Allocation history placeholder.
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Text(
                                l10n.envelopesDetailAllocationHistory,
                                style:
                                    Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 16),
                              Icon(
                                Icons.history_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.envelopesDetailAllocationHistoryPlaceholder,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Transactions placeholder.
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.receipt_long_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.envelopesDetailTransactionsPlaceholder,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Goal progress placeholder.
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              Icon(
                                Icons.flag_outlined,
                                size: 48,
                                color: Theme.of(context).colorScheme.outline,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                l10n.envelopesDetailGoalProgressPlaceholder,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openEdit(BuildContext context, Envelope envelope) async {
    final cubit = context.read<EnvelopeDetailCubit>();
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => EnvelopeFormPage(
          envelopeRepository: context.read<EnvelopeRepository>(),
          budgetId: envelope.budgetId,
          categoryGroups: categoryGroups,
          envelope: envelope,
        ),
      ),
    );
    if (result == true && context.mounted) {
      await cubit.refresh();
    }
  }
}

class _HeaderDetail extends StatelessWidget {
  const _HeaderDetail({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.onPrimary.withValues(alpha: 0.8),
            fontSize: 11,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          formatCents(amount),
          style: const TextStyle(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.outline,
                ),
          ),
          Text(value, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
