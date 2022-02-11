import 'package:flutter/material.dart';

import '../../../ui/components/components.dart';
import '../../../ui/pages/pages.dart';
import 'components/components.dart';
import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
    return Scaffold(
        appBar: AppBar(title: Text('Enquetes')),
        body: StreamBuilder<List<SurveyViewModel>>(
            stream: presenter.surveysStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return ReloadScreen(
                    error: snapshot.error, reload: presenter.loadData);
              }
              if (snapshot.hasData) {
                return SurveyItems(snapshot.data);
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
