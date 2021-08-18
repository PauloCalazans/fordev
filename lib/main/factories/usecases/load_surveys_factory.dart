import '../../composites/composites.dart';

import '../../../data/usecases/usecases.dart';
import '../../../domain/usecases/usecases.dart';
import '../factories.dart';

RemoteLoadSurveys makeRemoteLoadSurveys() {
  return RemoteLoadSurveys(
      httpClient: makeAuthorizeHttpClientDecorator(),
      url: makeApiUrl('survey')
  );
}

LocalLoadSurveys makeLocalLoadSurveys() => LocalLoadSurveys(cacheStorage: makeLocalStorageAdapter());

LoadSurveys makeRemoteLoadSurveysWithLocalFallback() =>
    RemoteLoadSurveysWithLocalFallback(
      remote: makeRemoteLoadSurveys(),
      local: makeLocalLoadSurveys()
    );