import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../surveys.dart';

import './components.dart';

class SurveyItems extends StatelessWidget {
  final List<SurveyViewModel> viewModels;
  SurveyItems(this.viewModels);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: CarouselSlider(
        options: CarouselOptions(aspectRatio: 1, enlargeCenterPage: true),
        items: viewModels.map((viewModel) => SurveyItem(viewModel)).toList(),
      ),
    );
  }
}
