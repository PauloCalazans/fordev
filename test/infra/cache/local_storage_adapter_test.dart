import 'package:mocktail/mocktail.dart';
import 'package:localstorage/localstorage.dart';
import 'package:faker/faker.dart';
import 'package:test/test.dart';

import 'package:fordev/infra/cache/cache.dart';

class LocalStorageSpy extends Mock implements LocalStorage {}

void main() {
  late LocalStorageSpy localStorage;
  late LocalStorageAdapter sut;
  late String key;
  late dynamic value;

  void mockDeleteError() => when(() => localStorage.deleteItem(any())).thenThrow(Exception());

  void mockSaveError() => when(() => localStorage.setItem(any(), any())).thenThrow(Exception());

  setUp(() {
    key = faker.randomGenerator.string(5);
    value = faker.randomGenerator.string(50);
    localStorage = LocalStorageSpy();
    sut = LocalStorageAdapter(localStorage: localStorage);
  });

  group('save', () {
    test('Should call localStorage with correct values', () async {
      await sut.save(key: key, value: value);

      verify(() => localStorage.deleteItem(key)).called(1);
      verify(() => localStorage.setItem(key, value)).called(1);
    });

    test('Should throw if delete item throws', () async {
      mockDeleteError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

    test('Should throw if set item throws', () async {
      mockSaveError();

      final future = sut.save(key: key, value: value);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

  group('delete', () {
    test('Should call localStorage with correct values', () async {
      await sut.delete(key);

      verify(() => localStorage.deleteItem(key)).called(1);
    });

    test('Should throw if delete item throws', () async {
      mockDeleteError();

      final future = sut.delete(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });

  });

  group('fetch', () {
    late String result;

    When mockFetchCall() {
      result = faker.randomGenerator.string(50);
      return when(() => localStorage.getItem(any()));
    }

    void mockFetch() => mockFetchCall().thenAnswer((_) async => result);

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      mockFetch();
    });

    test('Should call localStorage with correct value', () async {
      await sut.fetch(key);

      verify(() => localStorage.getItem(key)).called(1);
    });

    test('Should return same value as localStorage', () async {
      final data = await sut.fetch(key);

      expect(data, result);
    });

    test('Should throw if getItem throws', () async {
      mockFetchError();

      final future = sut.fetch(key);

      expect(future, throwsA(TypeMatcher<Exception>()));
    });
  });

}