import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'vault_entry.dart';

@immutable
class DecryptedVaultEntry extends Equatable {
  const DecryptedVaultEntry({
    required this.decryptedTitle,
    required this.entry,
  });

  final String decryptedTitle;
  final VaultEntry entry;

  @override
  List<Object?> get props => [decryptedTitle, entry];
}
