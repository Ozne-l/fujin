import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/video_duration_chip.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/media_text.dart';
import 'package:fujin/pages/chat_media/widgets/dark_pill.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/chat_media/widgets/media_picture.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';

class TrayPreview extends StatelessWidget {
  const TrayPreview({required this.media, required this.onOpen, super.key});

  static const double _markIcon = 12;
  static const EdgeInsets _markPadding = EdgeInsets.symmetric(
    horizontal: 6,
    vertical: FujinSpace.s1,
  );

  final EditedMedia media;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    final radius = BorderRadius.circular(FujinRadius.card);
    return Semantics(
      button: true,
      label: intl.chatTrayEdit,
      child: GestureDetector(
        onTap: onOpen,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: colors.backgroundNeutral,
            borderRadius: radius,
          ),
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              borderRadius: radius,
              border: Border.all(color: colors.borderCard),
            ),
            child: ClipRRect(
              borderRadius: radius,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  LayoutBuilder(
                    builder: (context, constraints) => MediaPicture(
                      media: media,
                      decodedSide:
                          (constraints.biggest.longestSide *
                                  MediaQuery.devicePixelRatioOf(context))
                              .round(),
                      fit: BoxFit.contain,
                    ),
                  ),
                  if (media is EditedVideo)
                    Center(
                      child: FujinIconButton.glyph(
                        glyph: MediaGlyph(
                          ChatMediaIcon.play,
                          size: FujinSize.icon,
                          color: colors.textPrimary,
                        ),
                        tooltip: intl.chatPlay,
                        onPressed: onOpen,
                        size: FujinSize.glyphCard,
                        floating: true,
                      ),
                    ),
                  if (media case EditedVideo(:final edit))
                    Positioned(
                      left: FujinSpace.s3,
                      bottom: FujinSpace.s4,
                      child: VideoDurationChip(duration: edit.keptDuration),
                    ),
                  if (media.mark case final mark?)
                    Positioned(
                      left: FujinSpace.s3,
                      top: FujinSpace.s3,
                      child: DarkPill(
                        icon: MediaText.markIcon(mark),
                        iconSize: _markIcon,
                        label: MediaText.mark(intl, mark),
                        labelStyle: FujinText.inter12Medium,
                        padding: _markPadding,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
