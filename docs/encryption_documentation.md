# Password Manager Encryption Architecture

This document outlines how data encryption, key derivation, and decryption are implemented in this password manager application. The system is designed with a **zero-knowledge** architecture, meaning that the server (Firestore) only ever sees encrypted blobs, and the keys to decrypt the data are never stored.

## 1. How Encryption Works

The encryption system is built on top of **libsodium** (via the `sodium` Dart package), which provides modern, secure, and easy-to-use cryptographic operations.

### Algorithm
The app uses libsodium's `SecretBox` API for symmetric-key authenticated encryption. Under the hood, this typically uses **XSalsa20** for encryption and **Poly1305** for authentication.

### The Encryption Process
When a `VaultEntry` is saved or updated in `VaultRepoImpl`, all sensitive fields are encrypted individually before being sent to Firestore. 
The fields that are encrypted include:
- `title`
- `username`
- `encryptedPassword` (the actual password)
- `website`
- `notes`

Non-sensitive metadata fields are left unencrypted so they can be queried or sorted if necessary:
- `id`
- `category`
- `createdAt`
- `updatedAt`

For each field encrypted (`EncryptionLocal.encrypt`):
1. The plaintext string is encoded to a UTF-8 byte array.
2. A **cryptographically secure random Nonce** (Number used ONCE) is generated for this specific encryption operation.
3. The `SecretBox.easy` method encrypts the data using the derived encryption key and the generated nonce.
4. The generated Nonce and the resulting Ciphertext are concatenated together `[Nonce bytes][Ciphertext bytes]`.
5. The combined byte array is then **Base64 encoded** into a string for safe storage in Firestore.

## 2. Where Are the Keys Stored?

**The encryption keys are NEVER stored on the disk or in the database.**

Instead, the key is dynamically derived in memory whenever the user unlocks their vault, and is kept securely in memory (using libsodium's `SecureKey` which prevents the key from being swapped to disk and securely wipes it from memory when disposed).

### Key Derivation
When the user enters their Master Password:
1. The user's Master Password and their unique User ID (`uid`) are concatenated in the format: `$uid:$masterKey`.
2. This combined string is converted into a seed byte array.
3. The seed is passed through libsodium's `genericHash` function (which implements the **BLAKE2b** hashing algorithm).
4. The output of this hash is exactly the required length to be used as a symmetric encryption key (`secretBox.keyBytes`).

### Master Key Verification
Since the master key isn't stored, the app needs a way to verify if the entered password is correct. 
When the vault is first set up, a verification hash is created:
1. The app takes a known plaintext string: `VAULT_KEY_VERIFY:$uid`.
2. It encrypts this string using the derived key.
3. The resulting ciphertext is stored in the database.

When the user attempts to log in, the app derives the key from their input and attempts to decrypt this stored verification hash. If it successfully decrypts back to `VAULT_KEY_VERIFY:$uid`, the Master Password is correct, and the derived key is kept in memory to decrypt the vault entries.

## 3. How Decryption Happens

Decryption is the exact inverse of the encryption process and happens dynamically when entries are fetched from Firestore (`VaultRepoImpl._decryptField`).

1. The Base64 encoded string is fetched from Firestore.
2. It is decoded back into a byte array.
3. Because the Nonce length is known and fixed (`secretBox.nonceBytes`), the byte array is split into two parts:
   - The **Nonce** (the first `n` bytes).
   - The **Ciphertext** (the remaining bytes).
4. The `SecretBox.openEasy` method is called with the Ciphertext, the extracted Nonce, and the in-memory derived `SecureKey`.
5. `SecretBox` simultaneously decrypts the data and verifies its authenticity (ensuring the data was not tampered with and was encrypted with the exact same key).
6. The resulting decrypted bytes are decoded from UTF-8 back into a plaintext string, which is then displayed in the UI.
