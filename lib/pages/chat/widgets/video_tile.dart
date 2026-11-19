import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/chat_files.dart';
import 'package:fujin/pages/chat/chat_text.dart';
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
  static const double _largeIcon = 22;
  static const double _smallIcon = 17;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final ratio = MediaQuery.devicePixelRatioOf(context);
    final poster = ref.watch(videoPosterProvider(url)).value;
    final duration = poster?.duration;
    final (disc, icon) = switch (large) {
      true => (_largeDisc, _largeIcon),
      false => (_smallDisc, _smallIcon),
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
              final poster? => Image.file(
                poster.file,
                fit: BoxFit.cover,
                cacheWidth: (size.width * ratio).round(),
                excludeFromSemantics: true,
                errorBuilder: (context, error, stackTrace) =>
                    ColoredBox(color: colors.backgroundNeutral),
              ),
              null => ColoredBox(color: colors.backgroundNeutral),
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
