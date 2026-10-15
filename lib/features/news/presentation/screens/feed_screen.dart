import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/utils/date_formatter.dart';
import 'package:daily_news/features/auth/presentation/widgets/account_button.dart';
import 'package:daily_news/features/news/presentation/providers/feed_controller.dart';
import 'package:daily_news/features/news/presentation/widgets/article_feed.dart';
import 'package:daily_news/features/news/presentation/widgets/category_bar.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 68,
        titleSpacing: 16,
        title: const _FeedTitle(),
        actions: const [AccountButton()],
        bottom: CategoryBar(
          selected: category,
          onSelected: ref.read(selectedCategoryProvider.notifier).select,
        ),
      ),
      body: ArticleFeed(key: ValueKey(category), category: category),
    );
  }
}

class _FeedTitle extends StatelessWidget {
  const _FeedTitle();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          DateFormatter.longDay(DateTime.now()).toUpperCase(),
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.primary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 2),
        const Text('Daily News'),
      ],
    );
  }
}
