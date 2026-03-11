import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/onboarding/cubit/cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class IncomeStep extends StatefulWidget {
  const IncomeStep({super.key});

  @override
  State<IncomeStep> createState() => _IncomeStepState();
}

class _IncomeStepState extends State<IncomeStep> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    final income = context.read<OnboardingCubit>().state.expectedIncome;
    _controller = TextEditingController(
      text: income > 0 ? income.toStringAsFixed(0) : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final currency =
        context.select<OnboardingCubit, String>(
      (c) => c.state.baseCurrency,
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.onboardingIncomeTitle,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(l10n.onboardingIncomeDescription),
          const SizedBox(height: 24),
          TextField(
            controller: _controller,
            decoration: InputDecoration(
              labelText: l10n.onboardingIncomeLabel,
              prefixText: '$currency ',
              border: const OutlineInputBorder(),
            ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              final amount = double.tryParse(value) ?? 0;
              context.read<OnboardingCubit>().setExpectedIncome(amount);
            },
          ),
        ],
      ),
    );
  }
}
