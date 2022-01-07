import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:testes/ui/pages/pages.dart';

class SplashPresenterSpy extends Mock implements SplashPresenter {}

void main() {
  SplashPresenterSpy presenter;
  var navigateToController = RxString();

  void mockStreams() {
    when(presenter.navigateToController)
        .thenAnswer((_) => navigateToController);
  }

  Future<void> loadPage(WidgetTester tester) async {
    presenter = SplashPresenterSpy();
    mockStreams();

    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashPage(presenter: presenter)),
        GetPage(
            name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
      ],
    ));
  }

  testWidgets('Should present spinner on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Should call checkAccount on page load',
      (WidgetTester tester) async {
    await loadPage(tester);

    verify(presenter.checkAccount()).called(1);
  });

  testWidgets('Should change page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.value = '/any_route';
    await tester.pumpAndSettle();

    expect(Get.currentRoute, '/any_route');
    expect(find.text('fake page'), findsOneWidget);
  });

  testWidgets('Should not change load page', (WidgetTester tester) async {
    await loadPage(tester);

    navigateToController.value = '';
    await tester.pump();
    expect(Get.currentRoute, '/');

    navigateToController.value = null;
    await tester.pump();
    expect(Get.currentRoute, '/');
  });
}
