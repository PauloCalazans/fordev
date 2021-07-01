import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/data/cache/cache.dart';

class LocalStorageAdapter implements SaveSecureCacheStorage {
  final FlutterSecureStorage secureStorage;

  LocalStorageAdapter({required this.secureStorage});

  @override
  Future<void>? saveSecure({required String key, required String value}) async {
    await secureStorage.write(key: key, value: value);
  }
}

class FlutterSecureStorageMock extends Mock implements FlutterSecureStorage {}

void main() {
  late FlutterSecureStorageMock secureStorage;
  late LocalStorageAdapter sut;
  late String key;
  late String value;

  setUp(() {
    secureStorage = FlutterSecureStorageMock();
    sut = LocalStorageAdapter(secureStorage: secureStorage);
    key = faker.lorem.word();
    value = faker.guid.guid();
  });

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);


    verify(() => sut.saveSecure(key: key, value: value));
  });
}