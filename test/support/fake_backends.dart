import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/calendar_date_hook.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final Uri mfpWebUri = Uri.parse('https://mfp-web.test');
final Uri mfpApiUri = Uri.parse('https://mfp-api.test');
final Uri ekkloUri = Uri.parse('https://ekklo.test');
final Uri mfpSyncUri = Uri.parse('https://mfp-sync.test');

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
    this.mfpFoods = const [],
    this.mfpSearches = const {},
    this.mfpBarcodes = const {},
  });

  List<MfpFoodEntry> entries;
  List<EkkloDailyMeal> ekkloMeals;
  List<String> mealNames;
  List<EkkloFood> ekkloFoods;
  Map<String, List<EkkloFood>> ekkloSearches;
  List<MfpFood> mfpFoods;
  Map<String, List<MfpFood>> mfpSearches;
  Map<String, MfpFood> mfpBarcodes;
  bool mfpWritesFail = false;
  final failingMeals = <String>{};
  final lostReplies = <String>{};
  var _nextId = 0;
  bool ekkloReachable = true;
  bool mfpReachable = true;
  int? mfpDiaryStatus;
  int? mfpSearchStatus;
  int? mfpSyncStatus;
  Completer<void>? diaryGate;
  Completer<void>? mealsGate;
  Completer<void>? mfpSearchGate;
  Completer<void>? mfpFoodGate;
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
    if (diaryGate case final gate? when request.url.path == _diaryPath) {
      await gate.future;
    }
    if (mealsGate case final gate?
        when request.method == 'GET' && request.url.path == dailyMealsPath) {
      await gate.future;
    }
    if (mfpSearchGate case final gate? when request.url.path == _mfpSearch) {
      await gate.future;
    }
    if (mfpFoodGate case final gate? when request.url.path == _mfpFoods) {
      await gate.future;
    }
    return switch ((request.method, request.url.host, request.url.path)) {
      (_, final host, _) when host == ekkloUri.host && !ekkloReachable =>
        throw http.ClientException('Connection refused', request.url),
      (_, final host, _)
          when (host == mfpWebUri.host ||
                  host == mfpApiUri.host ||
                  host == mfpSyncUri.host) &&
              !mfpReachable =>
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
      ('GET', final host, _diaryPath) when host == mfpApiUri.host =>
        switch (mfpDiaryStatus) {
          final status? => http.Response('', status),
          null => _json({
            'items': [
              for (final entry in entries)
                if (CalendarDateHook.format(entry.date) ==
                    request.url.queryParameters[_entryDate])
                  entry.toMap(),
            ],
          }),
        },
      ('POST', final host, _diaryPath) when host == mfpApiUri.host => _addEntry(
        request,
      ),
      ('DELETE', final host, final path)
          when host == mfpApiUri.host && path.startsWith('$_diaryPath/') =>
        _removeEntry(request),
      ('GET', final host, _mfpSearch) when host == mfpApiUri.host =>
        switch (mfpSearchStatus) {
          final status? => http.Response('', status),
          null => _json({
            'items': [
              for (final food
                  in mfpSearches[request.url.queryParameters['q']] ??
                      const <MfpFood>[])
                if (request.url.queryParameters['scope'] != _verifiedScope ||
                    (food.verified ?? false))
                  {'type': _foodHit, 'item': food.toMap()},
            ],
          }),
        },
      ('GET', final host, _mfpFoods) when host == mfpApiUri.host => _json({
        'items': [
          for (final food in mfpFoods)
            if (food.id == request.url.queryParameters['ids']) food.toMap(),
        ],
      }),
      ('POST', final host, _syncPath) when host == mfpSyncUri.host =>
        switch (mfpSyncStatus) {
          final status? => http.Response('', status),
          null => _barcode(request),
        },
      ('GET', final host, '/v2/users/mfp-user') when host == mfpApiUri.host =>
        _json({
          'item': {
            'diary_preferences': {'meal_names': mealNames},
          },
        }),
      ('GET', final host, dailyMealsPath) when host == ekkloUri.host => _json([
        for (final meal in ekkloMeals) meal.toMap(),
      ]),
      ('GET', final host, _mealHistory) when host == ekkloUri.host => _json(
        EkkloMealHistoryPage(
          currentPage: 1,
          hasNext: false,
          hasPrev: false,
          items: ekkloMeals,
        ).toMap(),
      ),
      ('GET', final host, _foodSearch) when host == ekkloUri.host => _json([
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
      ('POST', final host, dailyMealsPath) when host == ekkloUri.host =>
        _appendItems(request),
      ('PUT', final host, final path)
          when host == ekkloUri.host && path.startsWith(dailyMealsPath) =>
        _updateQuantity(request),
      ('DELETE', final host, final path)
          when host == ekkloUri.host && path.startsWith(dailyMealsPath) =>
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
    syncUri: mfpSyncUri,
    sessionStore: store,
  );

  Future<EkkloClient> ekklo() async => ekkloWith(await ekkloTokenStore());

  Future<EkkloTokenStore> ekkloTokenStore() async {
    final store = InMemoryEkkloTokenStore();
    await store.write(_ekkloTokens);
    return store;
  }

  EkkloClient ekkloWith(EkkloTokenStore store) => EkkloClient(
    httpClient: httpClient,
    baseUri: ekkloUri,
    tokenStore: store,
  );

  static const dailyMealsPath = '/api/v1/nutritions/daily-meals';
  static const _diaryPath = '/v2/diary';
  static const _entryDate = 'entry_date';
  static const _mfpSearch = '/v2/search/nutrition';
  static const _mfpFoods = '/v2/foods';
  static const _verifiedScope = 'verified';
  static const _foodHit = 'food';
  static const _syncPath = '/iphone_api/synchronize';
  static const _syncMagic = 0x04d3;
  static const _syncHeaderSize = 10;
  static const _syncSequenceOffset = 16;
  static const _syncReply = 102;
  static const _syncFood = 31;
  static const _syncOk = 1;
  static const _foodItems = '/api/v1/nutritions/food-items/';
  static const _foodSearch = '${_foodItems}search';
  static const _mealHistory = '$dailyMealsPath/history';

  List<EkkloDailyMealItem> get ekkloItems => [
    for (final meal in ekkloMeals) ...meal.items,
  ];

  String _id(String prefix) => '$prefix-${++_nextId}';

  http.Response _addEntry(http.Request request) {
    if (mfpWritesFail) return http.Response('', 500);
    return switch (jsonDecode(request.body)) {
      {
        'items': [
          {
            'date': final String date,
            'meal_name': final String mealName,
            'servings': final num servings,
            'food': {'id': final String foodId},
            'serving_size':
                {
                  'value': final num value,
                  'unit': final String unit,
                } &&
                final Map<String, Object?> serving,
          },
        ],
      } =>
        switch (mfpFoods.where((food) => food.id == foodId).firstOrNull) {
          final food? => _entryAdded(
            food,
            date: DateTime.parse(date),
            mealName: mealName,
            servings: servings.toDouble(),
            servingSize: MfpServingSize(
              value: value.toDouble(),
              unit: unit,
              nutritionMultiplier: switch (serving['nutrition_multiplier']) {
                final num multiplier => multiplier.toDouble(),
                _ => null,
              },
            ),
          ),
          null => http.Response('', 404),
        },
      _ => http.Response('', 400),
    };
  }

  http.Response _entryAdded(
    MfpFood food, {
    required DateTime date,
    required String mealName,
    required double servings,
    required MfpServingSize servingSize,
  }) {
    final factor = (servingSize.nutritionMultiplier ?? 1) * servings;
    final perServing = food.nutrients ?? const MfpNutrients();
    double? scaled(double? amount) => switch (amount) {
      final amount? => amount * factor,
      null => null,
    };
    final id = _id('entry');
    entries = [
      ...entries,
      MfpFoodEntry(
        id: id,
        date: DateTime.utc(date.year, date.month, date.day),
        mealName: mealName,
        mealPosition: 0,
        servings: servings,
        servingSize: servingSize,
        food: MfpEntryFood(
          id: food.id,
          description: food.description,
          version: food.version,
          brandName: food.brandName,
        ),
        nutrients: MfpNutrients(
          energy: switch (perServing.energy) {
            final energy? => MfpEnergy(
              unit: energy.unit,
              value: energy.value * factor,
            ),
            null => null,
          },
          protein: scaled(perServing.protein),
          carbohydrates: scaled(perServing.carbohydrates),
          fat: scaled(perServing.fat),
          fiber: scaled(perServing.fiber),
        ),
      ),
    ];
    return _json({
      'items': [
        {'id': id},
      ],
    });
  }

  http.Response _removeEntry(http.Request request) {
    if (mfpWritesFail) return http.Response('', 500);
    final id = request.url.pathSegments.last;
    entries = [
      for (final entry in entries)
        if (entry.id != id) entry,
    ];
    return http.Response('', 204);
  }

  http.Response _barcode(http.Request request) {
    final body = request.bodyBytes;
    final start = _indexOf(body, ascii.encode('\r\n\r\n')) + 4;
    final data = ByteData.sublistView(
      body,
      start,
      _indexOf(body, ascii.encode('\r\n--'), from: start),
    );
    final sequence = data.getInt64(_syncSequenceOffset);
    final lookup = data.getUint32(2) + _syncHeaderSize;
    final length = data.getUint16(lookup);
    final barcode = utf8.decode(
      Uint8List.sublistView(
        body,
        start + lookup + 2,
        start + lookup + 2 + length,
      ),
    );
    return http.Response.bytes(
      [
        ..._syncPacket(_syncReply, [..._i64(sequence), _syncOk]),
        if (mfpBarcodes[barcode] case final food?)
          ..._syncPacket(_syncFood, [
            ..._i64(0),
            ..._syncString(food.id),
            ..._i64(0),
            ..._i64(0),
            ..._syncString(''),
            ..._i64(0),
            ..._syncString(''),
            ..._syncString(food.description),
            ..._syncString(food.brandName ?? ''),
          ]),
      ],
      200,
      headers: {'content-type': 'application/octet-stream'},
    );
  }

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
    if (failingMeals.contains(name)) return http.Response('', 422);
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
        if (meal.id == mealId)
          meal.copyWith(
            items: [
              for (final item in meal.items)
                if (item.id == itemId)
                  updated = item.copyWith(
                    quantity: (body['quantity'] as num? ?? 0).toDouble(),
                  )
                else
                  item,
            ],
          )
        else
          meal,
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
        if (meal.id == mealId)
          meal.copyWith(
            items: [
              for (final item in meal.items)
                if (item.id != itemId) item,
            ],
          )
        else
          meal,
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

  static int _indexOf(List<int> bytes, List<int> needle, {int from = 0}) {
    for (var i = from; i <= bytes.length - needle.length; i++) {
      var matches = true;
      for (var j = 0; j < needle.length && matches; j++) {
        matches = bytes[i + j] == needle[j];
      }
      if (matches) return i;
    }
    throw StateError('multipart boundary not found');
  }

  static List<int> _syncPacket(int type, List<int> payload) => [
    ...(ByteData(2)..setUint16(0, _syncMagic)).buffer.asUint8List(),
    ...(ByteData(
      4,
    )..setUint32(0, _syncHeaderSize + payload.length)).buffer.asUint8List(),
    ...(ByteData(2)..setUint16(0, 1)).buffer.asUint8List(),
    ...(ByteData(2)..setUint16(0, type)).buffer.asUint8List(),
    ...payload,
  ];

  static List<int> _syncString(String value) {
    final bytes = utf8.encode(value);
    return [
      ...(ByteData(2)..setUint16(0, bytes.length)).buffer.asUint8List(),
      ...bytes,
    ];
  }

  static List<int> _i64(int value) =>
      (ByteData(8)..setInt64(0, value)).buffer.asUint8List();

  static http.Response _json(Object body) =>
      http.Response(jsonEncode(body), 200, headers: _jsonType);
}
