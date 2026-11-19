import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/crop_geometry.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/pages/chat_media/media_frames.dart';
import 'package:fujin/pages/chat_media/widgets/cropped_picture.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MediaPicture extends ConsumerWidget {
  const MediaPicture({
    required this.media,
    required this.decodedSide,
    required this.fit,
    super.key,
  });

  final EditedMedia media;
  final int decodedSide;
  final BoxFit fit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final (path, crop, turns) = switch (media) {
      EditedPhoto(:final path, :final edit) => (
        path,
        edit.shownCrop,
        edit.quarterTurns,
      ),
      EditedVideo(:final path, :final edit) => (
        switch (ref
            .watch(mediaFramesProvider(posterFrames(path, edit.duration)))
            .value) {
          [final poster?] => poster,
          _ => null,
        },
        edit.crop ?? CropGeometry.whole,
        0,
      ),
    };
    final upright = media.upright;
    final landscape = upright.width >= upright.height;
    return switch (path) {
      null => ColoredBox(color: colors.backgroundNeutral),
      final path => CroppedPicture(
        upright: upright,
        crop: crop,
        quarterTurns: turns,
        fit: fit,
        child: Image.file(
          File(path),
          fit: BoxFit.fill,
          cacheWidth: switch (landscape) {
            true => null,
            false => decodedSide,
          },
          cacheHeight: switch (landscape) {
            true => decodedSide,
            false => null,
          },
          gaplessPlayback: true,
          errorBuilder: (context, error, stackTrace) =>
              ColoredBox(color: colors.backgroundNeutral),
        ),
      ),
    };
  }
}
