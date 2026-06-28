import 'dart:convert';
import 'dart:typed_data';
import 'package:sodium/sodium_sumo.dart';

class EncryptionLocal {
  EncryptionLocal({required SodiumSumo sodium}) : _sodium = sodium;

  final SodiumSumo _sodium;

  Uint8List generateSalt() {
    return _sodium.randombytes.buf(_sodium.crypto.pwhash.saltBytes);
  }

  SecureKey deriveKey({required String masterKey, required Uint8List salt}) {
    return _sodium.crypto.pwhash.call(
      outLen: _sodium.crypto.secretBox.keyBytes,
      password: Int8List.fromList(utf8.encode(masterKey)),
      salt: salt,
      opsLimit: _sodium.crypto.pwhash.opsLimitInteractive,
      memLimit: _sodium.crypto.pwhash.memLimitInteractive,
    );
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

  String encryptMasterKeyForSync({
    required String masterKey,
    required Uint8List salt,
  }) {
    final SecureKey key = deriveKey(masterKey: masterKey, salt: salt);
    try {
      return encrypt(plainText: masterKey, key: key);
    } finally {
      key.dispose();
    }
  }

  bool verifyEncryptedMasterKey({
    required String masterKey,
    required Uint8List salt,
    required String storedEncryptedMasterKey,
  }) {
    final SecureKey key = deriveKey(masterKey: masterKey, salt: salt);
    try {
      final String decrypted = decrypt(
        cipherText: storedEncryptedMasterKey,
        key: key,
      );
      return decrypted == masterKey;
    } on Exception catch (_) {
      return false;
    } finally {
      key.dispose();
    }
  }
}
