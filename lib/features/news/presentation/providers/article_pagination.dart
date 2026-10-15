import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/presentation/providers/feed_state.dart';

mixin ArticlePagination on AsyncNotifier<FeedState> {
  Future<ArticlePage> fetchPage(int page);

  Future<FeedState> loadFirstPage() async =>
      FeedState.fromPage(await fetchPage(1));

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final loading = current.copyWith(
      isLoadingMore: true,
      clearLoadMoreError: true,
    );
    state = AsyncData(loading);

    try {
      final next = await fetchPage(current.page + 1);
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.appendPage(next));
    } catch (e) {
      if (!ref.mounted || !identical(state.value, loading)) return;
      final failure = mapToFailure(e);
      state = AsyncData(
        current.copyWith(
          isLoadingMore: false,
          loadMoreError: failure is CancelledFailure ? null : failure,
        ),
      );
    }
  }
}
