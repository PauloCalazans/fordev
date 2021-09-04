import '../../../domain/entities/entities.dart';
import '../../../domain/helpers/helpers.dart';
import '../../../domain/usecases/save_survey_result.dart';

import '../../../data/models/models.dart';
import '../../http/http.dart';

class RemoteSaveSurveyResult implements SaveSurveyResult {
  final String url;
  final HttpClient httpClient;

  RemoteSaveSurveyResult({required this.url, required this.httpClient});

  Future<SurveyResultEntity>? save({required String answer}) async {
    try {
      final json = await httpClient.request(url: url, method: 'put', body: {'answer': answer});
      return RemoteSurveyResultModel.fromJson(json).toEntity();
    } on HttpError catch(error) {
      throw error == HttpError.forbidden ? DomainError.accessDenied : DomainError.unexpected;
    }

  }
}