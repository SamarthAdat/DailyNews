import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:daily_news/app/router/app_routes.dart';
import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/core/utils/snackbars.dart';
import 'package:daily_news/core/widgets/error_view.dart';
import 'package:daily_news/core/widgets/message_view.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';
import 'package:daily_news/features/news/presentation/providers/feed_controller.dart';
import 'package:daily_news/features/news/presentation/providers/feed_state.dart';
import 'package:daily_news/features/news/presentation/widgets/article_tile.dart';
import 'package:daily_news/features/news/presentation/widgets/featured_article_card.dart';
import 'package:daily_news/features/news/presentation/widgets/feed_footer.dart';
import 'package:daily_news/features/news/presentation/widgets/feed_skeleton.dart';

class ArticleFeed extends ConsumerWidget {
  const ArticleFeed({super.key, required this.category});

  final NewsCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = feedControllerProvider(category);
    final feed = ref.watch(provider);

    return switch (feed) {
      AsyncValue(:final value?) => _FeedList(category: category, state: value),
      AsyncValue(isLoading: true) => const FeedSkeleton(),
      AsyncValue(:final error?) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(provider),
      ),
      _ => const FeedSkeleton(),
    };
  }
}

class _FeedList extends ConsumerWidget {
  const _FeedList({required this.category, required this.state});

  static const _loadMoreThreshold = 600.0;

  final NewsCategory category;
  final FeedState state;

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    try {
      await ref.read(feedControllerProvider(category).notifier).refresh();
    } catch (e) {
      if (!context.mounted) return;
      context.showMessage(mapToFailure(e).message);
    }
  }

  void _open(BuildContext context, Article article) {
    context.push(AppRoutes.article, extra: article);
  }

  bool _onScroll(ScrollNotification notification, WidgetRef ref) {
    if (notification.metrics.axis == Axis.vertical &&
        notification.metrics.extentAfter < _loadMoreThreshold &&
        state.canLoadMore) {
      ref.read(feedControllerProvider(category).notifier).loadMore();
    }
    return false;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(feedControllerProvider(category).notifier);

    if (state.articles.isEmpty) {
      return MessageView(
        icon: Icons.inbox_outlined,
        title: 'No stories right now',
        message: 'Check back in a little while for fresh headlines.',
        actionLabel: 'Refresh',
        onAction: () => _refresh(context, ref),
      );
    }

    final featured = state.articles.first;
    final hasFeatured = featured.hasImage;
    final rest = hasFeatured ? state.articles.skip(1).toList() : state.articles;

    return RefreshIndicator(
      onRefresh: () => _refresh(context, ref),
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) => _onScroll(notification, ref),
        child: CustomScrollView(
          key: PageStorageKey('feed-${category.name}'),
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            if (hasFeatured)
              SliverToBoxAdapter(
                child: FeaturedArticleCard(
                  article: featured,
                  onTap: () => _open(context, featured),
                ),
              ),
            SliverList.separated(
              itemCount: rest.length,
              itemBuilder: (_, index) => ArticleTile(
                article: rest[index],
                onTap: () => _open(context, rest[index]),
              ),
              separatorBuilder: (_, _) =>
                  const Divider(indent: 16, endIndent: 16),
            ),
            SliverToBoxAdapter(
              child: FeedFooter(state: state, onRetry: notifier.loadMore),
            ),
          ],
        ),
      ),
    );
  }
}
