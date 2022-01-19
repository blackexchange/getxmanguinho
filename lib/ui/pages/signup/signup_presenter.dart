import 'package:get/get.dart';
import '../../helpers/errors/ui_error.dart';

abstract class SignUpPresenter {
  Rx<UIError> get emailError;
  Rx<UIError> get passwordError;
  Rx<UIError> get nameError;
  Rx<UIError> get passwordConfirmationError;

  Rx<UIError> get mainError;
  RxString get navigateTo;
  RxBool get isFormValid;
  RxBool get isLoading;

  void validateEmail(String email);
  void validatePassword(String password);
  void validateName(String name);
  void validatePasswordConfirmation(String passwordConfirmation);
  Future<void> signUp();
  void goToLogin();
}
