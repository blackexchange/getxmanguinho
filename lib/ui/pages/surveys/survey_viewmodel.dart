import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class SurveyViewModel extends Equatable {
  final String id;
  final String question;
  final String date;
  final bool didAnswer;
  List get props => ['id', 'question', 'date', 'didAswer'];

  SurveyViewModel({
    @required this.id,
    @required this.question,
    @required this.date,
    @required this.didAnswer,
  });
}
