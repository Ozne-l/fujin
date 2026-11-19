import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/upload/uploading_media.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/upload/upload_ring.dart';
import 'package:fujin/pages/chat/widgets/media_gallery.dart';
import 'package:fujin/pages/chat/widgets/video_duration_chip.dart';
import 'package:fujin/pages/chat_media/widgets/media_picture.dart';

class UploadTile extends StatelessWidget {
  const UploadTile({required this.media, required this.single, super.key});

  final UploadingMedia media;
  final bool single;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final edited = media.media;
    final size = MediaGallery.sizeOf(
      video: media.kind == ChatMediaKind.video,
      single: single,
    );
    final radius = MediaGallery.radiusOf(single: single);
    final side = (size.longestSide * MediaQuery.devicePixelRatioOf(context))
        .round();
    return Semantics(
      image: true,
      label: switch (media.kind) {
        ChatMediaKind.video => context.intl.chatVideo,
        ChatMediaKind.image || ChatMediaKind.voice => context.intl.chatPhoto,
      },
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          border: Border.all(color: colors.borderCard),
          borderRadius: BorderRadius.circular(radius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: SizedBox.fromSize(
            size: size,
            child: Stack(
              fit: StackFit.expand,
              children: [
                switch (edited) {
                  null => ColoredBox(color: colors.backgroundNeutral),
                  final edited => MediaPicture(
                    media: edited,
                    decodedSide: side,
                    fit: BoxFit.cover,
                  ),
                },
                if (edited case EditedVideo(:final edit))
                  Positioned(
                    left: FujinSpace.s2,
                    bottom: FujinSpace.s2,
                    child: VideoDurationChip(duration: edit.keptDuration),
                  ),
                if (media.percent case final percent?)
                  Center(child: UploadRing(percent: percent)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
