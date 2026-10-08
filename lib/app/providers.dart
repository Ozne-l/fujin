import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/http/read_only_http_client.dart';
import 'package:fujin/data/links/sent_link_repository.dart';
import 'package:fujin/data/memory/memory_repository.dart';
import 'package:fujin/data/sessions/secure_ekklo_token_store.dart';
import 'package:fujin/data/sessions/secure_mfp_session_store.dart';
import 'package:fujin/domain/accounts/accounts_service.dart';
import 'package:fujin/domain/journal/journal_service.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final clockProvider = Provider<DateTime Function()>((ref) => DateTime.now);

final databaseProvider = Provider<FujinDatabase>(
  (ref) => throw StateError('databaseProvider is overridden in bootstrap'),
);

final httpClientProvider = Provider<http.Client>((ref) {
  final client = switch (Config.environment) {
    AppEnvironment.production => http.Client(),
    AppEnvironment.dev => ReadOnlyHttpClient(
      http.Client(),
      ekkloBaseUri: Config.ekkloBaseUri,
    ),
  };
  ref.onDispose(client.close);
  return client;
});

final secureStorageProvider = Provider<FlutterSecureStorage>(
  (ref) => const FlutterSecureStorage(),
);

final mfpUserAgentProvider = Provider<String>(
  (ref) => MyFitnessPalClient.defaultUserAgent,
);

final mfpClientProvider = Provider<MyFitnessPalClient>((ref) {
  final client = MyFitnessPalClient(
    sessionStore: SecureMfpSessionStore(ref.watch(secureStorageProvider)),
    httpClient: ref.watch(httpClientProvider),
    webUri: Config.mfpWebUri,
    apiUri: Config.mfpApiUri,
    userAgent: ref.watch(mfpUserAgentProvider),
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(client.close);
  return client;
});

final ekkloClientProvider = Provider<EkkloClient>((ref) {
  final client = EkkloClient(
    tokenStore: SecureEkkloTokenStore(ref.watch(secureStorageProvider)),
    httpClient: ref.watch(httpClientProvider),
    baseUri: Config.ekkloBaseUri,
    clock: ref.watch(clockProvider),
  );
  ref.onDispose(client.close);
  return client;
});

final sentLinkRepositoryProvider = Provider<SentLinkRepository>(
  (ref) => SentLinkRepository(ref.watch(databaseProvider)),
);

final memoryRepositoryProvider = Provider<MemoryRepository>(
  (ref) => MemoryRepository(ref.watch(databaseProvider)),
);

final accountsServiceProvider = Provider<AccountsService>(
  (ref) => AccountsService(
    mfp: ref.watch(mfpClientProvider),
    ekklo: ref.watch(ekkloClientProvider),
  ),
);

final journalServiceProvider = Provider<JournalService>(
  (ref) => JournalService(
    mfp: ref.watch(mfpClientProvider),
    ekklo: ref.watch(ekkloClientProvider),
    links: ref.watch(sentLinkRepositoryProvider),
    memory: ref.watch(memoryRepositoryProvider),
    clock: ref.watch(clockProvider),
  ),
);
