import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/core/constants/_app_theme.dart';
import 'package:taghyeer_test/core/network/_dio_client.dart';
import 'package:taghyeer_test/features/auth/bloc/_auth_cubit.dart';
import 'package:taghyeer_test/features/auth/repository/_auth_repository.dart';
import 'package:taghyeer_test/features/splash/pages/_splash_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<DioClient>(
          create: (_) => DioClient(),
        ),
        RepositoryProvider<AuthRepository>(
          create: (ctx) => AuthRepository(ctx.read<DioClient>()),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>(
            create: (ctx) => AuthCubit(ctx.read<AuthRepository>()),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.system,
          home: const SplashPage(),
        ),
      ),
    );
  }
}