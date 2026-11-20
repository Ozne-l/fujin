import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/chat_media_hero.dart';
import 'package:fujin/pages/chat/widgets/photo_tile.dart';
import 'package:fujin/pages/chat/widgets/video_tile.dart';

class MediaGallery extends StatelessWidget {
  const MediaGallery({
    required this.messageId,
    required this.media,
    required this.onOpen,
    super.key,
  });

  final String messageId;
  final List<EkkloMedia> media;
  final ValueChanged<int> onOpen;

  static const double width = FujinSize.chatMediaWidth;
  static const Size _photo = Size.square(FujinSize.chatSinglePhoto);
  static const Size _video = Size(width, FujinSize.chatVideoHeight);
  static const Size _tile = Size.square(FujinSize.chatMediaTile);

  static Size sizeOf({required bool video, required bool single}) =>
      switch ((video, single)) {
        (true, true) => _video,
        (false, true) => _photo,
        (_, false) => _tile,
      };

  static double widthOf(List<EkkloMedia> media) => switch (media) {
    [final only] => sizeOf(
      video: only.kind == EkkloMediaKind.video,
      single: true,
    ).width,
    _ => width,
  };

  static double radiusOf({required bool single}) => switch (single) {
    true => FujinRadius.field,
    false => FujinRadius.tile,
  };

  @override
  Widget build(BuildContext context) {
    Widget tile(int index, EkkloMedia item, {required bool single}) {
      final size = sizeOf(
        video: item.kind == EkkloMediaKind.video,
        single: single,
      );
      final radius = radiusOf(single: single);
      return Semantics(
        button: true,
        label: switch (item.kind) {
          EkkloMediaKind.image => context.intl.chatPhoto,
          EkkloMediaKind.video || EkkloMediaKind.voice => null,
        },
        child: GestureDetector(
          onTap: () => onOpen(index),
          child: ChatMediaHero(
            messageId: messageId,
            index: index,
            url: item.url,
            video: item.kind == EkkloMediaKind.video,
            thumb: size,
            radius: radius,
            child: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                border: Border.all(color: context.colors.borderCard),
                borderRadius: BorderRadius.circular(radius),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: switch (item.kind) {
                  EkkloMediaKind.video => VideoTile(
                    url: item.url,
                    size: size,
                    large: single,
                  ),
                  EkkloMediaKind.image ||
                  EkkloMediaKind.voice => PhotoTile(url: item.url, size: size),
                },
              ),
            ),
          ),
        ),
      );
    }

    return switch (media) {
      [final only] => tile(0, only, single: true),
      _ => SizedBox(
        width: width,
        child: Wrap(
          spacing: FujinSpace.s1,
          runSpacing: FujinSpace.s1,
          children: [
            for (final (index, item) in media.indexed)
              tile(index, item, single: false),
          ],
        ),
      ),
    };
  }
}
