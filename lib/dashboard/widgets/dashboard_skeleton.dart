import 'package:envelope/shared/widgets/shimmer_box.dart';
import 'package:flutter/material.dart';

/// Skeleton screen shown while dashboard data loads.
/// Mirrors the real layout: RTA card → envelope grid → accounts → transactions.
class DashboardSkeleton extends StatelessWidget {
  const DashboardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 8),
      physics: const NeverScrollableScrollPhysics(),
      children: [
        // RTA card skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.4),
            ),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ShimmerBox(width: 120, height: 14),
                    ShimmerBox(width: 80, height: 22),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 12),
                const ShimmerBox(width: 200, height: 12),
              ],
            ),
          ),
        ),

        // Section label
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: ShimmerBox(width: 80, height: 12),
        ),

        // Envelope card grid (2 rows × 2 cards)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final width = (constraints.maxWidth - 8) / 2;
              return Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < 4; i++)
                    ShimmerBox(width: width, height: 176, borderRadius: 12),
                ],
              );
            },
          ),
        ),

        const SizedBox(height: 16),

        // Accounts card skeleton
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest
                  .withValues(alpha: 0.4),
            ),
            padding: const EdgeInsets.all(16),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerBox(width: 80, height: 12),
                    SizedBox(height: 8),
                    ShimmerBox(width: 120, height: 18),
                  ],
                ),
                ShimmerBox(width: 40, height: 40, borderRadius: 20),
              ],
            ),
          ),
        ),

        // Recent transactions skeleton
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Column(
            children: [
              for (var i = 0; i < 3; i++)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      const ShimmerBox(
                        width: 40,
                        height: 40,
                        borderRadius: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ShimmerBox(
                              width: 120 + (i * 20).toDouble(),
                              height: 13,
                            ),
                            const SizedBox(height: 6),
                            const ShimmerBox(width: 80, height: 11),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      const ShimmerBox(width: 60, height: 14),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
