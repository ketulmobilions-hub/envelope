import 'package:flutter/material.dart';

/// Constrains content to a maximum width and centers it on wide screens.
///
/// Use this to wrap page bodies so they don't stretch full-width on
/// tablet/desktop/web layouts.
class ResponsiveContent extends StatelessWidget {
  const ResponsiveContent({
    required this.child,
    this.maxWidth = 800,
    super.key,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
