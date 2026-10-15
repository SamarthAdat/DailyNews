import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/core/utils/validators.dart';
import 'package:daily_news/features/auth/domain/entities/user.dart';
import 'package:daily_news/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  const LoginUser(this._repository);

  final AuthRepository _repository;

  Future<User> call({required String email, required String password}) async {
    final error = Validators.email(email) ?? Validators.password(password);
    if (error != null) throw ValidationFailure(error);

    return _repository.login(
      email: email.trim().toLowerCase(),
      password: password,
    );
  }
}
