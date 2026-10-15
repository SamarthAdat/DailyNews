import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:daily_news/features/auth/data/models/user_model.dart';
import 'package:daily_news/features/auth/domain/entities/user.dart';
import 'package:daily_news/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  const AuthRepositoryImpl(this._localDataSource, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  final AuthLocalDataSource _localDataSource;
  final DateTime Function() _clock;

  @override
  User? currentUser() {
    try {
      return _localDataSource.readUser();
    } catch (e) {
      throw mapToFailure(e);
    }
  }

  @override
  Future<User> login({required String email, required String password}) async {
    final user = UserModel(
      email: email,
      name: _displayNameFrom(email),
      signedInAt: _clock(),
    );

    try {
      await _localDataSource.saveUser(user);
      return user;
    } catch (e) {
      throw mapToFailure(e);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _localDataSource.clear();
    } catch (e) {
      throw mapToFailure(e);
    }
  }

  String _displayNameFrom(String email) {
    final words = email
        .split('@')
        .first
        .split(RegExp(r'[._+\-]+'))
        .where((word) => word.isNotEmpty);

    if (words.isEmpty) return email;
    return words
        .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
