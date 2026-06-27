import 'package:sodium/sodium.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class DecryptParams {
  const DecryptParams({required this.cipherText, required this.key});
  final String cipherText;
  final SecureKey key;
}

class DecryptUseCase implements UseCase<String, DecryptParams> {
  DecryptUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  String call(DecryptParams params) {
    return encryptionRepo.decrypt(
      cipherText: params.cipherText,
      key: params.key,
    );
  }
}
