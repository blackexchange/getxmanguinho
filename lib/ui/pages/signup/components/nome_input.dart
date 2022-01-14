import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../helpers/errors/errors.dart';
import '../signup_presenter.dart';
import '../../../helpers/helpers.dart';

class NomeInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final presenter = Get.find<SignUpPresenter>();

    return Obx(() => TextFormField(
          decoration: InputDecoration(
              labelText: 'Nome',
              errorText: presenter.nameError.value.isNull
                  ? null
                  : presenter.nameError.value.description,
              icon: Icon(
                Icons.person_add,
                color: Theme.of(context).primaryColorLight,
              )),
          keyboardType: TextInputType.name,
          onChanged: presenter.validateName,
        ));
  }
}
