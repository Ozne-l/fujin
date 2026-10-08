import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, test;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;

import '../support/fake_backends.dart';

void main() {
  test('the dev flavor stops writes on the app HTTP client', () async {
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(
          AppEnvironment.fromFlavor('dev'),
        ),
      ],
    );
    addTearDown(container.dispose);

    final client = container.read(httpClientProvider);

    await check(
      client.post(ekkloUri.resolve('/api/v1/nutritions/daily-meals')),
    ).throws<http.ClientException>(
      (blocked) => blocked
          .has((exception) => exception.message, 'message')
          .contains('read-only dev environment'),
    );
  });

  test(
    'a missing or unknown flavor fails instead of running as production',
    () {
      check(() => AppEnvironment.fromFlavor(null)).throws<StateError>();
      check(() => AppEnvironment.fromFlavor('staging')).throws<ArgumentError>();
    },
  );
}
