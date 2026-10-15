import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

abstract interface class FavoritesRepository {
  List<FavoriteArticle> getFavorites();

  Future<void> addFavorite(Article article, {DateTime? savedAt});

  Future<void> removeFavorite(String articleUrl);
}
