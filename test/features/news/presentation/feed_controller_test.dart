import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';
import 'package:daily_news/features/news/domain/repositories/news_repository.dart';
import 'package:daily_news/features/news/presentation/providers/feed_controller.dart';
import 'package:daily_news/features/news/presentation/providers/news_providers.dart';

Article _article(String id) => Article(
  url: 'https://example.com/$id',
  title: 'Story $id',
  sourceName: 'Reuters',
  publishedAt: DateTime(2026, 10, 14),
);

class _FakeNewsRepository implements NewsRepository {
  final pages = <int, List<Article>>{};
  final failingPages = <int>{};
  int lastPage = 2;

  @override
  Future<ArticlePage> getTopHeadlines({
    required NewsCategory category,
    required int page,
  }) async {
    if (failingPages.contains(page)) throw const NetworkFailure();
    return ArticlePage(
      articles: pages[page] ?? const [],
      page: page,
      hasMore: page < lastPage,
    );
  }
}

void main() {
  late _FakeNewsRepository repository;
  late ProviderContainer container;
  final provider = feedControllerProvider(NewsCategory.business);

  setUp(() {
    repository = _FakeNewsRepository()
      ..pages[1] = [_article('1'), _article('2')]
      ..pages[2] = [_article('2'), _article('3')];
    container = ProviderContainer(
      overrides: [newsRepositoryProvider.overrideWithValue(repository)],
      retry: (_, _) => null,
    );
    addTearDown(container.dispose);
  });

  test('loads the first page', () async {
    final state = await container.read(provider.future);

    expect(state.articles, hasLength(2));
    expect(state.hasMore, isTrue);
  });

  test('appends the next page without duplicates', () async {
    await container.read(provider.future);
    await container.read(provider.notifier).loadMore();

    final state = container.read(provider).requireValue;
    expect(state.articles.map((a) => a.title), [
      'Story 1',
      'Story 2',
      'Story 3',
    ]);
    expect(state.page, 2);
    expect(state.hasMore, isFalse);
  });

  test('keeps loaded articles when the next page fails', () async {
    repository.failingPages.add(2);
    await container.read(provider.future);
    await container.read(provider.notifier).loadMore();

    final state = container.read(provider).requireValue;
    expect(state.articles, hasLength(2));
    expect(state.loadMoreError, isA<NetworkFailure>());
    expect(state.isLoadingMore, isFalse);
  });

  test('refresh failure keeps current data and rethrows', () async {
    await container.read(provider.future);
    repository.failingPages.add(1);

    await expectLater(
      container.read(provider.notifier).refresh(),
      throwsA(isA<NetworkFailure>()),
    );
    expect(container.read(provider).requireValue.articles, hasLength(2));
  });

  test('first page failure ends in an error state', () async {
    repository.failingPages.add(1);

    await expectLater(container.read(provider.future), throwsA(isA<Failure>()));
    expect(container.read(provider).hasError, isTrue);
  });
}
