import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/auth/presentation/providers/auth_controller.dart';
import 'package:daily_news/features/auth/presentation/providers/auth_providers.dart';

import '../fakes.dart';

void main() {
  late FakeAuthRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = FakeAuthRepository();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(repository)],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
  });

  test('starts logged out when no session is stored', () {
    expect(container.read(isLoggedInProvider), isFalse);
  });

  test('login and logout update the session state', () async {
    final controller = container.read(authControllerProvider.notifier);

    await controller.login(email: 'john@mail.com', password: 'secret1');
    expect(container.read(isLoggedInProvider), isTrue);

    await controller.logout();
    expect(container.read(isLoggedInProvider), isFalse);
  });

  test('invalid credentials end in an error state', () async {
    await container
        .read(authControllerProvider.notifier)
        .login(email: 'john', password: '1');

    final state = container.read(authControllerProvider);
    expect(state.error, isA<ValidationFailure>());
    expect(container.read(isLoggedInProvider), isFalse);
  });
}
