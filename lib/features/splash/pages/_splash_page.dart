import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/core/constants/_app_constants.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';
import 'package:taghyeer_test/features/auth/pages/_login_page.dart';
import 'package:taghyeer_test/features/dashboard/_wrapper.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthCubit>().checkLogin();
    });
  }

  void _navigate(Widget page) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoggedIn) {
          _navigate(const DashboardWrapper());
        } else if (state is AuthUnauthenticated) {
          _navigate(const LoginPage());
        }
      },
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        body: SafeArea(
          child: Stack(
            children: [
              _logoText(theme),
              _loadingIndicator(theme.colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Center _logoText(ThemeData theme) {
    return Center(
      child: Text(
        AppConstants.splashText,
        style: theme.textTheme.headlineMedium,
      ),
    );
  }

  Positioned _loadingIndicator(ColorScheme colorScheme) {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: CupertinoActivityIndicator(color: colorScheme.primary),
    );
  }
}
