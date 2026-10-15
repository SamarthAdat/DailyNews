import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/utils/validators.dart';

void main() {
  group('Validators.email', () {
    test('rejects empty input', () {
      expect(Validators.email(''), isNotNull);
      expect(Validators.email('   '), isNotNull);
      expect(Validators.email(null), isNotNull);
    });

    test('rejects malformed addresses', () {
      expect(Validators.email('john'), isNotNull);
      expect(Validators.email('john@'), isNotNull);
      expect(Validators.email('john@mail'), isNotNull);
    });

    test('accepts valid addresses', () {
      expect(Validators.email('john@mail.com'), isNull);
      expect(Validators.email(' jane.doe+news@company.co.in '), isNull);
    });
  });

  group('Validators.password', () {
    test('rejects short passwords', () {
      expect(Validators.password(''), isNotNull);
      expect(Validators.password('12345'), isNotNull);
    });

    test('accepts passwords with minimum length', () {
      expect(Validators.password('123456'), isNull);
    });
  });
}
