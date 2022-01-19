import 'package:get/get.dart';
import '../../helpers/errors/ui_error.dart';

abstract class LoginPresenter {
  Rx<UIError> get emailError;
  Rx<UIError> get passwordError;
  Rx<UIError> get mainError;
  RxString get navigateTo;
  RxBool get isFormValid;
  RxBool get isLoading;

  void validateEmail(String email);
  void validatePassword(String password);
  Future<void> auth();
  void goToSignUp();
}
