import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import 'package:testes/ui/pages/pages.dart';

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
                return Padding(
                  padding: EdgeInsets.all(40),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          snapshot.error,
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          onPressed: presenter.loadData,
                          child: Text('Recarregar'),
                        )
                      ]),
                );
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
              return Center(
                child: CircularProgressIndicator(),
              );
            }));
  }
}
