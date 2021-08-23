import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';

class GetxSurveysPresenter implements SurveysPresenter {
  final LoadSurveys loadSurveys;

  final _isLoading = true.obs;
  final _isSessionExpired = false.obs;
  final _surveys = Rxn<List<SurveyViewModel>>();
  var _navigateTo = RxnString(null);

  Stream<bool?> get isLoadingStream => _isLoading.stream;
  Stream<bool?> get isSessionExpiredStream => _isSessionExpired.stream;
  Stream<List<SurveyViewModel>?> get surveysStream => _surveys.stream;
  Stream<String?>? get navigateToStream => _navigateTo.stream;

  GetxSurveysPresenter({required this.loadSurveys});

  Future<void>? loadData() async {
    try {
      _isLoading.value = true;
      final surveys = await loadSurveys.loadBySurvey();
      _surveys.value = surveys!.map((survey) =>
          SurveyViewModel(
              id: survey.id,
              question: survey.question,
              date: DateFormat('dd MMM yyyy').format(survey.dateTime),
              didAnswer: survey.didAnswer
          )).toList();
    } on DomainError catch(error) {
      if(error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveys.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void>? goToSurveyResult(String surveyId) async {
    _navigateTo.value = '/survey_result/$surveyId';
  }
}