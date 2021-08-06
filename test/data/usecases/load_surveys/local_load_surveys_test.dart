import 'package:faker/faker.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/data/models/local_survey_model.dart';
import 'package:fordev/domain/entities/entities.dart';

class LocalLoadSurveys {
  final FetchCacheStorage fetchCacheStorage;

  LocalLoadSurveys({required this.fetchCacheStorage});

  Future<List<SurveyEntity>>? load() async {
    final data = await fetchCacheStorage.fetch('surveys');
    if(data?.isEmpty != false) throw DomainError.unexpected;
    return data.map<SurveyEntity>((json) => LocalSurveyModel.fromJson(json).toEntity()).toList();
  }
}

abstract class FetchCacheStorage {
  Future<dynamic>? fetch(String key);
}

class FetchCacheStorageSpy extends Mock implements FetchCacheStorage { }

void main() {
  late FetchCacheStorageSpy fetchCacheStorage;
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

  void mockFetch(List<Map>? list) {
    data = list;
    when(() => fetchCacheStorage.fetch(any())).thenAnswer((_) async => data);
  }

  setUp(() {
    fetchCacheStorage = FetchCacheStorageSpy();
    sut = LocalLoadSurveys(fetchCacheStorage: fetchCacheStorage);
    mockFetch(mockValidData());
  });

  test('Should call FetchCacheStorage with correct key', () async {
    await sut.load();

    verify(() => fetchCacheStorage.fetch('surveys')).called(1);
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
}