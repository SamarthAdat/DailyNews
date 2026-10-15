import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/network/network_providers.dart';
import 'package:daily_news/core/storage/storage_providers.dart';
import 'package:daily_news/features/search/data/datasources/search_history_local_data_source.dart';
import 'package:daily_news/features/search/data/datasources/search_remote_data_source.dart';
import 'package:daily_news/features/search/data/repositories/search_repository_impl.dart';
import 'package:daily_news/features/search/domain/repositories/search_repository.dart';
import 'package:daily_news/features/search/domain/usecases/recent_searches.dart';
import 'package:daily_news/features/search/domain/usecases/search_articles.dart';

final searchRemoteDataSourceProvider = Provider<SearchRemoteDataSource>(
  (ref) => SearchRemoteDataSource(ref.watch(apiClientProvider)),
);

final searchHistoryDataSourceProvider = Provider<SearchHistoryLocalDataSource>(
  (ref) => SearchHistoryLocalDataSource(ref.watch(searchBoxProvider)),
);

final searchRepositoryProvider = Provider<SearchRepository>(
  (ref) => SearchRepositoryImpl(
    ref.watch(searchRemoteDataSourceProvider),
    ref.watch(searchHistoryDataSourceProvider),
  ),
);

final searchArticlesProvider = Provider<SearchArticles>(
  (ref) => SearchArticles(ref.watch(searchRepositoryProvider)),
);

final getRecentSearchesProvider = Provider<GetRecentSearches>(
  (ref) => GetRecentSearches(ref.watch(searchRepositoryProvider)),
);

final saveRecentSearchProvider = Provider<SaveRecentSearch>(
  (ref) => SaveRecentSearch(ref.watch(searchRepositoryProvider)),
);

final clearRecentSearchesProvider = Provider<ClearRecentSearches>(
  (ref) => ClearRecentSearches(ref.watch(searchRepositoryProvider)),
);
