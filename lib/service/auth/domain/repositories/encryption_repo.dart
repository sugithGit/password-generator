import 'dart:typed_data';

import 'package:sodium/sodium.dart';

abstract interface class EncryptionRepo {
  Uint8List generateSalt();

  SecureKey deriveKey({required String masterKey, required Uint8List salt});

  String encrypt({required String plainText, required SecureKey key});

  String decrypt({required String cipherText, required SecureKey key});

  String encryptMasterKeyForSync({
    required String masterKey,
    required Uint8List salt,
  });

  bool verifyEncryptedMasterKey({
    required String masterKey,
    required Uint8List salt,
    required String storedEncryptedMasterKey,
  });
}
