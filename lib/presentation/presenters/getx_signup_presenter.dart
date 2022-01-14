import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:testes/ui/pages/pages.dart';
import '../../ui/helpers/errors/errors.dart';

import '../../ui/pages/login/login_presenter.dart';
import '../../domain/helpers/helpers.dart';
import '../../domain/usecases/usecases.dart';

import '../protocols/protocols.dart';

class GetxSignUpPresenter extends GetxController {
  final Validation validation;
  final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;

  var emailError = Rx<UIError>();
  var passwordError = Rx<UIError>();
  var mainError = Rx<UIError>();
  var navigateTo = RxString();
  var isFormValid = false.obs;
  var isLoading = false.obs;

  GetxSignUpPresenter(
      {@required this.validation,
      @required this.authentication,
      @required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  UIError _validateField({String field, String value}) {
    final error = validation.validate(field: field, value: value);

    switch (error) {
      case ValidationError.invalidField:
        return UIError.invalidField;
      case ValidationError.requiredField:
        return UIError.requiredField;
      default:
        return null;
    }
  }

  void _validateForm() {
    isFormValid.value = emailError.value == null &&
        passwordError.value == null &&
        _email != null &&
        _password != null;
  }

  Future<void> auth() async {
    try {
      isLoading.value = true;
      final account = await authentication
          .auth(AuthenticationParams(email: _email, secret: _password));
      await saveCurrentAccount.save(account);
      navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.invalidCredentials:
          mainError.value = UIError.invalidCredentials;
          break;
        default:
          mainError.value = UIError.unexpected;
      }

      isLoading.value = false;
    }
  }
}
