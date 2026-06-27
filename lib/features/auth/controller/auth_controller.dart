import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuthException;
import 'package:rxget/rxget.dart';

import '../../../service/auth/domain/entities/auth_user.dart';
import '../../../service/auth/domain/use_cases/get_current_user_use_case.dart';
import '../../../service/auth/domain/use_cases/sign_in_use_case.dart';
import '../../../service/auth/domain/use_cases/sign_out_use_case.dart';
import '../../../service/auth/domain/use_cases/sign_up_use_case.dart';

part 'auth_state.dart';

class AuthController extends GetxController<AuthState> {
  AuthController({
    required this.getCurrentUserUseCase,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
  }) : state = AuthState();

  final GetCurrentUserUseCase getCurrentUserUseCase;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;

  @override
  final AuthState state;

  void checkAuth() => _checkAuth();
  Future<void> signIn({required String email, required String password}) => _signIn(email, password);
  Future<void> signUp({required String email, required String password}) => _signUp(email, password);
  Future<void> signOut() => _signOut();

  void _checkAuth() {
    final AuthUser? user = getCurrentUserUseCase.call(null);
    state._user.value = user;
  }

  Future<void> _signIn(String email, String password) async {
    state._isLoading.value = true;
    state._error.value = null;
    try {
      final AuthUser user = await signInUseCase.call(
        SignInParams(email: email, password: password),
      );
      state._user.value = user;
    } on FirebaseAuthException catch (e) {
      final String parsedError = _parseAuthError(e.code);
      state._error.value = parsedError;
      state._user.value = null;
      throw Exception(parsedError);
    } catch (e) {
      final String errorMsg = e.toString();
      state._error.value = errorMsg;
      state._user.value = null;
      throw Exception(errorMsg);
    } finally {
      state._isLoading.value = false;
    }
  }

  Future<void> _signUp(String email, String password) async {
    state._isLoading.value = true;
    state._error.value = null;
    try {
      final AuthUser user = await signUpUseCase.call(
        SignUpParams(email: email, password: password),
      );
      state._user.value = user;
    } on FirebaseAuthException catch (e) {
      final String parsedError = _parseAuthError(e.code);
      state._error.value = parsedError;
      state._user.value = null;
      throw Exception(parsedError);
    } catch (e) {
      final String errorMsg = e.toString();
      state._error.value = errorMsg;
      state._user.value = null;
      throw Exception(errorMsg);
    } finally {
      state._isLoading.value = false;
    }
  }

  Future<void> _signOut() async {
    await signOutUseCase.call(null);
    state._user.value = null;
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
