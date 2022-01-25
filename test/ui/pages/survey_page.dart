import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testes/ui/helpers/errors/ui_error.dart';

import 'package:testes/ui/pages/pages.dart';

class SurveysPresenterSpy extends Mock implements SurveysPresenter {}

void main() {
  SurveysPresenter presenter;

  var loadSurveys = RxList<SurveyViewModel>();

  var isFormValid = RxBool();
  var isLoading = RxBool();

  StreamController<List<SurveyViewModel>> loadSurveysController;

  void mockStreams() {
    when(presenter.isFormValid).thenAnswer((_) => isFormValid);
    when(presenter.isLoading).thenAnswer((_) => isLoading);
    when(presenter.loadSurveysList).thenAnswer((_) => loadSurveys);
    when(presenter.loadSurveysController)
        .thenAnswer((_) => loadSurveysController.stream);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = Get.put<SurveysPresenter>(SurveysPresenterSpy());
    mockStreams();

    final loginPage = GetMaterialApp(
      initialRoute: '/surveys',
      getPages: [
        GetPage(name: '/surveys', page: () => SurveysPage(presenter)),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    );
    await tester.pumpWidget(loginPage);
  }

  List<SurveyViewModel> makeSurveys() => [
        SurveyViewModel(
            id: '1', question: 'Question 1', date: 'any_date', didAnswer: true),
        SurveyViewModel(
            id: '2', question: 'Question 2', date: 'any_date', didAnswer: false)
      ];

  List<SurveyViewModel> makeSurveysGet() => [
        SurveyViewModel(
            id: '1', question: 'Question 1', date: 'any_date', didAnswer: true),
        SurveyViewModel(
            id: '2', question: 'Question 2', date: 'any_date', didAnswer: false)
      ];

  testWidgets('Should call LoadSurveys on page load',
      (WidgetTester tester) async {
    await loadPage(tester);
    //verify(presenter.loadData()).called(1);
  });

  testWidgets('Should call loading', (WidgetTester tester) async {
    await loadPage(tester);

    isLoading.value = true;
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = false;
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);

    isLoading.value = true;
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    isLoading.value = null;
    await tester.pump();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Should error if load fail', (WidgetTester tester) async {
    await loadPage(tester);

    loadSurveysController.addError(UIError.unexpected.description);
    await tester.pump();

    expect(find.text('Algo errado aconteceu.'), findsOneWidget);
    expect(find.text('Recarregar'), findsOneWidget);
    expect(find.text('Question 1'), findsNothing);
  });

  testWidgets('Should present list if load success',
      (WidgetTester tester) async {
    await loadPage(tester);

    //loadSurveysController.add(makeSurveys());
    loadSurveys.addAll(makeSurveys());
    print(loadSurveys);
    await tester.pump();

    expect(find.text('Algo errado aconteceu.'), findsOneWidget);
    expect(find.text('Recarregar'), findsNothing);
    expect(find.text('Question 1'), findsOneWidget);
  });

/*
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

    emailError.value = UIError.invalidField;
    await tester.pump();
    expect(find.text('Campo inválido'), findsOneWidget);
  });

  testWidgets('Should present error if email is empty',
      (WidgetTester tester) async {
    await loadPage(tester);

    emailError.value = UIError.requiredField;
    await tester.pump();
    expect(find.text('Campo obrigatório'), findsOneWidget);
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

  testWidgets('Should present if password empty', (WidgetTester tester) async {
    await loadPage(tester);

    passwordError.value = UIError.requiredField;
    await tester.pump();

    expect(find.text('Campo obrigatório'), findsOneWidget);
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

    mainError.value = UIError.invalidCredentials;
    await tester.pump();

    expect(find.text('Credenciais inválidas'), findsOneWidget);
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
    expect(Get.currentRoute, '/login');

    navigateTo.value = null;
    await tester.pump();
    expect(Get.currentRoute, '/login');
  });
  testWidgets('Should call to SignUp', (WidgetTester tester) async {
    await loadPage(tester);

    final button = find.text('Criar Conta');
    await tester.ensureVisible(button);

    await tester.tap(button);
    await tester.pump();

    verify(presenter.goToSignUp()).called(1);
  });
*/
}
