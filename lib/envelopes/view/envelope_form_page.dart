import 'package:envelope/l10n/l10n.dart';
import 'package:envelope_repository/envelope_repository.dart';
import 'package:flutter/material.dart';

/// Page for adding or editing an envelope.
///
/// Pass [envelope] to edit an existing envelope, or leave it `null` to create.
/// [categoryGroups] provides the list of available groups for the dropdown.
/// [initialCategoryGroupId] pre-selects a group when adding a new envelope.
class EnvelopeFormPage extends StatefulWidget {
  const EnvelopeFormPage({
    required this.envelopeRepository,
    required this.budgetId,
    required this.categoryGroups,
    this.initialCategoryGroupId,
    this.envelope,
    super.key,
  });

  final EnvelopeRepository envelopeRepository;
  final String budgetId;
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
  bool _isSubmitting = false;

  bool get _isEditing => widget.envelope != null;

  @override
  void initState() {
    super.initState();
    _nameController =
        TextEditingController(text: widget.envelope?.name ?? '');
    _selectedGroupId = widget.envelope?.categoryGroupId ??
        widget.initialCategoryGroupId ??
        (widget.categoryGroups.isNotEmpty
            ? widget.categoryGroups.first.id
            : '');
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
          _isEditing ? l10n.envelopesEditEnvelope : l10n.envelopesAddEnvelope,
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
                    initialValue:
                        _selectedGroupId.isNotEmpty ? _selectedGroupId : null,
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
    if (_selectedGroupId.isEmpty) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(content: Text(context.l10n.envelopesNoCategoryGroupsError)),
        );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      if (_isEditing) {
        final updated = widget.envelope!.copyWith(
          name: _nameController.text.trim(),
          categoryGroupId: _selectedGroupId,
        );
        await widget.envelopeRepository.updateEnvelope(updated);
      } else {
        await widget.envelopeRepository.createEnvelope(
          budgetId: widget.budgetId,
          categoryGroupId: _selectedGroupId,
          name: _nameController.text.trim(),
        );
      }

      if (mounted) Navigator.of(context).pop(true);
    } on EnvelopeException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }
}
