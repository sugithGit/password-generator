import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class EncryptMasterKeyForSyncParams {
  const EncryptMasterKeyForSyncParams({
    required this.uid,
    required this.masterKey,
  });
  final String uid;
  final String masterKey;
}

class EncryptMasterKeyForSyncUseCase
    implements UseCase<String, EncryptMasterKeyForSyncParams> {
  EncryptMasterKeyForSyncUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  String call(EncryptMasterKeyForSyncParams params) {
    return encryptionRepo.encryptMasterKeyForSync(
      uid: params.uid,
      masterKey: params.masterKey,
    );
  }
}
