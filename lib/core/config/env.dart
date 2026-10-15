abstract final class Env {
  static const newsApiKey = String.fromEnvironment('NEWS_API_KEY');

  static bool get hasNewsApiKey => newsApiKey.isNotEmpty;
}
