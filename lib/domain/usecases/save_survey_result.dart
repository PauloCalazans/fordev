import '../entities/entities.dart';

abstract class SaveSurveyResult {
  Future<SurveyResultEntity>? loadBySurvey({required String answer});
}