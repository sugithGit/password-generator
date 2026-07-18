import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthRemote {
  FirebaseAuthRemote({FirebaseAuth? firebaseAuth, GoogleSignIn? googleSignIn})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  bool get isAuthenticated => currentUser != null;

  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signUp({
    required String email,
    required String password,
  }) async {
    return _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.authenticate();
    final GoogleSignInAuthentication googleAuth = googleUser.authentication;
    final String? idToken = googleAuth.idToken;
    if (idToken == null) {
      throw Exception('Failed to obtain Google ID Token');
    }
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: idToken,
    );
    return _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await Future.wait(
      <Future<void>>[
        _firebaseAuth.signOut(),
        _googleSignIn.signOut(),
      ].map((future) => future.catchError((_) {})),
    );
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> deleteAccount() async {
    await currentUser?.delete();
  }
}
