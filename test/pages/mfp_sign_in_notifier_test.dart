import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, test;
import 'package:fujin/app/providers.dart';
import 'package:fujin/pages/common/sign_in_failure.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_notifier.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';

ProviderContainer _signInWith(FakeBackends backends, MfpSessionStore store) {
  final container = ProviderContainer(
    overrides: [mfpClientProvider.overrideWithValue(backends.mfpWith(store))],
  );
  addTearDown(container.dispose);
  container.listen(mfpSignInProvider, (previous, next) {});
  return container;
}

Iterable<http.Request> _tokenRequests(FakeBackends backends) => backends
    .requests
    .where((request) => request.url.path == '/user/auth_token');

void main() {
  test('waits for a session cookie before asking MyFitnessPal', () async {
    final backends = FakeBackends();
    final container = _signInWith(backends, InMemoryMfpSessionStore());

    await container
        .read(mfpSignInProvider.notifier)
        .offer(const MfpSessionCookies({'consent': 'accepted'}));

    check(container.read(mfpSignInProvider)).equals(const MfpSignInIdle());
    check(_tokenRequests(backends)).isEmpty();
  });

  test('signs in with the session cookies and stores them', () async {
    final backends = FakeBackends();
    final store = InMemoryMfpSessionStore();
    final container = _signInWith(backends, store);

    await container
        .read(mfpSignInProvider.notifier)
        .offer(FakeBackends.mfpSession);

    check(container.read(mfpSignInProvider)).equals(const MfpSignInDone());
    check(await store.read()).equals(FakeBackends.mfpSession);
  });

  test(
    'reports a refused session once, then signs in with the next cookies',
    () async {
      final backends = FakeBackends();
      final store = InMemoryMfpSessionStore();
      final notifier = _signInWith(
        backends,
        store,
      ).read(mfpSignInProvider.notifier);

      await notifier.offer(FakeBackends.refusedMfpSession);
      await notifier.offer(FakeBackends.refusedMfpSession);
      final refused = notifier.state;
      await notifier.offer(FakeBackends.mfpSession);

      check(refused).equals(const MfpSignInFailed(SignInFailure.refused));
      check(_tokenRequests(backends)).length.equals(2);
      check(notifier.state).equals(const MfpSignInDone());
    },
  );

  test(
    'says MyFitnessPal is unreachable, then tries the same cookies again',
    () async {
      final backends = FakeBackends()..mfpReachable = false;
      final store = InMemoryMfpSessionStore();
      final notifier = _signInWith(
        backends,
        store,
      ).read(mfpSignInProvider.notifier);

      await notifier.offer(FakeBackends.mfpSession);
      final unreachable = notifier.state;
      final storedWhileUnreachable = await store.read();
      backends.mfpReachable = true;
      await notifier.offer(FakeBackends.mfpSession);

      check(
        unreachable,
      ).equals(const MfpSignInFailed(SignInFailure.unreachable));
      check(storedWhileUnreachable).isNull();
      check(notifier.state).equals(const MfpSignInDone());
    },
  );
}
