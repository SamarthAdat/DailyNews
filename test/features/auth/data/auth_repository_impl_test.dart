import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/auth/data/repositories/auth_repository_impl.dart';

import '../fakes.dart';

void main() {
  late FakeAuthLocalDataSource dataSource;
  late AuthRepositoryImpl repository;
  final now = DateTime(2026, 10, 15, 9, 30);

  setUp(() {
    dataSource = FakeAuthLocalDataSource();
    repository = AuthRepositoryImpl(dataSource, clock: () => now);
  });

  test('login persists the user with a readable name', () async {
    final user = await repository.login(
      email: 'samarth.adat@gmail.com',
      password: 'secret1',
    );

    expect(user.name, 'Samarth Adat');
    expect(user.initials, 'SA');
    expect(user.signedInAt, now);
    expect(dataSource.stored, user);
    expect(repository.currentUser(), user);
  });

  test('logout clears the stored session', () async {
    await repository.login(email: 'john@mail.com', password: 'secret1');
    await repository.logout();

    expect(repository.currentUser(), isNull);
  });

  test('storage errors surface as CacheFailure', () async {
    dataSource.failWrites = true;

    await expectLater(
      repository.login(email: 'john@mail.com', password: 'secret1'),
      throwsA(isA<CacheFailure>()),
    );
  });
}
