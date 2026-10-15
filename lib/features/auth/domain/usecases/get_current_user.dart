import 'package:daily_news/features/auth/domain/entities/user.dart';
import 'package:daily_news/features/auth/domain/repositories/auth_repository.dart';

class GetCurrentUser {
  const GetCurrentUser(this._repository);

  final AuthRepository _repository;

  User? call() => _repository.currentUser();
}
