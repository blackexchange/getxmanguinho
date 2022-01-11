import 'package:get/get.dart';

abstract class SplashPresenter {
  RxString get navigateToController;
  Future<void> checkAccount({int durationInSeconds});
}
