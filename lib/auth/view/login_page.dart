import 'package:auth_repository/auth_repository.dart';
import 'package:envelope/app/app.dart';
import 'package:envelope/auth/cubit/cubit.dart';
import 'package:envelope/auth/view/forgot_password_page.dart';
import 'package:envelope/auth/view/sign_up_page.dart';
import 'package:envelope/auth/widgets/widgets.dart';
import 'package:envelope/l10n/l10n.dart';
import 'package:envelope/shared/widgets/undo_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static String routeName = AppRoutes.login;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginCubit(
        authRepository: context.read<AuthRepository>(),
      ),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;

    return BlocListener<LoginCubit, LoginState>(
      listenWhen: (previous, current) => previous.status != current.status,
      listener: (context, state) {
        if (state.status == LoginStatus.failure) {
          showAppSnackBar(
            context,
            SnackBar(content: Text(state.errorMessage ?? '')),
          );
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.mail_outlined,
                        size: 64,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.appTitle,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: l10n.emailLabel,
                          prefixIcon: const Icon(Icons.email_outlined),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autocorrect: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.emailRequired;
                          }
                          if (!value.contains('@')) {
                            return l10n.emailInvalid;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: l10n.passwordLabel,
                          prefixIcon: const Icon(Icons.lock_outlined),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        obscureText: _obscurePassword,
                        textInputAction: TextInputAction.done,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return l10n.passwordRequired;
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) => _submit(),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () =>
                              context.pushNamed(ForgotPasswordPage.routeName),
                          child: Text(l10n.forgotPasswordLink),
                        ),
                      ),
                      const SizedBox(height: 8),
                      BlocBuilder<LoginCubit, LoginState>(
                        buildWhen: (p, c) => p.status != c.status,
                        builder: (context, state) {
                          final isSubmitting =
                              state.status == LoginStatus.submitting ||
                              state.status == LoginStatus.success;
                          return SizedBox(
                            width: double.infinity,
                            child: FilledButton(
                              onPressed: isSubmitting ? null : _submit,
                              child: isSubmitting
                                  ? const SizedBox.square(
                                      dimension: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : Text(l10n.signInButton),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      const SocialSignInDivider(),
                      const SizedBox(height: 16),
                      const SocialSignInButtons(),
                      const SizedBox(height: 24),
                      TextButton(
                        onPressed: () =>
                            context.pushNamed(SignUpPage.routeName),
                        child: Text(l10n.noAccountLink),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      await context.read<LoginCubit>().signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
    }
  }
}
