import 'package:test/test.dart';
import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/usecases/usecases.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteSaveSurveyResult sut;
  late String url;
  late HttpClientSpy httpClient;
  late String answer;

  setUp(() {
    url = faker.internet.httpUrl();
    answer = faker.lorem.sentence();
    httpClient = HttpClientSpy();
    sut = RemoteSaveSurveyResult(url: url, httpClient: httpClient);
  });

  test('Should call HttpClient with correct values', () async {
    await sut.save(answer: answer);

    verify(() => httpClient.request(url: url, method: 'put', body: {'answer': answer}));
  });
}
