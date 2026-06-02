import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Floating action button that expands into a speed dial with three child
/// FABs: expense, income, and transfer.
///
/// The main FAB rotates 45° into an X when open. Children slide upward from
/// behind the main FAB. Tap the main FAB or any child to close.
class QuickAddSpeedDial extends StatefulWidget {
  const QuickAddSpeedDial({
    required this.onExpense,
    required this.onIncome,
    required this.onTransfer,
    this.onLongPress,
    this.expenseLabel = 'Expense',
    this.incomeLabel = 'Income',
    this.transferLabel = 'Transfer',
    this.tooltip,
    super.key,
  });

  final VoidCallback onExpense;
  final VoidCallback onIncome;
  final VoidCallback onTransfer;
  final VoidCallback? onLongPress;
  final String expenseLabel;
  final String incomeLabel;
  final String transferLabel;
  final String? tooltip;

  @override
  State<QuickAddSpeedDial> createState() => QuickAddSpeedDialState();
}

class QuickAddSpeedDialState extends State<QuickAddSpeedDial>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expand;

  /// Anchors the overlay-hosted child FABs to the inline main FAB's position.
  final LayerLink _link = LayerLink();

  /// Full-screen overlay entry hosting the scrim plus the child FABs while
  /// the dial is open. Children must live above the scrim so their taps win
  /// the gesture arena — otherwise the scrim's onTap eats the tap and only
  /// closes the dial without running the action.
  OverlayEntry? _entry;

  bool get _isOpen => _controller.status != AnimationStatus.dismissed;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 220),
    );
    _expand = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
  }

  @override
  void dispose() {
    _removeEntry();
    _controller
      ..stop()
      ..dispose();
    super.dispose();
  }

  void _toggle() {
    if (_isOpen) {
      close();
    } else {
      _insertEntry();
      unawaited(_controller.forward());
    }
  }

  /// Closes the dial. Public so callers can close on external events.
  void close() {
    if (!_isOpen) return;
    unawaited(
      _controller.reverse().whenComplete(_removeEntry),
    );
  }

  void _insertEntry() {
    if (_entry != null) return;
    final overlay = Overlay.maybeOf(context, rootOverlay: true);
    if (overlay == null) return;
    _entry = OverlayEntry(builder: _buildOverlay);
    overlay.insert(_entry!);
  }

  void _removeEntry() {
    _entry?.remove();
    _entry = null;
  }

  void _onChildTap(VoidCallback action) {
    close();
    action();
  }

  Widget _buildOverlay(BuildContext _) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: close,
          ),
        ),
        Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: _link,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.bottomRight,
            showWhenUnlinked: false,
            child: AnimatedBuilder(
              animation: _expand,
              builder: (context, _) {
                final t = _expand.value;
                return SizedBox(
                  width: 280,
                  height: 260,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      _ChildFab(
                        offsetY: 72 * t,
                        opacity: t,
                        icon: Icons.swap_horiz,
                        label: widget.transferLabel,
                        heroTag: 'speed_dial_transfer',
                        onPressed: () => _onChildTap(widget.onTransfer),
                      ),
                      _ChildFab(
                        offsetY: 136 * t,
                        opacity: t,
                        icon: Icons.trending_up,
                        label: widget.incomeLabel,
                        heroTag: 'speed_dial_income',
                        onPressed: () => _onChildTap(widget.onIncome),
                      ),
                      _ChildFab(
                        offsetY: 200 * t,
                        opacity: t,
                        icon: Icons.shopping_bag_outlined,
                        label: widget.expenseLabel,
                        heroTag: 'speed_dial_expense',
                        onPressed: () => _onChildTap(widget.onExpense),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _link,
      child: AnimatedBuilder(
        animation: _expand,
        builder: (context, _) {
          final t = _expand.value;
          return GestureDetector(
            onLongPress: widget.onLongPress,
            child: FloatingActionButton(
              heroTag: 'speed_dial_main',
              tooltip: widget.tooltip,
              onPressed: _toggle,
              child: Transform.rotate(
                angle: t * math.pi / 4,
                child: const Icon(Icons.add),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ChildFab extends StatelessWidget {
  const _ChildFab({
    required this.offsetY,
    required this.opacity,
    required this.icon,
    required this.label,
    required this.heroTag,
    required this.onPressed,
  });

  final double offsetY;
  final double opacity;
  final IconData icon;
  final String label;
  final String heroTag;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final visible = opacity > 0.01;
    return Positioned(
      right: 0,
      bottom: offsetY,
      child: IgnorePointer(
        ignoring: !visible,
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Material(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                elevation: 2,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              FloatingActionButton.small(
                heroTag: heroTag,
                onPressed: onPressed,
                child: Icon(icon),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
