import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testes/ui/helpers/errors/ui_error.dart';

import 'package:testes/ui/pages/pages.dart';

class SignUpPresenterSpy extends Mock implements SignUpPresenter {}

void main() {
  SignUpPresenter presenter;

  var emailError = Rx<UIError>();
  var passwordError = Rx<UIError>();
  var passwordConfirmationError = Rx<UIError>();
  var nameError = Rx<UIError>();

  var mainError = Rx<UIError>();
  var navigateTo = RxString();
  var isFormValid = RxBool();
  var isLoading = RxBool();

  void mockStreams() {
    when(presenter.nameError).thenAnswer((_) => nameError);
    when(presenter.emailError).thenAnswer((_) => emailError);
    when(presenter.passwordError).thenAnswer((_) => passwordError);
    when(presenter.passwordConfirmationError)
        .thenAnswer((_) => passwordConfirmationError);

    when(presenter.isFormValid).thenAnswer((_) => isFormValid);
    when(presenter.isLoading).thenAnswer((_) => isLoading);
    when(presenter.mainError).thenAnswer((_) => mainError);
    when(presenter.navigateTo).thenAnswer((_) => navigateTo);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<SignUpPresenter>(SignUpPresenterSpy());
    mockStreams();

    final signUpPage = GetMaterialApp(
      initialRoute: '/signUp',
      getPages: [
        GetPage(name: '/signUp', page: () => SignUpPage(presenter)),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(signUpPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(
        of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(nameTextChildren, findsOneWidget,
        reason:
            'Busca mais de um campo texto no input. Se houver significa que tem erro no campo.');

    final emailTextChildren = find.descendant(
        of: find.bySemanticsLabel('Email'), matching: find.byType(Text));

    expect(emailTextChildren, findsOneWidget,
        reason:
            'Busca mais de um campo texto no input. Se houver significa que tem erro no campo.');

    final passwordTextChildren = find.descendant(
        of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(passwordTextChildren, findsOneWidget,
        reason:
            'Busca mais de um campo texto no input. Se houver significa que tem erro no campo.');

    final passwordConfirmationTextChildren = find.descendant(
        of: find.bySemanticsLabel('Confirmar Senha'),
        matching: find.byType(Text));
    expect(passwordConfirmationTextChildren, findsOneWidget,
        reason:
            'Busca mais de um campo texto no input. Se houver significa que tem erro no campo.');

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should validate with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final nome = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Nome'), nome);
    verify(presenter.validateName(nome));

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);
    verify(presenter.validatePassword(senha));

    final senhaConfirma = faker.internet.password();
    await tester.enterText(
        find.bySemanticsLabel('Confirmar Senha'), senhaConfirma);
    verify(presenter.validatePasswordConfirmation(senhaConfirma));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = UIError.invalidField;
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    emailError.value = UIError.requiredField;
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    emailError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present name error', (WidgetTester tester) async {
    await loadPage(tester);

    nameError.value = UIError.invalidField;
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    nameError.value = UIError.requiredField;
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    nameError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present Senha ', (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = UIError.invalidField;
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    passwordError.value = UIError.requiredField;
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Nome'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present Senha Confirmação', (WidgetTester tester) async {
    await loadPage(tester);

    passwordConfirmationError.value = UIError.invalidField;
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);

    passwordConfirmationError.value = UIError.requiredField;
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);

    passwordConfirmationError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Confirmar Senha'),
            matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should enable button is form ', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = true;
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('Should enable button is form is valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = false;
    await tester.pump();

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);
  });

  testWidgets('Should call function', (WidgetTester tester) async {
    await loadPage(tester);

    isFormValid.value = true;
    final button = find.byType(RaisedButton);
    await tester.pump();
    await tester.ensureVisible(button);
    await tester.tap(button);

    await tester.pump();

    verify(presenter.signUp()).called(1);
  });
  testWidgets('Should call loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should hide loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();

    isLoading.value = false;
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should error signup error', (WidgetTester tester) async {
    await loadPage(tester);

    mainError.value = UIError.emailInUse;
    await tester.pump();

    expect(find.text('Email já está em uso.'), findsOneWidget);
  });
  testWidgets('Should error auth throws', (WidgetTester tester) async {
    await loadPage(tester);

    mainError.value = UIError.unexpected;
    await tester.pump();

    expect(find.text('Algo errado aconteceu.'), findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateTo.value = '/any_route';
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change load page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateTo.value = '';
    await tester.pump();
    expect(Get.currentRoute, '/signUp');

    navigateTo.value = null;
    await tester.pump();
    expect(Get.currentRoute, '/signUp');
  });
}
