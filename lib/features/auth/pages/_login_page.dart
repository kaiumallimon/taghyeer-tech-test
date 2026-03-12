import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';
import 'package:taghyeer_test/features/auth/widgets/_login_background.dart';
import 'package:taghyeer_test/features/auth/widgets/_login_footer.dart';
import 'package:taghyeer_test/features/auth/widgets/_login_form.dart';
import 'package:taghyeer_test/features/auth/widgets/_login_header.dart';
import 'package:taghyeer_test/features/dashboard/_wrapper.dart';
import 'package:taghyeer_test/shared/widgets/_custom_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    final username = _usernameController.text.trim();
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
        final theme = Theme.of(context);

        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          body: Stack(
            children: [
              const LoginBackground(),
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
                          const LoginHeader(),
                          const SizedBox(height: 48),
                          LoginForm(
                            usernameController: _usernameController,
                            passwordController: _passwordController,
                            isLoading: isLoading,
                            onLoginPressed: _onLoginPressed,
                          ),
                          const SizedBox(height: 40),
                          const LoginFooter(),
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
}
