import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive_ce.dart';

import 'package:daily_news/features/search/data/datasources/search_history_local_data_source.dart';

void main() {
  late Directory tempDir;
  late SearchHistoryLocalDataSource history;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('search_history_test');
    Hive.init(tempDir.path);
    history = SearchHistoryLocalDataSource(
      await Hive.openBox<dynamic>('search_history_test_box'),
    );
  });

  tearDown(() async {
    await Hive.close();
    await tempDir.delete(recursive: true);
  });

  test('keeps the newest search first without duplicates', () async {
    await history.add('Tesla');
    await history.add('Oil prices');
    await history.add('tesla');

    expect(history.read(), ['tesla', 'Oil prices']);
  });

  test('keeps a limited number of entries', () async {
    for (var i = 0; i < 12; i++) {
      await history.add('query $i');
    }

    final entries = history.read();
    expect(entries, hasLength(SearchHistoryLocalDataSource.maxEntries));
    expect(entries.first, 'query 11');
  });

  test('clear removes everything', () async {
    await history.add('Tesla');
    await history.clear();

    expect(history.read(), isEmpty);
  });
}
