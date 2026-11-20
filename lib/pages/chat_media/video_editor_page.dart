import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/crop_geometry.dart';
import 'package:fujin/domain/chat/edit/duration_clamp.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/video_edit.dart';
import 'package:fujin/domain/chat/edit/video_passage.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/media_frames.dart';
import 'package:fujin/pages/chat_media/widgets/aspect_chips.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip_size.dart';
import 'package:fujin/pages/chat_media/widgets/crop_stage.dart';
import 'package:fujin/pages/chat_media/widgets/cropped_picture.dart';
import 'package:fujin/pages/chat_media/widgets/editor_frame.dart';
import 'package:fujin/pages/chat_media/widgets/gesture_safe_padding.dart';
import 'package:fujin/pages/chat_media/widgets/media_flight.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/chat_media/widgets/video_timeline.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:video_player/video_player.dart';

class VideoEditorPage extends HookConsumerWidget {
  const VideoEditorPage({
    required this.video,
    required this.position,
    required this.count,
    super.key,
  });

  static const int _thumbnails = 8;
  static const double _audible = 1;
  static const double _silent = 0;

  final EditedVideo video;
  final int position;
  final int count;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final edit = useState(video.edit);
    final mode = useState(_Mode.trim);
    final selection = useState<VideoPassage?>(null);
    final controller = useMemoized(
      () => ref.read(fileVideoProvider)(File(video.path)),
      [video.path],
    );
    final ready = useState(false);
    final value = useValueListenable(controller);
    useEffect(() {
      Future<void> start() async {
        try {
          await controller.initialize();
          await controller.seekTo(edit.value.firstKeptStart);
        } on Exception {
          return;
        }
        if (context.mounted) ready.value = true;
      }

      void skipRemoved() {
        final current = controller.value;
        if (!current.isPlaying) return;
        final at = current.position;
        final kept = edit.value;
        if (kept.keeps(at)) return;
        switch (kept.nextKeptStart(at)) {
          case final next?:
            unawaited(controller.seekTo(next));
          case null:
            unawaited(controller.pause());
            unawaited(controller.seekTo(kept.firstKeptStart));
        }
      }

      unawaited(start());
      controller.addListener(skipRemoved);
      return () {
        controller.removeListener(skipRemoved);
        unawaited(controller.dispose());
      };
    }, [controller]);
    final muted = edit.value.muted;
    useEffect(() {
      if (ready.value) {
        unawaited(
          controller.setVolume(switch (muted) {
            true => _silent,
            false => _audible,
          }),
        );
      }
      return null;
    }, [muted, ready.value]);
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final frames =
        ref
            .watch(
              mediaFramesProvider((
                source: video.path,
                duration: video.edit.duration,
                count: _thumbnails,
                maxSize: (FujinSize.timelineStripHeight * dpr).ceil(),
              )),
            )
            .value ??
        List<String?>.filled(_thumbnails, null);
    final poster = switch (ref
        .watch(
          mediaFramesProvider(posterFrames(video.path, video.edit.duration)),
        )
        .value) {
      [final path?] => path,
      _ => null,
    };
    final playhead = switch (ready.value) {
      true => value.position,
      false => edit.value.firstKeptStart,
    };
    final colors = context.colors;
    final upright = video.upright;
    final picture = FadeThrough(
      scale: 1,
      child: KeyedSubtree(
        key: ValueKey((ready.value, poster)),
        child: switch ((ready.value, poster)) {
          (true, _) => VideoPlayer(controller),
          (false, final poster?) => Image.file(
            File(poster),
            fit: BoxFit.fill,
            gaplessPlayback: true,
          ),
          (false, null) => ColoredBox(color: colors.cameraButton),
        },
      ),
    );
    Future<void> togglePlay() async {
      if (value.isPlaying) return controller.pause();
      final at = value.position;
      if (!edit.value.keeps(at) || at >= edit.value.end) {
        await controller.seekTo(
          edit.value.nextKeptStart(at) ?? edit.value.firstKeptStart,
        );
      }
      await controller.play();
    }

    void seek(Duration at) {
      if (ready.value) unawaited(controller.seekTo(at));
    }

    void changed(VideoEdit changed) {
      edit.value = changed;
      if (!changed.keeps(value.position)) {
        seek(changed.nextKeptStart(value.position) ?? changed.firstKeptStart);
      }
    }

    final crop = edit.value.crop ?? CropGeometry.whole;
    return EditorFrame(
      title: context.intl.chatEditorVideoTitle,
      position: position,
      count: count,
      onDone: () => Navigator.of(context).pop(video.copyWith(edit: edit.value)),
      children: [
        Expanded(
          child: FadeThrough(
            child: KeyedSubtree(
              key: ValueKey(mode.value),
              child: switch (mode.value) {
                _Mode.trim => Padding(
                  padding: const EdgeInsets.all(FujinSize.screenMargin),
                  child: Stack(
                    fit: StackFit.expand,
                    alignment: Alignment.center,
                    children: [
                      CroppedPicture(
                        upright: upright,
                        crop: crop,
                        child: MediaFlight(path: video.path, child: picture),
                      ),
                      Center(
                        child: FujinIconButton.glyph(
                          glyph: FadeThrough(
                            scale: 1 - FujinMotion.swapScale,
                            child: MediaGlyph(
                              switch (value.isPlaying) {
                                true => ChatMediaIcon.pause,
                                false => ChatMediaIcon.play,
                              },
                              key: ValueKey(value.isPlaying),
                              size: FujinSize.icon,
                              color: colors.textPrimary,
                            ),
                          ),
                          tooltip: switch (value.isPlaying) {
                            true => context.intl.chatPause,
                            false => context.intl.chatPlay,
                          },
                          onPressed: switch (ready.value) {
                            true => () => unawaited(togglePlay()),
                            false => null,
                          },
                          size: FujinSize.glyphCard,
                          floating: true,
                        ),
                      ),
                    ],
                  ),
                ),
                _Mode.crop => CropStage(
                  aspectRatio: upright.aspectRatio,
                  picture: picture,
                  crop: crop,
                  onDragged: (handle, delta) =>
                      edit.value = edit.value.dragged(handle, delta, upright),
                ),
              },
            ),
          ),
        ),
        FadeThrough(
          child: KeyedSubtree(
            key: ValueKey(mode.value),
            child: switch (mode.value) {
              _Mode.trim => GestureSafePadding(
                child: Column(
                  spacing: FujinSpace.s2,
                  children: [
                    Row(
                      children: [
                        Text(
                          ChatText.clock(edit.value.finalPosition(playhead)),
                          style: FujinText.inter13Regular.copyWith(
                            color: colors.cameraText,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          ChatText.clock(edit.value.keptDuration),
                          style: FujinText.inter13Regular.copyWith(
                            color: colors.cameraText,
                          ),
                        ),
                      ],
                    ),
                    VideoTimeline(
                      edit: edit.value,
                      frames: frames,
                      playhead: playhead.clampedTo(
                        Duration.zero,
                        edit.value.duration,
                      ),
                      selection: selection.value,
                      onEdited: changed,
                      onSelected: (passage) => selection.value = passage,
                      onSeek: seek,
                    ),
                    if (selection.value case final passage?)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        spacing: FujinSpace.s3,
                        children: [
                          CameraChip(
                            label: context.intl.cancel,
                            onPressed: () => selection.value = null,
                          ),
                          CameraChip(
                            label: context.intl.chatEditorRemovePassage,
                            icon: ChatMediaIcon.scissors,
                            onPressed: switch (edit.value.canRemove(passage)) {
                              true => () {
                                selection.value = null;
                                changed(edit.value.removing(passage));
                              },
                              false => null,
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              _Mode.crop => AspectChips(
                selected: edit.value.aspect,
                onSelected: (aspect) =>
                    edit.value = edit.value.withAspect(aspect, upright),
              ),
            },
          ),
        ),
        const SizedBox(height: FujinSpace.s4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: FujinSpace.s2,
          children: [
            for (final choice in _Mode.values)
              CameraChip(
                label: switch (choice) {
                  _Mode.trim => context.intl.chatEditorTrim,
                  _Mode.crop => context.intl.chatEditorCrop,
                },
                icon: switch (choice) {
                  _Mode.trim => ChatMediaIcon.scissors,
                  _Mode.crop => ChatMediaIcon.crop,
                },
                size: CameraChipSize.chip,
                selected: mode.value == choice,
                onPressed: () {
                  selection.value = null;
                  mode.value = choice;
                  if (choice == _Mode.crop) unawaited(controller.pause());
                },
              ),
          ],
        ),
        const SizedBox(height: FujinSpace.s3),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: FujinSpace.s3,
          children: [
            CameraChip(
              label: switch (muted) {
                true => context.intl.chatEditorMuted,
                false => context.intl.chatEditorSound,
              },
              icon: switch (muted) {
                true => ChatMediaIcon.muted,
                false => ChatMediaIcon.sound,
              },
              onPressed: () => edit.value = edit.value.toggledSound(),
            ),
            CameraChip(
              label: context.intl.chatEditorReset,
              onPressed: switch (edit.value !=
                  VideoEdit.untouched(edit.value.duration)) {
                true => () {
                  selection.value = null;
                  changed(VideoEdit.untouched(edit.value.duration));
                },
                false => null,
              },
            ),
          ],
        ),
        const SizedBox(height: FujinSpace.s4),
      ],
    );
  }
}

enum _Mode { trim, crop }
