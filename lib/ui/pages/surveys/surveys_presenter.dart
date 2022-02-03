import './survey_viewmodel.dart';

abstract class SurveysPresenter {
  Stream<List<SurveyViewModel>> get surveysStream;
  Future<void> loadData();
}
