import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:daily_news/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:daily_news/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

Article _article(String id) => Article(
  url: 'https://example.com/news/$id?utm_source=${'x' * 300}',
  title: 'Story $id',
  sourceName: 'Reuters',
  publishedAt: DateTime.utc(2026, 10, 14, 8),
  description: 'Description $id',
  imageUrl: 'https://example.com/$id.jpg',
);

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late FavoritesRepositoryImpl repository;
  var now = DateTime.utc(2026, 10, 15, 9);

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('favorites_test');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>('favorites_test_box');
    repository = FavoritesRepositoryImpl(
      FavoritesLocalDataSource(box),
      clock: () => now,
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('stores articles with long urls and reads them back', () async {
    final article = _article('1');

    await repository.addFavorite(article);
    final favorites = repository.getFavorites();

    expect(favorites, hasLength(1));
    expect(favorites.first.article.props, article.props);
    expect(favorites.first.savedAt, now);
  });

  test('lists the most recently saved first', () async {
    await repository.addFavorite(_article('old'));
    now = now.add(const Duration(hours: 1));
    await repository.addFavorite(_article('new'));

    final titles = repository.getFavorites().map((f) => f.article.title);
    expect(titles, ['Story new', 'Story old']);
  });

  test('saving the same article twice keeps a single entry', () async {
    await repository.addFavorite(_article('1'));
    await repository.addFavorite(_article('1'));

    expect(repository.getFavorites(), hasLength(1));
  });

  test('removes an article by url', () async {
    final article = _article('1');
    await repository.addFavorite(article);

    await repository.removeFavorite(article.url);

    expect(repository.getFavorites(), isEmpty);
  });

  test('skips corrupted entries instead of failing', () async {
    await repository.addFavorite(_article('1'));
    await box.put('broken', {'article': 'not a map'});

    expect(repository.getFavorites(), hasLength(1));
  });
}
