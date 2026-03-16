import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:transaction_repository/transaction_repository.dart';

/// Multi-select tag picker with inline create capability.
class TagPicker extends StatefulWidget {
  const TagPicker({
    required this.availableTags,
    required this.selectedTagIds,
    required this.onChanged,
    required this.onCreateTag,
    super.key,
  });

  final List<Tag> availableTags;
  final List<String> selectedTagIds;
  final ValueChanged<List<String>> onChanged;
  final ValueChanged<String> onCreateTag;

  @override
  State<TagPicker> createState() => _TagPickerState();
}

class _TagPickerState extends State<TagPicker> {
  final _controller = TextEditingController();
  bool _isCreating = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.transactionsTagsLabel,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final tag in widget.availableTags)
              FilterChip(
                label: Text(tag.name),
                selected: widget.selectedTagIds.contains(tag.id),
                onSelected: (selected) {
                  final updated = List<String>.from(widget.selectedTagIds);
                  if (selected) {
                    updated.add(tag.id);
                  } else {
                    updated.remove(tag.id);
                  }
                  widget.onChanged(updated);
                },
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: Text(l10n.transactionsAddTag),
              onPressed: () => setState(() => _isCreating = true),
            ),
          ],
        ),
        if (_isCreating) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: l10n.transactionsTagNameHint,
                    isDense: true,
                  ),
                  onSubmitted: _submitNewTag,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.check),
                onPressed: () => _submitNewTag(_controller.text),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  _controller.clear();
                  setState(() => _isCreating = false);
                },
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _submitNewTag(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    widget.onCreateTag(trimmed);
    _controller.clear();
    setState(() => _isCreating = false);
  }
}
