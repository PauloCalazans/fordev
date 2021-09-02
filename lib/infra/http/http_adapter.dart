import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapater implements HttpClient {
  final Client client;

  HttpAdapater(this.client);

  Future request({
    required String url,
    required String method,
    Map? body,
    Map? headers
  }) async {
    final defaultHeaders = headers?.cast<String, String>() ?? {}..addAll({
      'content-type': 'application/json',
      'accept': 'application/json'
    });
    final requestBody = body != null ? jsonEncode(body) : null;
    var response = Response('', 500);
    try {
      late Future<Response> futureResponse;
      if (method == 'post') {
        futureResponse = client.post(Uri.parse(url), headers: defaultHeaders, body: requestBody);
      } else if (method == 'get') {
        futureResponse = client.get(Uri.parse(url), headers: defaultHeaders);
      }

      response = await futureResponse.timeout(Duration(seconds: 5));

    } catch(error) {
      throw HttpError.serverError;
    }
    return _handleResponse(response);
  }

  Map? _handleResponse(Response response) {
    if(response.statusCode == 200) {
      return response.body.isEmpty ? null : jsonDecode(response.body);
    } else if (response.statusCode == 204) {
      return null;
    } else if(response.statusCode == 400) {
      throw HttpError.badRequest;
    } else if(response.statusCode == 401) {
      throw HttpError.unauthorized;
    } else if(response.statusCode == 403) {
      throw HttpError.forbidden;
    } else if(response.statusCode == 404) {
      throw HttpError.notFound;
    } else {
      throw HttpError.serverError;
    }
  }
}