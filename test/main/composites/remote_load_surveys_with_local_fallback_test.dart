import 'package:faker/faker.dart';
import 'package:fordev/domain/helpers/domain_error.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/data/usecases/usecases.dart';

class RemoteLoadSurveysWithLocalFallback {
  final RemoteLoadSurveys remote;
  final LocalLoadSurveySpy local;

  RemoteLoadSurveysWithLocalFallback({required this.remote, required this.local});

  Future<List<SurveyEntity>?>? load() async {
    try {
      final surveys = await remote.load();
      await local.save(surveys ?? []);

      return surveys;
    } catch(error) {
      if(error == DomainError.accessDenied) {
        rethrow;
      }

      await local.validate();
      return local.load();
    }
  }
}

class RemoteLoadSurveySpy extends Mock implements RemoteLoadSurveys {}
class LocalLoadSurveySpy extends Mock implements LocalLoadSurveys {}

void main() {
  late RemoteLoadSurveySpy remote;
  late LocalLoadSurveySpy local;
  late RemoteLoadSurveysWithLocalFallback sut;
  late List<SurveyEntity> remoteSurveys;
  late List<SurveyEntity> localSurveys;

  List<SurveyEntity> mockSurveys() => [
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        dateTime: faker.date.dateTime(),
        didAnswer: faker.randomGenerator.boolean()
    )
  ];

  When mockRemoteLoadCall() => when(() => remote.load());

  void mockRemoteLoad() {
    remoteSurveys = mockSurveys();
    mockRemoteLoadCall().thenAnswer((_) async => remoteSurveys);
  }

  void mockRemoteLoadError(DomainError error) => mockRemoteLoadCall().thenThrow(error);

  When mockLocalLoadCall() => when(() => local.load());

  void mockLocalLoad() {
    localSurveys = mockSurveys();
    mockLocalLoadCall().thenAnswer((_) async => localSurveys);
  }

  void mockLocalLoadError() => mockLocalLoadCall().thenThrow(DomainError.unexpected);

  setUp(() {
    remote = RemoteLoadSurveySpy();
    local = LocalLoadSurveySpy();
    sut = RemoteLoadSurveysWithLocalFallback(remote: remote, local: local);
    mockRemoteLoad();
    mockLocalLoad();
  });

  test('Should call remote load', () async {
    await sut.load();

    verify(() => remote.load()).called(1);
  });

  test('Should call local save with remote surveys', () async {
    await sut.load();

    verify(() => local.save(remoteSurveys)).called(1);
  });

  test('Should return remote data', () async {
    final surveys = await sut.load();

    expect(surveys, remoteSurveys);
  });

  test('Should rethrow if remote load throws AccessDeniedError', () async {
    mockRemoteLoadError(DomainError.accessDenied);

    final future = sut.load();

    expect(future, throwsA(DomainError.accessDenied));
  });

  test('Should call local fetch on remote error', () async {
    mockRemoteLoadError(DomainError.unexpected);

    await sut.load();

    verify(() => local.validate()).called(1);
    verify(() => local.load()).called(1);
  });

  test('Should return local surveys', () async {
    mockRemoteLoadError(DomainError.unexpected);

    final surveys = await sut.load();

    expect(surveys, localSurveys);
  });

  test('Should throw UnexpectedError if remote and local throws', () async {
    mockRemoteLoadError(DomainError.unexpected);
    mockLocalLoadError();

    final future = sut.load();

    expect(future, throwsA(DomainError.unexpected));
  });

}