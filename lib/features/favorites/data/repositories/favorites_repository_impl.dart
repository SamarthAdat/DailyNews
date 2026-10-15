import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:daily_news/features/favorites/data/models/favorite_article_model.dart';
import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:daily_news/features/news/data/models/article_model.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  const FavoritesRepositoryImpl(
    this._localDataSource, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final FavoritesLocalDataSource _localDataSource;
  final DateTime Function() _clock;

  @override
  List<FavoriteArticle> getFavorites() {
    try {
      return _localDataSource.readAll();
    } catch (e) {
      throw mapToFailure(e);
    }
  }

  @override
  Future<void> addFavorite(Article article, {DateTime? savedAt}) async {
    try {
      await _localDataSource.save(
        FavoriteArticleModel(
          article: ArticleModel.fromEntity(article),
          savedAt: savedAt ?? _clock(),
        ),
      );
    } catch (e) {
      throw mapToFailure(e);
    }
  }

  @override
  Future<void> removeFavorite(String articleUrl) async {
    try {
      await _localDataSource.delete(articleUrl);
    } catch (e) {
      throw mapToFailure(e);
    }
  }
}
