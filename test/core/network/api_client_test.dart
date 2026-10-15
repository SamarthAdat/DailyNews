import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:daily_news/core/config/env.dart';
import 'package:daily_news/core/error/exceptions.dart';
import 'package:daily_news/core/network/network_providers.dart';

void main() {
  test(
    'requests fail with a clear message when the API key is missing',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final request = container.read(apiClientProvider).get('/top-headlines');

      await expectLater(
        request,
        throwsA(
          isA<ServerException>().having(
            (e) => e.message,
            'message',
            contains('API key is missing'),
          ),
        ),
      );
    },
    skip: Env.hasNewsApiKey ? 'API key is set for this run' : false,
  );
}
