import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../service/auth/domain/entities/auth_user.dart';
import '../../../service/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../../service/auth/domain/use_cases/sign_in_use_case.dart';
import '../../../service/auth/domain/use_cases/sign_out_use_case.dart';
import '../../../service/auth/domain/use_cases/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required this.getCurrentUserUseCase,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheck);
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
  }

  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  Future<void> _onAuthCheck(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    final AuthUser? user = getCurrentUserUseCase.call(null);
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
      final AuthUser user = await signInUseCase.call(
        SignInParams(email: event.email, password: event.password),
      );
      emit(Authenticated(user: user));
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
      final AuthUser user = await signUpUseCase.call(
        SignUpParams(email: event.email, password: event.password),
      );
      emit(Authenticated(user: user));
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
    await signOutUseCase.call(null);
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
