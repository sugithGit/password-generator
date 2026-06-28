import 'package:sodium/sodium.dart';
import '../../domain/repositories/encryption_repo.dart';
import '../local/encryption_local.dart';

class EncryptionRepoImpl implements EncryptionRepo {
  EncryptionRepoImpl({required EncryptionLocal encryptionLocal})
    : _encryptionLocal = encryptionLocal;

  final EncryptionLocal _encryptionLocal;

  @override
  SecureKey deriveKey({required String uid, required String masterKey}) {
    return _encryptionLocal.deriveKey(uid: uid, masterKey: masterKey);
  }

  @override
  String encrypt({required String plainText, required SecureKey key}) {
    return _encryptionLocal.encrypt(plainText: plainText, key: key);
  }

  @override
  String decrypt({required String cipherText, required SecureKey key}) {
    return _encryptionLocal.decrypt(cipherText: cipherText, key: key);
  }

  @override
  String encryptMasterKeyForSync({
    required String uid,
    required String masterKey,
  }) {
    return _encryptionLocal.encryptMasterKeyForSync(
      uid: uid,
      masterKey: masterKey,
    );
  }

  @override
  bool verifyEncryptedMasterKey({
    required String uid,
    required String masterKey,
    required String storedEncryptedMasterKey,
  }) {
    return _encryptionLocal.verifyEncryptedMasterKey(
      uid: uid,
      masterKey: masterKey,
      storedEncryptedMasterKey: storedEncryptedMasterKey,
    );
  }
}
