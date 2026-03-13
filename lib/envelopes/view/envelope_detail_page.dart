import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/envelopes/view/envelope_form_page.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// Detail page for a single envelope showing allocation info and history.
///
/// Expects an [EnvelopeDetailCubit] to be provided above this widget.
/// [categoryGroups] is passed to the edit form so the group dropdown is
/// populated; supply the active (non-archived) groups from the parent page.
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
          appBar: AppBar(
            title: Text(envelope.name),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.envelopesEditEnvelope,
                onPressed: () => _openEdit(context, envelope),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Allocation summary card.
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Text(
                        l10n.envelopesDetailAvailable,
                        style:
                            Theme.of(context).textTheme.titleSmall?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        formatCents(0),
                        style: Theme.of(context)
                            .textTheme
                            .headlineLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _AllocationDetail(
                            label: l10n.envelopesDetailAllocated,
                            amount: 0,
                          ),
                          _AllocationDetail(
                            label: l10n.envelopesDetailSpent,
                            amount: 0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                          // Dedicated key for the status value (different
                          // semantic from the "Archived" section header).
                          value: l10n.envelopesStatusArchived,
                        ),
                        const Divider(),
                      ],
                      _InfoRow(
                        label: l10n.envelopesCreatedAtLabel,
                        value: DateFormat.yMd().format(envelope.createdAt),
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
                        style: Theme.of(context).textTheme.titleSmall,
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
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
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
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
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
                        style:
                            Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
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

class _AllocationDetail extends StatelessWidget {
  const _AllocationDetail({required this.label, required this.amount});

  final String label;
  final int amount;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          formatCents(amount),
          style: Theme.of(context).textTheme.titleMedium,
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
