abstract final class ApiConstants {
  static const baseUrl = 'https://newsapi.org/v2';

  static const topHeadlines = '/top-headlines';
  static const everything = '/everything';

  static const defaultCountry = 'us';
  static const pageSize = 20;
  static const maxResults = 100;

  static const connectTimeout = Duration(seconds: 15);
  static const receiveTimeout = Duration(seconds: 20);
}
