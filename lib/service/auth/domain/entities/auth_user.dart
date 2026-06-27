import 'package:equatable/equatable.dart';

class AuthUser with EquatableMixin {
  const AuthUser({
    required this.uid,
    this.email,
  });

  final String uid;
  final String? email;

  @override
  List<Object?> get props => <Object?>[uid, email];

  @override
  String toString() {
    return 'AuthUser(uid: $uid, email: $email)';
  }
}
