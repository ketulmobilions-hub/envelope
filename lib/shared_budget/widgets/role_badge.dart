import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared_budget/bloc/bloc.dart';
import 'package:flutter/material.dart';

/// Small chip displaying a member's role with color coding.
class RoleBadge extends StatelessWidget {
  const RoleBadge({required this.role, super.key});

  final String role;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final colorScheme = Theme.of(context).colorScheme;

    final (label, color) = switch (role) {
      MemberRole.owner => (
        l10n.sharedBudgetRoleOwner,
        colorScheme.primary,
      ),
      MemberRole.editor => (
        l10n.sharedBudgetRoleEditor,
        colorScheme.secondary,
      ),
      _ => (
        l10n.sharedBudgetRoleViewer,
        colorScheme.outline,
      ),
    };

    return Chip(
      label: Text(
        label,
        style: TextStyle(fontSize: 12, color: color),
      ),
      side: BorderSide(color: color),
      backgroundColor: color.withValues(alpha: 0.1),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      padding: EdgeInsets.zero,
    );
  }
}
