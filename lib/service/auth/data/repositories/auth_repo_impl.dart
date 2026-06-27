import 'package:firebase_auth/firebase_auth.dart';

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
    final UserCredential credential = await _firebaseAuthRemote.signIn(
      email: email,
      password: password,
    );
    return AuthUserModel.fromFirebaseUser(credential.user!).toAuthUser();
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
  }) async {
    final UserCredential credential = await _firebaseAuthRemote.signUp(
      email: email,
      password: password,
    );
    return AuthUserModel.fromFirebaseUser(credential.user!).toAuthUser();
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuthRemote.signOut();
  }
}
