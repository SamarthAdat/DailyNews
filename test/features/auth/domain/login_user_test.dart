import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/auth/domain/usecases/login_user.dart';

import '../fakes.dart';

void main() {
  late FakeAuthRepository repository;
  late LoginUser loginUser;

  setUp(() {
    repository = FakeAuthRepository();
    loginUser = LoginUser(repository);
  });

  test('throws ValidationFailure and skips repository for bad input', () async {
    await expectLater(
      loginUser(email: 'not-an-email', password: 'secret1'),
      throwsA(isA<ValidationFailure>()),
    );
    await expectLater(
      loginUser(email: 'john@mail.com', password: '123'),
      throwsA(isA<ValidationFailure>()),
    );
    expect(repository.loginCalls, 0);
  });

  test('normalizes email before passing it to repository', () async {
    final user = await loginUser(email: '  John@Mail.COM ', password: 'secret1');

    expect(user.email, 'john@mail.com');
    expect(repository.loginCalls, 1);
  });
}
