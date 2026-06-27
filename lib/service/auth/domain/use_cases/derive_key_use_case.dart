import 'package:sodium/sodium.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class DeriveKeyParams {
  const DeriveKeyParams({required this.uid, required this.masterKey});
  final String uid;
  final String masterKey;
}

class DeriveKeyUseCase implements UseCase<SecureKey, DeriveKeyParams> {
  DeriveKeyUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  SecureKey call(DeriveKeyParams params) {
    return encryptionRepo.deriveKey(uid: params.uid, masterKey: params.masterKey);
  }
}
