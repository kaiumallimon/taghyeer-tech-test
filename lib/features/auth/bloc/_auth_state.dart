part of '_auth_cubit.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthUnauthenticated extends AuthState {}

class AuthLoggedIn extends AuthState {
  final Map<String, dynamic> userData;
  AuthLoggedIn(this.userData);
}

class AuthError extends AuthState {
  final String message;
  AuthError(this.message);
}