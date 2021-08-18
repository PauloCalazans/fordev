import '../entities/entities.dart';

abstract class LoadSurveysResult {
  Future<SurveyEntity?>? loadBySurvey({String surveyId});
}