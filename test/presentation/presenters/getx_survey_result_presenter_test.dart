import 'package:test/test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:faker/faker.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';

import 'package:fordev/presentation/presenters/presenters.dart';

class LoadSurveyResultSpy extends Mock implements LoadSurveyResult {}
class SaveSurveyResultSpy extends Mock implements SaveSurveyResult {}

void main() {
  late LoadSurveyResultSpy loadSurveyResult;
  late SaveSurveyResultSpy saveSurveyResult;
  late GetxSurveyResultPresenter sut;
  late SurveyResultEntity loadResult;
  late SurveyResultEntity saveResult;
  late String surveyId;
  late String answer;

  SurveyResultEntity mockValidData() => SurveyResultEntity(
      surveyId: faker.guid.guid(),
      question: faker.lorem.sentence(),
      answers: [
        SurveyAnswerEntity(
          image: faker.internet.httpUrl(),
          answer: faker.lorem.sentence(),
          percent: faker.randomGenerator.integer(100),
          isCurrentAnswer: faker.randomGenerator.boolean(),
        ),
        SurveyAnswerEntity(
          answer: faker.lorem.sentence(),
          percent: faker.randomGenerator.integer(100),
          isCurrentAnswer: faker.randomGenerator.boolean(),
        ),
      ]
  );

  When mockLoadSurveyResultCall() => when(() => loadSurveyResult.loadBySurvey(surveyId: any(named: 'surveyId')));

  void mockLoadSurveyResult(SurveyResultEntity data) {
    loadResult = data;
    mockLoadSurveyResultCall().thenAnswer((_) async => loadResult);
  }

  void mockLoadSurveyResultError(DomainError error) => mockLoadSurveyResultCall().thenThrow(error);

  When mockSaveSurveyResultCall() => when(() => saveSurveyResult.save(answer: any(named: 'answer')));

  void mockSaveSurveyResult(SurveyResultEntity data) {
    saveResult = data;
    mockSaveSurveyResultCall().thenAnswer((_) async => saveResult);
  }

  void mockSaveSurveyResultError(DomainError error) => mockSaveSurveyResultCall().thenThrow(error);

  setUp(() {
    surveyId = faker.guid.guid();
    answer = faker.lorem.sentence();

    loadSurveyResult = LoadSurveyResultSpy();
    saveSurveyResult = SaveSurveyResultSpy();
    sut = GetxSurveyResultPresenter(
      loadSurveyResult: loadSurveyResult,
      saveSurveyResult: saveSurveyResult,
      surveyId: surveyId
    );
    mockLoadSurveyResult(mockValidData());
    mockSaveSurveyResult(mockValidData());
  });

  group('loadData', () {
    test('Should call LoadSurveyResult on loadData', () async {
      await sut.loadData();

      verify(() => loadSurveyResult.loadBySurvey(surveyId: surveyId)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.loadData();
    });

    test('Should call loadBySurvey on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(result,
          SurveyResultViewModel(
              surveyId:
              loadResult.surveyId,
              question: loadResult.question,
              answers: [
                SurveyAnswerViewModel(
                    image: loadResult.answers[0].image,
                    answer: loadResult.answers[0].answer,
                    isCurrentAnswer: loadResult.answers[0].isCurrentAnswer,
                    percent: '${loadResult.answers[0].percent}%'
                ),
                SurveyAnswerViewModel(
                    answer: loadResult.answers[1].answer,
                    isCurrentAnswer: loadResult.answers[1].isCurrentAnswer,
                    percent: '${loadResult.answers[1].percent}%'
                )
              ]
          )
      )));

      await sut.loadData();
    });

    test('Should emits correct event on failure', () async {
      mockLoadSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.loadData();
    });

    test('Should emit correct events on access denied', () async {
      mockLoadSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.loadData();
    });
  });

  group ('save', () {
    test('Should call SaveSurveyResult on save', () async {
      await sut.save(answer: answer);

      verify(() => saveSurveyResult.save(answer: answer)).called(1);
    });

    test('Should emit correct events on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));

      await sut.save(answer: answer);
    });

    test('Should call loadBySurvey on success', () async {
      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(expectAsync1((result) => expect(result,
          SurveyResultViewModel(
              surveyId:
              saveResult.surveyId,
              question: saveResult.question,
              answers: [
                SurveyAnswerViewModel(
                    image: saveResult.answers[0].image,
                    answer: saveResult.answers[0].answer,
                    isCurrentAnswer: saveResult.answers[0].isCurrentAnswer,
                    percent: '${saveResult.answers[0].percent}%'
                ),
                SurveyAnswerViewModel(
                    answer: saveResult.answers[1].answer,
                    isCurrentAnswer: saveResult.answers[1].isCurrentAnswer,
                    percent: '${saveResult.answers[1].percent}%'
                )
              ]
          )
      )));

      await sut.save(answer: answer);
    });

    test('Should emits correct event on failure', () async {
      mockSaveSurveyResultError(DomainError.unexpected);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      sut.surveyResultStream.listen(null, onError: expectAsync1((error) => expect(error, UIError.unexpected.description)));

      await sut.save(answer: answer);
    });

    test('Should emit correct events on access denied', () async {
      mockSaveSurveyResultError(DomainError.accessDenied);

      expectLater(sut.isLoadingStream, emitsInOrder([true, false]));
      expectLater(sut.isSessionExpiredStream, emits(true));

      await sut.save(answer: answer);
    });
  });
}