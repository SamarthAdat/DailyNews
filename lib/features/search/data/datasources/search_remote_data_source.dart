import 'package:dio/dio.dart';

import 'package:daily_news/core/constants/api_constants.dart';
import 'package:daily_news/core/network/api_client.dart';
import 'package:daily_news/features/news/data/models/articles_response_model.dart';

class SearchRemoteDataSource {
  SearchRemoteDataSource(this._client);

  final ApiClient _client;
  CancelToken? _inFlight;

  Future<ArticlesResponseModel> searchArticles({
    required String text,
    required String sortBy,
    required int page,
    DateTime? from,
    int pageSize = ApiConstants.pageSize,
  }) async {
    _inFlight?.cancel();
    final cancelToken = _inFlight = CancelToken();

    try {
      final json = await _client.get(
        ApiConstants.everything,
        cancelToken: cancelToken,
        queryParameters: {
          'q': text,
          'searchIn': 'title,description',
          'language': 'en',
          'sortBy': sortBy,
          'page': page,
          'pageSize': pageSize,
          if (from != null) 'from': from.toUtc().toIso8601String(),
        },
      );
      return ArticlesResponseModel.fromJson(json);
    } finally {
      if (identical(_inFlight, cancelToken)) _inFlight = null;
    }
  }
}
