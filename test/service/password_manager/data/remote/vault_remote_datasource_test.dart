import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_generator/service/password_manager/data/model/vault_entry_model.dart';
import 'package:password_generator/service/password_manager/data/remote/vault_remote_datasource.dart';

void main() {
  group('VaultRemoteDatasource', () {
    late FakeFirebaseFirestore fakeFirestore;
    late VaultRemoteDatasource datasource;
    const String testUserId = '12345';
    // reversed is 54321

    setUp(() {
      fakeFirestore = FakeFirebaseFirestore();
      datasource = VaultRemoteDatasource(
        userId: testUserId,
        firestore: fakeFirestore,
      );
    });

    test('addEntry saves entry to correct path', () async {
      final now = DateTime.now();
      final entry = VaultEntryModel(
        id: 'entry1',
        title: 'title',
        username: 'user',
        encryptedPassword: 'password',
        category: 'social',
        createdAt: now,
        updatedAt: now,
      );

      await datasource.addEntry(entry);

      final doc = await fakeFirestore
          .collection('vault')
          .doc('54321')
          .collection('entries')
          .doc('entry1')
          .get();

      expect(doc.exists, isTrue);
      expect(doc.data()!['title'], 'title');
    });

    test('updateEntry updates existing entry', () async {
      final now = DateTime.now();
      final entry = VaultEntryModel(
        id: 'entry1',
        title: 'title',
        username: 'user',
        encryptedPassword: 'password',
        category: 'social',
        createdAt: now,
        updatedAt: now,
      );

      await datasource.addEntry(entry);

      final updatedEntry = VaultEntryModel(
        id: 'entry1',
        title: 'updated_title',
        username: 'user',
        encryptedPassword: 'password',
        category: 'social',
        createdAt: now,
        updatedAt: now,
      );

      await datasource.updateEntry(updatedEntry);

      final doc = await fakeFirestore
          .collection('vault')
          .doc('54321')
          .collection('entries')
          .doc('entry1')
          .get();

      expect(doc.data()!['title'], 'updated_title');
    });

    test('deleteEntry removes entry from firestore', () async {
      final now = DateTime.now();
      final entry = VaultEntryModel(
        id: 'entry1',
        title: 'title',
        username: 'user',
        encryptedPassword: 'password',
        category: 'social',
        createdAt: now,
        updatedAt: now,
      );

      await datasource.addEntry(entry);
      await datasource.deleteEntry('entry1');

      final doc = await fakeFirestore
          .collection('vault')
          .doc('54321')
          .collection('entries')
          .doc('entry1')
          .get();

      expect(doc.exists, isFalse);
    });

    test('getEntries streams list of entries ordered by updatedAt descending', () async {
      final now = DateTime.now();
      final olderEntry = VaultEntryModel(
        id: 'entry1',
        title: 'title1',
        username: 'user1',
        encryptedPassword: 'password',
        category: 'social',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
      );

      final newerEntry = VaultEntryModel(
        id: 'entry2',
        title: 'title2',
        username: 'user2',
        encryptedPassword: 'password',
        category: 'social',
        createdAt: now,
        updatedAt: now,
      );

      await datasource.addEntry(olderEntry);
      await datasource.addEntry(newerEntry);

      final stream = datasource.getEntries();
      final entries = await stream.first;

      expect(entries.length, 2);
      expect(entries[0].id, 'entry2');
      expect(entries[1].id, 'entry1');
    });
  });
}
