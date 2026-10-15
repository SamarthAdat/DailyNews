import 'package:equatable/equatable.dart';

import 'package:daily_news/features/news/domain/entities/article.dart';

class ArticlePage extends Equatable {
  const ArticlePage({
    required this.articles,
    required this.page,
    required this.hasMore,
  });

  final List<Article> articles;
  final int page;
  final bool hasMore;

  @override
  List<Object?> get props => [articles, page, hasMore];
}
