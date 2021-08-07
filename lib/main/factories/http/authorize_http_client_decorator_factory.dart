import '../../../data/http/http.dart';
import '../../factories/factories.dart';
import '../../decorators/decorators.dart';

HttpClient makeAuthorizeHttpClientDecorator() {
  return AuthorizeHttpClientDecorator(
      decoratee: makeHttpAdapter(),
      fetchSecureCacheStorage: makeSecureStorageAdapter()
  );
}