part of 'vault_controller.dart';

class _VaultState extends GetxState {
  final RxBool _isLoading = false.obs;
  final RxnString _error = RxnString();
  final RxList<VaultEntry> _entries = <VaultEntry>[].obs;
  final RxnString _searchQuery = RxnString();
  final Rxn<VaultCategory> _selectedCategory = Rxn<VaultCategory>();

  bool get isLoading => _isLoading.value;
  String? get error => _error.value;
  List<VaultEntry> get entries => _entries;
  String? get searchQuery => _searchQuery.value;
  VaultCategory? get selectedCategory => _selectedCategory.value;

  @override
  void onClose() {
    _isLoading.close();
    _error.close();
    _entries.close();
    _searchQuery.close();
    _selectedCategory.close();
  }
}
