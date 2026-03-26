import 'package:flutter/material.dart';

/// A linear progress bar with a percentage label.
class GoalProgressBar extends StatelessWidget {
  const GoalProgressBar({required this.progress, super.key});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).toInt();
    final color = percentage >= 100
        ? Theme.of(context).colorScheme.tertiary
        : percentage >= 50
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '$percentage%',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: progress,
          backgroundColor:
              Theme.of(context).colorScheme.surfaceContainerHighest,
          color: color,
        ),
      ],
    );
  }
}
