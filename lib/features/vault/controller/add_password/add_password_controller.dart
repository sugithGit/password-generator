import 'package:rxget/rxget.dart';
import 'package:rxget_annotation/rxget_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../../service/password_manager/domain/entities/vault_category.dart';
import '../../../../service/password_manager/domain/entities/vault_entry.dart';
import '../../../../service/password_manager/domain/repositories/vault_repository.dart';

part 'add_password_state.dart';
part 'add_password_controller.g.dart';

class AddPasswordController extends GetxController<_AddPasswordState> {
  AddPasswordController({
    required VaultCategory selectedCategory,
    required this.repository,
  }) : state = _AddPasswordState(selectedCategory: selectedCategory);

  final VaultRepository repository;

  @override
  _AddPasswordState state;

  void changeCategory(VaultCategory category) => _changeCategory(category);
  Future<void> addEntry({
    required String title,
    required String username,
    required String password,
    String? website,
    String? notes,
    VaultCategory? category,
  }) => _addEntry(
    title: title,
    username: username,
    password: password,
    website: website,
    notes: notes,
    category: category ?? state.selectedCategory,
  );
  Future<void> updateEntry(VaultEntry entry) => _updateEntry(entry);
  Future<void> deleteEntry(String entryId) => _deleteEntry(entryId);
  void enableBtn({required String title, required String password}) =>
      _enableBtn(title: title, password: password);

  void _changeCategory(VaultCategory category) {
    state._selectedCategory.value = category;
  }

  Future<void> _addEntry({
    required String title,
    required String username,
    required String password,
    required VaultCategory category,
    String? website,
    String? notes,
  }) async {
    // We could handle loading states here if we wanted to
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
      rethrow;
    }
  }

  Future<void> _updateEntry(VaultEntry entry) async {
    try {
      await repository.updateEntry(entry.copyWith(updatedAt: DateTime.now()));
    } catch (e) {
      rethrow;
    }
  }

  Future<void> _deleteEntry(String entryId) async {
    try {
      await repository.deleteEntry(entryId);
    } catch (e) {
      rethrow;
    }
  }

  void _enableBtn({required String title, required String password}) {
    state._enableBtn.value = title.isNotEmpty && password.isNotEmpty;
  }
}
