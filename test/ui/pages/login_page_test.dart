import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:testes/ui/pages/pages.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {
  LoginPresenter presenter;

  var emailError = RxString();
  var passwordError = RxString();
  var mainError = RxString();
  var navigateTo = RxString();
  var isFormValid = RxBool();
  var isLoading = RxBool();

  void mockStreams() {
    when(presenter.emailError).thenAnswer((_) => emailError);
    when(presenter.passwordError).thenAnswer((_) => passwordError);
    when(presenter.isFormValid).thenAnswer((_) => isFormValid);
    when(presenter.isLoading).thenAnswer((_) => isLoading);
    when(presenter.mainError).thenAnswer((_) => mainError);
    when(presenter.navigateTo).thenAnswer((_) => navigateTo);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<LoginPresenter>(LoginPresenterSpy());
    mockStreams();

    final loginPage = GetMaterialApp(
      initialRoute: '/login',
      getPages: [
        GetPage(name: '/login', page: () => LoginPage(presenter)),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  testWidgets('Should load with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

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

    final button = tester.widget<RaisedButton>(find.byType(RaisedButton));
    expect(button.onPressed, null);

    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should validate with correct initial state',
      (WidgetTester tester) async {
    await loadPage(tester);

    final email = faker.internet.email();
    await tester.enterText(find.bySemanticsLabel('Email'), email);
    verify(presenter.validateEmail(email));

    final senha = faker.internet.password();
    await tester.enterText(find.bySemanticsLabel('Senha'), senha);
    verify(presenter.validatePassword(senha));
  });

  testWidgets('Should present error if email is invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = 'any error';
    await tester.pump();
    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present if email valid', (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Email'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present if password invalid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = 'any error';
    await tester.pump();

    expect(find.text('any error'), findsOneWidget);
  });

  testWidgets('Should present no error if password valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = '';
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should present no error if password valid',
      (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = null;
    await tester.pump();

    expect(
        find.descendant(
            of: find.bySemanticsLabel('Senha'), matching: find.byType(Text)),
        findsOneWidget);
  });

  testWidgets('Should enable button is form is valid',
      (WidgetTester tester) async {
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
    await tester.pump();
    await tester.tap(find.byType(RaisedButton));
    await tester.pump();

    verify(presenter.auth()).called(1);
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
  testWidgets('Should error auth error', (WidgetTester tester) async {
    await loadPage(tester);

    mainError.value = 'main error';
    await tester.pump();

    expect(find.text('main error'), findsOneWidget);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateTo.value = '/any_route';
    await tester.pumpAndSettle();
    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });
}
