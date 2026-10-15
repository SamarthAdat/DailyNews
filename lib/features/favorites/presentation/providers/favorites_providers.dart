import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/storage/storage_providers.dart';
import 'package:daily_news/features/favorites/data/datasources/favorites_local_data_source.dart';
import 'package:daily_news/features/favorites/data/repositories/favorites_repository_impl.dart';
import 'package:daily_news/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:daily_news/features/favorites/domain/usecases/add_favorite.dart';
import 'package:daily_news/features/favorites/domain/usecases/get_favorites.dart';
import 'package:daily_news/features/favorites/domain/usecases/remove_favorite.dart';

final favoritesLocalDataSourceProvider = Provider<FavoritesLocalDataSource>(
  (ref) => FavoritesLocalDataSource(ref.watch(favoritesBoxProvider)),
);

final favoritesRepositoryProvider = Provider<FavoritesRepository>(
  (ref) => FavoritesRepositoryImpl(ref.watch(favoritesLocalDataSourceProvider)),
);

final getFavoritesProvider = Provider<GetFavorites>(
  (ref) => GetFavorites(ref.watch(favoritesRepositoryProvider)),
);

final addFavoriteProvider = Provider<AddFavorite>(
  (ref) => AddFavorite(ref.watch(favoritesRepositoryProvider)),
);

final removeFavoriteProvider = Provider<RemoveFavorite>(
  (ref) => RemoveFavorite(ref.watch(favoritesRepositoryProvider)),
);
