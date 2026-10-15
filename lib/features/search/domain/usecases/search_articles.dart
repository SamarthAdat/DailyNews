import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';
import 'package:daily_news/features/search/domain/repositories/search_repository.dart';

class SearchArticles {
  const SearchArticles(this._repository);

  final SearchRepository _repository;

  Future<ArticlePage> call({required SearchQuery query, int page = 1}) async {
    if (!query.isSearchable) {
      throw const ValidationFailure(
        'Type at least ${SearchQuery.minLength} characters to search.',
      );
    }
    return _repository.searchArticles(query: query, page: page);
  }
}
