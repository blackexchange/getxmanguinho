import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:testes/ui/pages/login/login_presenter.dart';
import '../signup_presenter.dart';

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
