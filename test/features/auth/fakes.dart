import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:daily_news/features/auth/data/models/user_model.dart';
import 'package:daily_news/features/auth/domain/entities/user.dart';
import 'package:daily_news/features/auth/domain/repositories/auth_repository.dart';

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  UserModel? stored;
  bool failWrites = false;

  @override
  UserModel? readUser() => stored;

  @override
  Future<void> saveUser(UserModel user) async {
    if (failWrites) throw const CacheException('write failed');
    stored = user;
  }

  @override
  Future<void> clear() async {
    if (failWrites) throw const CacheException('write failed');
    stored = null;
  }
}

class FakeAuthRepository implements AuthRepository {
  User? user;
  int loginCalls = 0;

  @override
  User? currentUser() => user;

  @override
  Future<User> login({required String email, required String password}) async {
    loginCalls++;
    return user = User(
      email: email,
      name: 'Test User',
      signedInAt: DateTime(2026),
    );
  }

  @override
  Future<void> logout() async => user = null;
}
