import 'package:meta/meta.dart';
import '../http/http.dart';
import '../../domain/entities/entities.dart';

class RemoteSurveysModel {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;

  RemoteSurveysModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });

  factory RemoteSurveysModel.fromJson(Map json) {
    if (!json.keys
        .toSet()
        .containsAll(['id', 'question', 'date', 'didAnswer'])) {
      throw HttpError.invalidData;
    }
    return RemoteSurveysModel(
      id: json['id'],
      question: json['question'],
      date: json['date'],
      didAnswer: json['didAnswer'],
    );
  }

  SurveyEntity toEntity() => SurveyEntity(
        id: id,
        question: question,
        dateTime: DateTime.parse(date),
        didAnswer: didAnswer,
      );
}
