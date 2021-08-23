import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';

class GetxSurveyResultPresenter implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final String surveyId;

  final _isLoading = true.obs;
  final _isSessionExpired = false.obs;
  final _surveyResult = Rxn<SurveyResultViewModel?>();

  Stream<bool?> get isLoadingStream => _isLoading.stream;
  Stream<bool?> get isSessionExpiredStream => _isSessionExpired.stream;
  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({ required this.loadSurveyResult, required this.surveyId });

  Future<void>? loadData() async {
    try {
      _isLoading.value = true;
      final surveyResult = await loadSurveyResult.loadBySurvey(surveyId: surveyId);
      _surveyResult.value = SurveyResultViewModel(
          surveyId: surveyResult!.surveyId,
          question: surveyResult.question,
          answers: surveyResult.answers.map((answer) => SurveyAnswerViewModel(
            image: answer.image,
            answer: answer.answer,
            percent: '${answer.percent}%',
            isCurrentAnswer: answer.isCurrentAnswer
          )).toList()
      );
    } on DomainError catch(error) {
      if(error == DomainError.accessDenied) {
        _isSessionExpired.value = true;
      } else {
        _surveyResult.addError(UIError.unexpected.description);
      }
    } finally {
      _isLoading.value = false;
    }
  }
}