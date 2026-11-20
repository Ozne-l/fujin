import 'dart:async';
import 'dart:math' as math;

import 'package:fujin/app/providers.dart';
import 'package:fujin/data/media/forget_file.dart';
import 'package:fujin/data/media/media_processing_exception.dart';
import 'package:fujin/data/media/picked_media.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/media_send.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';
import 'package:fujin/pages/chat_media/media_scratch.dart';
import 'package:fujin/pages/chat_media/media_tray.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final NotifierProvider<MediaTrayNotifier, MediaTray> mediaTrayProvider =
    NotifierProvider.autoDispose<MediaTrayNotifier, MediaTray>(
      MediaTrayNotifier.new,
    );

final class MediaTrayNotifier extends Notifier<MediaTray> {
  @override
  MediaTray build() {
    final scratch = MediaScratch(ref.watch(appCacheDirectoryProvider));
    ref.onDispose(() => unawaited(scratch.clear()));
    return const MediaTray();
  }

  Future<void> add(List<PickedMedia> picked) async {
    final processor = ref.read(mediaProcessorProvider);
    final kept = picked.take(state.room).toList();
    for (final extra in picked.skip(kept.length)) {
      unawaited(forgetFile(extra.path));
    }
    final added = <EditedMedia>[];
    for (final media in kept) {
      switch (media) {
        case PickedPhoto(:final path, :final width, :final height):
          added.add(EditedPhoto(path: path, width: width, height: height));
        case PickedVideo(:final path):
          try {
            final probe = await processor.probeVideo(path);
            added.add(
              EditedVideo(
                path: path,
                width: probe.uprightWidth,
                height: probe.uprightHeight,
                edit: VideoEdit.untouched(probe.duration),
              ),
            );
          } on MediaProcessingException {
            unawaited(forgetFile(path));
          }
      }
    }
    if (!ref.mounted) {
      for (final media in added) {
        unawaited(forgetFile(media.path));
      }
      return;
    }
    final merged = [...state.media, ...added];
    for (final extra in merged.skip(MediaSend.maximumMedia)) {
      unawaited(forgetFile(extra.path));
    }
    if (added.isEmpty || state.isFull) return;
    state = MediaTray(
      media: merged.take(MediaSend.maximumMedia).toList(),
      selected: state.media.length,
    );
  }

  void select(int index) => state = state.copyWith(selected: index);

  void replace(int index, EditedMedia media) => state = state.copyWith(
    media: [...state.media]..[index] = media,
  );

  void remove(int index) {
    unawaited(forgetFile(state.media[index].path));
    final media = [...state.media]..removeAt(index);
    final selected = switch (index < state.selected) {
      true => state.selected - 1,
      false => state.selected,
    };
    state = MediaTray(
      media: media,
      selected: selected.clamp(0, math.max(0, media.length - 1)),
    );
  }

  MediaSend send({required String caption, required String? replyToId}) =>
      MediaSend(
        media: state.media,
        caption: caption.trim(),
        replyToId: replyToId,
      );

  void discard() {
    for (final media in state.media) {
      unawaited(forgetFile(media.path));
    }
    state = const MediaTray();
  }
}
