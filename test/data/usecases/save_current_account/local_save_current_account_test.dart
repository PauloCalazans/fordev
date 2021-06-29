import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/domain/usecases/usecases.dart';
import 'package:fordev/domain/entities/entities.dart';

class LocalSaveCurrentAccount implements SaveCurrentAccount {
  final SaveSecureCacheStorage saveSecureCacheStorage;

  LocalSaveCurrentAccount({required this.saveSecureCacheStorage});

  Future<void> save(AccountEntity account) async {
    await saveSecureCacheStorage.saveSecure(key: 'token', value: account.token);
  }
}

abstract class SaveSecureCacheStorage {
  Future<void>? saveSecure({required String key, required String value});
}

class SaveSecureCacheStorageMock extends Mock implements SaveSecureCacheStorage {}

void main() {
  test('Should call SaveCacheStorage with correct values', () async {
      final saveSecureCacheStorage = SaveSecureCacheStorageMock();
      final sut = LocalSaveCurrentAccount(saveSecureCacheStorage: saveSecureCacheStorage);
      final account = AccountEntity(faker.guid.guid());

      await sut.save(account);

      verify(() => saveSecureCacheStorage.saveSecure(key: 'token', value: account.token));
  });
}