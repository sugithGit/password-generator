import 'package:cloud_firestore/cloud_firestore.dart';

class MasterKeyRemoteDatasource {
  MasterKeyRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('m_key');

  Future<void> saveMasterKeyData({
    required String uid,
    required String encryptedMasterKey,
    required String salt,
  }) async {
    await _collection.doc(uid).set({
      'encryptedKey': encryptedMasterKey,
      'salt': salt,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, String>?> getMasterKeyData({required String uid}) async {
    final doc = await _collection.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      final data = doc.data()!;
      if (data.containsKey('encryptedKey') && data.containsKey('salt')) {
        return {
          'encryptedKey': data['encryptedKey'] as String,
          'salt': data['salt'] as String,
        };
      }
    }
    return null;
  }
}
