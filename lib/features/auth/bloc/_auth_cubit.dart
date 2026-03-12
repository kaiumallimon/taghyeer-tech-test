import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:taghyeer_test/core/storage/_local_storage.dart';
import 'package:taghyeer_test/features/auth/repository/_auth_repository.dart';

part '_auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository repo;

  AuthCubit(this.repo) : super(AuthInitial());


  // method for login
  Future<void> login({required String username, required String password}) async {
    // emit loading state
    emit(AuthLoading());
    try {
      // fetch user data from repository
      final userData = await repo.login(username: username, password: password);

      // store in local storage
      await LocalStorage.saveUser(userData);

      // emit logged in state with user data
      emit(AuthLoggedIn(userData));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  // method to check if user is already logged in
  Future<void> checkLogin() async {
    final userData = await LocalStorage.fetchUser();

    if (userData != null) {
      emit(AuthLoggedIn(userData));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // method for logout
  Future<void> logout() async {
    await LocalStorage.clearUser();
    emit(AuthUnauthenticated());
  }
}
