import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class CreateVerificationHashParams {
  const CreateVerificationHashParams({
    required this.uid,
    required this.masterKey,
  });
  final String uid;
  final String masterKey;
}

class CreateVerificationHashUseCase
    implements UseCase<String, CreateVerificationHashParams> {
  CreateVerificationHashUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  String call(CreateVerificationHashParams params) {
    return encryptionRepo.createVerificationHash(
      uid: params.uid,
      masterKey: params.masterKey,
    );
  }
}
