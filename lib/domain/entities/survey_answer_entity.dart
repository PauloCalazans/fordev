class SurveyAnswerEntity {
    final String? image;
    final String answer;
    final bool isCurrentAnswer;
    final int percent;

  SurveyAnswerEntity({
    this.image,
    required this.answer,
    required this.isCurrentAnswer,
    required this.percent
  });

}