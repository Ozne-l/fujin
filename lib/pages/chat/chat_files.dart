import 'dart:io';

import 'package:fujin/app/providers.dart';
import 'package:fujin/data/chat_media/video_poster.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

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
