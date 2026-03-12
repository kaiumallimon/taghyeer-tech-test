import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';
import 'package:taghyeer_test/features/dashboard/_wrapper.dart';
import 'package:taghyeer_test/shared/widgets/_custom_button.dart';
import 'package:taghyeer_test/shared/widgets/_custom_snackbar.dart';
import 'package:taghyeer_test/shared/widgets/_custom_textfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final username = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (username.isEmpty || password.isEmpty) {
      CustomSnackbar.show(
        context,
        type: SnackbarType.warning,
        title: 'Missing fields',
        message: 'Please enter your username and password.',
      );
      return;
    }
    context.read<AuthCubit>().login(username: username, password: password);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const DashboardWrapper()),
          );
        } else if (state is AuthError) {
          CustomSnackbar.show(
            context,
            type: SnackbarType.error,
            title: 'Login failed',
            message: state.message,
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Stack(
            children: [
              // Decorative blobs
              Positioned(
                top: -80,
                right: -60,
                child: _Blob(
                  size: 260,
                  color: theme.colorScheme.primary.withAlpha(30),
                ),
              ),
              Positioned(
                top: 60,
                left: -80,
                child: _Blob(
                  size: 200,
                  color: theme.colorScheme.primary.withAlpha(18),
                ),
              ),

              // Main content
              SafeArea(
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: size.height),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 60),

                          // Brand logo
                          _brandLogo(theme),

                          const SizedBox(height: 32),

                          // Headline
                          _headlineWidget(theme),
                          const SizedBox(height: 8),
                          _subtitleWidget(theme),

                          const SizedBox(height: 48),

                          // Form
                          CustomTextField(
                            hint: AppConstants.emailHint,
                            label: AppConstants.emailLabel,
                            controller: _emailController,
                            keyboardType: TextInputType.text,
                            prefixIcon: Icons.person_outline_rounded,
                          ),
                          const SizedBox(height: 20),
                          CustomTextField(
                            hint: AppConstants.passwordHint,
                            label: AppConstants.passwordLabel,
                            controller: _passwordController,
                            isPassword: true,
                            prefixIcon: Icons.lock_outline_rounded,
                          ),

                          const SizedBox(height: 12),

                          // Forgot password
                          _forgotPasswordWidget(context, theme),

                          const SizedBox(height: 12),

                          // Sign-in button
                          CustomButton(
                            label: AppConstants.loginButtonLabel,
                            onPressed: isLoading ? null : _onLoginPressed,
                            isLoading: isLoading,
                            prefixIcon: Icons.login_rounded,
                          ),

                          const SizedBox(height: 40),

                          // Sign-up prompt
                          _signupWidget(theme, context),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Widget for the "Forgot Password?" link
  Align _forgotPasswordWidget(BuildContext context, ThemeData theme) {
    return Align(
      alignment: Alignment.centerRight,
      child: GestureDetector(
        onTap: () {
          CustomSnackbar.show(context, message: "Not implemented yet");
        },
        child: Text(
          AppConstants.forgotPassword,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // Widget for the subtitle text
  Text _subtitleWidget(ThemeData theme) {
    return Text(
      AppConstants.loginSubtitle,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withAlpha(160),
      ),
    );
  }

  // Widget for the headline text
  Text _headlineWidget(ThemeData theme) {
    return Text(
      AppConstants.loginTitle,
      style: theme.textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w800,
        letterSpacing: -0.5,
      ),
    );
  }

  // Widget for the brand logo
  Container _brandLogo(ThemeData theme) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(80),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Icon(Icons.tag, color: theme.colorScheme.onPrimary, size: 32),
    );
  }

  // Widget for the sign-up prompt with tappable "Sign Up" text
  Center _signupWidget(ThemeData theme, BuildContext context) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: AppConstants.noAccountPrompt,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface.withAlpha(160),
          ),
          children: [
            WidgetSpan(
              alignment: PlaceholderAlignment.middle,
              child: GestureDetector(
                onTap: () {
                  CustomSnackbar.show(context, message: "Not implemented yet");
                },
                child: Text(
                  AppConstants.signUpLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}
