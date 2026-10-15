import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/core/network/api_client.dart';
import 'package:daily_news/features/search/data/datasources/search_remote_data_source.dart';

class _PendingApiClient implements ApiClient {
  final requests = <({Map<String, dynamic> query, CancelToken token})>[];
  final _completers = <Completer<Map<String, dynamic>>>[];

  @override
  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
  }) {
    final completer = Completer<Map<String, dynamic>>();
    requests.add((query: queryParameters!, token: cancelToken!));
    _completers.add(completer);
    cancelToken.whenCancel.then((_) {
      if (!completer.isCompleted) {
        completer.completeError(const RequestCancelledException());
      }
    });
    return completer.future;
  }

  void completeLast() => _completers.last.complete({
    'status': 'ok',
    'totalResults': 0,
    'articles': <dynamic>[],
  });
}

void main() {
  test('a new search cancels the one still in flight', () async {
    final client = _PendingApiClient();
    final dataSource = SearchRemoteDataSource(client);

    final first = dataSource.searchArticles(
      text: 'tesla',
      sortBy: 'relevancy',
      page: 1,
    );
    final second = dataSource.searchArticles(
      text: 'tesla earnings',
      sortBy: 'relevancy',
      page: 1,
    );
    client.completeLast();

    await expectLater(first, throwsA(isA<RequestCancelledException>()));
    await expectLater(second, completes);
    expect(client.requests.first.token.isCancelled, isTrue);
    expect(client.requests.last.token.isCancelled, isFalse);
  });

  test('sends filters to the API', () async {
    final client = _PendingApiClient();
    final dataSource = SearchRemoteDataSource(client);

    final request = dataSource.searchArticles(
      text: 'oil',
      sortBy: 'publishedAt',
      page: 2,
      from: DateTime.utc(2026, 10, 8),
    );
    client.completeLast();
    await request;

    expect(client.requests.single.query, {
      'q': 'oil',
      'searchIn': 'title,description',
      'language': 'en',
      'sortBy': 'publishedAt',
      'page': 2,
      'pageSize': 20,
      'from': '2026-10-08T00:00:00.000Z',
    });
  });
}
