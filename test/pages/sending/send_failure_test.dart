import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show group, test;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../../support/fake_backends.dart';
import '../../support/fixtures.dart';

void main() {
  group('in Fujin DEV', () {
    Future<Object> mfpError(
      Future<void> Function(MyFitnessPalClient mfp) call,
    ) async {
      final backends = FakeBackends();
      final mfp = backends.mfpWith(
        InMemoryMfpSessionStore(),
        client: ReadOnlyHttpClient(
          backends.httpClient,
          ekkloBaseUri: ekkloUri,
          mfpSyncUri: mfpSyncUri,
        ),
      );
      await mfp.signIn(FakeBackends.mfpSession);
      backends.mfpReachable = false;
      try {
        await call(mfp);
      } on Object catch (error) {
        return error;
      }
      throw StateError('MyFitnessPal answered');
    }

    test(
      'reads a MyFitnessPal read that fails as a network failure, not as '
      'blocked',
      () async {
        final error = await mfpError((mfp) => mfp.diary.forDate(day));

        check(
          SendFailure.of(error, AppEnvironment.dev),
        ).equals(SendFailure.network);
      },
    );

    test('reads a MyFitnessPal write as blocked', () async {
      final error = await mfpError((mfp) => mfp.diary.remove('e1'));

      check(
        SendFailure.of(error, AppEnvironment.dev),
      ).equals(SendFailure.blockedInDev);
    });
  });
}
