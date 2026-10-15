import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:daily_news/features/favorites/presentation/providers/favorites_controller.dart';
import 'package:daily_news/features/favorites/presentation/providers/favorites_providers.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

class _FakeFavoritesRepository implements FavoritesRepository {
  final items = <FavoriteArticle>[];
  bool failRemove = false;

  @override
  List<FavoriteArticle> getFavorites() => List.of(items);

  @override
  Future<void> addFavorite(Article article, {DateTime? savedAt}) async {
    items
      ..removeWhere((item) => item.article.url == article.url)
      ..insert(
        0,
        FavoriteArticle(article: article, savedAt: savedAt ?? DateTime(2026)),
      );
  }

  @override
  Future<void> removeFavorite(String articleUrl) async {
    if (failRemove) throw const CacheFailure();
    items.removeWhere((item) => item.article.url == articleUrl);
  }
}

void main() {
  final article = Article(
    url: 'https://example.com/a',
    title: 'Story',
    sourceName: 'Reuters',
    publishedAt: DateTime(2026, 10, 14),
  );

  late _FakeFavoritesRepository repository;
  late ProviderContainer container;

  setUp(() {
    repository = _FakeFavoritesRepository();
    container = ProviderContainer(
      overrides: [favoritesRepositoryProvider.overrideWithValue(repository)],
    );
    addTearDown(container.dispose);
  });

  test('toggle saves and then removes an article', () async {
    final controller = container.read(favoritesControllerProvider.notifier);

    expect(await controller.toggle(article), isTrue);
    expect(container.read(isFavoriteProvider(article.url)), isTrue);

    expect(await controller.toggle(article), isFalse);
    expect(container.read(isFavoriteProvider(article.url)), isFalse);
  });

  test('restores the list when removal fails', () async {
    final controller = container.read(favoritesControllerProvider.notifier);
    await controller.add(article);
    repository.failRemove = true;

    await expectLater(
      controller.remove(article.url),
      throwsA(isA<CacheFailure>()),
    );
    expect(container.read(favoritesControllerProvider), hasLength(1));
  });

  test('undo keeps the original saved time', () async {
    final controller = container.read(favoritesControllerProvider.notifier);
    final savedAt = DateTime(2026, 10, 1);

    await controller.add(article, savedAt: savedAt);
    await controller.remove(article.url);
    await controller.add(article, savedAt: savedAt);

    expect(container.read(favoritesControllerProvider).single.savedAt, savedAt);
  });
}
