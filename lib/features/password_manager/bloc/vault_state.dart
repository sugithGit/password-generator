part of 'vault_bloc.dart';

abstract class VaultState {
  const VaultState();
}

class VaultInitial extends VaultState {
  const VaultInitial();
}

class VaultLoading extends VaultState {
  const VaultLoading();
}

class VaultLoaded extends VaultState {
  const VaultLoaded({
    required this.entries,
    this.searchQuery,
    this.selectedCategory,
  });

  final List<VaultEntry> entries;
  final String? searchQuery;
  final VaultCategory? selectedCategory;
}

class VaultError extends VaultState {
  const VaultError({required this.message});
  final String message;
}
