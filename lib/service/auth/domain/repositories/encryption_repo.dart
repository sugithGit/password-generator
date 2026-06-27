import 'package:sodium/sodium.dart';

abstract interface class EncryptionRepo {
  SecureKey deriveKey({required String uid, required String masterKey});

  String encrypt({required String plainText, required SecureKey key});

  String decrypt({required String cipherText, required SecureKey key});

  String createVerificationHash({
    required String uid,
    required String masterKey,
  });

  bool verifyMasterKey({
    required String uid,
    required String masterKey,
    required String storedVerificationHash,
  });
}
