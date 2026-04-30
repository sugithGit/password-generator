part of 'vault_bloc.dart';

abstract class VaultEvent {
  const VaultEvent();
}

class LoadVault extends VaultEvent {
  const LoadVault();
}

class AddEntry extends VaultEvent {
  const AddEntry({
    required this.title,
    required this.username,
    required this.password,
    this.website,
    this.notes,
    this.category = VaultCategory.other,
  });

  final String title;
  final String username;
  final String password;
  final String? website;
  final String? notes;
  final VaultCategory category;
}

class UpdateEntry extends VaultEvent {
  const UpdateEntry({required this.entry});
  final VaultEntry entry;
}

class DeleteEntry extends VaultEvent {
  const DeleteEntry({required this.entryId});
  final String entryId;
}

class SearchEntries extends VaultEvent {
  const SearchEntries({required this.query});
  final String query;
}

class FilterByCategory extends VaultEvent {
  const FilterByCategory({this.category});
  final VaultCategory? category;
}

class _EntriesUpdated extends VaultEvent {
  const _EntriesUpdated(this.entries);
  final List<VaultEntry> entries;
}
