import 'package:firebase_auth/firebase_auth.dart' show User;
import '../../domain/entities/auth_user.dart';

class AuthUserModel {
  const AuthUserModel({required this.uid, this.email});

  final String uid;
  final String? email;

  static AuthUserModel fromFirebaseUser(User user) {
    return AuthUserModel(uid: user.uid, email: user.email);
  }

  AuthUser toAuthUser() {
    return AuthUser(uid: uid, email: email);
  }
}
