import 'package:envelope/auth/cubit/cubit.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SocialSignInButtons extends StatelessWidget {
  const SocialSignInButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.read<LoginCubit>().signInWithGoogle(),
            icon: const Icon(Icons.g_mobiledata, size: 24),
            label: Text(l10n.signInWithGoogle),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () => context.read<LoginCubit>().signInWithApple(),
            icon: const Icon(Icons.apple, size: 24),
            label: Text(l10n.signInWithApple),
          ),
        ),
      ],
    );
  }
}
