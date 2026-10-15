import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';

abstract interface class SearchRepository {
  Future<ArticlePage> searchArticles({
    required SearchQuery query,
    required int page,
  });

  List<String> getRecentSearches();

  Future<void> saveRecentSearch(String text);

  Future<void> clearRecentSearches();
}
