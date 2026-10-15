import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/search/presentation/providers/search_providers.dart';

final recentSearchesProvider =
    NotifierProvider<RecentSearchesController, List<String>>(
      RecentSearchesController.new,
    );

class RecentSearchesController extends Notifier<List<String>> {
  @override
  List<String> build() => ref.read(getRecentSearchesProvider).call();

  Future<void> remember(String text) async {
    await ref.read(saveRecentSearchProvider).call(text);
    state = ref.read(getRecentSearchesProvider).call();
  }

  Future<void> clear() async {
    await ref.read(clearRecentSearchesProvider).call();
    state = const [];
  }
}
