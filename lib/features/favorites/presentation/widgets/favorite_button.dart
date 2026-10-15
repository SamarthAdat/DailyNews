import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/core/utils/snackbars.dart';
import 'package:daily_news/features/favorites/presentation/providers/favorites_controller.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

class FavoriteButton extends ConsumerWidget {
  const FavoriteButton({super.key, required this.article});

  final Article article;

  Future<void> _toggle(BuildContext context, WidgetRef ref) async {
    try {
      final saved = await ref
          .read(favoritesControllerProvider.notifier)
          .toggle(article);
      if (!context.mounted) return;
      context.showMessage(
        saved ? 'Saved for offline reading' : 'Removed from saved',
      );
    } catch (e) {
      if (!context.mounted) return;
      context.showMessage(mapToFailure(e).message);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSaved = ref.watch(isFavoriteProvider(article.url));

    return IconButton.filledTonal(
      tooltip: isSaved ? 'Remove from saved' : 'Save article',
      onPressed: () => _toggle(context, ref),
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        child: Icon(
          isSaved ? Icons.bookmark_rounded : Icons.bookmark_border_rounded,
          key: ValueKey(isSaved),
        ),
      ),
    );
  }
}
