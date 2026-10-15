import 'package:daily_news/features/auth/domain/entities/user.dart';

abstract interface class AuthRepository {
  User? currentUser();

  Future<User> login({required String email, required String password});

  Future<void> logout();
}
