import 'package:envelope/accounts/widgets/format_cents.dart';
import 'package:envelope/envelopes/widgets/envelope_shape_painter.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/utils/currency_utils.dart';
import 'package:envelope/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A card widget that overlays envelope info on an envelope-shaped background.
class EnvelopeCard extends StatefulWidget {
  const EnvelopeCard({
    required this.name,
    required this.availableCents,
    required this.allocatedCents,
    required this.spentCents,
    this.isOverspent = false,
    this.primaryLabel,
    this.limitLabel,
    this.color,
    this.heroTag,
    this.onTap,
    this.onAllocate,
    this.onFixOverspend,
    this.onPay,
    super.key,
  });

  final String name;
  final int availableCents;
  final int allocatedCents;
  final int spentCents;
  final bool isOverspent;

  /// When set, replaces the big amount with this text (e.g. "Due: $450").
  final String? primaryLabel;

  /// Small secondary line shown below [primaryLabel] (e.g. "$550 of $1,000").
  final String? limitLabel;
  final Color? color;
  final String? heroTag;
  final VoidCallback? onTap;

  /// Called when the user submits a new allocation amount (in cents).
  final ValueChanged<int>? onAllocate;

  /// Called when the user taps "Fix Overspend" on an overspent card.
  final VoidCallback? onFixOverspend;

  /// Called when the user taps "Pay" on a CC payment envelope card.
  final VoidCallback? onPay;

  @override
  State<EnvelopeCard> createState() => _EnvelopeCardState();
}

class _EnvelopeCardState extends State<EnvelopeCard> {
  bool _isEditing = false;
  late final TextEditingController _controller;
  late final FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode
      ..removeListener(_onFocusChange)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  void _enterEditMode() {
    if (widget.onAllocate == null) return;
    setState(() {
      _isEditing = true;
      final dollars = widget.allocatedCents > 0
          ? (widget.allocatedCents / 100).toStringAsFixed(2)
          : '';
      _controller
        ..text = dollars
        ..selection = TextSelection(
          baseOffset: 0,
          extentOffset: dollars.length,
        );
    });
    _focusNode.requestFocus();
  }

  void _onFocusChange() {
    if (!_focusNode.hasFocus && _isEditing) {
      _submitEditing();
    }
  }

  void _submitEditing() {
    final text = _controller.text.trim();
    final cents = parseCents(text);
    if (cents != null && cents >= 0) {
      widget.onAllocate?.call(cents);
    }
    setState(() => _isEditing = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final symbol = currencySymbol(context);
    final fillColor = widget.isOverspent
        ? AppColors.expense
        : (widget.color ?? AppColors.primary);
    final textColor = AppColors.onPrimary.withValues(alpha: 0.9);

    Widget card = SizedBox(
      height: 140,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: EnvelopeShapePainter(
                fillColor: fillColor,
              ),
            ),
          ),
          // Full-card tap target for navigation / dismiss editing.
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: _isEditing
                  ? () => _focusNode.unfocus()
                  : widget.onTap,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              14,
              44,
              14,
              12,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Upper area — passes taps through to full-card
                // detector above.
                Expanded(
                  child: IgnorePointer(
                    child: SizedBox.expand(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        Text(
                          widget.name.toUpperCase(),
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                            letterSpacing: 0.8,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const Spacer(),
                        if (widget.primaryLabel != null) ...[
                          Text(
                            widget.primaryLabel!,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                          if (widget.limitLabel != null)
                            Text(
                              widget.limitLabel!,
                              style: TextStyle(
                                fontSize: 10,
                                color: textColor.withValues(alpha: 0.7),
                              ),
                            ),
                        ] else
                          Text(
                            formatCents(
                              widget.availableCents,
                              symbol: symbol,
                            ),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: textColor,
                            ),
                          ),
                      ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Divider(
                  height: 1,
                  thickness: 0.8,
                  color: textColor.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 4),
                // Bottom area — "Pay" for CC envelopes, "Fix Overspend"
                // when overspent, inline allocation editing otherwise.
                if (widget.onPay != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onPay,
                    child: Row(
                      children: [
                        Icon(
                          Icons.credit_card_outlined,
                          size: 10,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.ccPayButton,
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else if (widget.isOverspent && widget.onFixOverspend != null)
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: widget.onFixOverspend,
                    child: Row(
                      children: [
                        Icon(
                          Icons.build_outlined,
                          size: 10,
                          color: textColor,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.envelopeFixOverspend,
                          style: TextStyle(
                            fontSize: 11,
                            color: textColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _isEditing ? null : _enterEditMode,
                    child: _isEditing
                        ? SizedBox(
                            height: 20,
                            child: TextField(
                              controller: _controller,
                              focusNode: _focusNode,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              cursorColor: Colors.white,
                              cursorWidth: 1.5,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              textInputAction: TextInputAction.done,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                              decoration: InputDecoration(
                                prefixText: symbol,
                                prefixStyle: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                                border: InputBorder.none,
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                focusedBorder: const UnderlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.white,
                                  ),
                                ),
                                contentPadding:
                                    const EdgeInsets.only(bottom: 4),
                                isDense: true,
                              ),
                              onSubmitted: (_) => _submitEditing(),
                            ),
                          )
                        : Row(
                            children: [
                              Flexible(
                                child: Text(
                                  l10n.envelopeCardOfAllocated(
                                    formatCents(
                                      widget.allocatedCents,
                                      symbol: symbol,
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: textColor,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              if (widget.onAllocate != null)
                                Padding(
                                  padding: const EdgeInsets.only(left: 4),
                                  child: Icon(
                                    Icons.edit_outlined,
                                    size: 10,
                                    color: textColor,
                                  ),
                                ),
                            ],
                          ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );

    if (widget.heroTag != null) {
      card = Hero(
        tag: widget.heroTag!,
        flightShuttleBuilder: (
          _,
          animation,
          direction,
          fromContext,
          toContext,
        ) {
          final curvedAnim = CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          );
          return AnimatedBuilder(
            animation: curvedAnim,
            builder: (context, _) {
              final t = curvedAnim.value;
              final radius =
                  BorderRadius.circular(12 * (1 - t));
              return ClipRRect(
                borderRadius: radius,
                child: Container(color: fillColor),
              );
            },
          );
        },
        child: Material(
          type: MaterialType.transparency,
          child: card,
        ),
      );
    }

    return Semantics(
      label: widget.onAllocate != null
          ? 'Tap allocated amount to edit'
          : null,
      child: _isEditing
          ? TapRegion(
              onTapOutside: (_) {
                _focusNode.unfocus();
              },
              child: card,
            )
          : card,
    );
  }
}
