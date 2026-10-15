import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:daily_news/app/router/app_routes.dart';
import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/core/widgets/message_view.dart';
import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/favorites/presentation/providers/favorites_controller.dart';
import 'package:daily_news/features/news/presentation/widgets/article_tile.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  Future<void> _remove(
    BuildContext context,
    WidgetRef ref,
    FavoriteArticle favorite,
  ) async {
    final controller = ref.read(favoritesControllerProvider.notifier);
    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    try {
      await controller.remove(favorite.article.url);
      messenger.showSnackBar(
        SnackBar(
          content: const Text('Removed from saved'),
          action: SnackBarAction(
            label: 'Undo',
            onPressed: () =>
                controller.add(favorite.article, savedAt: favorite.savedAt),
          ),
        ),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(mapToFailure(e).message)));
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final favorites = ref.watch(favoritesControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Saved')),
      body: favorites.isEmpty
          ? const MessageView(
              icon: Icons.bookmark_border_rounded,
              title: 'No saved articles yet',
              message:
                  'Tap the bookmark on any story to keep it here, '
                  'even when you are offline.',
            )
          : ListView.separated(
              padding: const EdgeInsets.only(bottom: 24),
              itemCount: favorites.length + 1,
              separatorBuilder: (_, index) => index == 0
                  ? const SizedBox.shrink()
                  : const Divider(indent: 16, endIndent: 16),
              itemBuilder: (context, index) {
                if (index == 0) return _Header(count: favorites.length);

                final favorite = favorites[index - 1];
                return Dismissible(
                  key: ValueKey(favorite.article.url),
                  direction: DismissDirection.endToStart,
                  background: const _DismissBackground(),
                  onDismissed: (_) => _remove(context, ref, favorite),
                  child: ArticleTile(
                    article: favorite.article,
                    onTap: () => context.push(
                      AppRoutes.article,
                      extra: favorite.article,
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: Text(
        '$count ${count == 1 ? 'article' : 'articles'} available offline · '
        'swipe left to remove',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _DismissBackground extends StatelessWidget {
  const _DismissBackground();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Container(
      color: colors.errorContainer,
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Icon(Icons.delete_outline_rounded, color: colors.onErrorContainer),
    );
  }
}
