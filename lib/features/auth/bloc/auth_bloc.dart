import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/auth/auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({required this.authService}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
  }

  final AuthService authService;

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final User? user = authService.currentUser;
    if (user != null) {
      emit(Authenticated(user: user));
    } else {
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignIn(
    SignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final UserCredential credential = await authService.signIn(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user: credential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _parseAuthError(e.code)));
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignUp(
    SignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final UserCredential credential = await authService.signUp(
        email: event.email,
        password: event.password,
      );
      emit(Authenticated(user: credential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthError(message: _parseAuthError(e.code)));
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(message: e.toString()));
      emit(Unauthenticated());
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await authService.signOut();
    emit(Unauthenticated());
  }

  String _parseAuthError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak.';
      case 'invalid-email':
        return 'Invalid email address.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}
