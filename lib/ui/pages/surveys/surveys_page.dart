import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:testes/ui/pages/pages.dart';

import '../../components/components.dart';
import 'components/components.dart';
import '../../helpers/helpers.dart';

import 'surveys_presenter.dart';

class SurveysPage extends StatelessWidget {
  final SurveysPresenter presenter;

  SurveysPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    presenter.loadData();
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

          return StreamBuilder<List<SurveyViewModel>>(
              stream: presenter.laodSurveysStream,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Column(children: [
                    Text(snapshot.error),
                    RaisedButton(
                      onPressed: presenter.loadData,
                      child: Text('Recarregar'),
                    )
                  ]);
                }
                if (snapshot.hasData) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: CarouselSlider(
                      options: CarouselOptions(
                          aspectRatio: 1, enlargeCenterPage: true),
                      items: snapshot.data
                          .map((viewModel) => SurveyItem(viewModel))
                          .toList(),
                    ),
                  );
                }
                return SizedBox(height: 0);
              });
        }));
  }
}
