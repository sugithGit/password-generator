import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:password_generator/service/auth/domain/repositories/encryption_repo.dart';
import 'package:password_generator/service/password_manager/data/model/vault_entry_model.dart';
import 'package:password_generator/service/password_manager/data/remote/vault_remote_datasource.dart';
import 'package:password_generator/service/password_manager/data/repositories/vault_repo_impl.dart';
import 'package:password_generator/service/password_manager/domain/entities/vault_category.dart';
import 'package:password_generator/service/password_manager/domain/entities/vault_entry.dart';
import 'package:sodium/sodium_sumo.dart';

class MockVaultRemoteDatasource extends Mock implements VaultRemoteDatasource {}

class MockEncryptionRepo extends Mock implements EncryptionRepo {}

class MockSecureKey extends Mock implements SecureKey {}

class FakeVaultEntryModel extends Fake implements VaultEntryModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeVaultEntryModel());
  });

  group('VaultRepoImpl', () {
    late MockVaultRemoteDatasource mockRemoteDatasource;
    late MockEncryptionRepo mockEncryptionRepo;
    late MockSecureKey mockSecureKey;
    late VaultRepoImpl repository;

    setUp(() {
      mockRemoteDatasource = MockVaultRemoteDatasource();
      mockEncryptionRepo = MockEncryptionRepo();
      mockSecureKey = MockSecureKey();

      repository = VaultRepoImpl(
        remoteDatasource: mockRemoteDatasource,
        encryptionRepo: mockEncryptionRepo,
        encryptionKey: mockSecureKey,
      );
    });

    test('getEntries maps and decrypts correctly', () {
      final now = DateTime.now();
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

      when(
        () => mockRemoteDatasource.getEntries(),
      ).thenAnswer((_) => Stream.value([model]));

      final stream = repository.getEntries();

      expect(
        stream,
        emits([
          isA<VaultEntry>()
              .having((e) => e.id, 'id', '123')
              .having((e) => e.title, 'title', 'enc_title')
              .having(
                (e) => e.encryptedPassword,
                'encryptedPassword',
                'enc_password',
              )
              .having((e) => e.category, 'category', VaultCategory.social),
        ]),
      );
    });

    test('addEntry encrypts fields and calls remote datasource', () async {
      final now = DateTime.now();
      final entry = VaultEntry(
        id: '123',
        title: 'plain_title',
        username: 'plain_username',
        encryptedPassword: 'plain_password',
        website: 'plain_website',
        notes: 'plain_notes',
        category: VaultCategory.social,
        createdAt: now,
        updatedAt: now,
      );

      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_title',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_title');
      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_username',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_username');
      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_password',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_password');
      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_website',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_website');
      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_notes',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_notes');

      when(() => mockRemoteDatasource.addEntry(any())).thenAnswer((_) async {});

      await repository.addEntry(entry);

      verify(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_title',
          key: mockSecureKey,
        ),
      ).called(1);

      final captured = verify(
        () => mockRemoteDatasource.addEntry(captureAny()),
      ).captured;
      final savedModel = captured.first as VaultEntryModel;

      expect(savedModel.title, 'enc_title');
      expect(savedModel.username, 'enc_username');
      expect(savedModel.encryptedPassword, 'enc_password');
      expect(savedModel.website, 'enc_website');
      expect(savedModel.notes, 'enc_notes');
    });

    test('updateEntry encrypts fields and calls remote datasource', () async {
      final now = DateTime.now();
      final entry = VaultEntry(
        id: '123',
        title: 'plain_title',
        username: null,
        encryptedPassword: 'plain_password',
        category: VaultCategory.work,
        createdAt: now,
        updatedAt: now,
      );

      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_title',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_title');
      when(
        () => mockEncryptionRepo.encrypt(
          plainText: 'plain_password',
          key: mockSecureKey,
        ),
      ).thenReturn('enc_password');

      when(
        () => mockRemoteDatasource.updateEntry(any()),
      ).thenAnswer((_) async {});

      await repository.updateEntry(entry);

      final captured = verify(
        () => mockRemoteDatasource.updateEntry(captureAny()),
      ).captured;
      final savedModel = captured.first as VaultEntryModel;

      expect(savedModel.title, 'enc_title');
      expect(savedModel.username, isNull);
      expect(savedModel.encryptedPassword, 'enc_password');
      expect(savedModel.website, isNull);
      expect(savedModel.notes, isNull);
      expect(savedModel.category, 'work');
    });

    test('deleteEntry calls remote datasource', () async {
      when(
        () => mockRemoteDatasource.deleteEntry(any()),
      ).thenAnswer((_) async {});

      await repository.deleteEntry('123');

      verify(() => mockRemoteDatasource.deleteEntry('123')).called(1);
    });

    test('decryptField calls encryptionRepo', () {
      when(
        () => mockEncryptionRepo.decrypt(
          cipherText: 'cipher',
          key: mockSecureKey,
        ),
      ).thenReturn('plain');

      final result = repository.decryptField('cipher');

      expect(result, 'plain');
      verify(
        () => mockEncryptionRepo.decrypt(
          cipherText: 'cipher',
          key: mockSecureKey,
        ),
      ).called(1);
    });
  });
}
