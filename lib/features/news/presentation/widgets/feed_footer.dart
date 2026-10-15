import 'package:flutter/material.dart';

import 'package:daily_news/features/news/presentation/providers/feed_state.dart';

class FeedFooter extends StatelessWidget {
  const FeedFooter({super.key, required this.state, required this.onRetry});

  final FeedState state;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );

    final Widget child;
    if (state.isLoadingMore) {
      child = const SizedBox.square(
        dimension: 24,
        child: CircularProgressIndicator(strokeWidth: 2.5),
      );
    } else if (state.loadMoreError != null) {
      child = Column(
        children: [
          Text(
            state.loadMoreError!.message,
            textAlign: TextAlign.center,
            style: mutedStyle,
          ),
          TextButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      );
    } else if (!state.hasMore) {
      child = Text("You're all caught up", style: mutedStyle);
    } else {
      child = const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Center(child: child),
    );
  }
}
