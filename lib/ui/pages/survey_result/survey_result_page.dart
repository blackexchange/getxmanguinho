import 'package:flutter/material.dart';
import 'package:testes/ui/pages/survey_result/survey_result.dart';
import '../../components/components.dart';

import './survey_result_presenter.dart';
import './components/components.dart';

class SurveyResultPage extends StatelessWidget {
  final SurveyResultPresenter presenter;

  SurveyResultPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Enquetes')),
        body: Builder(builder: (context) {
          presenter.isLoadingStream.listen((isLoading) {
            if (isLoading == true) {
              showLoading(context);
            } else {
              hideLoading(context);
            }
          });
          presenter.loadData();

          return StreamBuilder<SurveyResultViewModel>(
              stream: presenter.surveyResultStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ReloadScreen(
                      error: snapshot.error, reload: presenter.loadData);
                }
                if (snapshot.hasData) {
                  return SurveyResult(snapshot.data);
                }
                return SizedBox(height: 0);
              });
        }));
  }
}
