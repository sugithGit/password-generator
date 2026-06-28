enum VaultCategory {
  social,
  email,
  banking,
  shopping,
  work,
  other;

  String get label {
    switch (this) {
      case VaultCategory.banking:
        return 'Banking';
      case VaultCategory.email:
        return 'Email';
      case VaultCategory.social:
        return 'Social';
      case VaultCategory.shopping:
        return 'Shopping';
      case VaultCategory.work:
        return 'Work';
      case VaultCategory.other:
        return 'Other';
    }
  }
}
