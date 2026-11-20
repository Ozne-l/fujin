import 'dart:async';
import 'dart:io';

import 'package:checks/checks.dart';
import 'package:flutter_test/flutter_test.dart' show addTearDown, test;
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/chat_media/chat_media_cache.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';
import 'package:fujin/domain/accounts/account.dart';
import 'package:fujin/domain/chat/chat_state.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../support/fake_backends.dart';
import '../../support/fake_media_processor.dart';
import '../../support/until.dart';

void main() {
  test('signing out of Ekklo forgets the chat and its media', () async {
    final root = Directory.systemTemp.createTempSync('forget-chat');
    addTearDown(() => root.deleteSync(recursive: true));
    final cachePath = FujinDatabase.cachePathIn(root);
    final media = Directory('${root.path}/${ChatMediaCache.folderName}');
    final backends = FakeBackends();
    backends.chatMedia['plate.jpg'] = [1, 2, 3];
    final ekklo = await backends.ekklo();
    final container = ProviderContainer(
      overrides: [
        appEnvironmentProvider.overrideWithValue(AppEnvironment.production),
        chatCachePathProvider.overrideWithValue(cachePath),
        appCacheDirectoryProvider.overrideWithValue(root),
        ekkloClientProvider.overrideWithValue(ekklo),
        mfpClientProvider.overrideWithValue(await backends.mfp()),
        clearWebCookiesProvider.overrideWithValue(() async {}),
        httpClientProvider.overrideWithValue(backends.httpClient),
        appForegroundProvider.overrideWith((ref) => Stream.value(false)),
        connectivityProvider.overrideWith((ref) => const Stream.empty()),
        mediaProcessorProvider.overrideWithValue(FakeMediaProcessor()),
      ],
    );
    addTearDown(container.dispose);
    final states = <ChatState>[];
    container.listen(
      chatProvider,
      (_, next) => states.addAll([?next.value]),
      fireImmediately: true,
    );
    await until(() => states.lastOrNull, (state) => state is ChatPresent);
    await container
        .read(chatMediaCacheProvider)
        .file(chatMediaUri.resolve('${FakeChat.mediaPath}plate.jpg'));
    check(File(cachePath).existsSync()).isTrue();

    await container.read(accountsServiceProvider).signOut(Account.ekklo);
    await until(() => states.lastOrNull, (state) => state is ChatAbsent);

    check(states.last).isA<ChatAbsent>();
    check(media.existsSync()).isFalse();
    check(
      container.read(chatRepositoryProvider).conversations(),
    ).isEmpty();
  });
}
