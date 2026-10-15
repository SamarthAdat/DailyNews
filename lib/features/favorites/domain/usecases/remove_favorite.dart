import 'package:daily_news/features/favorites/domain/repositories/favorites_repository.dart';

class RemoveFavorite {
  const RemoveFavorite(this._repository);

  final FavoritesRepository _repository;

  Future<void> call(String articleUrl) =>
      _repository.removeFavorite(articleUrl);
}
