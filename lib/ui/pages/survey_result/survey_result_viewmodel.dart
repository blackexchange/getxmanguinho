//import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'survey_result.dart';

class SurveyResultViewModel {
  final String surveyId;
  final String question;
  final List<SurveyAnswerViewModel> answers;
  // List get props => ['id', 'question', 'date', 'didAswer'];

  SurveyResultViewModel({
    @required this.surveyId,
    @required this.question,
    @required this.answers,
  });
}
