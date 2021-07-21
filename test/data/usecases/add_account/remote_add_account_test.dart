import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/domain/helpers/helpers.dart';
import 'package:fordev/domain/usecases/usecases.dart';

import 'package:fordev/data/usecases/usecases.dart';
import 'package:fordev/data/http/http.dart';

class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late RemoteAddAccount sut;
  late HttpClientSpy httpClient;
  late String url;
  late AddAccountParams params;

  When mockRequest() => when(() => httpClient.request(url: any(named: 'url'), method: any(named: 'method') , body: any(named: 'body')));

  void mockHttpError(HttpError error) {
    mockRequest().thenThrow(error);
  }

  setUp(() {
    httpClient = HttpClientSpy();
    url = faker.internet.httpUrl();
    sut = RemoteAddAccount(httpClient: httpClient, url: url);
    params = AddAccountParams(
        name: faker.person.name(),
        email: faker.internet.email(),
        password: faker.internet.password(),
        passwordConfirmation: faker.internet.password()
    );
  });

  test('Should call HttpClient with correct values', () async {
    await sut.add(params);

    verify(() =>
        httpClient.request(
            url: url,
            method: 'post',
            body: {
              'name': params.name,
              'email': params.email,
              'password': params.password,
              'passwordConfirmation': params.passwordConfirmation
            }
        )
    );
  });

  test('Should throw UnexpectedError if HttClient returns 400', () async {
    mockHttpError(HttpError.badRequest);

    final future = sut.add(params);

    expect(future, throwsA(DomainError.unexpected));
  });
}