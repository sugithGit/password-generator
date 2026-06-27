part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class AuthCheckRequested extends AuthEvent {}

class SignInRequested extends AuthEvent {
  const SignInRequested({required this.email, required this.password});
  final String email;
  final String password;
}

class SignUpRequested extends AuthEvent {
  const SignUpRequested({required this.email, required this.password});
  final String email;
  final String password;
}

class SignOutRequested extends AuthEvent {}
