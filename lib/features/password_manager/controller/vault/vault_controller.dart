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
  List<VaultEntry> _allEntries = <VaultEntry>[];

  void loadVault() => _loadVault();

  void searchEntries(String query) => _searchEntries(query);
  void filterByCategory(VaultCategory? category) => _filterByCategory(category);

  void _loadVault() {
    state._isLoading.value = true;
    state._error.value = null;
    _subscription?.cancel();
    _subscription = repository.getEntries().listen(
      (List<VaultEntry> entries) {
        _allEntries = entries;
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
    List<VaultEntry> filtered = _allEntries;

    final VaultCategory? category = state.selectedCategory;
    if (category != null) {
      filtered = filtered
          .where((VaultEntry e) => e.category == category)
          .toList();
    }

    final String? query = state.searchQuery;
    if (query != null && query.isNotEmpty) {
      final String lowercaseQuery = query.toLowerCase();
      filtered = filtered
          .where(
            (VaultEntry e) =>
                e.title.toLowerCase().contains(lowercaseQuery) ||
                (e.website?.toLowerCase().contains(lowercaseQuery) ?? false),
          )
          .toList();
    }

    state._entries.assignAll(filtered);
  }
}
