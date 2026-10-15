import 'dart:math';

import 'package:daily_news/core/constants/api_constants.dart';
import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/data/datasources/news_remote_data_source.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';
import 'package:daily_news/features/news/domain/repositories/news_repository.dart';

class NewsRepositoryImpl implements NewsRepository {
  const NewsRepositoryImpl(this._remoteDataSource);

  final NewsRemoteDataSource _remoteDataSource;

  @override
  Future<ArticlePage> getTopHeadlines({
    required NewsCategory category,
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.fetchTopHeadlines(
        category: category.apiValue,
        page: page,
      );
      final available = min(response.totalResults, ApiConstants.maxResults);

      return ArticlePage(
        articles: response.articles,
        page: page,
        hasMore:
            response.articles.isNotEmpty &&
            page * ApiConstants.pageSize < available,
      );
    } catch (e) {
      throw mapToFailure(e);
    }
  }
}
