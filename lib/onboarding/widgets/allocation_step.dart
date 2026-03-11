import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllocationStep extends StatelessWidget {
  const AllocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final totalAllocated = state.allocations.values.fold<double>(
          0,
          (sum, v) => sum + v,
        );
        final remaining = state.expectedIncome - totalAllocated;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.onboardingAllocationTitle,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.onboardingAllocationDescription),
                  const SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    spacing: 16,
                    children: [
                      Text(
                        '${l10n.onboardingIncomeToAllocate}: '
                        '${state.baseCurrency} '
                        '${state.expectedIncome.toStringAsFixed(2)}',
                      ),
                      Text(
                        '${l10n.onboardingRemainingToAllocate}: '
                        '${state.baseCurrency} '
                        '${remaining.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: remaining < 0
                              ? Theme.of(context).colorScheme.error
                              : null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.categoryGroups.length,
                itemBuilder: (context, groupIndex) {
                  final group = state.categoryGroups[groupIndex];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8, 12, 8, 4),
                        child: Text(
                          group.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      ...group.envelopes.asMap().entries.map(
                        (entry) {
                          final key =
                              '$groupIndex:${entry.value}';
                          return _AllocationField(
                            groupIndex: groupIndex,
                            envelopeName: entry.value,
                            currency: state.baseCurrency,
                            value:
                                state.allocations[key] ?? 0,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: state.status == OnboardingStatus.submitting
                      ? null
                      : () => context
                            .read<OnboardingCubit>()
                            .completeOnboarding(),
                  child: state.status == OnboardingStatus.submitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.onboardingComplete),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _AllocationField extends StatefulWidget {
  const _AllocationField({
    required this.groupIndex,
    required this.envelopeName,
    required this.currency,
    required this.value,
  });

  final int groupIndex;
  final String envelopeName;
  final String currency;
  final double value;

  @override
  State<_AllocationField> createState() => _AllocationFieldState();
}

class _AllocationFieldState extends State<_AllocationField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.value > 0
          ? widget.value.toStringAsFixed(0)
          : '',
    );
  }

  @override
  void didUpdateWidget(covariant _AllocationField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      final text = widget.value > 0
          ? widget.value.toStringAsFixed(0)
          : '';
      if (_controller.text != text) {
        _controller.text = text;
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: widget.envelopeName,
          prefixText: '${widget.currency} ',
          border: const OutlineInputBorder(),
          isDense: true,
        ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        onChanged: (value) {
          final amount = double.tryParse(value) ?? 0;
          context.read<OnboardingCubit>().setAllocation(
                widget.groupIndex,
                widget.envelopeName,
                amount,
              );
        },
      ),
    );
  }
}
