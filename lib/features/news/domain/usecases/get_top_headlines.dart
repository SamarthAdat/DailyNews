import 'package:daily_news/features/news/domain/entities/article_page.dart';
import 'package:daily_news/features/news/domain/entities/news_category.dart';
import 'package:daily_news/features/news/domain/repositories/news_repository.dart';

class GetTopHeadlines {
  const GetTopHeadlines(this._repository);

  final NewsRepository _repository;

  Future<ArticlePage> call({required NewsCategory category, int page = 1}) {
    return _repository.getTopHeadlines(category: category, page: page);
  }
}
