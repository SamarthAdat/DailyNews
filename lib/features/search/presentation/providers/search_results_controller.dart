import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/presentation/providers/article_pagination.dart';
import 'package:daily_news/features/news/presentation/providers/feed_state.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';
import 'package:daily_news/features/search/presentation/providers/search_providers.dart';

final searchResultsProvider = AsyncNotifierProvider.autoDispose
    .family<SearchResultsController, FeedState, SearchQuery>(
      SearchResultsController.new,
    );

class SearchResultsController extends AsyncNotifier<FeedState>
    with ArticlePagination {
  SearchResultsController(this.query);

  static const cacheDuration = Duration(minutes: 3);

  final SearchQuery query;

  @override
  Future<FeedState> build() async {
    final keepAlive = ref.keepAlive();
    final expiry = Timer(cacheDuration, keepAlive.close);
    ref.onDispose(expiry.cancel);

    try {
      return await loadFirstPage();
    } catch (_) {
      keepAlive.close();
      rethrow;
    }
  }

  @override
  Future<ArticlePage> fetchPage(int page) {
    return ref.read(searchArticlesProvider)(query: query, page: page);
  }
}
