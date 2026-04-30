import 'dart:convert';
import 'dart:typed_data';

import 'package:sodium/sodium.dart';

/// Zero-knowledge encryption service using libsodium's SecretBox.
///
/// Key derivation: SHA-256(firebaseUID + userMasterKey) → 32-byte SecretBox key.
/// All data is encrypted with XSalsa20-Poly1305 (authenticated encryption).
///
/// Two keys are required:
///  1. Firebase Auth UID (obtained after login)
///  2. User's master key (stored physically by the user — if lost, data is unrecoverable)
class EncryptionService {
  EncryptionService({required Sodium sodium}) : _sodium = sodium;

  final Sodium _sodium;

  /// Derives a deterministic 32-byte SecretBox key from the user's UID and master key.
  /// Both components are required — losing either means data cannot be decrypted.
  SecureKey deriveKey({
    required String uid,
    required String masterKey,
  }) {
    // Combine UID + masterKey into a single seed
    final String combined = '$uid:$masterKey';
    final Uint8List seed =
        Uint8List.fromList(utf8.encode(combined));

    // Use generic hash (Blake2b) to produce exactly keyBytes (32) bytes
    final Uint8List hash = _sodium.crypto.genericHash.call(
      message: seed,
      outLen: _sodium.crypto.secretBox.keyBytes,
    );

    // Wrap in a SecureKey for safe memory handling
    return _sodium.secureCopy(hash);
  }

  /// Encrypts plaintext using SecretBox (XSalsa20-Poly1305).
  /// Returns a base64-encoded string containing nonce + ciphertext.
  String encrypt({
    required String plainText,
    required SecureKey key,
  }) {
    final Uint8List messageBytes = Uint8List.fromList(utf8.encode(plainText));

    // Generate a random nonce
    final Uint8List nonce = _sodium.randombytes.buf(
      _sodium.crypto.secretBox.nonceBytes,
    );

    // Encrypt with authenticated encryption
    final Uint8List cipherText = _sodium.crypto.secretBox.easy(
      message: messageBytes,
      nonce: nonce,
      key: key,
    );

    // Combine nonce + ciphertext for storage
    final Uint8List combined = Uint8List(nonce.length + cipherText.length)
      ..setAll(0, nonce)
      ..setAll(nonce.length, cipherText);

    return base64Encode(combined);
  }

  /// Decrypts a base64-encoded nonce+ciphertext string back to plaintext.
  String decrypt({
    required String cipherText,
    required SecureKey key,
  }) {
    final Uint8List combined = base64Decode(cipherText);
    final int nonceLength = _sodium.crypto.secretBox.nonceBytes;

    // Split nonce and ciphertext
    final Uint8List nonce = combined.sublist(0, nonceLength);
    final Uint8List encrypted = combined.sublist(nonceLength);

    final Uint8List decrypted = _sodium.crypto.secretBox.openEasy(
      cipherText: encrypted,
      nonce: nonce,
      key: key,
    );

    return utf8.decode(decrypted);
  }

  /// Creates a verification hash that can be stored in Firestore to later
  /// verify if the user entered the correct master key.
  /// This hash is NOT reversible — it only proves the key is correct.
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

  /// Validates if the user's master key is correct by attempting to decrypt
  /// the stored verification hash.
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
