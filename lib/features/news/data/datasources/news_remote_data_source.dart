import 'package:daily_news/core/constants/api_constants.dart';
import 'package:daily_news/core/network/api_client.dart';
import 'package:daily_news/features/news/data/models/articles_response_model.dart';

class NewsRemoteDataSource {
  const NewsRemoteDataSource(this._client);

  final ApiClient _client;

  Future<ArticlesResponseModel> fetchTopHeadlines({
    required String category,
    required int page,
    int pageSize = ApiConstants.pageSize,
  }) async {
    final json = await _client.get(
      ApiConstants.topHeadlines,
      queryParameters: {
        'country': ApiConstants.defaultCountry,
        'category': category,
        'page': page,
        'pageSize': pageSize,
      },
    );
    return ArticlesResponseModel.fromJson(json);
  }
}
