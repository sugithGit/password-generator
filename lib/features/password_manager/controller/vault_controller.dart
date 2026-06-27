import 'dart:async';
import 'package:rxget/rxget.dart';
import 'package:uuid/uuid.dart';

import '../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../../service/password_manager/domain/repositories/vault_repository.dart';

part 'vault_state.dart';

class VaultController extends GetxController<VaultState> {
  VaultController({required this.repository}) : state = VaultState();

  final VaultRepository repository;
  StreamSubscription<List<VaultEntry>>? _subscription;
  List<VaultEntry> _allEntries = <VaultEntry>[];

  @override
  final VaultState state;

  void loadVault() => _loadVault();

  Future<void> addEntry({
    required String title,
    required String username,
    required String password,
    String? website,
    String? notes,
    VaultCategory category = VaultCategory.other,
  }) =>
      _addEntry(
        title: title,
        username: username,
        password: password,
        website: website,
        notes: notes,
        category: category,
      );

  Future<void> updateEntry(VaultEntry entry) => _updateEntry(entry);
  Future<void> deleteEntry(String entryId) => _deleteEntry(entryId);
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

  Future<void> _addEntry({
    required String title,
    required String username,
    required String password,
    String? website,
    String? notes,
    required VaultCategory category,
  }) async {
    state._error.value = null;
    try {
      final VaultEntry entry = VaultEntry(
        id: const Uuid().v4(),
        title: title,
        username: username,
        encryptedPassword: password,
        website: website,
        notes: notes,
        category: category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repository.addEntry(entry);
    } catch (e) {
      state._error.value = 'Failed to add entry: $e';
      rethrow;
    }
  }

  Future<void> _updateEntry(VaultEntry entry) async {
    state._error.value = null;
    try {
      await repository.updateEntry(
        entry.copyWith(
          updatedAt: DateTime.now(),
        ),
      );
    } catch (e) {
      state._error.value = 'Failed to update entry: $e';
      rethrow;
    }
  }

  Future<void> _deleteEntry(String entryId) async {
    state._error.value = null;
    try {
      await repository.deleteEntry(entryId);
    } catch (e) {
      state._error.value = 'Failed to delete entry: $e';
      rethrow;
    }
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
      filtered = filtered.where((VaultEntry e) => e.category == category).toList();
    }

    final String? query = state.searchQuery;
    if (query != null && query.isNotEmpty) {
      final String lowercaseQuery = query.toLowerCase();
      filtered = filtered
          .where(
            (VaultEntry e) =>
                e.title.toLowerCase().contains(lowercaseQuery) ||
                e.username.toLowerCase().contains(lowercaseQuery) ||
                (e.website?.toLowerCase().contains(lowercaseQuery) ?? false),
          )
          .toList();
    }

    state._entries.assignAll(filtered);
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }
}
