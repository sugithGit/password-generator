import 'dart:convert';
import 'dart:typed_data';
import 'package:sodium/sodium.dart';

class EncryptionLocal {
  EncryptionLocal({required Sodium sodium}) : _sodium = sodium;

  final Sodium _sodium;

  SecureKey deriveKey({required String uid, required String masterKey}) {
    final String combined = '$uid:$masterKey';
    final Uint8List seed = Uint8List.fromList(utf8.encode(combined));

    final Uint8List hash = _sodium.crypto.genericHash.call(
      message: seed,
      outLen: _sodium.crypto.secretBox.keyBytes,
    );

    return _sodium.secureCopy(hash);
  }

  String encrypt({required String plainText, required SecureKey key}) {
    final Uint8List messageBytes = Uint8List.fromList(utf8.encode(plainText));

    final Uint8List nonce = _sodium.randombytes.buf(
      _sodium.crypto.secretBox.nonceBytes,
    );

    final Uint8List cipherText = _sodium.crypto.secretBox.easy(
      message: messageBytes,
      nonce: nonce,
      key: key,
    );

    final Uint8List combined = Uint8List(nonce.length + cipherText.length)
      ..setAll(0, nonce)
      ..setAll(nonce.length, cipherText);

    return base64Encode(combined);
  }

  String decrypt({required String cipherText, required SecureKey key}) {
    final Uint8List combined = base64Decode(cipherText);
    final int nonceLength = _sodium.crypto.secretBox.nonceBytes;

    final Uint8List nonce = combined.sublist(0, nonceLength);
    final Uint8List encrypted = combined.sublist(nonceLength);

    final Uint8List decrypted = _sodium.crypto.secretBox.openEasy(
      cipherText: encrypted,
      nonce: nonce,
      key: key,
    );

    return utf8.decode(decrypted);
  }

  String createVerificationHash({
    required String uid,
    required String masterKey,
  }) {
    final String verificationPlaintext = 'VAULT_KEY_VERIFY:$uid';
    final SecureKey key = deriveKey(uid: uid, masterKey: masterKey);
    try {
      return encrypt(plainText: verificationPlaintext, key: key);
    } finally {
      key.dispose();
    }
  }

  bool verifyMasterKey({
    required String uid,
    required String masterKey,
    required String storedVerificationHash,
  }) {
    final SecureKey key = deriveKey(uid: uid, masterKey: masterKey);
    try {
      final String decrypted = decrypt(
        cipherText: storedVerificationHash,
        key: key,
      );
      return decrypted == 'VAULT_KEY_VERIFY:$uid';
    } on Exception catch (_) {
      return false;
    } finally {
      key.dispose();
    }
  }
}
