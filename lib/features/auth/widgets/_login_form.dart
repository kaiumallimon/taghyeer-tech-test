import 'package:flutter/material.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/shared/widgets/_custom_button.dart';
import 'package:taghyeer_test/shared/widgets/_custom_snackbar.dart';
import 'package:taghyeer_test/shared/widgets/_custom_textfield.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    super.key,
    required this.usernameController,
    required this.passwordController,
    required this.isLoading,
    required this.onLoginPressed,
  });

  final TextEditingController usernameController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onLoginPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          hint: AppConstants.userNameHint,
          label: AppConstants.userNameLabel,
          controller: usernameController,
          keyboardType: TextInputType.text,
          prefixIcon: Icons.person_outline_rounded,
        ),

        const SizedBox(height: 20),

        CustomTextField(
          hint: AppConstants.passwordHint,
          label: AppConstants.passwordLabel,
          controller: passwordController,
          isPassword: true,
          prefixIcon: Icons.lock_outline_rounded,
        ),

        const SizedBox(height: 12),

        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () =>
                CustomSnackbar.show(context, message: 'Not implemented yet'),
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

        CustomButton(
          label: AppConstants.loginButtonLabel,
          onPressed: isLoading ? null : onLoginPressed,
          isLoading: isLoading,
          prefixIcon: Icons.login_rounded,
        ),
      ],
    );
  }
}
