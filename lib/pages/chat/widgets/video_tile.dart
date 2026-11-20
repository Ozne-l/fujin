import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/chat_text.dart';
import 'package:fujin/pages/chat/widgets/image_arrival.dart';
import 'package:fujin/pages/chat/widgets/media_placeholder.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:fujin/pages/chat/widgets/video_duration_chip.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class VideoTile extends ConsumerWidget {
  const VideoTile({
    required this.url,
    required this.size,
    required this.large,
    super.key,
  });

  final Uri url;
  final Size size;
  final bool large;

  static const double _largeDisc = FujinSize.pictogram;
  static const double _smallDisc = FujinSize.controlHeight;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final poster = ref.watch(videoPosterProvider(url)).value;
    final duration = poster?.duration;
    final (disc, icon) = switch (large) {
      true => (_largeDisc, FujinSize.videoPlayIcon),
      false => (_smallDisc, FujinSize.videoPlayIconSmall),
    };
    return Semantics(
      label: switch (duration) {
        null => context.intl.chatVideo,
        final duration => context.intl.chatVideoSemantics(
          ChatText.spoken(context.intl, duration),
        ),
      },
      image: true,
      child: SizedBox.fromSize(
        size: size,
        child: Stack(
          fit: StackFit.expand,
          children: [
            switch (poster) {
              final poster? => Image(
                image: PhotoTile.thumbOf(
                  poster.file,
                  width: size.width,
                  ratio: ratio,
                ),
                fit: BoxFit.cover,
                excludeFromSemantics: true,
                frameBuilder: ImageArrival.frameBuilder,
                errorBuilder: (context, error, stackTrace) =>
                    const MediaPlaceholder(),
              ),
              null => const MediaPlaceholder(),
            },
            Center(
              child: Container(
                width: disc,
                height: disc,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colors.backgroundGlass,
                  shape: BoxShape.circle,
                ),
                child: MediaGlyph(
                  ChatMediaIcon.play,
                  size: icon,
                  color: colors.textPrimary,
                ),
              ),
            ),
            if (duration case final duration?)
              Positioned(
                left: FujinSpace.s2,
                bottom: FujinSpace.s2,
                child: VideoDurationChip(duration: duration),
              ),
          ],
        ),
      ),
    );
  }
}
