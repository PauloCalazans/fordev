import '../../domain/entities/entities.dart';

import '../http/http.dart';

class RemoteSurveyModel {
  final String id;
  final String question;
  final String dateTime;
  final bool didAnswer;

  RemoteSurveyModel({
    required this.id,
    required this.question,
    required this.dateTime,
    required this.didAnswer
  });

  factory RemoteSurveyModel.fromJson(Map json) {
    return RemoteSurveyModel(
      id: json['id'],
      question: json['question'],
      dateTime: json['date'],
      didAnswer: json['didAnswer'],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
    id: id,
    question: question,
    dateTime: DateTime.parse(dateTime),
    didAnswer: didAnswer
  );
}