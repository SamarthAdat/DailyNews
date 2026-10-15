import 'package:flutter/material.dart';

import 'package:daily_news/core/widgets/app_network_image.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';
import 'package:daily_news/features/news/presentation/widgets/article_meta.dart';

class ArticleTile extends StatelessWidget {
  const ArticleTile({super.key, required this.article, this.onTap});

  final Article article;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ArticleMeta(article: article),
                  const SizedBox(height: 6),
                  Text(
                    article.title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            if (article.hasImage) ...[
              const SizedBox(width: 14),
              AppNetworkImage(
                url: article.imageUrl,
                width: 92,
                height: 92,
                borderRadius: BorderRadius.circular(10),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
