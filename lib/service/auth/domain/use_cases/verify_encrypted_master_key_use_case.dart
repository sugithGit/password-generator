import 'dart:typed_data';

import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class VerifyEncryptedMasterKeyParams {
  const VerifyEncryptedMasterKeyParams({
    required this.masterKey,
    required this.salt,
    required this.storedEncryptedMasterKey,
  });
  final String masterKey;
  final Uint8List salt;
  final String storedEncryptedMasterKey;
}

class VerifyEncryptedMasterKeyUseCase implements UseCase<bool, VerifyEncryptedMasterKeyParams> {
  VerifyEncryptedMasterKeyUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  bool call(VerifyEncryptedMasterKeyParams params) {
    return encryptionRepo.verifyEncryptedMasterKey(
      masterKey: params.masterKey,
      salt: params.salt,
      storedEncryptedMasterKey: params.storedEncryptedMasterKey,
    );
  }
}
