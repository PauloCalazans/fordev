import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fordev/infra/cache/cache.dart';

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

  void mockSaveSecureError() {
    when(() => secureStorage.write(key: any(named: 'key'), value: any(named: 'value'))).thenThrow(Exception());
  }

  test('Should call save secure with correct values', () async {
    await sut.saveSecure(key: key, value: value);

    verify(() => sut.saveSecure(key: key, value: value));
  });

  test('Should throw if save secure throws', () async {
    mockSaveSecureError();
    final future = sut.saveSecure(key: key, value: value);

    expect(future, throwsA(TypeMatcher<Exception>()));
  });
}