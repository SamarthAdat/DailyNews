import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';
import 'package:daily_news/features/search/domain/repositories/search_repository.dart';
import 'package:daily_news/features/search/domain/usecases/search_articles.dart';

class _NoopSearchRepository implements SearchRepository {
  int calls = 0;

  @override
  Future<ArticlePage> searchArticles({
    required SearchQuery query,
    required int page,
  }) async {
    calls++;
    return ArticlePage(articles: const [], page: page, hasMore: false);
  }

  @override
  List<String> getRecentSearches() => const [];

  @override
  Future<void> saveRecentSearch(String text) async {}

  @override
  Future<void> clearRecentSearches() async {}
}

void main() {
  test('queries differing only by case are treated as the same', () {
    expect(const SearchQuery(text: 'Tesla'), const SearchQuery(text: 'tesla'));
    expect(
      const SearchQuery(text: 'tesla'),
      isNot(const SearchQuery(text: 'tesla', sort: SearchSort.latest)),
    );
  });

  test('period computes the start date from now', () {
    final now = DateTime(2026, 10, 15);

    expect(SearchPeriod.anyTime.startFrom(now), isNull);
    expect(SearchPeriod.week.startFrom(now), DateTime(2026, 10, 8));
  });

  test('SearchArticles rejects queries that are too short', () async {
    final repository = _NoopSearchRepository();
    final searchArticles = SearchArticles(repository);

    await expectLater(
      searchArticles(query: const SearchQuery(text: ' a ')),
      throwsA(isA<ValidationFailure>()),
    );
    expect(repository.calls, 0);

    await searchArticles(query: const SearchQuery(text: 'ai'));
    expect(repository.calls, 1);
  });
}
