import 'package:checks/checks.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_test/flutter_test.dart' show test;
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/data/http/blocked_web_socket.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

import '../support/fake_backends.dart';
import '../support/fixtures.dart';

const _syncPath = '/iphone_api/synchronize';
const _unknownBarcode = '4006381333931';

final class _Guarded {
  _Guarded(this.backends)
    : client = ReadOnlyHttpClient(
        backends.httpClient,
        ekkloBaseUri: ekkloUri,
        mfpSyncUri: mfpSyncUri,
      );

  final FakeBackends backends;
  final ReadOnlyHttpClient client;

  EkkloClient ekklo(EkkloTokenStore store) =>
      EkkloClient(httpClient: client, baseUri: ekkloUri, tokenStore: store);

  MyFitnessPalClient mfp() => MyFitnessPalClient(
    httpClient: client,
    webUri: mfpWebUri,
    apiUri: mfpApiUri,
    syncUri: mfpSyncUri,
    sessionStore: InMemoryMfpSessionStore(),
  );

  Future<EkkloClient> signedInEkklo() async {
    final signedIn = ekklo(InMemoryEkkloTokenStore());
    await signedIn.login(
      email: FakeBackends.ekkloEmail,
      password: FakeBackends.ekkloPassword,
    );
    return signedIn;
  }

  Future<MyFitnessPalClient> signedInMfp() async {
    final signedIn = mfp();
    await signedIn.signIn(FakeBackends.mfpSession);
    return signedIn;
  }

  Iterable<String> get writesSent => backends.requests
      .where((request) => request.method != 'GET')
      .map((request) => '${request.method} ${request.url.path}');
}

void main() {
  test('lets reads and the Ekklo sign-in through', () async {
    final guarded = _Guarded(FakeBackends());

    final ekklo = await guarded.signedInEkklo();
    await ekklo.meals.forDate(day);
    final mfp = await guarded.signedInMfp();
    await mfp.diary.forDate(day);

    check(guarded.writesSent).deepEquals(['POST /api/v1/auth/login']);
    check(
      guarded.backends.requests.map((request) => request.url.path),
    ).contains('/v2/diary');
  });

  test('lets an expired Ekklo session refresh', () async {
    final guarded = _Guarded(FakeBackends());
    final store = InMemoryEkkloTokenStore();
    await store.write(FakeBackends.staleEkkloTokens);

    await check(
      guarded.ekklo(store).meals.forDate(day),
    ).throws<EkkloAuthException>();

    check(
      guarded.writesSent,
    ).deepEquals(['POST /api/v1/auth/login/refresh_token']);
  });

  test('stops every Ekklo chat request, reads included', () async {
    final guarded = _Guarded(FakeBackends());
    final ekklo = await guarded.signedInEkklo();

    await check(ekklo.messaging.me()).completes();
    await check(
      ekklo.messaging.conversations(),
    ).throws<EkkloNetworkException>();
    await check(
      ekklo.messaging.messages(FakeChat.conversationId),
    ).throws<EkkloNetworkException>();
    await check(
      ekklo.messaging.presignUpload(
        fileName: 'plate.jpg',
        fileType: 'image/jpeg',
        resourceType: EkkloUploadResourceType.values.first,
        resourceId: FakeChat.conversationId,
      ),
    ).throws<EkkloNetworkException>();

    check(
      guarded.backends.requests.map((request) => request.url.path),
    ).not((paths) => paths.any((path) => path.startsWith('/api/v1/messaging')));
    check(
      guarded.backends.requests.map((request) => request.url.path),
    ).not((paths) => paths.any((path) => path.startsWith('/api/v1/uploads')));
  });

  test('never opens the Ekklo chat socket', () async {
    final store = InMemoryEkkloTokenStore();
    await store.write(FakeChat.ownerTokens);
    final ekklo = EkkloClient(
      baseUri: ekkloUri,
      tokenStore: store,
      webSocketConnector: blockedWebSocket,
    );

    await check(
      ekklo.messaging.connectSocket(),
    ).throws<EkkloNetworkException>();
  });

  test('lets the MyFitnessPal barcode lookup through', () async {
    final guarded = _Guarded(FakeBackends());
    final mfp = await guarded.signedInMfp();

    await check(
      mfp.foods.byBarcode(_unknownBarcode),
    ).completes((result) => result.isA<MfpBarcodeUnknown>());

    check(guarded.writesSent).deepEquals(['POST $_syncPath']);
  });

  test('stops every other write before it reaches the server', () async {
    final guarded = _Guarded(FakeBackends());
    final ekklo = await guarded.signedInEkklo();
    final mfp = await guarded.signedInMfp();

    await check(ekklo.meals.delete('meal-1')).throws<EkkloNetworkException>();
    await check(
      ekklo.foods.deleteOwn('food-1'),
    ).throws<EkkloNetworkException>();
    await check(mfp.diary.remove('entry-1')).throws<MfpNetworkException>();
    await check(
      guarded.client.put(ekkloUri.resolve('/api/v1/nutritions/daily-meals')),
    ).throws<http.ClientException>();
    await check(
      guarded.client.patch(mfpApiUri.resolve('/v2/diary')),
    ).throws<http.ClientException>();
    await check(
      guarded.client.post(mfpApiUri.resolve('/api/v1/auth/login')),
    ).throws<http.ClientException>();

    await check(
      guarded.client.post(mfpApiUri.resolve(_syncPath)),
    ).throws<http.ClientException>();
    await check(
      guarded.client.post(mfpSyncUri.resolve('/v2/diary')),
    ).throws<http.ClientException>();
    await check(
      guarded.client.post(mfpApiUri.resolve('/v2/diary')),
    ).throws<http.ClientException>();

    check(guarded.writesSent).deepEquals(['POST /api/v1/auth/login']);
  });
}
