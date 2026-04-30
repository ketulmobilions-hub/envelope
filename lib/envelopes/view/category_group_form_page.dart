import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';

/// Page for adding or editing a category group.
///
/// Pass [categoryGroup] to edit an existing group, or leave it `null` to
/// create.
class CategoryGroupFormPage extends StatefulWidget {
  const CategoryGroupFormPage({
    required this.envelopeRepository,
    required this.budgetId,
    this.categoryGroup,
    super.key,
  });

  final EnvelopeRepository envelopeRepository;
  final String budgetId;
  final CategoryGroup? categoryGroup;

  @override
  State<CategoryGroupFormPage> createState() => _CategoryGroupFormPageState();
}

class _CategoryGroupFormPageState extends State<CategoryGroupFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  bool _isSubmitting = false;

  bool get _isEditing => widget.categoryGroup != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.categoryGroup?.name ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isEditing
              ? l10n.envelopesEditCategoryGroup
              : l10n.envelopesAddCategoryGroup,
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
                    labelText: l10n.envelopesCategoryGroupNameLabel,
                    prefixIcon: const Icon(Icons.category_outlined),
                  ),
                  textInputAction: TextInputAction.done,
                  textCapitalization: TextCapitalization.words,
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.envelopesCategoryGroupNameRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: _isSubmitting ? null : _submit,
                  child: _isSubmitting
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          _isEditing
                              ? l10n.envelopesSaveButton
                              : l10n.envelopesCreateButton,
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSubmitting = true);

    try {
      if (_isEditing) {
        final updated = widget.categoryGroup!.copyWith(
          name: _nameController.text.trim(),
        );
        await widget.envelopeRepository.updateCategoryGroup(updated);
      } else {
        await widget.envelopeRepository.createCategoryGroup(
          budgetId: widget.budgetId,
          name: _nameController.text.trim(),
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } on EnvelopeException catch (e) {
      if (mounted) {
        showAppSnackBar(context, SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
