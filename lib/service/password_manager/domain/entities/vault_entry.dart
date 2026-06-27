import 'package:equatable/equatable.dart';

enum VaultCategory {
  social,
  email,
  banking,
  shopping,
  work,
  other;

  String get label {
    switch (this) {
      case VaultCategory.social:
        return 'Social';
      case VaultCategory.email:
        return 'Email';
      case VaultCategory.banking:
        return 'Banking';
      case VaultCategory.shopping:
        return 'Shopping';
      case VaultCategory.work:
        return 'Work';
      case VaultCategory.other:
        return 'Other';
    }
  }
}

class VaultEntry with EquatableMixin {
  const VaultEntry({
    required this.id,
    required this.title,
    required this.username,
    required this.encryptedPassword,
    this.website,
    this.notes,
    this.category = VaultCategory.other,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String username;
  final String encryptedPassword;
  final String? website;
  final String? notes;
  final VaultCategory category;
  final DateTime createdAt;
  final DateTime updatedAt;

  VaultEntry copyWith({
    String? id,
    String? title,
    String? username,
    String? encryptedPassword,
    String? website,
    String? notes,
    VaultCategory? category,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return VaultEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      username: username ?? this.username,
      encryptedPassword: encryptedPassword ?? this.encryptedPassword,
      website: website ?? this.website,
      notes: notes ?? this.notes,
      category: category ?? this.category,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        id,
        title,
        username,
        encryptedPassword,
        website,
        notes,
        category,
        createdAt,
        updatedAt,
      ];
}
