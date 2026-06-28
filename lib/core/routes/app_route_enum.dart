enum AppRouteEnum {
  splash('/splash'),
  loading('/loading'),
  login('/login'),
  masterKey('/master-key'),
  vault('/vault'),
  biometricGate('/biometric-gate'),
  addEntry('/add-entry'),
  viewPassword('/view-password'),
  passwordGenerate('/password-generate');

  const AppRouteEnum(this.path);
  final String path;
}
