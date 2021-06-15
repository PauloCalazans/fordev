import 'dart:convert';

import 'package:faker/faker.dart';
import 'package:http/http.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'http_adapter_test.mocks.dart';

class HttpAdapater {
  final Client client;

  HttpAdapater(this.client);

  Future<void>? request({
    required String url,
    required String method,
    Map? body
  }) async {
    final headers = {
      'content-type': 'application/json',
      'accept': 'application/json'
    };
    await client.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body)
    );
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
  });
}