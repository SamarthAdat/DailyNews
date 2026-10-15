import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/utils/date_formatter.dart';

void main() {
  final now = DateTime(2026, 10, 15, 12);

  test('formats recent dates relative to now', () {
    expect(DateFormatter.relative(now, now: now), 'Just now');
    expect(
      DateFormatter.relative(
        now.subtract(const Duration(minutes: 5)),
        now: now,
      ),
      '5m ago',
    );
    expect(
      DateFormatter.relative(now.subtract(const Duration(hours: 3)), now: now),
      '3h ago',
    );
    expect(
      DateFormatter.relative(now.subtract(const Duration(days: 2)), now: now),
      '2d ago',
    );
  });

  test('falls back to a short date after a week', () {
    expect(
      DateFormatter.relative(DateTime(2026, 9, 30), now: now),
      '30 Sep 2026',
    );
  });
}
