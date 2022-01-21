import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../ui/pages/pages.dart';
import '../../factories.dart';

Widget makeSignUpPage() {
  final presenter = Get.put<SignUpPresenter>(makeGetxSignUpPresenter());
  return SignUpPage(presenter);
}
