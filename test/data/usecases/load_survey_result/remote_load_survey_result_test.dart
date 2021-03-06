import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

import '../../../mocks/mocks.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveyResult sut;
  late String url;
  late HttpClientSpy httpClient;
  late Map surveyResult;

  When mockRequest() => when(() =>
      httpClient.request(url: any(named: 'url'), method: any(named: 'method')));

  void mockHttpData(Map data) {
    surveyResult = data;
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveyResult(url: url, httpClient: httpClient);
    mockHttpData(FakeSurveyResultFactory.makeApiJson());
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveyResult on 200', () async {
    final result = await sut.loadBySurvey();

    expect(result, SurveyResultEntity(
        surveyId: surveyResult['surveyId'],
        question: surveyResult['question'],
        answers: [
          SurveyAnswerEntity(
              image: surveyResult['answers'][0]['image'],
              answer: surveyResult['answers'][0]['answer'],
              isCurrentAnswer: surveyResult['answers'][0]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][0]['percent']
          ),
          SurveyAnswerEntity(
              answer: surveyResult['answers'][1]['answer'],
              isCurrentAnswer: surveyResult['answers'][1]['isCurrentAccountAnswer'],
              percent: surveyResult['answers'][1]['percent']
          )
        ]
    ));
  });

  test('Should throw UnexpectedErro if HttpClient returns 200 with invalid data', () async {
    mockHttpData(FakeSurveyResultFactory.makeInvalidApiJson());

    final result = sut.loadBySurvey();

    expect(result, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttClient returns 404', () async {
    mockHttpError(HttpError.notFound);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttClient returns 500', () async {
    mockHttpError(HttpError.serverError);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.unexpected));
  });

  test('Should throw UnexpectedError if HttClient returns 403', () async {
    mockHttpError(HttpError.forbidden);

    final future = sut.loadBySurvey();

    expect(future, throwsA(DomainError.accessDenied));
  });
}
