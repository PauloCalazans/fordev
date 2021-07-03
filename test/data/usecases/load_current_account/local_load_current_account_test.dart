import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late LocalLoadCurrentAccount sut;
  late String token;

  When mockFetchSecureCall() {
    return when(() => fetchSecureCacheStorage.fetchSecure(any()));
  }

  void mockFetchSecure() {
    mockFetchSecureCall().thenAnswer((_) async => token);
  }

  void mockFetchSecureError() {
    mockFetchSecureCall().thenThrow(Exception());
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    sut = LocalLoadCurrentAccount(fetchSecureCacheStorage: fetchSecureCacheStorage);
    token = faker.guid.guid();
    mockFetchSecure();
  });

  test('Should call FetchSecureCacheStorage with correct value', () async {
    await sut.load();

      verify(() => fetchSecureCacheStorage.fetchSecure('token'));
  });

  test('Should return an AccoutnEntity', () async {
    final account = await sut.load();

    expect(account, AccountEntity(token));
  });

  test('Should throw UnexpectedError if FetchSecure if error', () {
    mockFetchSecureError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });
}