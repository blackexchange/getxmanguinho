import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/errors/ui_error.dart';
import '../login_presenter.dart';
import '../../../helpers/helpers.dart';

class PasswordInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<LoginPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
              labelText: 'Senha',
              errorText: presenter.passwordError.isNull
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
