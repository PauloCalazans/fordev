import '../../domain/entities/entities.dart';

class LocalSurveyModel {
  final String id;
  final String question;
  final DateTime dateTime;
  final bool didAnswer;

  LocalSurveyModel({
    required this.id,
    required this.question,
    required this.dateTime,
    required this.didAnswer
  });

  factory LocalSurveyModel.fromJson(Map json) {
    if(!json.keys.toSet().containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw Exception();
    }

    return LocalSurveyModel(
        id: json['id'],
        question: json['question'],
        dateTime: DateTime.parse(json['date']),
        didAnswer: bool.fromEnvironment(json['didAnswer'])
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: id,
    question: question,
    dateTime: dateTime,
    didAnswer: didAnswer
  );
}