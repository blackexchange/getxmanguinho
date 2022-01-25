import 'dart:async';

import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:testes/ui/pages/surveys/survey_viewmodel.dart';
import 'package:testes/ui/pages/surveys/surveys_presenter.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../ui/pages/login/login_presenter.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxSurveysPresenter {
  final LoadSurveys loadSurveys;

  GetxSurveysPresenter({@required this.loadSurveys});

  var mainError = Rx<UIError>();
  var navigateTo = RxString();
  var isFormValid = false.obs;
  var isLoading = false.obs;
  var loadSurveysList = RxList<SurveyViewModel>();
  var loadSurveysController;

  Future<void> loadData() async {
    try {
      mainError.value = null;
      isLoading.value = true;
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError.value = UIError.invalidCredentials;
          break;
        default:
          mainError.value = UIError.unexpected;
      }

      isLoading.value = false;
    }
  }
}
