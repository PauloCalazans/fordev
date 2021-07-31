class SurveyViewModel {
  final String id;
  final String question;
  final String data;
  final bool didAnswer;

  SurveyViewModel({
    required this.id,
    required this.question,
    required this.data,
    required this.didAnswer
  });
}