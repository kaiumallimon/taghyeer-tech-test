import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    Future.delayed(const Duration(seconds: 2), () {
      if (context.mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => page));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: colors.surface,
      systemNavigationBarIconBrightness: isDark
          ? Brightness.light
          : Brightness.dark,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthLoggedIn) {
            _navigate(const DashboardWrapper());
          }

          if (state is AuthUnauthenticated) {
            _navigate(const LoginPage());
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary.withAlpha(20), colors.surface],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Column(
                children: [
                  const Spacer(),

                  _buildLogo(theme),

                  const SizedBox(height: 24),

                  _buildTitle(theme),

                  const Spacer(),

                  _buildLoading(colors),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(ThemeData theme) {
    return Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withAlpha(80),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(Icons.tag, color: theme.colorScheme.onPrimary, size: 42),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Column(
      children: [
        Text(
          AppConstants.appName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(ColorScheme colors) {
    return Column(
      children: [
        CupertinoActivityIndicator(color: colors.primary),

        const SizedBox(height: 12),

        Text(
          "Please wait...",
          style: TextStyle(
            color: colors.onSurface.withAlpha(160),
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
