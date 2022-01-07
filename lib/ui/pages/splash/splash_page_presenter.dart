import 'package:get/get.dart';

abstract class SplashPresenter {
  RxString navigateToController;
  Future<void> loadCurrentAccount();
}
