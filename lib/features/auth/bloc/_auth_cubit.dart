import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/core/storage/_local_storage.dart';
import 'package:taghyeer_test/features/auth/repository/_auth_repository.dart';

part '_auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthInitial());

  // method for login
  Future<void> login({required String username, required String password}) async {
    emit(AuthLoading());
    try {
      final response = await repo.login(username: username, password: password);

      // Save tokens separately
      await LocalStorage.saveTokens(
        accessToken: response['accessToken'] as String,
        refreshToken: response['refreshToken'] as String,
      );

      // Save user profile without tokens
      final userProfile = Map<String, dynamic>.from(response)
        ..remove('accessToken')
        ..remove('refreshToken');
      await LocalStorage.saveUser(userProfile);

      emit(AuthLoggedIn(userProfile));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // method to check if user is already logged in
  Future<void> checkLogin() async {
    final token = LocalStorage.fetchAccessToken();
    if (token != null) {
      final userData = LocalStorage.fetchUser();
      emit(AuthLoggedIn(userData ?? {}));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // method for logout
  Future<void> logout() async {
    await LocalStorage.clearAll();
    emit(AuthUnauthenticated());
  }
}
