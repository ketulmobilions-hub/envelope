import 'dart:async';

import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EnvelopesStep extends StatelessWidget {
  const EnvelopesStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingEnvelopesTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.onboardingEnvelopesDescription),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.categoryGroups.length + 1,
                itemBuilder: (context, index) {
                  if (index == state.categoryGroups.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.add),
                        label: Text(l10n.onboardingAddGroup),
                        onPressed: () =>
                            _showAddGroupDialog(context),
                      ),
                    );
                  }
                  final group = state.categoryGroups[index];
                  return _CategoryGroupCard(
                    groupIndex: index,
                    group: group,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAddGroupDialog(BuildContext context) {
    final controller = TextEditingController();
    final l10n = context.l10n;

    unawaited(showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.onboardingAddGroup),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(dialogContext)
                    .cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  context
                      .read<OnboardingCubit>()
                      .addCategoryGroup(name);
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.onboardingAddGroup),
            ),
          ],
        );
      },
    ));
  }
}

class _CategoryGroupCard extends StatelessWidget {
  const _CategoryGroupCard({
    required this.groupIndex,
    required this.group,
  });

  final int groupIndex;
  final OnboardingCategoryGroup group;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        title: Text(group.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.delete_outline, size: 20),
              onPressed: () => context
                  .read<OnboardingCubit>()
                  .removeCategoryGroup(groupIndex),
            ),
            const Icon(Icons.expand_more),
          ],
        ),
        children: [
          ...group.envelopes.asMap().entries.map((entry) {
            return ListTile(
              dense: true,
              title: Text(entry.value),
              trailing: IconButton(
                icon: const Icon(Icons.close, size: 18),
                onPressed: () => context
                    .read<OnboardingCubit>()
                    .removeEnvelope(groupIndex, entry.key),
              ),
            );
          }),
          ListTile(
            dense: true,
            leading: const Icon(Icons.add, size: 18),
            title: Text(
              l10n.onboardingAddEnvelope,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onTap: () => _showAddEnvelopeDialog(context),
          ),
        ],
      ),
    );
  }

  void _showAddEnvelopeDialog(BuildContext context) {
    final controller = TextEditingController();
    final l10n = context.l10n;

    unawaited(showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.onboardingAddEnvelope),
          content: TextField(
            controller: controller,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(dialogContext)
                    .cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  context
                      .read<OnboardingCubit>()
                      .addEnvelope(groupIndex, name);
                }
                Navigator.of(dialogContext).pop();
              },
              child: Text(l10n.onboardingAddEnvelope),
            ),
          ],
        );
      },
    ));
  }
}
