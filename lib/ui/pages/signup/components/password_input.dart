import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/errors/ui_error.dart';
import '../signup_presenter.dart';
import '../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
              labelText: 'Senha',
              errorText: presenter.passwordError.value.isNull
                  ? null
                  : presenter.passwordError.value.description,
              icon: Icon(
                Icons.lock,
                color: Theme.of(context).primaryColorLight,
              )),
          obscureText: true,
          onChanged: presenter.validatePassword,
        ));
  }
}
