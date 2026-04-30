part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  Authenticated({required this.user});
  final User user;
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  AuthError({required this.message});
  final String message;
}
