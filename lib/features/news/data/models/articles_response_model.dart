import 'package:daily_news/features/news/data/models/article_model.dart';

class ArticlesResponseModel {
  const ArticlesResponseModel({
    required this.articles,
    required this.totalResults,
  });

  factory ArticlesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawArticles = json['articles'];
    final seenUrls = <String>{};
    final articles = <ArticleModel>[];

    if (rawArticles is List) {
      for (final item in rawArticles) {
        if (item is! Map<String, dynamic>) continue;
        final article = ArticleModel.tryParse(item);
        if (article != null && seenUrls.add(article.url)) {
          articles.add(article);
        }
      }
    }

    return ArticlesResponseModel(
      articles: articles,
      totalResults: (json['totalResults'] as num?)?.toInt() ?? 0,
    );
  }

  final List<ArticleModel> articles;
  final int totalResults;
}
