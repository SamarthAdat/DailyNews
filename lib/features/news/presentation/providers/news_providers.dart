import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/network/network_providers.dart';
import 'package:daily_news/features/news/data/datasources/news_remote_data_source.dart';
import 'package:daily_news/features/news/data/repositories/news_repository_impl.dart';
import 'package:daily_news/features/news/domain/repositories/news_repository.dart';
import 'package:daily_news/features/news/domain/usecases/get_top_headlines.dart';

final newsRemoteDataSourceProvider = Provider<NewsRemoteDataSource>(
  (ref) => NewsRemoteDataSource(ref.watch(apiClientProvider)),
);

final newsRepositoryProvider = Provider<NewsRepository>(
  (ref) => NewsRepositoryImpl(ref.watch(newsRemoteDataSourceProvider)),
);

final getTopHeadlinesProvider = Provider<GetTopHeadlines>(
  (ref) => GetTopHeadlines(ref.watch(newsRepositoryProvider)),
);
