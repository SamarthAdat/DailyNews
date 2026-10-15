import 'package:equatable/equatable.dart';

import 'package:daily_news/features/news/domain/entities/article.dart';

class FavoriteArticle extends Equatable {
  const FavoriteArticle({required this.article, required this.savedAt});

  final Article article;
  final DateTime savedAt;

  @override
  List<Object?> get props => [article, savedAt];
}
