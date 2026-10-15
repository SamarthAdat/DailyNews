import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';
import 'package:daily_news/features/news/presentation/providers/feed_state.dart';
import 'package:daily_news/features/news/presentation/providers/news_providers.dart';

final selectedCategoryProvider =
    NotifierProvider<SelectedCategory, NewsCategory>(SelectedCategory.new);

final feedControllerProvider =
    AsyncNotifierProvider.family<FeedController, FeedState, NewsCategory>(
      FeedController.new,
    );

class SelectedCategory extends Notifier<NewsCategory> {
  @override
  NewsCategory build() => NewsCategory.business;

  void select(NewsCategory category) => state = category;
}

class FeedController extends AsyncNotifier<FeedState> {
  FeedController(this.category);

  final NewsCategory category;

  @override
  Future<FeedState> build() async {
    final firstPage = await ref.read(getTopHeadlinesProvider)(
      category: category,
    );
    return FeedState.fromPage(firstPage);
  }

  Future<void> refresh() async {
    try {
      final firstPage = await ref.read(getTopHeadlinesProvider)(
        category: category,
      );
      if (!ref.mounted) return;
      state = AsyncData(FeedState.fromPage(firstPage));
    } catch (e, st) {
      if (!ref.mounted) return;
      if (state.hasValue) rethrow;
      state = AsyncError(e, st);
    }
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore || current.isLoadingMore) return;

    final loading = current.copyWith(
      isLoadingMore: true,
      clearLoadMoreError: true,
    );
    state = AsyncData(loading);

    try {
      final next = await ref.read(getTopHeadlinesProvider)(
        category: category,
        page: current.page + 1,
      );
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(current.appendPage(next));
    } catch (e) {
      if (!ref.mounted || !identical(state.value, loading)) return;
      state = AsyncData(
        current.copyWith(isLoadingMore: false, loadMoreError: mapToFailure(e)),
      );
    }
  }
}
