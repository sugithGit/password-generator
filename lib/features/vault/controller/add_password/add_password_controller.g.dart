// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_password_controller.dart';

// **************************************************************************
// GetxStateGenerator
// **************************************************************************

class _AddPasswordState extends GetxState {
  _AddPasswordState({
    required VaultCategory selectedCategory,
    bool enableBtn = false,
  }) : _selectedCategory = Rx<VaultCategory>(selectedCategory),
       _enableBtn = Rx<bool>(enableBtn);

  // --- Reactive fields ---

  final Rx<VaultCategory> _selectedCategory;
  VaultCategory get selectedCategory => _selectedCategory.value;
  set selectedCategory(VaultCategory value) => _selectedCategory.value = value;

  final Rx<bool> _enableBtn;
  bool get enableBtn => _enableBtn.value;
  set enableBtn(bool value) => _enableBtn.value = value;

  // --- Lifecycle ---

  @override
  void onClose() {
    _selectedCategory.close();
    _enableBtn.close();
  }
}
