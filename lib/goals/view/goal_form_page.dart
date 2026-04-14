import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/goals/cubit/cubit.dart';
import 'package:envelope/goals/widgets/goal_helpers.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:goal_repository/goal_repository.dart';

/// Page for adding or editing a goal.
///
/// Pass [goal] to edit an existing goal, or leave it `null` to create.
class GoalFormPage extends StatefulWidget {
  const GoalFormPage({
    this.goal,
    super.key,
  });

  final Goal? goal;

  @override
  State<GoalFormPage> createState() => _GoalFormPageState();
}

class _GoalFormPageState extends State<GoalFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _targetAmountController;
  late final TextEditingController _monthlyContributionController;
  late String _selectedType;
  DateTime? _targetDate;

  bool get _isEditing => widget.goal != null;

  static const _goalTypes = [
    'savings_target',
    'monthly_contribution',
    'debt_payoff',
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.goal?.name ?? '');
    _targetAmountController = TextEditingController(
      text: widget.goal?.targetAmount != null
          ? (widget.goal!.targetAmount! / 100).toStringAsFixed(2)
          : '',
    );
    _monthlyContributionController = TextEditingController(
      text: widget.goal?.monthlyContribution != null
          ? (widget.goal!.monthlyContribution! / 100).toStringAsFixed(2)
          : '',
    );
    _selectedType = widget.goal?.type ?? _goalTypes.first;
    _targetDate = widget.goal?.targetDate;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _targetAmountController.dispose();
    _monthlyContributionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<GoalFormCubit, GoalFormState>(
      listener: (context, state) {
        if (state.status == GoalFormStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == GoalFormStatus.failure) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                state.errorMessage ?? l10n.goalsErrorUpdateFailed,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing ? l10n.goalsEditGoal : l10n.goalsAddGoal,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: l10n.goalsNameLabel,
                      prefixIcon: const Icon(Icons.flag_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.goalsNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedType,
                    decoration: InputDecoration(
                      labelText: l10n.goalsTypeLabel,
                      prefixIcon: const Icon(Icons.category_outlined),
                    ),
                    items: _goalTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(localizedGoalType(type, l10n)),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => _selectedType = value);
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  // Type-specific fields.
                  if (_selectedType == 'savings_target' ||
                      _selectedType == 'debt_payoff') ...[
                    TextFormField(
                      controller: _targetAmountController,
                      decoration: InputDecoration(
                        labelText: l10n.goalsTargetAmountLabel,
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (_selectedType == 'savings_target' ||
                            _selectedType == 'debt_payoff') {
                          if (value == null || value.trim().isEmpty) {
                            return l10n.goalsTargetAmountRequired;
                          }
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedType == 'savings_target') ...[
                    _DatePickerField(
                      label: l10n.goalsTargetDateLabel,
                      value: _targetDate,
                      onChanged: (date) => setState(() => _targetDate = date),
                    ),
                    const SizedBox(height: 16),
                  ],
                  if (_selectedType == 'monthly_contribution') ...[
                    TextFormField(
                      controller: _monthlyContributionController,
                      decoration: InputDecoration(
                        labelText: l10n.goalsMonthlyContributionLabel,
                        prefixIcon: const Icon(Icons.attach_money),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d*\.?\d{0,2}'),
                        ),
                      ],
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(height: 16),
                  ],
                  const SizedBox(height: 16),
                  BlocBuilder<GoalFormCubit, GoalFormState>(
                    buildWhen: (prev, curr) => prev.status != curr.status,
                    builder: (context, state) {
                      final isSubmitting =
                          state.status == GoalFormStatus.submitting;
                      return FilledButton(
                        onPressed: isSubmitting ? null : _submit,
                        child: isSubmitting
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _isEditing
                                    ? l10n.goalsSaveButton
                                    : l10n.goalsCreateButton,
                              ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final targetAmountCents = parseCents(_targetAmountController.text);
    final monthlyContributionCents =
        parseCents(_monthlyContributionController.text);

    context.read<GoalFormCubit>().submit(
      name: _nameController.text.trim(),
      type: _selectedType,
      targetAmount: targetAmountCents,
      targetDate: _targetDate,
      monthlyContribution: monthlyContributionCents,
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onChanged;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? DateTime.now().add(const Duration(days: 30)),
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
        );
        if (picked != null) {
          onChanged(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(
          value != null
              ? '${value!.month.toString().padLeft(2, '0')}/'
                  '${value!.day.toString().padLeft(2, '0')}/'
                  '${value!.year}'
              : '',
        ),
      ),
    );
  }
}
