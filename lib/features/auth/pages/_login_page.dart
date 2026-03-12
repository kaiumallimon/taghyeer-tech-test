import 'package:flutter/material.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Stack(
        children: [
          // ── Background accent blobs ──────────────────────────────────
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

          // ── Main content ─────────────────────────────────────────────
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

                      // ── Brand logo ───────────────────────────────────
                      Container(
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
                        child: Icon(
                          Icons.bolt_rounded,
                          color: theme.colorScheme.onPrimary,
                          size: 32,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // ── Headline ─────────────────────────────────────
                      Text(
                        AppConstants.loginTitle,
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppConstants.loginSubtitle,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface.withAlpha(160),
                        ),
                      ),

                      const SizedBox(height: 48),

                      // ── Form ─────────────────────────────────────────
                      CustomTextField(
                        hint: AppConstants.emailHint,
                        label: AppConstants.emailLabel,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.mail_outline_rounded,
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

                      // ── Forgot password ───────────────────────────────
                      Align(
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
                      ),

                      const SizedBox(height: 12),

                      // ── Sign-in button ────────────────────────────────
                      CustomButton(
                        label: AppConstants.loginButtonLabel,
                        onPressed: () {},
                        prefixIcon: Icons.login_rounded,
                      ),

                      const SizedBox(height: 40),

                      // ── Sign-up prompt ────────────────────────────────
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
  }

  // Widget for the sign-up prompt with tappable "Sign Up" text
  Center _signupWidget(ThemeData theme, BuildContext context) {
    return Center(
                      child: RichText(
                        text: TextSpan(
                          text: AppConstants.noAccountPrompt,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color:
                                theme.colorScheme.onSurface.withAlpha(160),
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

// ── Helpers ───────────────────────────────────────────────────────────────────

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.onSurface.withAlpha(40),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 22,
              color: theme.colorScheme.onSurface.withAlpha(200),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.onSurface.withAlpha(200),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
