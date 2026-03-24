import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A dialog that lets users quickly allocate an amount to an envelope.
///
/// Returns the allocated amount in cents via [Navigator.pop], or `null`
/// if cancelled.
class QuickAllocateDialog extends StatefulWidget {
  const QuickAllocateDialog({
    required this.envelopeName,
    this.currentAmountCents,
    super.key,
  });

  final String envelopeName;
  final int? currentAmountCents;

  @override
  State<QuickAllocateDialog> createState() => _QuickAllocateDialogState();
}

class _QuickAllocateDialogState extends State<QuickAllocateDialog> {
  late final TextEditingController _controller;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final initial = widget.currentAmountCents;
    _controller = TextEditingController(
      text: initial != null && initial > 0
          ? (initial / 100).toStringAsFixed(2)
          : '',
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final cents = parseCents(_controller.text);
    Navigator.of(context).pop(cents);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return AlertDialog(
      title: Text(l10n.quickAllocateTitle(widget.envelopeName)),
      content: Form(
        key: _formKey,
        child: TextFormField(
          controller: _controller,
          autofocus: true,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          textInputAction: TextInputAction.done,
          onFieldSubmitted: (_) => _submit(),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d{0,2}'),
            ),
          ],
          decoration: InputDecoration(
            hintText: l10n.quickAllocateHint,
            prefixText: r'$',
          ),
          validator: (value) {
            final cents = parseCents(value ?? '');
            if (cents == null || cents <= 0) {
              return l10n.quickAllocateHint;
            }
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.quickAllocateCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(l10n.quickAllocateSave),
        ),
      ],
    );
  }
}
