abstract interface class MasterKeyRepo {
  Future<Map<String, String>?> getMasterKeyData(String uid);
  Future<void> saveMasterKeyData({
    required String uid,
    required String encryptedMasterKey,
    required String salt,
  });
  Future<String?> getLocalMasterKey(String uid);
  Future<void> saveLocalMasterKey({
    required String uid,
    required String masterKey,
  });
}
