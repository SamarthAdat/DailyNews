import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/features/auth/presentation/providers/auth_providers.dart';
import 'package:daily_news/features/auth/presentation/screens/login_screen.dart';

import '../fakes.dart';

void main() {
  late FakeAuthRepository repository;

  Future<void> pumpLogin(WidgetTester tester) async {
    repository = FakeAuthRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [authRepositoryProvider.overrideWithValue(repository)],
        child: const MaterialApp(home: LoginScreen()),
      ),
    );
  }

  testWidgets('shows field errors when the form is empty', (tester) async {
    await pumpLogin(tester);

    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(find.text('Enter your email'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
    expect(repository.loginCalls, 0);
  });

  testWidgets('signs in with valid details', (tester) async {
    await pumpLogin(tester);

    await tester.enterText(find.byType(TextFormField).first, 'john@mail.com');
    await tester.enterText(find.byType(TextFormField).last, 'secret123');
    await tester.tap(find.text('Sign in'));
    await tester.pump();

    expect(repository.loginCalls, 1);
    expect(repository.user?.email, 'john@mail.com');
  });
}
