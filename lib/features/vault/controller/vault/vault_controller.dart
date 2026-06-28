import 'dart:async';
import 'package:rxget/rxget.dart';

import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../../../service/password_manager/domain/repositories/vault_repository.dart';

part 'vault_state.dart';

class VaultController extends GetxController<_VaultState> {
  VaultController({required this.repository}) : state = _VaultState();

  final VaultRepository repository;

  @override
  final _VaultState state;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  StreamSubscription<List<VaultEntry>>? _subscription;
  List<DecryptedVaultEntry> _allEntries = <DecryptedVaultEntry>[];

  void loadVault() => _loadVault();

  void searchEntries(String query) => _searchEntries(query);
  void filterByCategory(VaultCategory? category) => _filterByCategory(category);

  void _loadVault() {
    state._isLoading.value = true;
    state._error.value = null;
    _subscription?.cancel();
    _subscription = repository.getEntries().listen(
      (List<VaultEntry> entries) {
        _allEntries = entries.map((e) => DecryptedVaultEntry(
          decryptedTitle: repository.decryptField(e.title),
          entry: e,
        )).toList();
        _applyFilterAndSearch();
        state._isLoading.value = false;
      },
      onError: (Object error) {
        state._error.value = 'Failed to load vault: $error';
        state._isLoading.value = false;
      },
    );
  }

  void _searchEntries(String query) {
    state._searchQuery.value = query;
    _applyFilterAndSearch();
  }

  void _filterByCategory(VaultCategory? category) {
    state._selectedCategory.value = category;
    _applyFilterAndSearch();
  }

  void _applyFilterAndSearch() {
    List<DecryptedVaultEntry> filtered = _allEntries;

    final VaultCategory? category = state.selectedCategory;
    if (category != null) {
      filtered = filtered
          .where((DecryptedVaultEntry e) => e.entry.category == category)
          .toList();
    }

    final String? query = state.searchQuery;
    if (query != null && query.isNotEmpty) {
      final String lowercaseQuery = query.toLowerCase();
      filtered = filtered
          .where(
            (DecryptedVaultEntry e) =>
                e.decryptedTitle.toLowerCase().contains(lowercaseQuery),
          )
          .toList();
    }

    state._entries.assignAll(filtered);
  }

  String decrypt(String cipherText) {
    return repository.decryptField(cipherText);
  }
}
