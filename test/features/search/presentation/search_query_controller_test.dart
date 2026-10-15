import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/features/search/domain/entities/search_query.dart';
import 'package:daily_news/features/search/presentation/providers/search_query_controller.dart';

void main() {
  late ProviderContainer container;
  late SearchQueryController controller;

  setUp(() {
    container = ProviderContainer();
    addTearDown(container.dispose);
    controller = container.read(searchQueryProvider.notifier);
  });

  Future<void> waitForDebounce() => Future<void>.delayed(
    SearchQueryController.debounceDuration + const Duration(milliseconds: 50),
  );

  test(
    'only the last keystroke within the debounce window is applied',
    () async {
      controller
        ..onTextChanged('t')
        ..onTextChanged('te')
        ..onTextChanged('tesla ');

      expect(container.read(searchQueryProvider).text, isEmpty);

      await waitForDebounce();
      expect(container.read(searchQueryProvider).text, 'tesla');
    },
  );

  test('submitting skips the debounce', () {
    controller.submit('  inflation ');

    expect(container.read(searchQueryProvider).text, 'inflation');
  });

  test('clearing the text is applied immediately', () async {
    controller.submit('oil');
    controller.onTextChanged('');

    expect(container.read(searchQueryProvider).text, isEmpty);
  });

  test('filters keep the current text', () {
    controller
      ..submit('nvidia')
      ..setSort(SearchSort.latest)
      ..setPeriod(SearchPeriod.week);

    expect(
      container.read(searchQueryProvider),
      const SearchQuery(
        text: 'nvidia',
        sort: SearchSort.latest,
        period: SearchPeriod.week,
      ),
    );
  });
}
