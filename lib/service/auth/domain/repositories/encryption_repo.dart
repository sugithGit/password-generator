import 'package:sodium/sodium.dart';

abstract interface class EncryptionRepo {
  SecureKey deriveKey({required String uid, required String masterKey});

  String encrypt({required String plainText, required SecureKey key});

  String decrypt({required String cipherText, required SecureKey key});

  String encryptMasterKeyForSync({
    required String uid,
    required String masterKey,
  });

  bool verifyEncryptedMasterKey({
    required String uid,
    required String masterKey,
    required String storedEncryptedMasterKey,
  });
}
