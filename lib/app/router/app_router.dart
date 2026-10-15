import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:daily_news/app/router/app_routes.dart';
import 'package:daily_news/app/shell/main_shell.dart';
import 'package:daily_news/features/auth/presentation/providers/auth_controller.dart';
import 'package:daily_news/features/auth/presentation/screens/login_screen.dart';
import 'package:daily_news/features/favorites/presentation/screens/favorites_screen.dart';
import 'package:daily_news/features/news/presentation/screens/feed_screen.dart';
import 'package:daily_news/features/search/presentation/screens/search_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ValueNotifier<bool>(ref.read(isLoggedInProvider));
  ref.listen(isLoggedInProvider, (_, next) => isLoggedIn.value = next);

  final router = GoRouter(
    initialLocation: AppRoutes.feed,
    refreshListenable: isLoggedIn,
    redirect: (context, state) {
      final onLoginPage = state.matchedLocation == AppRoutes.login;

      if (!isLoggedIn.value) return onLoginPage ? null : AppRoutes.login;
      if (onLoginPage) return AppRoutes.feed;
      return null;
    },
    routes: [
      GoRoute(path: AppRoutes.login, builder: (_, _) => const LoginScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            MainShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.feed,
                builder: (_, _) => const FeedScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.search,
                builder: (_, _) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (_, _) => const FavoritesScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );

  ref.onDispose(() {
    router.dispose();
    isLoggedIn.dispose();
  });
  return router;
});
