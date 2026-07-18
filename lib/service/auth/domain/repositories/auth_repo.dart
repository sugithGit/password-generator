import '../entities/auth_user.dart';

abstract interface class AuthRepo {
  AuthUser? get currentUser;
  Stream<AuthUser?> get authStateChanges;
  bool get isAuthenticated;

  Future<AuthUser> signIn({required String email, required String password});

  Future<AuthUser> signUp({required String email, required String password});

  Future<AuthUser> signInWithGoogle();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);

  Future<void> deleteAccount();
}
