import 'package:faker/faker.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:testes/domain/entities/account_entity.dart';
import 'package:testes/domain/helpers/domain_error.dart';
import 'package:testes/presentation/protocols/protocols.dart';
import 'package:testes/presentation/presenters/presenters.dart';

import 'package:testes/domain/usecases/usecases.dart';

class ValidationSpy extends Mock implements Validation {}

class AuthenticationSpy extends Mock implements Authentication {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxLoginPresenter sut;
  ValidationSpy validation;
  SaveCurrentAccount saveCurrentAccount;

  AuthenticationSpy authentication;
  String email;
  String password;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, String value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAuthenticationCall() => when(authentication.auth(any));

  void mockAuthentication() {
    mockAuthenticationCall().thenAnswer((_) async => (AccountEntity(token)));
  }

  void mockAuthenticationError(DomainError error) {
    mockAuthenticationCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    authentication = AuthenticationSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxLoginPresenter(
        validation: validation,
        authentication: authentication,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    password = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAuthentication();
  });
  test('Should call Validation with corretc email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit email error if validation fails', () {
    mockValidation(value: 'error');

    sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit null if validation succeeds', () {
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  //PASSWORD

  test('Should call Validation with corretc password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(value: 'error');

    sut.passwordError.listen(expectAsync1((error) => expect(error, 'error')));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation succeeds', () {
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit password error if validation fails', () {
    mockValidation(field: 'email', value: 'error');

    sut.emailError.listen(expectAsync1((error) => expect(error, 'error')));

    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
  });

  test('Should emit form password invalid', () async {
    sut.emailError.listen(expectAsync1((error) => expect(error, null)));

    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));

    expectLater(sut.isFormValid.stream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
  });

  test('Should call auth with correct param', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(authentication
            .auth(AuthenticationParams(email: email, secret: password)))
        .called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    await sut.auth();
    verify(saveCurrentAccount.save(AccountEntity(token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrent Account Fails', () async {
    mockSaveCurrentAccountError();

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));
    sut.mainError.listen(
        expectAsync1((error) => expect(error, 'Algo errado aconteceu.')));

    await sut.auth();
  });

  test('Should emit correct events on Auth operation success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoading.stream, emits(true));

    await sut.auth();
  });

  test('Should page change on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);

    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.auth();
  });

  test('Should emit correct events on Invalid CredentialsError', () async {
    mockAuthenticationError(DomainError.invalidCredentials);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));
    sut.mainError.listen(
        expectAsync1((error) => expect(error, 'Credenciais inválidas.')));

    await sut.auth();
  });

  test('Should emit correct events on Invalid UnexpectedError', () async {
    mockAuthenticationError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));
    sut.mainError.listen(
        expectAsync1((error) => expect(error, 'Algo errado aconteceu.')));

    await sut.auth();
  });
}
