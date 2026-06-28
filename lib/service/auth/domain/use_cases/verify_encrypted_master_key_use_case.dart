import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class VerifyEncryptedMasterKeyParams {
  const VerifyEncryptedMasterKeyParams({
    required this.uid,
    required this.masterKey,
    required this.storedEncryptedMasterKey,
  });
  final String uid;
  final String masterKey;
  final String storedEncryptedMasterKey;
}

class VerifyEncryptedMasterKeyUseCase implements UseCase<bool, VerifyEncryptedMasterKeyParams> {
  VerifyEncryptedMasterKeyUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  bool call(VerifyEncryptedMasterKeyParams params) {
    return encryptionRepo.verifyEncryptedMasterKey(
      uid: params.uid,
      masterKey: params.masterKey,
      storedEncryptedMasterKey: params.storedEncryptedMasterKey,
    );
  }
}
