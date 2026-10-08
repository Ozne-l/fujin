import 'dart:convert';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final Uri mfpWebUri = Uri.parse('https://mfp-web.test');
final Uri mfpApiUri = Uri.parse('https://mfp-api.test');
final Uri ekkloUri = Uri.parse('https://ekklo.test');

const _jsonType = {'content-type': 'application/json; charset=utf-8'};
const _sessionCookies = MfpSessionCookies({
  '__Secure-next-auth.session-token': 'fake-session',
});
const _ekkloTokens = EkkloTokens(
  accessToken: 'fake-access',
  refreshToken: 'fake-refresh',
);

final class FakeBackends {
  FakeBackends({
    this.entries = const [],
    this.ekkloMeals = const [],
    this.mealNames = const [],
  });

  List<MfpFoodEntry> entries;
  List<EkkloDailyMeal> ekkloMeals;
  List<String> mealNames;
  bool ekkloReachable = true;
  bool mfpReachable = true;
  final requests = <http.Request>[];

  static const ekkloEmail = 'owner@example.com';
  static const ekkloPassword = 'right-password';
  static const ekkloRefusal = 'Invalid email or password';
  static const staleEkkloTokens = EkkloTokens(
    accessToken: 'stale-access',
    refreshToken: 'stale-refresh',
  );
  static const MfpSessionCookies mfpSession = _sessionCookies;
  static const refusedMfpSession = MfpSessionCookies({
    '__Secure-next-auth.session-token': 'refused-session',
  });

  late final httpClient = MockClient((request) async {
    requests.add(request);
    return switch ((request.method, request.url.host, request.url.path)) {
      (_, final host, _) when host == ekkloUri.host && !ekkloReachable =>
        throw http.ClientException('Connection refused', request.url),
      (_, final host, _) when host == mfpWebUri.host && !mfpReachable =>
        throw http.ClientException('Connection refused', request.url),
      ('POST', final host, '/api/v1/auth/login') when host == ekkloUri.host =>
        _ekkloLogin(request),
      ('POST', final host, '/api/v1/auth/login/refresh_token')
          when host == ekkloUri.host =>
        http.Response('', 401),
      (_, final host, _)
          when host == ekkloUri.host && !_carriesEkkloAccess(request) =>
        http.Response('', 401),
      ('GET', final host, '/user/auth_token')
          when host == mfpWebUri.host &&
              request.headers['cookie'] == refusedMfpSession.header =>
        http.Response('', 401),
      ('GET', final host, '/user/auth_token') when host == mfpWebUri.host =>
        _json({
          'access_token': 'mfp-access',
          'refresh_token': 'mfp-refresh',
          'token_type': 'Bearer',
          'expires_in': 3600,
          'user_id': 'mfp-user',
        }),
      ('GET', final host, '/v2/diary') when host == mfpApiUri.host => _json({
        'items': [for (final entry in entries) entry.toMap()],
      }),
      ('GET', final host, '/v2/users/mfp-user') when host == mfpApiUri.host =>
        _json({
          'item': {
            'diary_preferences': {'meal_names': mealNames},
          },
        }),
      ('GET', final host, '/api/v1/nutritions/daily-meals')
          when host == ekkloUri.host =>
        _json([for (final meal in ekkloMeals) meal.toMap()]),
      _ => http.Response('', 404),
    };
  });

  Future<MyFitnessPalClient> mfp() async {
    final client = mfpWith(InMemoryMfpSessionStore());
    await client.signIn(_sessionCookies);
    return client;
  }

  MyFitnessPalClient mfpWith(MfpSessionStore store) => MyFitnessPalClient(
    httpClient: httpClient,
    webUri: mfpWebUri,
    apiUri: mfpApiUri,
    sessionStore: store,
  );

  Future<EkkloClient> ekklo() async {
    final store = InMemoryEkkloTokenStore();
    await store.write(_ekkloTokens);
    return ekkloWith(store);
  }

  EkkloClient ekkloWith(EkkloTokenStore store) => EkkloClient(
    httpClient: httpClient,
    baseUri: ekkloUri,
    tokenStore: store,
  );

  static http.Response _ekkloLogin(http.Request request) =>
      switch (jsonDecode(request.body)) {
        {'email': ekkloEmail, 'password': ekkloPassword} => _json({
          'access_token': _ekkloTokens.accessToken,
          'refresh_token': _ekkloTokens.refreshToken,
          'role': 'customer',
          'first_login': false,
        }),
        _ => http.Response(
          jsonEncode({'error': ekkloRefusal}),
          401,
          headers: _jsonType,
        ),
      };

  static bool _carriesEkkloAccess(http.Request request) =>
      request.headers['authorization'] == 'Bearer ${_ekkloTokens.accessToken}';

  static http.Response _json(Object body) =>
      http.Response(jsonEncode(body), 200, headers: _jsonType);
}
