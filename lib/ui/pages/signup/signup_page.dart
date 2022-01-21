import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../helpers/helpers.dart';

import '../../components/components.dart';
import 'components/components.dart';
import 'signup_presenter.dart';

class SignUpPage extends StatelessWidget {
  final SignUpPresenter presenter;

  SignUpPage(this.presenter);

  @override
  Widget build(BuildContext context) {
    void _hideKeyBoard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      body: Builder(builder: (context) {
        presenter.isLoading.listen((isLoading) {
          if (isLoading) {
            showLoading(context);
          } else {
            hideLoading(context);
          }
        });

        presenter.mainError.listen((error) {
          if (error != null) {
            showErrorMessage(context, error.description);
          }
        });
        presenter.navigateTo.listen((page) {
          if (page?.isNotEmpty == true) {
            Get.offAllNamed(page);
          }
        });

        return GestureDetector(
          onTap: _hideKeyBoard,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                LoginHeader(),
                Headline1(text: 'Criar Conta'),
                Padding(
                  padding: EdgeInsets.all(32),
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        NomeInput(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: EmailInput(),
                        ),
                        PasswordInput(),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: PasswordConfirmationInput(),
                        ),
                        SignUpButton(),
                        FlatButton.icon(
                          onPressed: presenter.goToLogin,
                          icon: Icon(Icons.exit_to_app),
                          label: Text(R.strings.login),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
