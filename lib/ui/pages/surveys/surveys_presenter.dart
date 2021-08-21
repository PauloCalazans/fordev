import 'survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<bool?> get isLoadingStream;
  Stream<List<SurveyViewModel>?> get surveysStream;
  Stream<String?>? get navigateToStream;

  Future<void>? loadData();
  Future<void>? goToSurveyResult(String surveyId);
}