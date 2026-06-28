import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/service/password_manager/domain/entities/decrypted_vault_entry.dart';
import 'package:password_generator/service/password_manager/domain/entities/vault_category.dart';
import 'package:password_generator/service/password_manager/domain/entities/vault_entry.dart';

void main() {
  group('DecryptedVaultEntry', () {
    test('supports value equality', () {
      final now = DateTime.now();
      final entry1 = VaultEntry(
        id: '1',
        title: 'enc_title',
        username: 'enc_user',
        encryptedPassword: 'enc_password',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      final entry2 = VaultEntry(
        id: '1',
        title: 'enc_title',
        username: 'enc_user',
        encryptedPassword: 'enc_password',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      final decrypted1 = DecryptedVaultEntry(
        decryptedTitle: 'plain_title',
        entry: entry1,
      );

      final decrypted2 = DecryptedVaultEntry(
        decryptedTitle: 'plain_title',
        entry: entry2,
      );

      final decrypted3 = DecryptedVaultEntry(
        decryptedTitle: 'plain_title2',
        entry: entry1,
      );

      expect(decrypted1, equals(decrypted2));
      expect(decrypted1, isNot(equals(decrypted3)));
    });
  });
}
