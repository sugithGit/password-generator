import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/vault_entry.dart';
import '../../domain/repositories/vault_repository.dart';

part 'vault_event.dart';
part 'vault_state.dart';

class VaultBloc extends Bloc<VaultEvent, VaultState> {
  VaultBloc({required this.repository}) : super(const VaultInitial()) {
    on<LoadVault>(_onLoadVault);
    on<AddEntry>(_onAddEntry);
    on<UpdateEntry>(_onUpdateEntry);
    on<DeleteEntry>(_onDeleteEntry);
    on<SearchEntries>(_onSearchEntries);
    on<FilterByCategory>(_onFilterByCategory);
    on<_EntriesUpdated>(_onEntriesUpdated);
  }

  final VaultRepository repository;
  StreamSubscription<List<VaultEntry>>? _subscription;
  List<VaultEntry> _allEntries = <VaultEntry>[];

  Future<void> _onLoadVault(LoadVault event, Emitter<VaultState> emit) async {
    emit(const VaultLoading());
    await _subscription?.cancel();
    _subscription = repository.getEntries().listen(
      (List<VaultEntry> entries) {
        add(_EntriesUpdated(entries));
      },
      onError: (Object error) {
        add(_EntriesUpdated(const <VaultEntry>[]));
      },
    );
  }

  void _onEntriesUpdated(_EntriesUpdated event, Emitter<VaultState> emit) {
    _allEntries = event.entries;
    emit(VaultLoaded(entries: _allEntries));
  }

  Future<void> _onAddEntry(AddEntry event, Emitter<VaultState> emit) async {
    try {
      final VaultEntry entry = VaultEntry(
        id: const Uuid().v4(),
        title: event.title,
        username: event.username,
        encryptedPassword: event.password,
        website: event.website,
        notes: event.notes,
        category: event.category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await repository.addEntry(entry);
    } catch (e) {
      emit(VaultError(message: 'Failed to add entry: $e'));
      emit(VaultLoaded(entries: _allEntries));
    }
  }

  Future<void> _onUpdateEntry(
    UpdateEntry event,
    Emitter<VaultState> emit,
  ) async {
    try {
      await repository.updateEntry(event.entry.copyWith(
        updatedAt: DateTime.now(),
      ));
    } catch (e) {
      emit(VaultError(message: 'Failed to update entry: $e'));
      emit(VaultLoaded(entries: _allEntries));
    }
  }

  Future<void> _onDeleteEntry(
    DeleteEntry event,
    Emitter<VaultState> emit,
  ) async {
    try {
      await repository.deleteEntry(event.entryId);
    } catch (e) {
      emit(VaultError(message: 'Failed to delete entry: $e'));
      emit(VaultLoaded(entries: _allEntries));
    }
  }

  void _onSearchEntries(SearchEntries event, Emitter<VaultState> emit) {
    if (event.query.isEmpty) {
      emit(VaultLoaded(entries: _allEntries));
      return;
    }
    final String query = event.query.toLowerCase();
    final List<VaultEntry> filtered = _allEntries
        .where((VaultEntry e) =>
            e.title.toLowerCase().contains(query) ||
            e.username.toLowerCase().contains(query) ||
            (e.website?.toLowerCase().contains(query) ?? false))
        .toList();
    emit(VaultLoaded(entries: filtered, searchQuery: event.query));
  }

  void _onFilterByCategory(
    FilterByCategory event,
    Emitter<VaultState> emit,
  ) {
    if (event.category == null) {
      emit(VaultLoaded(entries: _allEntries));
      return;
    }
    final List<VaultEntry> filtered = _allEntries
        .where((VaultEntry e) => e.category == event.category)
        .toList();
    emit(VaultLoaded(entries: filtered, selectedCategory: event.category));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
