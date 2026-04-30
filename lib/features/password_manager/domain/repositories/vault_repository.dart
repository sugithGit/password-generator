import '../entities/vault_entry.dart';

abstract interface class VaultRepository {
  Stream<List<VaultEntry>> getEntries();
  Future<void> addEntry(VaultEntry entry);
  Future<void> updateEntry(VaultEntry entry);
  Future<void> deleteEntry(String entryId);
}
