import 'package:cloud_firestore/cloud_firestore.dart';

class MasterKeyRemoteDatasource {
  MasterKeyRemoteDatasource({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('m_key');

  Future<void> saveEncryptedMasterKey({
    required String uid,
    required String encryptedMasterKey,
  }) async {
    await _collection.doc(uid).set({
      'encryptedKey': encryptedMasterKey,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<String?> getEncryptedMasterKey({required String uid}) async {
    final doc = await _collection.doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return doc.data()!['encryptedKey'] as String?;
    }
    return null;
  }
}
