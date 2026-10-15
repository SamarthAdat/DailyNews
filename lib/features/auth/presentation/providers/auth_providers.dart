import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/core/storage/storage_providers.dart';
import 'package:daily_news/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:daily_news/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:daily_news/features/auth/domain/repositories/auth_repository.dart';
import 'package:daily_news/features/auth/domain/usecases/get_current_user.dart';
import 'package:daily_news/features/auth/domain/usecases/login_user.dart';
import 'package:daily_news/features/auth/domain/usecases/logout_user.dart';

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>(
  (ref) => AuthLocalDataSource(ref.watch(sessionBoxProvider)),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(ref.watch(authLocalDataSourceProvider)),
);

final getCurrentUserProvider = Provider<GetCurrentUser>(
  (ref) => GetCurrentUser(ref.watch(authRepositoryProvider)),
);

final loginUserProvider = Provider<LoginUser>(
  (ref) => LoginUser(ref.watch(authRepositoryProvider)),
);

final logoutUserProvider = Provider<LogoutUser>(
  (ref) => LogoutUser(ref.watch(authRepositoryProvider)),
);
