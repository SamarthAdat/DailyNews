import 'package:hive_ce/hive_ce.dart';

import 'package:daily_news/core/error/exceptions.dart';

class SearchHistoryLocalDataSource {
  const SearchHistoryLocalDataSource(this._box);

  static const maxEntries = 8;
  static const _key = 'recent_searches';

  final Box<dynamic> _box;

  List<String> read() {
    final raw = _box.get(_key);
    if (raw is! List) return const [];
    return raw.whereType<String>().toList();
  }

  Future<void> add(String text) async {
    final lowered = text.toLowerCase();
    final updated = [
      text,
      ...read().where((entry) => entry.toLowerCase() != lowered),
    ].take(maxEntries).toList();

    await _write(() => _box.put(_key, updated));
  }

  Future<void> clear() => _write(() => _box.delete(_key));

  Future<void> _write(Future<void> Function() operation) async {
    try {
      await operation();
    } on HiveError catch (e) {
      throw CacheException(e.message);
    }
  }
}
