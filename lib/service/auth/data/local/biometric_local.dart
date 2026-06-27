import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';

class BiometricLocal {
  BiometricLocal({LocalAuthentication? localAuth})
      : _localAuth = localAuth ?? LocalAuthentication();

  final LocalAuthentication _localAuth;

  Future<bool> isDeviceSupported() async {
    return _localAuth.isDeviceSupported();
  }

  Future<bool> canCheckBiometrics() async {
    return _localAuth.canCheckBiometrics;
  }

  Future<bool> authenticate({
    String reason = 'Authenticate to access your Password Vault',
  }) async {
    try {
      return await _localAuth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          stickyAuth: true,
        ),
      );
    } on FirebaseAuthException catch (_) {
      return false;
    }
  }
}
