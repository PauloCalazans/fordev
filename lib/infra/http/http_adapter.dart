import 'dart:convert';

import 'package:http/http.dart';

import '../../data/http/http.dart';

class HttpAdapater implements HttpClient {
  final Client client;

  HttpAdapater(this.client);

  Future<Map?>? request({
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
    } else {
      throw HttpError.serverError;
    }
  }
}