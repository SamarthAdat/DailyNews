import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';

abstract interface class NewsRepository {
  Future<ArticlePage> getTopHeadlines({
    required NewsCategory category,
    required int page,
  });
}
