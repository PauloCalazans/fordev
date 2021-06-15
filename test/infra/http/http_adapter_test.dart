import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:fordev/data/http/http.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapater implements HttpClient {
  final Client client;

  HttpAdapater(this.client);

  Future<Map>? request({
    required String url,
    required String method,
    Map? body
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    final requestBody = body != null ? jsonEncode(body) : null;

    var response = await client.post(
        Uri.parse(url),
        headers: headers,
        body: requestBody
    );

    return jsonDecode(response.body);
  }
}


@GenerateMocks([Client], customMocks: [MockSpec<HttpAdapater>(returnNullOnMissingStub: true)])
void main() {
  late HttpAdapater sut;
  late MockClient client;
  late String url;

  setUp(() {
    client = MockClient();
    sut = HttpAdapater(client);
    url = faker.internet.httpUrl();
  });

  group('post', () {

    test('Should call post with correct values', () async {
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      await sut.request(url: url, method: 'post', body: {'any_key': 'any_value'});

      verify(
        client.post(
            Uri.parse(url),
            headers: {
              'content-type': 'application/json',
              'accept': 'application/json'
            },
            body: '{"any_key":"any_value"}'
          )
      );
    });

    test('Should call post without body', () async {
      when(client.post(any, body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));
      await sut.request(url: url, method: 'post');

      verify(
          client.post(
              any,
              headers: anyNamed('headers')
          )
      );
    });

    test('Should return data if post returns 200', () async {
      when(client.post(any, headers: anyNamed('headers')))
      .thenAnswer((_) async => Response('{"any_key": "any_value"}', 200));

      final response = await sut.request(url: url, method: 'post');

      expect(response, {"any_key": "any_value"});
    });
  });
}