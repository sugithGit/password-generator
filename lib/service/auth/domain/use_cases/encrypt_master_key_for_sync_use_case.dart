import 'dart:typed_data';

import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class EncryptMasterKeyForSyncParams {
  const EncryptMasterKeyForSyncParams({
    required this.masterKey,
    required this.salt,
  });
  final String masterKey;
  final Uint8List salt;
}

class EncryptMasterKeyForSyncUseCase
    implements UseCase<String, EncryptMasterKeyForSyncParams> {
  EncryptMasterKeyForSyncUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  String call(EncryptMasterKeyForSyncParams params) {
    return encryptionRepo.encryptMasterKeyForSync(
      masterKey: params.masterKey,
      salt: params.salt,
    );
  }
}
