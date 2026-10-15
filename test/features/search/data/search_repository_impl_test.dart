import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/core/error/failures.dart';
import 'package:daily_news/features/news/data/models/articles_response_model.dart';
import 'package:daily_news/features/search/data/datasources/search_history_local_data_source.dart';
import 'package:daily_news/features/search/data/datasources/search_remote_data_source.dart';
import 'package:daily_news/features/search/data/repositories/search_repository_impl.dart';
import 'package:daily_news/features/search/domain/entities/search_query.dart';

class _FakeRemote implements SearchRemoteDataSource {
  _FakeRemote({this.error});

  final Exception? error;
  late String text;
  late String sortBy;
  DateTime? from;

  @override
  Future<ArticlesResponseModel> searchArticles({
    required String text,
    required String sortBy,
    required int page,
    DateTime? from,
    int pageSize = 20,
  }) async {
    if (error != null) throw error!;
    this.text = text;
    this.sortBy = sortBy;
    this.from = from;
    return const ArticlesResponseModel(articles: [], totalResults: 0);
  }
}

class _NoHistory implements SearchHistoryLocalDataSource {
  @override
  List<String> read() => const [];

  @override
  Future<void> add(String text) async {}

  @override
  Future<void> clear() async {}
}

void main() {
  final now = DateTime(2026, 10, 15, 12);

  test('translates the query into API parameters', () async {
    final remote = _FakeRemote();
    final repository = SearchRepositoryImpl(
      remote,
      _NoHistory(),
      clock: () => now,
    );

    final page = await repository.searchArticles(
      query: const SearchQuery(
        text: ' fed rates ',
        sort: SearchSort.latest,
        period: SearchPeriod.week,
      ),
      page: 1,
    );

    expect(remote.text, 'fed rates');
    expect(remote.sortBy, 'publishedAt');
    expect(remote.from, DateTime(2026, 10, 8, 12));
    expect(page.hasMore, isFalse);
  });

  test('cancelled requests surface as CancelledFailure', () async {
    final repository = SearchRepositoryImpl(
      _FakeRemote(error: const RequestCancelledException()),
      _NoHistory(),
    );

    await expectLater(
      repository.searchArticles(query: const SearchQuery(text: 'oil'), page: 1),
      throwsA(isA<CancelledFailure>()),
    );
  });
}
