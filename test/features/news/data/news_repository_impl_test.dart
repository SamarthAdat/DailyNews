import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/data/datasources/news_remote_data_source.dart';
import 'package:daily_news/features/news/data/models/article_model.dart';
import 'package:daily_news/features/news/data/models/articles_response_model.dart';
import 'package:daily_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';

class _FakeRemoteDataSource implements NewsRemoteDataSource {
  _FakeRemoteDataSource({this.totalResults = 0, this.error});

  final int totalResults;
  final Exception? error;
  String? requestedCategory;

  @override
  Future<ArticlesResponseModel> fetchTopHeadlines({
    required String category,
    required int page,
    int pageSize = 20,
  }) async {
    requestedCategory = category;
    if (error != null) throw error!;

    return ArticlesResponseModel(
      totalResults: totalResults,
      articles: [
        ArticleModel(
          url: 'https://example.com/$page',
          title: 'Story $page',
          sourceName: 'Reuters',
          publishedAt: DateTime(2026, 10, 14),
        ),
      ],
    );
  }
}

void main() {
  test('passes the category and reports more pages when available', () async {
    final remote = _FakeRemoteDataSource(totalResults: 59);
    final repository = NewsRepositoryImpl(remote);

    final page = await repository.getTopHeadlines(
      category: NewsCategory.technology,
      page: 2,
    );

    expect(remote.requestedCategory, 'technology');
    expect(page.page, 2);
    expect(page.hasMore, isTrue);
  });

  test('stops on the last page', () async {
    final repository = NewsRepositoryImpl(
      _FakeRemoteDataSource(totalResults: 59),
    );

    final page = await repository.getTopHeadlines(
      category: NewsCategory.business,
      page: 3,
    );

    expect(page.hasMore, isFalse);
  });

  test('respects the free plan result cap', () async {
    final repository = NewsRepositoryImpl(
      _FakeRemoteDataSource(totalResults: 500),
    );

    final page = await repository.getTopHeadlines(
      category: NewsCategory.general,
      page: 5,
    );

    expect(page.hasMore, isFalse);
  });

  test('maps data source errors to failures', () async {
    final repository = NewsRepositoryImpl(
      _FakeRemoteDataSource(error: const NetworkException()),
    );

    await expectLater(
      repository.getTopHeadlines(category: NewsCategory.business, page: 1),
      throwsA(isA<NetworkFailure>()),
    );
  });
}
