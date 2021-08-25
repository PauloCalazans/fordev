import 'package:faker/faker.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/data/cache/cache.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/entities/entities.dart';

class CacheStorageSpy extends Mock implements CacheStorage { }

void main() {
  group('load', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    List<Map>? data;

    List<Map> mockValidData() => [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': DateTime(2021, 08, 05).toIso8601String(),
        'didAnswer': 'false'
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': DateTime(2021, 05, 12).toIso8601String(),
        'didAnswer': 'true'
      }
    ];

    When mockFetchCall() =>  when(() => cacheStorage.fetch(any()));

    void mockFetch(List<Map>? list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.load();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should return a list of surveys on success', () async {
      final surveys = await sut.load();

      expect(surveys, [
        SurveyEntity(id: data![0]['id']!, question: data![0]['question']!, dateTime: DateTime.utc(2021, 08, 05), didAnswer: false),
        SurveyEntity(id: data![1]['id']!, question: data![1]['question']!, dateTime: DateTime.utc(2021, 05, 12), didAnswer: true),
      ]);
    });

    test('Should throw UnexpectedError if cache is empty or null', () async {
      mockFetch([]);
      final future = sut.load();
      expect(future, throwsA(DomainError.unexpected));

      mockFetch(null);
      final future2 = sut.load();
      expect(future2, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is invalid', () async {
      mockFetch([{
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': 'invalid date',
        'didAnswer': 'true'
      }]);
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache is incomplete', () async {
      mockFetch([{
        'date': DateTime.utc(2021, 08, 05),
        'didAnswer': 'true'
      }]);
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });

    test('Should throw UnexpectedError if cache throws', () async {
      mockFetchError();
      final future = sut.load();

      expect(future, throwsA(DomainError.unexpected));
    });
  });

  group('validate', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    List<Map>? data;

    List<Map> mockValidData() => [
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': DateTime(2021, 08, 05).toIso8601String(),
        'didAnswer': 'false'
      },
      {
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': DateTime(2021, 05, 12).toIso8601String(),
        'didAnswer': 'true'
      }
    ];

    When mockFetchCall() =>  when(() => cacheStorage.fetch(any()));

    void mockFetch(List<Map>? list) {
      data = list;
      mockFetchCall().thenAnswer((_) async => data);
    }

    void mockFetchError() => mockFetchCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      mockFetch(mockValidData());
    });

    test('Should call CacheStorage with correct key', () async {
      await sut.validate();

      verify(() => cacheStorage.fetch('surveys')).called(1);
    });

    test('Should delete cache if it is invalid', () async {
      mockFetch([{
        'id': faker.guid.guid(),
        'question': faker.randomGenerator.string(10),
        'date': 'invalid date',
        'didAnswer': 'false'
      }]);

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetch([{
        'date': DateTime(2021, 05, 12).toIso8601String(),
        'didAnswer': 'false'
      }]);

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });

    test('Should delete cache if it is incomplete', () async {
      mockFetchError();

      await sut.validate();

      verify(() => cacheStorage.delete('surveys')).called(1);
    });
  });

  group('save', () {
    late CacheStorageSpy cacheStorage;
    late LocalLoadSurveys sut;
    late List<SurveyEntity> surveys;

    List<SurveyEntity> mockSurveys() => [
      SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2021, 6, 1),
          didAnswer: true
      ),
      SurveyEntity(
          id: faker.guid.guid(),
          question: faker.randomGenerator.string(10),
          dateTime: DateTime.utc(2020, 5, 12),
          didAnswer: false
      )
    ];

    When mockSaveCall() =>  when(() => cacheStorage.save(key: any(named: 'key'), value: any(named: 'value')));

    void mockSaveError() => mockSaveCall().thenThrow(Exception());

    setUp(() {
      cacheStorage = CacheStorageSpy();
      sut = LocalLoadSurveys(cacheStorage: cacheStorage);
      surveys = mockSurveys();
    });

    test('Should call CacheStorage with correct values', () async {
      final list = [{
        'id': surveys[0].id,
        'question': surveys[0].question,
        'dateTime': surveys[0].dateTime.toIso8601String(),
        'didAnswer': 'true'
        },
        {
        'id': surveys[1].id,
        'question': surveys[1].question,
        'dateTime': surveys[1].dateTime.toIso8601String(),
        'didAnswer': 'false'
      }];

      await sut.save(surveys);

      verify(() => cacheStorage.save(key: 'surveys', value: list)).called(1);
    });

    test('Should throw unexpected error if save throws', () async {
      mockSaveError();

      final future = sut.save(surveys);

      expect(future, throwsA(DomainError.unexpected));
    });
  });
}