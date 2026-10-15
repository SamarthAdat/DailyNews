import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/core/error/failures.dart';

void main() {
  group('mapToFailure', () {
    test('maps network exception to NetworkFailure', () {
      expect(mapToFailure(const NetworkException()), isA<NetworkFailure>());
    });

    test('keeps the server message when there is one', () {
      final failure = mapToFailure(
        const ServerException(message: 'Rate limited', statusCode: 429),
      );

      expect(failure, const ServerFailure('Rate limited'));
    });

    test('falls back to a default server message', () {
      final failure = mapToFailure(const ServerException(statusCode: 500));

      expect(failure.message, isNotEmpty);
      expect(failure, isA<ServerFailure>());
    });

    test('returns the same failure when given a failure', () {
      const failure = CacheFailure('disk full');

      expect(mapToFailure(failure), same(failure));
    });

    test('maps unknown errors to UnexpectedFailure', () {
      expect(mapToFailure(StateError('boom')), isA<UnexpectedFailure>());
    });
  });
}
