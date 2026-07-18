import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/entities/auth_exceptions.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/repositories/auth_repo.dart';
import '../model/auth_user_model.dart';
import '../remote/firebase_auth_remote.dart';

class AuthRepoImpl implements AuthRepo {
  AuthRepoImpl({required FirebaseAuthRemote firebaseAuthRemote})
    : _firebaseAuthRemote = firebaseAuthRemote;

  final FirebaseAuthRemote _firebaseAuthRemote;

  @override
  AuthUser? get currentUser {
    final User? user = _firebaseAuthRemote.currentUser;
    return user == null
        ? null
        : AuthUserModel.fromFirebaseUser(user).toAuthUser();
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _firebaseAuthRemote.authStateChanges.map(
      (User? user) => user == null
          ? null
          : AuthUserModel.fromFirebaseUser(user).toAuthUser(),
    );
  }

  @override
  bool get isAuthenticated => _firebaseAuthRemote.isAuthenticated;

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuthRemote.signIn(
        email: email,
        password: password,
      );
      return AuthUserModel.fromFirebaseUser(credential.user!).toAuthUser();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const AuthUnknownException();
    }
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final UserCredential credential = await _firebaseAuthRemote.signUp(
        email: email,
        password: password,
      );
      return AuthUserModel.fromFirebaseUser(credential.user!).toAuthUser();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const AuthUnknownException();
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    try {
      final UserCredential credential = await _firebaseAuthRemote
          .signInWithGoogle();
      return AuthUserModel.fromFirebaseUser(credential.user!).toAuthUser();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const AuthUnknownException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuthRemote.signOut();
    } on FirebaseAuthException catch (e) {
      throw _mapFirebaseAuthException(e);
    } catch (e) {
      throw const AuthUnknownException();
    }
  }

  AuthException _mapFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return const AuthUserNotFoundException();
      case 'wrong-password':
        return const AuthWrongPasswordException();
      case 'email-already-in-use':
        return const AuthEmailAlreadyInUseException();
      case 'weak-password':
        return const AuthWeakPasswordException();
      case 'invalid-email':
        return const AuthInvalidEmailException();
      case 'invalid-credential':
        return const AuthInvalidCredentialsException();
      case 'permission-denied':
        return const AuthPermissionDeniedException();
      default:
        return const AuthUnknownException();
    }
  }
}
