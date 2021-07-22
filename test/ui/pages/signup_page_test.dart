import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fordev/ui/helpers/errors/errors.dart';
import 'package:fordev/ui/pages/pages.dart';
import 'package:get/get.dart';
import 'package:mocktail/mocktail.dart';

class LoginPresenterSpy extends Mock implements LoginPresenter {}

void main() {

  Future<void> loadPage(WidgetTester tester) async {

    final signupPage = GetMaterialApp(
      initialRoute: '/signup',
        getPages: [
          GetPage(name: '/signup', page: () => SignUpPage()),
          GetPage(name: '/any_route', page: () => Scaffold(body: Text('fake page'))),
        ]
    );
    await tester.pumpWidget(signupPage);
  }

  
  testWidgets('Should load with correct initial state', (WidgetTester tester) async {
    await loadPage(tester);

    final nameTextChildren = find.descendant(of: find.bySemanticsLabel('Nome'), matching: find.byType(Text));
    expect(
      nameTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no erros, since one of the childs is always the label text'
    );

    final emailTextChildren = find.descendant(of: find.bySemanticsLabel('Email'), matching: find.byType(Text));
    expect(
      emailTextChildren,
      findsOneWidget,
      reason: 'when a TextFormField has only one text child, means it has no erros, since one of the childs is always the label text'
    );

    final passwordTextChildren = find.descendant(of: find.bySemanticsLabel('Senha'), matching: find.byType(Text));
    expect(
        passwordTextChildren,
        findsOneWidget,
        reason: 'when a TextFormField has only one text child, means it has no erros, since one of the childs is always the label text'
    );

    final passwordConfimationTextChildren = find.descendant(of: find.bySemanticsLabel('Confirmar Senha'), matching: find.byType(Text));
    expect(
        passwordConfimationTextChildren,
        findsOneWidget,
        reason: 'when a TextFormField has only one text child, means it has no erros, since one of the childs is always the label text'
    );
    
    final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
    expect(button.onPressed, null);
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });
}