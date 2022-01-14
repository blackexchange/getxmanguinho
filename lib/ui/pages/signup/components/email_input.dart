import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/errors/errors.dart';
import '../signup_presenter.dart';
import '../../../helpers/helpers.dart';

class EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
              labelText: 'Email',
              errorText: presenter.emailError.value.isNull
                  ? null
                  : presenter.emailError.value.description,
              icon: Icon(
                Icons.email,
                color: Theme.of(context).primaryColorLight,
              )),
          keyboardType: TextInputType.emailAddress,
          onChanged: presenter.validateEmail,
        ));
  }
}
