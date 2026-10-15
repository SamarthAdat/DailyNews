import 'package:flutter/material.dart';

import 'package:daily_news/core/utils/date_formatter.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';

class ArticleMeta extends StatelessWidget {
  const ArticleMeta({super.key, required this.article});

  final Article article;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final style = theme.textTheme.labelMedium;

    return Row(
      children: [
        Flexible(
          child: Text(
            article.sourceName.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style?.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Text('·', style: style?.copyWith(color: colors.outline)),
        ),
        Text(
          DateFormatter.relative(article.publishedAt),
          style: style?.copyWith(color: colors.onSurfaceVariant),
        ),
      ],
    );
  }
}
