import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:daily_news/features/search/domain/entities/search_query.dart';

final searchQueryProvider =
    NotifierProvider<SearchQueryController, SearchQuery>(
      SearchQueryController.new,
    );

class SearchQueryController extends Notifier<SearchQuery> {
  static const debounceDuration = Duration(milliseconds: 450);

  Timer? _debounce;

  @override
  SearchQuery build() {
    ref.onDispose(() => _debounce?.cancel());
    return const SearchQuery();
  }

  void onTextChanged(String text) {
    _debounce?.cancel();
    final trimmed = text.trim();

    if (trimmed.isEmpty) {
      state = state.copyWith(text: '');
      return;
    }
    _debounce = Timer(
      debounceDuration,
      () => state = state.copyWith(text: trimmed),
    );
  }

  void submit(String text) {
    _debounce?.cancel();
    state = state.copyWith(text: text.trim());
  }

  void setSort(SearchSort sort) => state = state.copyWith(sort: sort);

  void setPeriod(SearchPeriod period) => state = state.copyWith(period: period);
}
