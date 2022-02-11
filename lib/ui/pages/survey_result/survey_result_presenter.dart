import './survey_result.dart';

abstract class SurveyResultPresenter {
  Stream<SurveyResultViewModel> get surveyResultStream;
  Stream<bool> get isLoadingStream;
  Future<void> loadData();
}
