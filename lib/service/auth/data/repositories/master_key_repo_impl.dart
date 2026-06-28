import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../domain/entities/auth_exceptions.dart';
import '../../domain/repositories/master_key_repo.dart';
import '../remote/master_key_remote_datasource.dart';

class MasterKeyRepoImpl implements MasterKeyRepo {
  MasterKeyRepoImpl({
    required this.remoteDatasource,
    this.secureStorage = const FlutterSecureStorage(),
  });

  final MasterKeyRemoteDatasource remoteDatasource;
  final FlutterSecureStorage secureStorage;

  @override
  Future<Map<String, String>?> getMasterKeyData(String uid) async {
    try {
      return await remoteDatasource.getMasterKeyData(uid: uid);
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const AuthPermissionDeniedException();
      }
      throw AuthUnknownException(
        e.message ?? 'An error occurred fetching master key data.',
      );
    } catch (e) {
      throw const AuthUnknownException('An unexpected error occurred.');
    }
  }

  @override
  Future<void> saveMasterKeyData({
    required String uid,
    required String encryptedMasterKey,
    required String salt,
  }) async {
    try {
      await remoteDatasource.saveMasterKeyData(
        uid: uid,
        encryptedMasterKey: encryptedMasterKey,
        salt: salt,
      );
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
        throw const AuthPermissionDeniedException();
      }
      throw AuthUnknownException(
        e.message ?? 'An error occurred saving master key data.',
      );
    } catch (e) {
      throw const AuthUnknownException('An unexpected error occurred.');
    }
  }

  @override
  Future<String?> getLocalMasterKey(String uid) async {
    try {
      return await secureStorage.read(key: 'master_key_$uid');
    } catch (e) {
      throw const AuthUnknownException(
        'An error occurred reading local master key.',
      );
    }
  }

  @override
  Future<void> saveLocalMasterKey({
    required String uid,
    required String masterKey,
  }) async {
    try {
      await secureStorage.write(key: 'master_key_$uid', value: masterKey);
    } catch (e) {
      throw const AuthUnknownException(
        'An error occurred saving local master key.',
      );
    }
  }
}
