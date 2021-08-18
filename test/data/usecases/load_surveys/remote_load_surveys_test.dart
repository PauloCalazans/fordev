import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/domain/helpers/helpers.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteLoadSurveys sut;
  late String url;
  late HttpClientSpy httpClient;
  late List<Map> list;

  List<Map> mockValidData() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String()
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String()
    }
  ];

  When mockRequest() => when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method')));

  void mockHttpData(List<Map> data) {
    mockRequest().thenAnswer((_) async => data);
  }

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    url = faker.internet.httpUrl();
    httpClient = HttpClientSpy();
    sut = RemoteLoadSurveys(url: url, httpClient: httpClient);
    list = mockValidData();
    mockHttpData(list);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    await sut.loadBySurvey();

    verify(() => httpClient.request(url: url, method: 'get'));
  });

  test('Should return surveys on 200', () async {
    final surveys = await sut.loadBySurvey();

    expect(surveys, [
      SurveyEntity(
          id: list[0]['id'],
          question: list[0]['question'],
          dateTime: DateTime.parse(list[0]['date']),
          didAnswer: list[0]['didAnswer']
      ),
      SurveyEntity(
          id: list[1]['id'],
          question: list[1]['question'],
          dateTime: DateTime.parse(list[1]['date']),
          didAnswer: list[1]['didAnswer']
      )
    ]);
  });

  test('Should throw UnexpectedErro if HttpClient returns 200 with invalid data', () async {
    mockHttpData([{'invalid_key': 'invalid_value'}]);

    final surveys = sut.loadBySurvey();

    expect(surveys, throwsA(DomainError.unexpected));
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