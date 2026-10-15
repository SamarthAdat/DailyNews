import 'package:daily_news/features/favorites/domain/entities/favorite_article.dart';
import 'package:daily_news/features/news/data/models/article_model.dart';

class FavoriteArticleModel extends FavoriteArticle {
  const FavoriteArticleModel({
    required ArticleModel super.article,
    required super.savedAt,
  });

  factory FavoriteArticleModel.fromMap(Map<String, dynamic> map) {
    return FavoriteArticleModel(
      article: ArticleModel.fromMap(
        Map<String, dynamic>.from(map['article'] as Map),
      ),
      savedAt: DateTime.parse(map['savedAt'] as String),
    );
  }

  Map<String, dynamic> toMap() => {
    'article': (article as ArticleModel).toMap(),
    'savedAt': savedAt.toUtc().toIso8601String(),
  };
}
