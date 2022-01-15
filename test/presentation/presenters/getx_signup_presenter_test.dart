import 'package:faker/faker.dart';

import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'package:testes/domain/entities/account_entity.dart';
import 'package:testes/domain/helpers/helpers.dart';
import 'package:testes/domain/usecases/usecases.dart';

import 'package:testes/presentation/protocols/protocols.dart';
import 'package:testes/presentation/presenters/presenters.dart';

import 'package:testes/ui/helpers/errors/errors.dart';

class ValidationSpy extends Mock implements Validation {}

class AddAccountSpy extends Mock implements AddAccount {}

class SaveCurrentAccountSpy extends Mock implements SaveCurrentAccount {}

void main() {
  GetxSignUpPresenter sut;
  ValidationSpy validation;
  SaveCurrentAccount saveCurrentAccount;

  AddAccountSpy addAccount;
  String email;
  String name;

  String password;
  String passwordConfirmation;
  String token;

  PostExpectation mockValidationCall(String field) => when(validation.validate(
      field: field == null ? anyNamed('field') : field,
      value: anyNamed('value')));

  void mockValidation({String field, ValidationError value}) {
    mockValidationCall(field).thenReturn(value);
  }

  PostExpectation mockAddAccountCall() => when(addAccount.add(any));

  void mockAddAccount() {
    mockAddAccountCall().thenAnswer((_) async => (AccountEntity(token: token)));
  }

  void mockAddAccountError(DomainError error) {
    mockAddAccountCall().thenThrow(error);
  }

  PostExpectation mockSaveCurrentAccountCall() =>
      when(saveCurrentAccount.save(any));

  void mockSaveCurrentAccountError() {
    mockSaveCurrentAccountCall().thenThrow(DomainError.unexpected);
  }

  setUp(() {
    validation = ValidationSpy();
    addAccount = AddAccountSpy();
    saveCurrentAccount = SaveCurrentAccountSpy();

    sut = GetxSignUpPresenter(
        validation: validation,
        addAccount: addAccount,
        saveCurrentAccount: saveCurrentAccount);
    email = faker.internet.email();
    name = faker.person.name();

    password = faker.internet.password();
    passwordConfirmation = faker.internet.password();
    token = faker.guid.guid();
    mockValidation();
    mockAddAccount();
  });

  //NOME
  test('Should call Validation with correct name', () {
    sut.validateName(email);

    verify(validation.validate(field: 'name', value: email)).called(1);
  });

  test('Should emit invalidField if name is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.nameError
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit requiredField error if name empty ', () {
    mockValidation(value: ValidationError.requiredField);

    sut.nameError
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });

  test('Should emit null if validation succeeds', () {
    sut.nameError.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateName(name);
    sut.validateName(name);
  });
  //EMAIL
  test('Should call Validation with correct email', () {
    sut.validateEmail(email);

    verify(validation.validate(field: 'email', value: email)).called(1);
  });

  test('Should emit invalidField if email is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.emailError
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validateEmail(email);
  });

  test('Should emit requiredField error if email empty ', () {
    mockValidation(value: ValidationError.requiredField);

    sut.emailError
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));

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
  test('Should call Validation with correct password', () {
    sut.validatePassword(password);

    verify(validation.validate(field: 'password', value: password)).called(1);
  });

  test('Should emit invalidField if password is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordError
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit requiredField error if password empty ', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordError
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordError.listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePassword(password);
    sut.validatePassword(password);
  });

//PASSWORD CONFIRMATION
  test('Should call Validation with correct passwordConfirmation', () {
    sut.validatePasswordConfirmation(passwordConfirmation);

    verify(validation.validate(
            field: 'passwordConfirmation', value: passwordConfirmation))
        .called(1);
  });

  test('Should emit invalidField if passwordConfirmation is invalid', () {
    mockValidation(value: ValidationError.invalidField);

    sut.passwordConfirmationError
        .listen(expectAsync1((error) => expect(error, UIError.invalidField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit requiredField error if passwordConfirmation empty ', () {
    mockValidation(value: ValidationError.requiredField);

    sut.passwordConfirmationError
        .listen(expectAsync1((error) => expect(error, UIError.requiredField)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should emit null if validation succeeds', () {
    sut.passwordConfirmationError
        .listen(expectAsync1((error) => expect(error, null)));

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

//BOTOES
  test('Should disable form button if any field is invalid', () {
    mockValidation(field: 'email', value: ValidationError.invalidField);

    sut.isFormValid.listen(expectAsync1((isValid) => expect(isValid, false)));

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validateName(name);
    sut.validatePasswordConfirmation(passwordConfirmation);
  });

  test('Should enable form button if all fields are valide', () async {
    expectLater(sut.isFormValid.stream, emitsInOrder([false, true]));

    sut.validateEmail(email);
    await Future.delayed(Duration.zero);
    sut.validatePassword(password);
    await Future.delayed(Duration.zero);
    sut.validatePasswordConfirmation(passwordConfirmation);
    await Future.delayed(Duration.zero);
    sut.validateName(name);
  });

//SIGNUP
  test('Should call SIgnUp with correct param', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);
    await sut.signUp();
    verify(addAccount.add(AddAccountParams(
            email: email,
            password: password,
            name: name,
            passwordConfirmation: passwordConfirmation)))
        .called(1);
  });

  test('Should call SaveCurrentAccount with correct values', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);
    await sut.signUp();
    verify(saveCurrentAccount.save(AccountEntity(token: token))).called(1);
  });

  test('Should emit UnexpectedError if SaveCurrent Account Fails', () async {
    mockSaveCurrentAccountError();

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));
    sut.mainError
        .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.signUp();
  });

  test('Should emit correct events on add account operation success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoading.stream, emits(true));

    await sut.signUp();
  });

  test('Should page change on success', () async {
    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);
    sut.navigateTo.listen(expectAsync1((page) => expect(page, '/surveys')));

    await sut.signUp();
  });

  test('Should emit correct events on Invalid In Use ', () async {
    mockAddAccountError(DomainError.emailInUse);

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));
    sut.mainError
        .listen(expectAsync1((error) => expect(error, UIError.emailInUse)));

    await sut.signUp();
  });

  test('Should emit correct events on Invalid UnexpectedError', () async {
    mockAddAccountError(DomainError.unexpected);

    sut.validateEmail(email);
    sut.validatePassword(password);
    sut.validatePasswordConfirmation(passwordConfirmation);
    sut.validateName(name);

    expectLater(sut.isLoading.stream, emitsInOrder([true, false]));
    sut.mainError
        .listen(expectAsync1((error) => expect(error, UIError.unexpected)));

    await sut.signUp();
  });
}
