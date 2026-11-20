import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/edit/photo_edit.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/aspect_chips.dart';
import 'package:fujin/pages/chat_media/widgets/camera_chip.dart';
import 'package:fujin/pages/chat_media/widgets/crop_stage.dart';
import 'package:fujin/pages/chat_media/widgets/editor_frame.dart';
import 'package:fujin/pages/chat_media/widgets/media_flight.dart';

class PhotoEditorPage extends HookWidget {
  const PhotoEditorPage({
    required this.photo,
    required this.position,
    required this.count,
    super.key,
  });

  final EditedPhoto photo;
  final int position;
  final int count;

  @override
  Widget build(BuildContext context) {
    final edit = useState(photo.edit);
    final upright = photo.upright;
    final shown = edit.value.shownSize(upright);
    final screen = MediaQuery.sizeOf(context);
    final decodedSide =
        (screen.longestSide * MediaQuery.devicePixelRatioOf(context)).round();
    return EditorFrame(
      title: context.intl.chatEditorPhotoTitle,
      position: position,
      count: count,
      onDone: () => Navigator.of(context).pop(photo.copyWith(edit: edit.value)),
      children: [
        Expanded(
          child: CropStage(
            aspectRatio: shown.aspectRatio,
            quarterTurns: edit.value.quarterTurns,
            picture: MediaFlight(
              path: photo.path,
              child: RotatedBox(
                quarterTurns: edit.value.quarterTurns,
                child: Image.file(
                  File(photo.path),
                  fit: BoxFit.fill,
                  cacheWidth: switch (upright.width >= upright.height) {
                    true => decodedSide,
                    false => null,
                  },
                  cacheHeight: switch (upright.width >= upright.height) {
                    true => null,
                    false => decodedSide,
                  },
                  gaplessPlayback: true,
                ),
              ),
            ),
            crop: edit.value.shownCrop,
            onDragged: (handle, delta) =>
                edit.value = edit.value.dragged(handle, delta, upright),
          ),
        ),
        AspectChips(
          selected: edit.value.aspect,
          onSelected: (aspect) =>
              edit.value = edit.value.withAspect(aspect, upright),
        ),
        const SizedBox(height: FujinSpace.s4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: FujinSpace.s3,
          children: [
            CameraChip(
              label: context.intl.chatEditorRotate,
              icon: ChatMediaIcon.rotate,
              onPressed: () => edit.value = edit.value.rotated(upright),
            ),
            CameraChip(
              label: context.intl.chatEditorReset,
              onPressed: switch (edit.value != const PhotoEdit()) {
                true => () => edit.value = const PhotoEdit(),
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
