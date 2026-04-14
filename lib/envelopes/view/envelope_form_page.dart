import 'package:envelope/envelopes/cubit/cubit.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Page for adding or editing an envelope.
///
/// Pass [envelope] to edit an existing envelope, or leave it `null` to create.
/// [categoryGroups] provides the list of available groups for the dropdown.
/// [initialCategoryGroupId] pre-selects a group when adding a new envelope.
class EnvelopeFormPage extends StatefulWidget {
  const EnvelopeFormPage({
    required this.categoryGroups,
    this.initialCategoryGroupId,
    this.envelope,
    super.key,
  });

  final List<CategoryGroup> categoryGroups;
  final String? initialCategoryGroupId;
  final Envelope? envelope;

  @override
  State<EnvelopeFormPage> createState() => _EnvelopeFormPageState();
}

class _EnvelopeFormPageState extends State<EnvelopeFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late String _selectedGroupId;
  String? _selectedColor;

  /// Predefined warm color swatches — visually distinct medium tones with
  /// ≥ 4.5:1 contrast ratio against white text (WCAG AA compliant).
  static const _colorSwatches = <({String hex, Color color, String label})>[
    (hex: '#D4896A', color: Color(0xFFD4896A), label: 'Peach'),
    (hex: '#B5564E', color: Color(0xFFB5564E), label: 'Terracotta'),
    (hex: '#A0522D', color: Color(0xFFA0522D), label: 'Sienna'),
    (hex: '#8B6914', color: Color(0xFF8B6914), label: 'Amber'),
    (hex: '#7A8450', color: Color(0xFF7A8450), label: 'Olive'),
    (hex: '#8B5E3C', color: Color(0xFF8B5E3C), label: 'Clay'),
    (hex: '#9B6878', color: Color(0xFF9B6878), label: 'Rose'),
    (hex: '#7B6B8A', color: Color(0xFF7B6B8A), label: 'Mauve'),
    (hex: '#907860', color: Color(0xFF907860), label: 'Taupe'),
  ];

  bool get _isEditing => widget.envelope != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.envelope?.name ?? '');
    _selectedGroupId =
        widget.envelope?.categoryGroupId ??
        widget.initialCategoryGroupId ??
        (widget.categoryGroups.isNotEmpty
            ? widget.categoryGroups.first.id
            : '');
    _selectedColor = widget.envelope?.color;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<EnvelopeFormCubit, EnvelopeFormState>(
      listener: (context, state) {
        if (state.status == EnvelopeFormStatus.success) {
          Navigator.of(context).pop(true);
        } else if (state.status == EnvelopeFormStatus.failure) {
          showAppSnackBar(
            context,
            SnackBar(
              content: Text(
                state.errorMessage ?? l10n.envelopesErrorUpdateFailed,
              ),
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _isEditing
                ? l10n.envelopesEditEnvelope
                : l10n.envelopesAddEnvelope,
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
                      labelText: l10n.envelopesEnvelopeNameLabel,
                      prefixIcon: const Icon(Icons.folder_outlined),
                    ),
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    autofocus: true,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return l10n.envelopesEnvelopeNameRequired;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (widget.categoryGroups.isNotEmpty)
                    DropdownButtonFormField<String>(
                      initialValue: _selectedGroupId.isNotEmpty
                          ? _selectedGroupId
                          : null,
                      decoration: InputDecoration(
                        labelText: l10n.envelopesCategoryGroupLabel,
                        prefixIcon: const Icon(Icons.category_outlined),
                      ),
                      items: widget.categoryGroups.map((group) {
                        return DropdownMenuItem(
                          value: group.id,
                          child: Text(group.name),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _selectedGroupId = value);
                        }
                      },
                    ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.envelopesColorLabel,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _colorSwatches.map((swatch) {
                      final isSelected = _selectedColor == swatch.hex;
                      return Semantics(
                        label: swatch.label,
                        selected: isSelected,
                        button: true,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor =
                                  isSelected ? null : swatch.hex;
                            });
                          },
                          child: Tooltip(
                            message: swatch.label,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: swatch.color,
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: AppColors.charcoal,
                                        width: 2.5,
                                      )
                                    : null,
                              ),
                              child: isSelected
                                  ? const Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: 18,
                                    )
                                  : null,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  BlocBuilder<EnvelopeFormCubit, EnvelopeFormState>(
                    buildWhen: (prev, curr) => prev.status != curr.status,
                    builder: (context, state) {
                      final isSubmitting =
                          state.status == EnvelopeFormStatus.submitting;
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
                                    ? l10n.envelopesSaveButton
                                    : l10n.envelopesCreateButton,
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
    if (_selectedGroupId.isEmpty) {
      showAppSnackBar(
        context,
        SnackBar(content: Text(context.l10n.envelopesNoCategoryGroupsError)),
      );
      return;
    }

    context.read<EnvelopeFormCubit>().submit(
      name: _nameController.text.trim(),
      categoryGroupId: _selectedGroupId,
      color: _selectedColor,
    );
  }
}
