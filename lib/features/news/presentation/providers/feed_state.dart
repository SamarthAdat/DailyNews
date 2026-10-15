import 'package:equatable/equatable.dart';

import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';
import 'package:daily_news/features/news/domain/entities/article_page.dart';

class FeedState extends Equatable {
  const FeedState({
    required this.articles,
    required this.page,
    required this.hasMore,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory FeedState.fromPage(ArticlePage page) => FeedState(
    articles: page.articles,
    page: page.page,
    hasMore: page.hasMore,
  );

  final List<Article> articles;
  final int page;
  final bool hasMore;
  final bool isLoadingMore;
  final Failure? loadMoreError;

  bool get canLoadMore => hasMore && !isLoadingMore && loadMoreError == null;

  FeedState appendPage(ArticlePage next) {
    final seenUrls = articles.map((article) => article.url).toSet();
    final fresh = next.articles.where((article) => seenUrls.add(article.url));

    return FeedState(
      articles: [...articles, ...fresh],
      page: next.page,
      hasMore: next.hasMore,
    );
  }

  FeedState copyWith({
    bool? isLoadingMore,
    Failure? loadMoreError,
    bool clearLoadMoreError = false,
  }) {
    return FeedState(
      articles: articles,
      page: page,
      hasMore: hasMore,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError: clearLoadMoreError
          ? null
          : loadMoreError ?? this.loadMoreError,
    );
  }

  @override
  List<Object?> get props => [
    articles,
    page,
    hasMore,
    isLoadingMore,
    loadMoreError,
  ];
}
