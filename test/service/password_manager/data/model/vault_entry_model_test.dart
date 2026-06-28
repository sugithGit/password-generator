import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/service/password_manager/data/model/vault_entry_model.dart';

void main() {
  group('VaultEntryModel', () {
    final DateTime now = DateTime.now();
    final model = VaultEntryModel(
      id: '123',
      title: 'enc_title',
      username: 'enc_username',
      encryptedPassword: 'enc_password',
      website: 'enc_website',
      notes: 'enc_notes',
      category: 'social',
      createdAt: now,
      updatedAt: now,
    );

    test('toMap converts to valid Map', () {
      final map = model.toMap();
      expect(map['title'], 'enc_title');
      expect(map['username'], 'enc_username');
      expect(map['encryptedPassword'], 'enc_password');
      expect(map['website'], 'enc_website');
      expect(map['notes'], 'enc_notes');
      expect(map['category'], 'social');
    });

    test('fromMap converts Map to valid VaultEntryModel', () {
      final map = {
        'title': 'enc_title',
        'username': 'enc_username',
        'encryptedPassword': 'enc_password',
        'website': 'enc_website',
        'notes': 'enc_notes',
        'category': 'social',
        'createdAt': now.toIso8601String(),
        'updatedAt': now.toIso8601String(),
      };

      final newModel = VaultEntryModel.fromMap(map, '123');
      expect(newModel.id, '123');
      expect(newModel.title, 'enc_title');
      expect(newModel.username, 'enc_username');
      expect(newModel.encryptedPassword, 'enc_password');
      expect(newModel.website, 'enc_website');
      expect(newModel.notes, 'enc_notes');
      expect(newModel.category, 'social');
      expect(newModel.createdAt, now);
      expect(newModel.updatedAt, now);
    });
  });
}
