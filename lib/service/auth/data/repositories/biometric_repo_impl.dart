import '../../domain/repositories/biometric_repo.dart';
import '../local/biometric_local.dart';

class BiometricRepoImpl implements BiometricRepo {
  BiometricRepoImpl({required BiometricLocal biometricLocal})
      : _biometricLocal = biometricLocal;

  final BiometricLocal _biometricLocal;

  @override
  Future<bool> isDeviceSupported() {
    return _biometricLocal.isDeviceSupported();
  }

  @override
  Future<bool> canCheckBiometrics() {
    return _biometricLocal.canCheckBiometrics();
  }

  @override
  Future<bool> authenticate({
    String reason = 'Authenticate to access your Password Vault',
  }) {
    return _biometricLocal.authenticate(reason: reason);
  }
}
