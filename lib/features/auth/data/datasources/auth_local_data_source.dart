import 'package:hive_ce/hive_ce.dart';

import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/features/auth/data/models/user_model.dart';

class AuthLocalDataSource {
  const AuthLocalDataSource(this._box);

  final Box<dynamic> _box;

  static const _userKey = 'current_user';

  UserModel? readUser() {
    final raw = _box.get(_userKey);
    if (raw is! Map) return null;

    try {
      return UserModel.fromMap(Map<String, dynamic>.from(raw));
    } on Object {
      throw const CacheException('Saved session is corrupted');
    }
  }

  Future<void> saveUser(UserModel user) async {
    try {
      await _box.put(_userKey, user.toMap());
    } on HiveError catch (e) {
      throw CacheException(e.message);
    }
  }

  Future<void> clear() async {
    try {
      await _box.delete(_userKey);
    } on HiveError catch (e) {
      throw CacheException(e.message);
    }
  }
}
