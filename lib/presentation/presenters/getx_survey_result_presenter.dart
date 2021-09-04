import 'package:get/get.dart';

import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';
import '../../domain/entities/entities.dart';

import '../../ui/helpers/errors/errors.dart';
import '../../ui/pages/pages.dart';
import '../helpers/helpers.dart';
import '../mixins/mixins.dart';

class GetxSurveyResultPresenter extends GetxController with LoadingManager, SessionManager implements SurveyResultPresenter {
  final LoadSurveyResult loadSurveyResult;
  final SaveSurveyResult saveSurveyResult;
  final String surveyId;

  final _surveyResult = Rxn<SurveyResultViewModel?>();

  Stream<SurveyResultViewModel?> get surveyResultStream => _surveyResult.stream;

  GetxSurveyResultPresenter({
    required this.loadSurveyResult,
    required this.saveSurveyResult,
    required this.surveyId
  });

  Future<void>? loadData() async {
   _showResultOnAction(() => loadSurveyResult.loadBySurvey(surveyId: surveyId));
  }

  Future<void>? save({required String answer}) async {
    _showResultOnAction(() => saveSurveyResult.save(answer: answer));
  }

  Future<void>? _showResultOnAction(Future<SurveyResultEntity?>? action()) async {
    try {
      isLoading = true;
      final surveyResult = await action();
      _surveyResult.subject.add(surveyResult!.toViewModel());
    } on DomainError catch(error) {
      if(error == DomainError.accessDenied) {
        isSessionExpired = true;
      } else {
        _surveyResult.addError(UIError.unexpected.description);
      }
    } finally {
      isLoading = false;
    }
  }
}