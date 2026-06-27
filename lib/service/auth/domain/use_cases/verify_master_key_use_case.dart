import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class VerifyMasterKeyParams {
  const VerifyMasterKeyParams({
    required this.uid,
    required this.masterKey,
    required this.storedVerificationHash,
  });
  final String uid;
  final String masterKey;
  final String storedVerificationHash;
}

class VerifyMasterKeyUseCase implements UseCase<bool, VerifyMasterKeyParams> {
  VerifyMasterKeyUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  bool call(VerifyMasterKeyParams params) {
    return encryptionRepo.verifyMasterKey(
      uid: params.uid,
      masterKey: params.masterKey,
      storedVerificationHash: params.storedVerificationHash,
    );
  }
}
