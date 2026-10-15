import 'dart:math';

import 'package:daily_news/core/constants/api_constants.dart';
import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/search/data/datasources/search_history_local_data_source.dart';
import 'package:daily_news/features/search/data/datasources/search_remote_data_source.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';
import 'package:daily_news/features/search/domain/repositories/search_repository.dart';

class SearchRepositoryImpl implements SearchRepository {
  const SearchRepositoryImpl(
    this._remoteDataSource,
    this._historyDataSource, {
    DateTime Function()? clock,
  }) : _clock = clock ?? DateTime.now;

  final SearchRemoteDataSource _remoteDataSource;
  final SearchHistoryLocalDataSource _historyDataSource;
  final DateTime Function() _clock;

  @override
  Future<ArticlePage> searchArticles({
    required SearchQuery query,
    required int page,
  }) async {
    try {
      final response = await _remoteDataSource.searchArticles(
        text: query.text.trim(),
        sortBy: query.sort.apiValue,
        from: query.period.startFrom(_clock()),
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

  @override
  List<String> getRecentSearches() => _historyDataSource.read();

  @override
  Future<void> saveRecentSearch(String text) async {
    try {
      await _historyDataSource.add(text);
    } catch (e) {
      throw mapToFailure(e);
    }
  }

  @override
  Future<void> clearRecentSearches() async {
    try {
      await _historyDataSource.clear();
    } catch (e) {
      throw mapToFailure(e);
    }
  }
}
