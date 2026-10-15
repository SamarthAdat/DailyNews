import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:daily_news/app/router/app_routes.dart';
import 'package:daily_news/features/news/domain/entities/article.dart';
import 'package:daily_news/features/search/presentation/providers/recent_searches_controller.dart';
import 'package:daily_news/features/search/presentation/providers/search_query_controller.dart';
import 'package:daily_news/features/search/presentation/widgets/search_field.dart';
import 'package:daily_news/features/search/presentation/widgets/search_filters_bar.dart';
import 'package:daily_news/features/search/presentation/widgets/search_results_view.dart';
import 'package:daily_news/features/search/presentation/widgets/search_suggestions.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _search(String text) {
    final trimmed = text.trim();
    _controller.value = TextEditingValue(
      text: trimmed,
      selection: TextSelection.collapsed(offset: trimmed.length),
    );
    _focusNode.unfocus();
    ref.read(searchQueryProvider.notifier).submit(trimmed);
    _remember(trimmed);
  }

  void _clear() {
    _controller.clear();
    ref.read(searchQueryProvider.notifier).onTextChanged('');
    _focusNode.requestFocus();
  }

  void _openArticle(Article article) {
    _remember(ref.read(searchQueryProvider).text);
    context.push(AppRoutes.article, extra: article);
  }

  void _remember(String text) {
    ref
        .read(recentSearchesProvider.notifier)
        .remember(text)
        .catchError((Object _) {});
  }

  @override
  Widget build(BuildContext context) {
    final query = ref.watch(searchQueryProvider);
    final queryController = ref.read(searchQueryProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
            child: SearchField(
              controller: _controller,
              focusNode: _focusNode,
              onChanged: queryController.onTextChanged,
              onSubmitted: _search,
              onClear: _clear,
            ),
          ),
          SearchFiltersBar(
            query: query,
            onSortChanged: queryController.setSort,
            onPeriodChanged: queryController.setPeriod,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: query.isSearchable
                ? SearchResultsView(query: query, onOpenArticle: _openArticle)
                : SearchSuggestions(onSelected: _search),
          ),
        ],
      ),
    );
  }
}
