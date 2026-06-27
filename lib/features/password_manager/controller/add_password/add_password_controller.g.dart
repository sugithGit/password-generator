// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_password_controller.dart';

// **************************************************************************
// GetxStateGenerator
// **************************************************************************

class _AddPasswordState extends GetxState {
  _AddPasswordState({required VaultCategory selectedCategory})
    : _selectedCategory = Rx<VaultCategory>(selectedCategory);

  // --- Reactive fields ---

  final Rx<VaultCategory> _selectedCategory;
  VaultCategory get selectedCategory => _selectedCategory.value;
  set selectedCategory(VaultCategory value) => _selectedCategory.value = value;

  // --- Lifecycle ---

  @override
  void onClose() {
    _selectedCategory.close();
  }
}
