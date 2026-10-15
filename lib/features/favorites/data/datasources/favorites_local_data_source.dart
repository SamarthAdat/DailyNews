import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/features/favorites/data/models/favorite_article_model.dart';

class FavoritesLocalDataSource {
  const FavoritesLocalDataSource(this._box);

  final Box<dynamic> _box;

  List<FavoriteArticleModel> readAll() {
    final favorites = <FavoriteArticleModel>[];

    for (final raw in _box.values) {
      if (raw is! Map) continue;
      try {
        favorites.add(
          FavoriteArticleModel.fromMap(Map<String, dynamic>.from(raw)),
        );
      } on Object catch (e) {
        debugPrint('Skipping unreadable favorite: $e');
      }
    }

    return favorites..sort((a, b) => b.savedAt.compareTo(a.savedAt));
  }

  Future<void> save(FavoriteArticleModel favorite) async {
    try {
      await _box.put(_keyFor(favorite.article.url), favorite.toMap());
    } on HiveError catch (e) {
      throw CacheException(e.message);
    }
  }

  Future<void> delete(String articleUrl) async {
    try {
      await _box.delete(_keyFor(articleUrl));
    } on HiveError catch (e) {
      throw CacheException(e.message);
    }
  }

  String _keyFor(String url) => sha1.convert(utf8.encode(url)).toString();
}
