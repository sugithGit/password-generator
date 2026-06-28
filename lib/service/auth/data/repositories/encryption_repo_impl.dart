import 'dart:typed_data';

import 'package:sodium/sodium.dart';
import '../../domain/repositories/encryption_repo.dart';
import '../local/encryption_local.dart';

class EncryptionRepoImpl implements EncryptionRepo {
  EncryptionRepoImpl({required EncryptionLocal encryptionLocal})
    : _encryptionLocal = encryptionLocal;

  final EncryptionLocal _encryptionLocal;

  @override
  Uint8List generateSalt() {
    return _encryptionLocal.generateSalt();
  }

  @override
  SecureKey deriveKey({required String masterKey, required Uint8List salt}) {
    return _encryptionLocal.deriveKey(masterKey: masterKey, salt: salt);
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
    required String masterKey,
    required Uint8List salt,
  }) {
    return _encryptionLocal.encryptMasterKeyForSync(
      masterKey: masterKey,
      salt: salt,
    );
  }

  @override
  bool verifyEncryptedMasterKey({
    required String masterKey,
    required Uint8List salt,
    required String storedEncryptedMasterKey,
  }) {
    return _encryptionLocal.verifyEncryptedMasterKey(
      masterKey: masterKey,
      salt: salt,
      storedEncryptedMasterKey: storedEncryptedMasterKey,
    );
  }
}
