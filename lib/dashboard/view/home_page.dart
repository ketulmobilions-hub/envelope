import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Home/dashboard page placeholder.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.homeTitle),
      ),
      body: Center(
        child: Text(context.l10n.homeTitle),
      ),
    );
  }
}
