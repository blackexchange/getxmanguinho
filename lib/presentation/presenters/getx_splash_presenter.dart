import 'package:get/get.dart';
import 'package:meta/meta.dart';
import 'package:testes/ui/pages/pages.dart';
import '../../domain/usecases/usecases.dart';

class GetxSplashPresenter implements SplashPresenter {
  var _navigateTo = RxString();
  final LoadCurrentAccount loadCurrentAccount;

  GetxSplashPresenter({@required this.loadCurrentAccount});

  RxString get navigateToController => _navigateTo;

  Future<void> checkAccount() async {
    try {
      final account = await loadCurrentAccount.load();
      _navigateTo.value = account.isNull ? '/login' : '/surveys';
    } catch (e) {
      _navigateTo.value = '/login';
    }
  }
}
