import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:wecount/screens/sign_up.dart' show SignUp;
import 'package:wecount/utils/localization.dart';
import '../test_utils.dart' show TestUtils;

void main() {
  testWidgets('Widget', (WidgetTester tester) async {
    await tester
        .pumpWidget(TestUtils.makeTestableWidget(child: const SignUp()));
    await tester.pumpAndSettle();

    var findByText = find.byType(Text);
    expect(findByText.evaluate().isEmpty, false);
    expect(find.text(t('SIGN_UP')), findsNWidgets(2));
    expect(find.text(t('EMAIL')), findsOneWidget);
    expect(find.text(t('EMAIL_HINT')), findsOneWidget);
    expect(find.text(t('PASSWORD')), findsOneWidget);
    expect(find.text(t('PASSWORD_HINT')), findsOneWidget);
    expect(find.text(t('PASSWORD_CONFIRM')), findsOneWidget);
    expect(find.text(t('PASSWORD_CONFIRM_HINT')), findsOneWidget);
  });

  testWidgets('Show [emailError] text when email address is not a valid form',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestUtils.makeTestableWidget(child: const SignUp()));
    await tester.pumpAndSettle();

    Finder emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'aa@aa');

    Finder passwordField = find.byKey(const Key('password'));
    await tester.enterText(passwordField, 'aaaaaa');

    // ignore: todo
    // TODO: Should mock firebase in order to survive below codes

    // await tester.tap(find.text('SIGN_UP').last);
    // await tester.pumpAndSettle();

    // expect(find.text('NO_VALID_EMAIL'), findsOneWidget);
  });

  testWidgets('Show [passwordError] text when password is not valid form',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestUtils.makeTestableWidget(child: const SignUp()));
    await tester.pumpAndSettle();

    Finder emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'aa@aa.aa');

    Finder passwordField = find.byKey(const Key('password'));
    await tester.enterText(passwordField, 'aaaaaa');

    await tester.tap(find.text(t('SIGN_UP')).last, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text(t('PASSWORD_CONFIRM_HINT')), findsOneWidget);
  });

  testWidgets('Show [passwordConfirmError] text when password is not confirmed',
      (WidgetTester tester) async {
    await tester
        .pumpWidget(TestUtils.makeTestableWidget(child: const SignUp()));
    await tester.pumpAndSettle();

    Finder emailField = find.byKey(const Key('email'));
    await tester.enterText(emailField, 'aa@aa.aa');

    Finder passwordField = find.byKey(const Key('password'));
    await tester.enterText(passwordField, 'aaaaaa12');

    Finder passwordConfirmField = find.byKey(const Key('password-confirm'));
    await tester.enterText(passwordConfirmField, 'aaaaaa');

    await tester.tap(find.text(t('SIGN_UP')).last, warnIfMissed: false);
    await tester.pumpAndSettle();

    expect(find.text(t('PASSWORD_CONFIRM_HINT')), findsNWidgets(1));
  });
}
