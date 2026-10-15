import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/favorites/domain/repositories/favorites_repository.dart';

class GetFavorites {
  const GetFavorites(this._repository);

  final FavoritesRepository _repository;

  List<FavoriteArticle> call() => _repository.getFavorites();
}
