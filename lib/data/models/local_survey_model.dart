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
        didAnswer: json['didAnswer'].toLowerCase() == 'true'
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: id,
    question: question,
    dateTime: dateTime,
    didAnswer: didAnswer
  );

  factory LocalSurveyModel.fromEntity(SurveyEntity entity) {
    return LocalSurveyModel(
        id: entity.id,
        question: entity.question,
        dateTime: entity.dateTime,
        didAnswer: entity.didAnswer
    );
  }

  Map<String, String> toJson() => {
    'id': id,
    'question': question,
    'dateTime': dateTime.toIso8601String(),
    'didAnswer': didAnswer.toString()
  };
}