import 'package:daily_news/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

class AddFavorite {
  const AddFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(Article article, {DateTime? savedAt}) {
    return _repository.addFavorite(article, savedAt: savedAt);
  }
}
