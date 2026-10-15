import 'package:daily_news/features/search/domain/repositories/search_repository.dart';

class GetRecentSearches {
  const GetRecentSearches(this._repository);

  final SearchRepository _repository;

  List<String> call() => _repository.getRecentSearches();
}

class SaveRecentSearch {
  const SaveRecentSearch(this._repository);

  final SearchRepository _repository;

  Future<void> call(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    await _repository.saveRecentSearch(trimmed);
  }
}

class ClearRecentSearches {
  const ClearRecentSearches(this._repository);

  final SearchRepository _repository;

  Future<void> call() => _repository.clearRecentSearches();
}
