import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';

/// Login page placeholder.
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.loginTitle),
      ),
      body: Center(
        child: Text(context.l10n.loginTitle),
      ),
    );
  }
}
