import '../../domain/entities/vault_entry.dart';

class VaultEntryModel {
  const VaultEntryModel({
    required this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.website,
    this.notes,
  });

  factory VaultEntryModel.fromMap(Map<String, dynamic> map, String docId) {
    return VaultEntryModel(
      id: docId,
      title: map['title'] as String? ?? '',
      username: map['username'] as String? ?? '',
      encryptedPassword: map['encryptedPassword'] as String? ?? '',
      website: map['website'] as String?,
      notes: map['notes'] as String?,
      category: map['category'] as String? ?? 'other',
      createdAt:
          DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt:
          DateTime.tryParse(map['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  final String id;
  final String title;
  final String? username;
  final String encryptedPassword;
  final String? website;
  final String? notes;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'username': username,
      'encryptedPassword': encryptedPassword,
      'website': website,
      'notes': notes,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  static VaultEntryModel fromEntity(VaultEntry entry) {
    return VaultEntryModel(
      id: entry.id,
      title: entry.title,
      username: entry.username,
      encryptedPassword: entry.encryptedPassword,
      website: entry.website,
      notes: entry.notes,
      category: entry.category.name,
      createdAt: entry.createdAt,
      updatedAt: entry.updatedAt,
    );
  }

  VaultEntry toEntity() {
    return VaultEntry(
      id: id,
      title: title,
      username: username,
      encryptedPassword: encryptedPassword,
      website: website,
      notes: notes,
      category: VaultCategory.values.firstWhere(
        (VaultCategory c) => c.name == category,
        orElse: () => VaultCategory.other,
      ),
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
