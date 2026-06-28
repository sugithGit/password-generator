import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/service/password_manager/domain/entities/vault_category.dart';
import 'package:password_generator/service/password_manager/domain/entities/vault_entry.dart';

void main() {
  group('VaultEntry', () {
    test('supports value equality', () {
      final now = DateTime.now();
      final entry1 = VaultEntry(
        id: '1',
        title: 'enc_title',
        username: 'enc_user',
        encryptedPassword: 'enc_password',
        website: 'enc_web',
        notes: 'enc_notes',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      final entry2 = VaultEntry(
        id: '1',
        title: 'enc_title',
        username: 'enc_user',
        encryptedPassword: 'enc_password',
        website: 'enc_web',
        notes: 'enc_notes',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      final entry3 = VaultEntry(
        id: '2',
        title: 'enc_title',
        username: 'enc_user',
        encryptedPassword: 'enc_password',
        website: 'enc_web',
        notes: 'enc_notes',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      expect(entry1, equals(entry2));
      expect(entry1, isNot(equals(entry3)));
    });

    test('copyWith updates fields correctly', () {
      final now = DateTime.now();
      final entry = VaultEntry(
        id: '1',
        title: 'enc_title',
        username: 'enc_user',
        encryptedPassword: 'enc_password',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      final newTime = now.add(const Duration(minutes: 5));
      final updated = entry.copyWith(
        title: 'new_title',
        username: 'new_user',
        updatedAt: newTime,
      );

      expect(updated.id, '1');
      expect(updated.title, 'new_title');
      expect(updated.username, 'new_user');
      expect(updated.encryptedPassword, 'enc_password');
      expect(updated.category, VaultCategory.social);
      expect(updated.createdAt, now);
      expect(updated.updatedAt, newTime);
    });
  });
}
