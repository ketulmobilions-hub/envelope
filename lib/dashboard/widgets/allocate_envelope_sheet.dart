import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/auth/auth.dart';
import 'package:envelope/dashboard/bloc/bloc.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AllocateMode { add, setTo }

Future<void> showAllocateEnvelopeSheet(
  BuildContext context, {
  required String envelopeId,
  required String envelopeName,
  required int currentAllocatedCents,
}) {
  final dashboardBloc = context.read<DashboardBloc>();
  final authBloc = context.read<AuthBloc>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (sheetContext) => MultiBlocProvider(
      providers: [
        BlocProvider<DashboardBloc>.value(value: dashboardBloc),
        BlocProvider<AuthBloc>.value(value: authBloc),
      ],
      child: _AllocateEnvelopeSheet(
        envelopeId: envelopeId,
        envelopeName: envelopeName,
        currentAllocatedCents: currentAllocatedCents,
      ),
    ),
  );
}

class _AllocateEnvelopeSheet extends StatefulWidget {
  const _AllocateEnvelopeSheet({
    required this.envelopeId,
    required this.envelopeName,
    required this.currentAllocatedCents,
  });

  final String envelopeId;
  final String envelopeName;
  final int currentAllocatedCents;

  @override
  State<_AllocateEnvelopeSheet> createState() => _AllocateEnvelopeSheetState();
}

class _AllocateEnvelopeSheetState extends State<_AllocateEnvelopeSheet> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  AllocateMode _mode = AllocateMode.add;

  String? _lastAutoFilledText;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onTextChanged);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onTextChanged)
      ..dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  void _setMode(AllocateMode mode) {
    if (_mode == mode) return;
    setState(() {
      _mode = mode;
      if (mode == AllocateMode.setTo && _controller.text.isEmpty) {
        final dollars = widget.currentAllocatedCents > 0
            ? (widget.currentAllocatedCents / 100).toStringAsFixed(2)
            : '';
        if (dollars.isNotEmpty) {
          _controller
            ..text = dollars
            ..selection = TextSelection(
              baseOffset: 0,
              extentOffset: dollars.length,
            );
          _lastAutoFilledText = dollars;
        }
      } else if (mode == AllocateMode.add &&
          _controller.text == _lastAutoFilledText) {
        _controller.clear();
        _lastAutoFilledText = null;
      }
    });
  }

  int? _parsedCents() => parseCents(_controller.text);

  int? _finalCents() {
    final parsed = _parsedCents();
    if (parsed == null) return null;
    return _mode == AllocateMode.add
        ? widget.currentAllocatedCents + parsed
        : parsed;
  }

  int _deltaCents() {
    final finalCents = _finalCents();
    if (finalCents == null) return 0;
    return finalCents - widget.currentAllocatedCents;
  }

  bool get _canSubmit {
    final parsed = _parsedCents();
    if (parsed == null || parsed < 0) return false;
    if (_mode == AllocateMode.add && parsed == 0) return false;
    final finalCents = _finalCents();
    if (finalCents == null || finalCents < 0) return false;
    if (_mode == AllocateMode.setTo &&
        finalCents == widget.currentAllocatedCents) {
      return false;
    }
    return true;
  }

  void _submit() {
    if (!_canSubmit) return;
    final finalCents = _finalCents()!;
    context.read<DashboardBloc>().add(
      QuickAllocationRequested(
        envelopeId: widget.envelopeId,
        amount: finalCents,
      ),
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final readyToAssign = context.select<DashboardBloc, int>(
      (b) => b.state.adjustedReadyToAssign,
    );
    final finalCents = _finalCents();
    final previewText = finalCents != null
        ? l10n.allocateSheetNewAllocation(
            formatCents(finalCents, symbol: symbol),
          )
        : null;
    final delta = _deltaCents();
    final overAllocated = delta > readyToAssign;

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Text(
            l10n.quickAllocateTitle(widget.envelopeName),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          Text(
            l10n.allocateSheetCurrentlyAllocated(
              formatCents(widget.currentAllocatedCents, symbol: symbol),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.allocateSheetReadyToAssign(
              formatCents(readyToAssign, symbol: symbol),
            ),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          SegmentedButton<AllocateMode>(
            segments: [
              ButtonSegment(
                value: AllocateMode.add,
                label: Text(l10n.allocateSheetModeAdd),
              ),
              ButtonSegment(
                value: AllocateMode.setTo,
                label: Text(l10n.allocateSheetModeSet),
              ),
            ],
            selected: {_mode},
            onSelectionChanged: (s) => _setMode(s.first),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            focusNode: _focusNode,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
            inputFormatters: [
              // Strip anything that isn't a digit or decimal point first.
              FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
              // Then enforce at most one dot and at most 2 decimal places.
              TextInputFormatter.withFunction((oldValue, newValue) {
                final text = newValue.text;
                if (text.isEmpty) return newValue;
                if (text.indexOf('.') != text.lastIndexOf('.')) return oldValue;
                final dotIndex = text.indexOf('.');
                if (dotIndex != -1 && text.length - dotIndex - 1 > 2) {
                  return oldValue;
                }
                return newValue;
              }),
            ],
            decoration: InputDecoration(
              prefixText: symbol,
              hintText: l10n.quickAllocateHint,
              border: const OutlineInputBorder(),
            ),
            onSubmitted: (_) => _submit(),
          ),
          if (previewText != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context)
                    .colorScheme
                    .primaryContainer
                    .withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                previewText,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ],
          if (overAllocated) ...[
            const SizedBox(height: 8),
            Text(
              l10n.allocateSheetOverAllocated,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.expense,
              ),
            ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.quickAllocateCancel),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton(
                  onPressed: _canSubmit ? _submit : null,
                  child: Text(l10n.quickAllocateSave),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
