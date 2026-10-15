import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

final favoritesControllerProvider =
    NotifierProvider<FavoritesController, List<FavoriteArticle>>(
      FavoritesController.new,
    );

final isFavoriteProvider = Provider.family<bool, String>(
  (ref, articleUrl) => ref.watch(
    favoritesControllerProvider.select(
      (favorites) => favorites.any((item) => item.article.url == articleUrl),
    ),
  ),
);

class FavoritesController extends Notifier<List<FavoriteArticle>> {
  @override
  List<FavoriteArticle> build() => ref.read(getFavoritesProvider).call();

  bool contains(String articleUrl) =>
      state.any((item) => item.article.url == articleUrl);

  Future<bool> toggle(Article article) async {
    if (contains(article.url)) {
      await remove(article.url);
      return false;
    }
    await add(article);
    return true;
  }

  Future<void> add(Article article, {DateTime? savedAt}) async {
    await ref.read(addFavoriteProvider).call(article, savedAt: savedAt);
    _reload();
  }

  Future<void> remove(String articleUrl) async {
    final previous = state;
    state = [
      for (final item in state)
        if (item.article.url != articleUrl) item,
    ];

    try {
      await ref.read(removeFavoriteProvider).call(articleUrl);
    } catch (_) {
      state = previous;
      rethrow;
    }
  }

  void _reload() => state = ref.read(getFavoritesProvider).call();
}
