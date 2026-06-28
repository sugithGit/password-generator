import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:rxget/rxget.dart';
import 'package:sodium/sodium.dart';

import '../../../../service/auth/data/local/biometric_local.dart';
import '../../../../service/auth/data/repositories/biometric_repo_impl.dart';
import '../../../../service/auth/domain/repositories/biometric_repo.dart';
import '../../../../service/auth/domain/repositories/encryption_repo.dart';
import '../../../../service/auth/domain/use_cases/authenticate_biometrics_use_case.dart';
import '../../../../service/auth/domain/use_cases/check_biometrics_support_use_case.dart';
import '../../../../service/password_manager/data/remote/vault_remote_datasource.dart';
import '../../../../service/password_manager/data/repositories/vault_repo_impl.dart';

part 'gateway_state.dart';

class GatewayController extends GetxController<_GatewayState> {
  GatewayController() : state = _GatewayState();

  @override
  final _GatewayState state;

  late final BiometricRepo _biometricRepo;
  late final CheckBiometricsSupportUseCase _checkBiometricsSupportUseCase;
  late final AuthenticateBiometricsUseCase _authenticateBiometricsUseCase;

  @override
  void onInit() {
    super.onInit();
    _biometricRepo = BiometricRepoImpl(biometricLocal: BiometricLocal());
    _checkBiometricsSupportUseCase = CheckBiometricsSupportUseCase(
      _biometricRepo,
    );
    _authenticateBiometricsUseCase = AuthenticateBiometricsUseCase(
      _biometricRepo,
    );
  }

  Future<void> authenticate({
    required void Function() onBiometricsUnsupported,
    required void Function(String masterKey) onBiometricsSuccessWithKey,
    required void Function() onBiometricsSuccessWithoutKey,
  }) async {
    state._isAuthenticating.value = true;
    state._authFailed.value = false;

    final bool isSupported = await _checkBiometricsSupportUseCase.call(null);

    if (!isSupported) {
      state._isAuthenticating.value = false;
      onBiometricsUnsupported();
      return;
    }

    final bool success = await _authenticateBiometricsUseCase.call(
      'Authenticate to access your Password Vault',
    );

    state._isAuthenticating.value = false;
    state._authFailed.value = !success;

    if (success) {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        const FlutterSecureStorage storage = FlutterSecureStorage();
        final String? masterKey = await storage.read(key: 'master_key_${user.uid}');
        if (masterKey != null) {
          onBiometricsSuccessWithKey(masterKey);
          return;
        }
      }
      onBiometricsSuccessWithoutKey();
    }
  }

  void onMasterKeyValidated(
    String masterKey, {
    required void Function(VaultRepoImpl) onReady,
  }) {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    // Derive the encryption key from UID + master key
    final EncryptionRepo encryptionRepo = Get.find<EncryptionRepo>();
    final SecureKey encryptionKey = encryptionRepo.deriveKey(
      uid: user.uid,
      masterKey: masterKey,
    );

    final VaultRemoteDatasource datasource = VaultRemoteDatasource(
      userId: user.uid,
    );
    final VaultRepoImpl repository = VaultRepoImpl(
      remoteDatasource: datasource,
      encryptionRepo: encryptionRepo,
      encryptionKey: encryptionKey,
    );

    onReady(repository);
  }
}
