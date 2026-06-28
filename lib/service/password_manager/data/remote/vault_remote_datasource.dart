import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/vault_entry_model.dart';

class VaultRemoteDatasource {
  VaultRemoteDatasource({required String userId, FirebaseFirestore? firestore})
    : _userId = userId,
      _firestore = firestore ?? FirebaseFirestore.instance;

  final String _userId;
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection {
    final String reversedUserId = _userId.split('').reversed.join();
    return _firestore
        .collection('vault')
        .doc(reversedUserId)
        .collection('entries');
  }

  Stream<List<VaultEntryModel>> getEntries() {
    return _collection.orderBy('updatedAt', descending: true).snapshots().map((
      QuerySnapshot<Map<String, dynamic>> snapshot,
    ) {
      return snapshot.docs.map((
        QueryDocumentSnapshot<Map<String, dynamic>> doc,
      ) {
        return VaultEntryModel.fromMap(doc.data(), doc.id);
      }).toList();
    });
  }

  Future<void> addEntry(VaultEntryModel entry) async {
    await _collection.doc(entry.id).set(entry.toMap());
  }

  Future<void> updateEntry(VaultEntryModel entry) async {
    await _collection.doc(entry.id).update(entry.toMap());
  }

  Future<void> deleteEntry(String entryId) async {
    await _collection.doc(entryId).delete();
  }
}
