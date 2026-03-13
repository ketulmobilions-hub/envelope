import 'package:envelope/budget/widgets/allocation_row.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';

/// An expandable section showing a category group and its envelope rows.
class AllocationGroupTile extends StatelessWidget {
  const AllocationGroupTile({
    required this.group,
    required this.envelopesWithAllocations,
    super.key,
  });

  final CategoryGroup group;
  final List<(Envelope, EnvelopeAllocation?)> envelopesWithAllocations;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: PageStorageKey(group.id),
      initiallyExpanded: true,
      title: Text(
        group.name,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      trailing: envelopesWithAllocations.isNotEmpty
          ? Text(
              _groupTotal(envelopesWithAllocations),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                  ),
            )
          : null,
      children: envelopesWithAllocations.isEmpty
          ? [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
                child: Text(
                  context.l10n.budgetGroupNoEnvelopes,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
              ),
            ]
          : envelopesWithAllocations
              .map(
                (pair) => AllocationRow(
                  key: ValueKey(pair.$1.id),
                  envelope: pair.$1,
                  allocation: pair.$2,
                ),
              )
              .toList(),
    );
  }

  static String _groupTotal(List<(Envelope, EnvelopeAllocation?)> pairs) {
    final total = pairs.fold<int>(
      0,
      (sum, pair) => sum + (pair.$2?.allocatedAmount ?? 0),
    );
    return '\$${(total / 100).toStringAsFixed(2)}';
  }
}
