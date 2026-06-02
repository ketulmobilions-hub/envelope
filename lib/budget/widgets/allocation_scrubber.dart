import 'dart:async';

import 'package:envelope/budget/bloc/bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Thin horizontal scrubber that nudges an envelope's allocation.
///
/// Drag right adds cents, drag left subtracts. Thumb springs back to center
/// on release. Fires [AllocationAmountChanged] per drag-update tick.
class AllocationScrubber extends StatefulWidget {
  const AllocationScrubber({
    required this.envelopeId,
    required this.currentCents,
    required this.onCentsChanged,
    this.centsPerPixel = 100,
    super.key,
  });

  final String envelopeId;
  final int currentCents;
  final ValueChanged<int> onCentsChanged;
  final int centsPerPixel;

  @override
  State<AllocationScrubber> createState() => _AllocationScrubberState();
}

class _AllocationScrubberState extends State<AllocationScrubber> {
  static const int _maxCents = 99999999999; // matches maxCentsAmount

  double _thumbOffset = 0;
  bool _isDragging = false;
  int _baseCents = 0;

  void _onDragStart(DragStartDetails details) {
    unawaited(HapticFeedback.selectionClick());
    setState(() {
      _isDragging = true;
      _thumbOffset = 0;
      _baseCents = widget.currentCents;
    });
  }

  void _onDragUpdate(DragUpdateDetails details, double trackHalfWidth) {
    final next = (_thumbOffset + details.delta.dx).clamp(
      -trackHalfWidth,
      trackHalfWidth,
    );
    final newAccum = next.round() * widget.centsPerPixel;
    final newCents = (_baseCents + newAccum).clamp(0, _maxCents);
    setState(() {
      _thumbOffset = next;
    });
    widget.onCentsChanged(newCents);
    context.read<BudgetBloc>().add(
      AllocationAmountChanged(
        envelopeId: widget.envelopeId,
        amount: newCents,
      ),
    );
  }

  void _onDragEnd(DragEndDetails details) {
    unawaited(HapticFeedback.lightImpact());
    setState(() {
      _isDragging = false;
      _thumbOffset = 0;
    });
  }

  void _onDragCancel() {
    setState(() {
      _isDragging = false;
      _thumbOffset = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (_, constraints) {
        final width = constraints.maxWidth;
        final halfWidth = (width / 2 - 12).clamp(0.0, double.infinity);
        return SizedBox(
          height: 28,
          child: RawGestureDetector(
            behavior: HitTestBehavior.opaque,
            gestures: <Type, GestureRecognizerFactory>{
              HorizontalDragGestureRecognizer:
                  GestureRecognizerFactoryWithHandlers<
                    HorizontalDragGestureRecognizer
                  >(
                    HorizontalDragGestureRecognizer.new,
                    (r) {
                      r
                        ..dragStartBehavior = DragStartBehavior.start
                        ..onStart = _onDragStart
                        ..onUpdate = (d) {
                          _onDragUpdate(d, halfWidth);
                        }
                        ..onEnd = _onDragEnd
                        ..onCancel = _onDragCancel;
                    },
                  ),
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Container(
                  width: 2,
                  height: 10,
                  color: theme.colorScheme.outlineVariant,
                ),
                AnimatedAlign(
                  duration: _isDragging
                      ? Duration.zero
                      : const Duration(milliseconds: 180),
                  curve: Curves.easeOutCubic,
                  alignment: Alignment(
                    halfWidth == 0 ? 0 : _thumbOffset / halfWidth,
                    0,
                  ),
                  child: AnimatedScale(
                    duration: const Duration(milliseconds: 120),
                    scale: _isDragging ? 1.15 : 1,
                    child: Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
