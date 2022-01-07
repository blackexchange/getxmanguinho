import 'package:faker/faker.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import 'package:testes/domain/entities/entities.dart';
import 'package:testes/domain/usecases/usecases.dart';
import 'package:testes/presentation/presenters/presenters.dart';

class LoadCurrentAccountSpy extends Mock implements LoadCurrentAccount {}

void main() {
  LoadCurrentAccountSpy loadCurrentAccount;
  GetxSplashPresenter sut;

  PostExpectation mockLoadCurrentAccountCall() =>
      when(loadCurrentAccount.load());

  void mockLoadCurrentAccount({AccountEntity account}) {
    mockLoadCurrentAccountCall().thenAnswer((_) async => account);
  }

  void mockLoadCurrentError() {
    mockLoadCurrentAccountCall().thenThrow(Exception());
  }

  setUp(() {
    loadCurrentAccount = LoadCurrentAccountSpy();
    sut = GetxSplashPresenter(loadCurrentAccount: loadCurrentAccount);
    mockLoadCurrentAccount(account: AccountEntity(faker.guid.guid()));
  });
  test('Should call LoadCurrentAccount', () async {
    await sut.checkAccount();
    verify(loadCurrentAccount.load()).called(1);
  });

  test('Should go to surveys on success', () async {
    sut.navigateToController
        .listen(expectAsync1((page) => expect(page, '/surveys')));
    await sut.checkAccount();
  });

  test('Should go to login on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToController
        .listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });

  test('Should go to login on null result', () async {
    mockLoadCurrentAccount(account: null);

    sut.navigateToController
        .listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });

  test('Should go to login on error', () async {
    mockLoadCurrentError();

    sut.navigateToController
        .listen(expectAsync1((page) => expect(page, '/login')));
    await sut.checkAccount();
  });
}
