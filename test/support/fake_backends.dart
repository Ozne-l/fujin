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
    this.ekkloFoods = const [],
    this.ekkloSearches = const {},
  });

  List<MfpFoodEntry> entries;
  List<EkkloDailyMeal> ekkloMeals;
  List<String> mealNames;
  List<EkkloFood> ekkloFoods;
  Map<String, List<EkkloFood>> ekkloSearches;
  final failingMeals = <String>{};
  final lostReplies = <String>{};
  var _nextId = 0;
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
      ('GET', final host, '/api/v1/nutritions/food-items/search')
          when host == ekkloUri.host =>
        _json([
          for (final food
              in ekkloSearches[request.url.queryParameters['q']] ??
                  const <EkkloFood>[])
            food.toMap(),
        ]),
      ('GET', final host, final path)
          when host == ekkloUri.host && path.startsWith(_foodItems) =>
        switch (ekkloFoods
            .where((food) => path == '$_foodItems${food.id}')
            .firstOrNull) {
          final food? => _json(food.toMap()),
          null => http.Response('', 404),
        },
      ('POST', final host, '/api/v1/nutritions/client/food-items')
          when host == ekkloUri.host =>
        _createOwn(request),
      ('POST', final host, _dailyMeals) when host == ekkloUri.host =>
        _appendItems(request),
      ('PUT', final host, final path)
          when host == ekkloUri.host && path.startsWith(_dailyMeals) =>
        _updateQuantity(request),
      ('DELETE', final host, final path)
          when host == ekkloUri.host && path.startsWith(_dailyMeals) =>
        _removeItem(request),
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

  static const _dailyMeals = '/api/v1/nutritions/daily-meals';
  static const _foodItems = '/api/v1/nutritions/food-items/';

  List<EkkloDailyMealItem> get ekkloItems => [
    for (final meal in ekkloMeals) ...meal.items,
  ];

  String _id(String prefix) => '$prefix-${++_nextId}';

  http.Response _createOwn(http.Request request) {
    final draft = EkkloFoodDraftMapper.fromJson(request.body);
    final food = EkkloFood(
      id: _id('own'),
      name: draft.name,
      portion: draft.portion,
      quantityType: draft.quantityType,
      calories: draft.calories,
      proteins: draft.proteins,
      carbs: draft.carbs,
      fats: draft.fats,
      fiber: draft.fiber ?? 0,
      sugar: draft.sugar,
      sodiumMilligrams: draft.sodiumMilligrams,
      category: draft.category,
      brands: draft.brands,
    );
    ekkloFoods = [...ekkloFoods, food];
    return _json(food.toMap());
  }

  http.Response _appendItems(http.Request request) {
    final body = jsonDecode(request.body) as Map<String, Object?>;
    final name = body['name'] as String? ?? '';
    if (failingMeals.contains(name)) return http.Response('', 503);
    final drafts = [
      for (final item in body['daily_meal_items'] as List<Object?>? ?? [])
        EkkloMealItemDraftMapper.fromMap(item as Map<String, Object?>),
    ];
    final items = [
      for (final draft in drafts)
        EkkloDailyMealItem(
          id: _id('item'),
          itemType: EkkloMealItemType.food,
          quantity: draft.quantity,
          quantityType: draft.quantityType,
          foodId: draft.foodId,
        ),
    ];
    final existing = ekkloMeals.where((meal) => meal.name == name).firstOrNull;
    final updated = switch (existing) {
      final meal? => meal.copyWith(items: [...meal.items, ...items]),
      null => EkkloDailyMeal(
        id: _id('meal'),
        date: DateTime.parse(body['date'] as String? ?? ''),
        name: name,
        revision: 1,
        items: items,
      ),
    };
    ekkloMeals = [
      for (final meal in ekkloMeals)
        if (meal.id != updated.id) meal,
      updated,
    ];
    if (lostReplies.contains(name)) return http.Response('', 503);
    return _json(updated.toMap());
  }

  http.Response _updateQuantity(http.Request request) {
    final (mealId, itemId) = _mealAndItem(request);
    final body = jsonDecode(request.body) as Map<String, Object?>;
    EkkloDailyMealItem? updated;
    ekkloMeals = [
      for (final meal in ekkloMeals)
        meal.id == mealId
            ? meal.copyWith(
                items: [
                  for (final item in meal.items)
                    item.id == itemId
                        ? updated = item.copyWith(
                            quantity: (body['quantity'] as num? ?? 0)
                                .toDouble(),
                          )
                        : item,
                ],
              )
            : meal,
    ];
    return switch (updated) {
      final item? => _json(item.toMap()),
      null => http.Response('', 404),
    };
  }

  http.Response _removeItem(http.Request request) {
    final (mealId, itemId) = _mealAndItem(request);
    ekkloMeals = [
      for (final meal in ekkloMeals)
        meal.id == mealId
            ? meal.copyWith(
                items: [
                  for (final item in meal.items)
                    if (item.id != itemId) item,
                ],
              )
            : meal,
    ];
    return http.Response('', 204);
  }

  static (String, String) _mealAndItem(http.Request request) {
    final segments = request.url.pathSegments;
    return (segments[segments.length - 3], segments.last);
  }

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
