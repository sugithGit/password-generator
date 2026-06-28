import 'dart:convert';
import 'dart:typed_data';

import 'package:rxget/rxget.dart';
import 'package:sodium/sodium.dart';

import '../../../../service/auth/data/local/biometric_local.dart';
import '../../../../service/auth/data/repositories/biometric_repo_impl.dart';
import '../../../../service/auth/domain/entities/auth_exceptions.dart';
import '../../../../service/auth/domain/entities/auth_user.dart';
import '../../../../service/auth/domain/repositories/auth_repo.dart';
import '../../../../service/auth/domain/repositories/biometric_repo.dart';
import '../../../../service/auth/domain/repositories/encryption_repo.dart';
import '../../../../service/auth/domain/repositories/master_key_repo.dart';
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
    required void Function() onRequiresMasterKeyCreation,
    required void Function() onRequiresMasterKeyInput,
    required void Function(String error) onAuthError,
  }) async {
    state._isAuthenticating.value = true;
    state._authFailed.value = false;

    final AuthRepo authRepo = Get.find<AuthRepo>();
    final MasterKeyRepo masterKeyRepo = Get.find<MasterKeyRepo>();

    final AuthUser? user = authRepo.currentUser;
    if (user == null) {
      state._isAuthenticating.value = false;
      return;
    }

    final String? masterKey = await masterKeyRepo.getLocalMasterKey(user.uid);

    if (masterKey != null) {
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
        onBiometricsSuccessWithKey(masterKey);
      }
    } else {
      try {
        final Map<String, String>? keyData = await masterKeyRepo
            .getMasterKeyData(user.uid);

        state._isAuthenticating.value = false;

        if (keyData == null) {
          onRequiresMasterKeyCreation();
        } else {
          onRequiresMasterKeyInput();
        }
      } on AuthPermissionDeniedException {
        state._isAuthenticating.value = false;
        await authRepo.signOut();
        onAuthError('Session expired or user deleted. Please log in again.');
      } on AuthException catch (e) {
        state._isAuthenticating.value = false;
        onAuthError(e.message);
      } catch (e) {
        state._isAuthenticating.value = false;
        onAuthError('An unexpected error occurred.');
      }
    }
  }

  Future<void> onMasterKeyValidated(
    String masterKey, {
    required void Function(VaultRepoImpl) onReady,
    required void Function(String error) onError,
  }) async {
    final AuthRepo authRepo = Get.find<AuthRepo>();
    final MasterKeyRepo masterKeyRepo = Get.find<MasterKeyRepo>();

    final AuthUser? user = authRepo.currentUser;
    if (user == null) {
      return;
    }

    final Map<String, String>? keyData = await masterKeyRepo.getMasterKeyData(
      user.uid,
    );

    if (keyData == null) {
      onError('Verification data not found.');
      return;
    }

    final Uint8List saltBytes = base64Decode(keyData['salt']!);

    // Derive the encryption key from master key and salt
    final EncryptionRepo encryptionRepo = Get.find<EncryptionRepo>();
    final SecureKey encryptionKey = encryptionRepo.deriveKey(
      masterKey: masterKey,
      salt: saltBytes,
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

  Future<void> checkIfNewUser({
    required void Function(String error) onAuthError,
  }) async {
    state._isLoading.value = true;
    final AuthRepo authRepo = Get.find<AuthRepo>();
    final MasterKeyRepo masterKeyRepo = Get.find<MasterKeyRepo>();

    final AuthUser? user = authRepo.currentUser;
    if (user == null) {
      state._isLoading.value = false;
      return;
    }

    try {
      final Map<String, String>? keyData = await masterKeyRepo.getMasterKeyData(
        user.uid,
      );
      state._isNewUser.value = keyData == null;
      state._isLoading.value = false;
    } on AuthPermissionDeniedException {
      await authRepo.signOut();
      onAuthError('Session expired or user deleted. Please log in again.');
    } on AuthException catch (e) {
      state._errorMessage.value = e.message;
      state._isLoading.value = false;
    } catch (e) {
      state._errorMessage.value = 'An unexpected error occurred.';
      state._isLoading.value = false;
    }
  }

  Future<void> submitMasterKey({
    required String masterKey,
    required void Function(String masterKey) onSuccess,
    required void Function(String error) onAuthError,
  }) async {
    state._isLoading.value = true;
    state._errorMessage.value = null;

    final AuthRepo authRepo = Get.find<AuthRepo>();
    final MasterKeyRepo masterKeyRepo = Get.find<MasterKeyRepo>();

    final AuthUser? user = authRepo.currentUser;
    if (user == null) {
      state._isLoading.value = false;
      return;
    }

    final EncryptionRepo encryptionRepo = Get.find<EncryptionRepo>();

    try {
      if (state.isNewUser) {
        // First time: generate salt and store encrypted master key
        final Uint8List saltBytes = encryptionRepo.generateSalt();
        final String saltBase64 = base64Encode(saltBytes);

        final String encryptedMasterKey = encryptionRepo
            .encryptMasterKeyForSync(masterKey: masterKey, salt: saltBytes);

        await masterKeyRepo.saveMasterKeyData(
          uid: user.uid,
          encryptedMasterKey: encryptedMasterKey,
          salt: saltBase64,
        );

        // Store in secure storage for biometrics
        await masterKeyRepo.saveLocalMasterKey(
          uid: user.uid,
          masterKey: masterKey,
        );

        onSuccess(masterKey);
      } else {
        // Returning user: validate master key
        final Map<String, String>? keyData = await masterKeyRepo
            .getMasterKeyData(user.uid);

        if (keyData == null) {
          state._errorMessage.value =
              'Verification data not found. Please contact support.';
          state._isLoading.value = false;
          return;
        }

        final String storedEncryptedMasterKey = keyData['encryptedKey']!;
        final Uint8List saltBytes = base64Decode(keyData['salt']!);

        final bool isValid = encryptionRepo.verifyEncryptedMasterKey(
          masterKey: masterKey,
          salt: saltBytes,
          storedEncryptedMasterKey: storedEncryptedMasterKey,
        );

        if (isValid) {
          // Store in secure storage for future biometrics
          await masterKeyRepo.saveLocalMasterKey(
            uid: user.uid,
            masterKey: masterKey,
          );

          onSuccess(masterKey);
        } else {
          state._errorMessage.value = 'Incorrect master key. Please try again.';
          state._isLoading.value = false;
        }
      }
    } on AuthPermissionDeniedException {
      await authRepo.signOut();
      onAuthError('Session expired or user deleted. Please log in again.');
    } on AuthException catch (e) {
      state._errorMessage.value = e.message;
      state._isLoading.value = false;
    } catch (e) {
      state._errorMessage.value = 'An unexpected error occurred.';
      state._isLoading.value = false;
    }
  }

  void toggleObscureMasterKey() {
    state._obscureMasterKey.value = !state.obscureMasterKey;
  }

  void toggleObscureConfirm() {
    state._obscureConfirm.value = !state.obscureConfirm;
  }
}
