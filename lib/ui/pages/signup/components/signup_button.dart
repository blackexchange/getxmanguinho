import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../signup_presenter.dart';
import '../../../helpers/helpers.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();

    return Obx(() => RaisedButton(
          onPressed:
              presenter.isFormValid?.value == true ? presenter.signUp : null,
          child: Text('Criar Conta'),
        ));
  }
}
