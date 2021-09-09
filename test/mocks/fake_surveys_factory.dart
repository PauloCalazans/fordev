import 'package:faker/faker.dart';
import 'package:fordev/domain/entities/entities.dart';
import 'package:fordev/ui/pages/pages.dart';

class FakeSurveysFactory {
  static List<Map> makeCacheJson() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(10),
      'date': '2021-08-05T00:00:00Z',
      'didAnswer': 'false'
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(10),
      'date': '2021-05-12T00:00:00Z',
      'didAnswer': 'true'
    }
  ];

  static List<Map> makeApiJson() => [
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String()
    },
    {
      'id': faker.guid.guid(),
      'question': faker.randomGenerator.string(50),
      'didAnswer': faker.randomGenerator.boolean(),
      'date': faker.date.dateTime().toIso8601String()
    }
  ];

  static List<Map> makeInvalidCacheJson() => [{
    'id': faker.guid.guid(),
    'question': faker.randomGenerator.string(10),
    'date': 'invalid date',
    'didAnswer': 'true'
  }];

  static List<Map> makeIncompleteCacheJson() => [{
    'date': DateTime(2021, 05, 12).toIso8601String(),
    'didAnswer': 'false'
  }];

  static List<Map> makeInvalidApiJson() => [ {'invalid_key': 'invalid_value'} ];

  static List<SurveyEntity> makeEntities() => [
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        dateTime: DateTime.utc(2021, 6, 1),
        didAnswer: true
    ),
    SurveyEntity(
        id: faker.guid.guid(),
        question: faker.randomGenerator.string(10),
        dateTime: DateTime.utc(2020, 5, 12),
        didAnswer: false
    )
  ];

  static List<SurveyViewModel> makeSurveys() {
    return [
      SurveyViewModel(id: '1', question: 'Question 1', date: 'Date 1', didAnswer: true),
      SurveyViewModel(id: '2', question: 'Question 2', date: 'Date 2', didAnswer: false),
    ];
  }
}