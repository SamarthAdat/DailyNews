import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:daily_news/core/utils/date_formatter.dart';
import 'package:daily_news/core/utils/snackbars.dart';
import 'package:daily_news/core/widgets/app_network_image.dart';
import 'package:daily_news/features/favorites/presentation/widgets/favorite_button.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key, required this.article});

  final Article article;

  Future<void> _openOriginal(BuildContext context) async {
    final uri = Uri.tryParse(article.url);
    var opened = false;

    if (uri != null) {
      try {
        opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
      } on Exception {
        opened = false;
      }
    }

    if (!opened && context.mounted) {
      context.showMessage("Couldn't open the article. Try again later.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: article.hasImage ? 280 : null,
            leadingWidth: 64,
            leading: Center(
              child: IconButton.filledTonal(
                tooltip: 'Back',
                onPressed: () => Navigator.of(context).maybePop(),
                icon: const Icon(Icons.arrow_back_rounded),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FavoriteButton(article: article),
              ),
            ],
            flexibleSpace: article.hasImage
                ? FlexibleSpaceBar(
                    background: AppNetworkImage(url: article.imageUrl),
                  )
                : null,
          ),
          SliverToBoxAdapter(child: _ArticleBody(article: article)),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: FilledButton.icon(
          onPressed: () => _openOriginal(context),
          icon: const Icon(Icons.open_in_new_rounded, size: 20),
          label: const Text('Read full article'),
        ),
      ),
    );
  }
}

class _ArticleBody extends StatelessWidget {
  const _ArticleBody({required this.article});

  final Article article;

  String? get _bodyText {
    final content = article.content;
    final description = article.description;
    if (content == null) return null;
    if (description == null) return content;

    final contentStart = content.replaceAll('…', '').trim();
    final isRepeat =
        description.startsWith(contentStart) ||
        contentStart.startsWith(description);
    return isRepeat ? null : content;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final byline = [
      if (article.author != null) article.author!,
      DateFormatter.dateTime(article.publishedAt),
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            article.sourceName.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            article.title,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.25,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            byline,
            style: theme.textTheme.bodySmall?.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const SizedBox(height: 20),
          if (article.description != null)
            Text(
              article.description!,
              style: theme.textTheme.titleMedium?.copyWith(height: 1.5),
            ),
          if (_bodyText != null) ...[
            const SizedBox(height: 16),
            Text(
              _bodyText!,
              style: theme.textTheme.bodyLarge?.copyWith(
                height: 1.6,
                color: colors.onSurfaceVariant,
              ),
            ),
          ],
          const SizedBox(height: 24),
          _PreviewNote(sourceName: article.sourceName),
        ],
      ),
    );
  }
}

class _PreviewNote extends StatelessWidget {
  const _PreviewNote({required this.sourceName});

  final String sourceName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, size: 20, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'This is a preview. The complete story is published by '
              '$sourceName.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
