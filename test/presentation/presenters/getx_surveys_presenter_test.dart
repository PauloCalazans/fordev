import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

class LoadSurveysSpy extends Mock implements LoadSurveys {}

void main() {
  late LoadSurveysSpy loadSurveys;
  late GetxSurveysPresenter sut;
  late List<SurveyEntity> surveys;

  List<SurveyEntity> mockValidData() => [
    SurveyEntity(id: faker.guid.guid(), question: faker.lorem.sentence(), dateTime: DateTime(2021, 07, 31), didAnswer: true),
    SurveyEntity(id: faker.guid.guid(), question: faker.lorem.sentence(), dateTime: DateTime(2020, 05, 30), didAnswer: true)  ];

  When mockLoadSurveysCall() => when(() => loadSurveys.loadBySurvey());

  void mockLoadSurveys(List<SurveyEntity> data) {
    surveys = data;
    mockLoadSurveysCall().thenAnswer((_) async => surveys);
  }

  void mockLoadSurveysError() => mockLoadSurveysCall().thenThrow(DomainError.unexpected);

  setUp(() {
    loadSurveys = LoadSurveysSpy();
    sut = GetxSurveysPresenter(loadSurveys: loadSurveys);
    mockLoadSurveys(mockValidData());
  });

  test('Should call LoadSurveys on loadData', () async {
    await sut.loadData();

    verify(() => loadSurveys.loadBySurvey()).called(1);
  });

  test('Should emit correct events on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

    await sut.loadData();
  });

  test('Should call LoadSurveys on success', () async {
    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(expectAsync1((surveys) => expect(surveys, [
      SurveyViewModel(id: surveys![0].id, question: surveys[0].question, date: '31 Jul 2021', didAnswer: surveys[0].didAnswer),
      SurveyViewModel(id: surveys[1].id, question: surveys[1].question, date: '30 Mai 2020', didAnswer: surveys[1].didAnswer)
    ])));

    await sut.loadData();
  });

  test('Should call LoadSurveys on failure', () async {
    mockLoadSurveysError();

    expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
    sut.surveysStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

    await sut.loadData();
  });

  test('Should go to SurveyResultPage on survey tap', () async {
    sut.navigateToStream!.listen(expectAsync1((page) => expect(page, '/survey_result/1')));
    sut.goToSurveyResult('1');
  });
}