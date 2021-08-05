import 'package:faker/faker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';
import 'package:fordev/data/cache/cache.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({required this.fetchSecureCacheStorage, required this.decoratee});

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers
  }) async {
    try {
      var token = await fetchSecureCacheStorage.fetchSecure('token');
      final authorizedHeaders = headers ?? {}..addAll({'x-access-token': token});
      return decoratee.request(url: url, method: method, body: body, headers: authorizedHeaders);
    } catch(error) {
      throw HttpError.forbidden;
    }
  }
}

class FetchSecureCacheStorageSpy extends Mock implements FetchSecureCacheStorage {}
class HttpClientSpy extends Mock implements HttpClient {}

void main() {
  late FetchSecureCacheStorageSpy fetchSecureCacheStorage;
  late AuthorizeHttpClientDecorator sut;
  late String url;
  late String method;
  late Map body;
  late HttpClientSpy httpClient;
  late String token;
  late String httpResponse;

  When mockTokenCall() => when(() => fetchSecureCacheStorage.fetchSecure(any()));

  void mockToken() {
    token = faker.guid.guid();
    mockTokenCall().thenAnswer((_) async => token);
  }

  void mockTokenError() {
    mockTokenCall().thenThrow(Exception());
  }

  void mockHttpResponse() {
    httpResponse = faker.randomGenerator.string(50);
    when(() => httpClient.request(
      url: any(named: 'url'),
      method: any(named: 'method'),
      body: any(named: 'body'),
      headers: any(named: 'headers')
    )).thenAnswer((_) async => httpResponse);
  }

  setUp(() {
    fetchSecureCacheStorage = FetchSecureCacheStorageSpy();
    httpClient = HttpClientSpy();
    sut = AuthorizeHttpClientDecorator(
      fetchSecureCacheStorage: fetchSecureCacheStorage,
      decoratee: httpClient
    );
    url = faker.internet.httpUrl();
    method = faker.randomGenerator.string(10);
    body = {'any_key': 'any_value'};
    mockToken();
    mockHttpResponse();
  });

  test('Should call FetchSecureCacheStorage with correct key', () async {
    await sut.request(url: url, method: method, body: body);

    verify(() => fetchSecureCacheStorage.fetchSecure('token')).called(1);
  });

  test('Should call decoratee with access token on header', () async {
    await sut.request(url: url, method: method, body: body);
    verify(() => httpClient.request(url: url, method: method, body: body, headers: {'x-access-token': token})).called(1);

    await sut.request(url: url, method: method, body: body, headers: {'any_header': 'any_value'});
    verify(() => httpClient.request(
        url: url,
        method: method,
        body: body,
        headers: {'x-access-token': token, 'any_header': 'any_value'}
      )
    ).called(1);
  });

  test('Should return same result as decoratee', () async {
    final response = await sut.request(url: url, method: method, body: body);

    expect(response, httpResponse);
  });

  test('Should throw ForbiddenError if FetchSecureCacheStorage throws', () {
    mockTokenError();

    final future = sut.request(url: url, method: method, body: body);

    expect(future, throwsA(HttpError.forbidden));
  });

}