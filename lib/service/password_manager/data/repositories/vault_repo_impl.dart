import 'package:sodium/sodium.dart';

import '../../../auth/domain/repositories/encryption_repo.dart';
import '../../domain/entities/vault_entry.dart';
import '../../domain/repositories/vault_repository.dart';
import '../model/vault_entry_model.dart';
import '../remote/vault_remote_datasource.dart';

/// Vault repository that encrypts ALL user data before storing to Firestore.
///
/// Zero-knowledge: Firestore only ever contains encrypted blobs.
/// Fields encrypted: title, username, password, website, notes.
/// Fields NOT encrypted: id, category, createdAt, updatedAt (metadata only).
class VaultRepoImpl implements VaultRepository {
  VaultRepoImpl({
    required this.remoteDatasource,
    required this.encryptionRepo,
    required this.encryptionKey,
  });

  final VaultRemoteDatasource remoteDatasource;
  final EncryptionRepo encryptionRepo;
  final SecureKey encryptionKey;

  @override
  Stream<List<VaultEntry>> getEntries() {
    return remoteDatasource.getEntries().map((List<VaultEntryModel> models) {
      return models.map((VaultEntryModel m) {
        // Decrypt all fields from Firestore
        return VaultEntry(
          id: m.id,
          title: _decryptField(m.title),
          username: m.username != null ? _decryptField(m.username!) : null,
          encryptedPassword: _decryptField(m.encryptedPassword),
          website: m.website != null ? _decryptField(m.website!) : null,
          notes: m.notes != null ? _decryptField(m.notes!) : null,
          category: VaultCategory.values.firstWhere(
            (VaultCategory c) => c.name == m.category,
            orElse: () => VaultCategory.other,
          ),
          createdAt: m.createdAt,
          updatedAt: m.updatedAt,
        );
      }).toList();
    });
  }

  @override
  Future<void> addEntry(VaultEntry entry) async {
    // Encrypt all sensitive fields before storing
    final VaultEntryModel model = VaultEntryModel(
      id: entry.id,
      title: _encryptField(entry.title),
      username: entry.username != null ? _encryptField(entry.username!) : null,
      encryptedPassword: _encryptField(entry.encryptedPassword),
      website: entry.website != null ? _encryptField(entry.website!) : null,
      notes: entry.notes != null ? _encryptField(entry.notes!) : null,
      category: entry.category.name,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
    await remoteDatasource.addEntry(model);
  }

  @override
  Future<void> updateEntry(VaultEntry entry) async {
    final VaultEntryModel model = VaultEntryModel(
      id: entry.id,
      title: _encryptField(entry.title),
      username: entry.username != null ? _encryptField(entry.username!) : null,
      encryptedPassword: _encryptField(entry.encryptedPassword),
      website: entry.website != null ? _encryptField(entry.website!) : null,
      notes: entry.notes != null ? _encryptField(entry.notes!) : null,
      category: entry.category.name,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
    await remoteDatasource.updateEntry(model);
  }

  @override
  Future<void> deleteEntry(String entryId) async {
    await remoteDatasource.deleteEntry(entryId);
  }

  String _encryptField(String plainText) {
    return encryptionRepo.encrypt(plainText: plainText, key: encryptionKey);
  }

  String _decryptField(String cipherText) {
    return encryptionRepo.decrypt(cipherText: cipherText, key: encryptionKey);
  }
}
