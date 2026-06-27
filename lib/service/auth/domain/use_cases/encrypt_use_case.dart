import 'package:sodium/sodium.dart';
import '../../../../core/use_case/use_case.dart';
import '../repositories/encryption_repo.dart';

class EncryptParams {
  const EncryptParams({required this.plainText, required this.key});
  final String plainText;
  final SecureKey key;
}

class EncryptUseCase implements UseCase<String, EncryptParams> {
  EncryptUseCase(this.encryptionRepo);
  final EncryptionRepo encryptionRepo;

  @override
  String call(EncryptParams params) {
    return encryptionRepo.encrypt(plainText: params.plainText, key: params.key);
  }
}
