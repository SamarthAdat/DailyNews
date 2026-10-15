import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/widgets/error_view.dart';
import 'package:daily_news/core/widgets/message_view.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';
import 'package:daily_news/features/news/presentation/widgets/article_tile.dart';
import 'package:daily_news/features/news/presentation/widgets/feed_footer.dart';
import 'package:daily_news/features/news/presentation/widgets/feed_skeleton.dart';
import 'package:daily_news/features/news/presentation/widgets/load_more_listener.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';
import 'package:daily_news/features/search/presentation/providers/search_results_controller.dart';

class SearchResultsView extends ConsumerWidget {
  const SearchResultsView({
    super.key,
    required this.query,
    required this.onOpenArticle,
  });

  final SearchQuery query;
  final ValueChanged<Article> onOpenArticle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = searchResultsProvider(query);
    final results = ref.watch(provider);

    switch (results) {
      case AsyncValue(:final value?) when value.articles.isEmpty:
        return MessageView(
          icon: Icons.search_off_rounded,
          title: 'No results for "${query.text}"',
          message: query.period == SearchPeriod.anyTime
              ? 'Try different or fewer keywords.'
              : 'Try different keywords or a wider time range.',
        );
      case AsyncValue(:final value?):
        final notifier = ref.read(provider.notifier);
        return LoadMoreListener(
          canLoadMore: value.canLoadMore,
          onLoadMore: notifier.loadMore,
          child: ListView.separated(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.only(top: 4),
            itemCount: value.articles.length + 1,
            separatorBuilder: (_, _) =>
                const Divider(indent: 16, endIndent: 16),
            itemBuilder: (_, index) {
              if (index == value.articles.length) {
                return FeedFooter(state: value, onRetry: notifier.loadMore);
              }
              final article = value.articles[index];
              return ArticleTile(
                article: article,
                onTap: () => onOpenArticle(article),
              );
            },
          ),
        );
      case AsyncValue(isLoading: true):
        return const FeedSkeleton(showFeatured: false);
      case AsyncValue(:final error?):
        return ErrorView(error: error, onRetry: () => ref.invalidate(provider));
      case _:
        return const FeedSkeleton(showFeatured: false);
    }
  }
}
