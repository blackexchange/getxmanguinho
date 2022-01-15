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
  final AddAccount addAccount;
  //final Authentication authentication;
  final SaveCurrentAccount saveCurrentAccount;

  String _email;
  String _password;
  String _name;
  String _passwordConfirmation;

  var emailError = Rx<UIError>();
  var passwordError = Rx<UIError>();
  var passwordConfirmationError = Rx<UIError>();
  var nameError = Rx<UIError>();

  var mainError = Rx<UIError>();
  var navigateTo = RxString();
  var isFormValid = false.obs;
  var isLoading = false.obs;

  GetxSignUpPresenter(
      {@required this.validation,
      @required this.addAccount,
      @required this.saveCurrentAccount});

  void validateEmail(String email) {
    _email = email;
    emailError.value = _validateField(field: 'email', value: email);
    _validateForm();
  }

  void validateName(String name) {
    _name = name;
    nameError.value = _validateField(field: 'name', value: name);
    _validateForm();
  }

  void validatePassword(String password) {
    _password = password;
    passwordError.value = _validateField(field: 'password', value: password);
    _validateForm();
  }

  void validatePasswordConfirmation(String passwordConfirmation) {
    _passwordConfirmation = passwordConfirmation;
    passwordConfirmationError.value = _validateField(
        field: 'passwordConfirmation', value: passwordConfirmation);
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
        nameError.value == null &&
        passwordConfirmationError.value == null &&
        _name != null &&
        _email != null &&
        _passwordConfirmation != null &&
        _password != null;
  }

  Future<void> signUp() async {
    try {
      isLoading.value = true;
      final account = await addAccount.add(AddAccountParams(
          email: _email,
          password: _password,
          name: _name,
          passwordConfirmation: _passwordConfirmation));
      await saveCurrentAccount.save(account);
      navigateTo.value = '/surveys';
    } on DomainError catch (error) {
      switch (error) {
        case DomainError.emailInUse:
          mainError.value = UIError.emailInUse;
          break;
        default:
          mainError.value = UIError.unexpected;
      }

      isLoading.value = false;
    }
  }
}
