import '../../data/cache/cache.dart';
import '../../data/http/http.dart';

class AuthorizeHttpClientDecorator implements HttpClient {
  final FetchSecureCacheStorage fetchSecureCacheStorage;
  final DeleteSecureCacheStorage deleteSecureCacheStorage;
  final HttpClient decoratee;

  AuthorizeHttpClientDecorator({
    required this.fetchSecureCacheStorage,
    required this.deleteSecureCacheStorage,
    required this.decoratee
  });

  Future<dynamic> request({
    required String url,
    required String method,
    Map? body,
    Map? headers
  }) async {
    String key = 'token';
    try {
      var token = await fetchSecureCacheStorage.fetch(key);
      final authorizedHeaders = headers ?? {}..addAll({'x-access-token': token});
      return decoratee.request(url: url, method: method, body: body, headers: authorizedHeaders);
    } catch(error) {
      if(error is HttpError && error != HttpError.forbidden) {
        rethrow;
      }

      await deleteSecureCacheStorage.delete(key);
      throw HttpError.forbidden;
    }
  }
}