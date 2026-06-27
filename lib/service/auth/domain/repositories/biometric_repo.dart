abstract interface class BiometricRepo {
  Future<bool> isDeviceSupported();
  Future<bool> canCheckBiometrics();
  Future<bool> authenticate({
    String reason = 'Authenticate to access your Password Vault',
  });
}
