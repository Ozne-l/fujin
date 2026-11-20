import 'dart:async';
import 'dart:io';

import 'package:fujin/app/providers.dart';
import 'package:fujin/data/chat_media/video_poster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';
import 'package:video_player/video_player.dart';

Duration? _noRetry(int retryCount, Object error) => null;

final FutureProviderFamily<File, Uri> chatFileProvider = FutureProvider
    .autoDispose
    .family<File, Uri>(
      (ref, url) => ref.watch(chatMediaCacheProvider).file(url),
      retry: _noRetry,
    );

final FutureProviderFamily<VideoPoster?, Uri> videoPosterProvider =
    FutureProvider.autoDispose.family<VideoPoster?, Uri>(
      (ref, url) => ref.watch(chatMediaCacheProvider).poster(url),
      retry: _noRetry,
    );

final FutureProviderFamily<VideoPlayerController, String> voicePlayerProvider =
    FutureProvider.autoDispose.family<VideoPlayerController, String>((
      ref,
      path,
    ) async {
      final player = ref.watch(fileVideoProvider)(File(path));
      ref.onDispose(() => unawaited(player.dispose()));
      await player.initialize();
      return player;
    }, retry: _noRetry);
