import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';
import 'package:daily_news/features/news/presentation/providers/article_pagination.dart';
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

class FeedController extends AsyncNotifier<FeedState> with ArticlePagination {
  FeedController(this.category);

  final NewsCategory category;

  @override
  Future<FeedState> build() => loadFirstPage();

  @override
  Future<ArticlePage> fetchPage(int page) {
    return ref.read(getTopHeadlinesProvider)(category: category, page: page);
  }

  Future<void> refresh() async {
    try {
      final firstPage = await loadFirstPage();
      if (!ref.mounted) return;
      state = AsyncData(firstPage);
    } catch (e, st) {
      if (!ref.mounted) return;
      if (state.hasValue) rethrow;
      state = AsyncError(e, st);
    }
  }
}
