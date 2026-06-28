import 'dart:typed_data';

import 'package:sodium/sodium.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class DeriveKeyParams {
  const DeriveKeyParams({
    required this.masterKey,
    required this.salt,
  });
  final String masterKey;
  final Uint8List salt;
}

class DeriveKeyUseCase implements UseCase<SecureKey, DeriveKeyParams> {
  DeriveKeyUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  SecureKey call(DeriveKeyParams params) {
    return encryptionRepo.deriveKey(
      masterKey: params.masterKey,
      salt: params.salt,
    );
  }
}
