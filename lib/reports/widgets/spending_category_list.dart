import 'package:envelope/reports/widgets/report_helpers.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:report_repository/report_repository.dart';

/// Category breakdown list with envelope drill-down.
class SpendingCategoryList extends StatelessWidget {
  const SpendingCategoryList({required this.categories, super.key});

  final List<SpendingByCategory> categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(categories.length, (i) {
        final category = categories[i];
        final color = reportCategoryColors[i % reportCategoryColors.length];
        return _CategoryTile(category: category, color: color);
      }),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.color});

  final SpendingByCategory category;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: CircleAvatar(
        radius: 8,
        backgroundColor: color,
      ),
      title: Text(
        category.categoryGroupName,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
      ),
      trailing: Text(
        formatCents(category.amount),
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.expense,
              fontWeight: FontWeight.w600,
            ),
      ),
      children: [
        for (final envelope in category.envelopes)
          ListTile(
            contentPadding: const EdgeInsets.only(left: 56, right: 16),
            title: Text(envelope.envelopeName),
            trailing: Text(
              formatCents(envelope.amount),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.secondaryText,
                  ),
            ),
          ),
      ],
    );
  }
}
