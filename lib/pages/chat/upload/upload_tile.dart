import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/chat/chat_media_kind.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/domain/chat/upload/uploading_media.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/upload/upload_disc.dart';
import 'package:fujin/pages/chat/upload/upload_ring.dart';
import 'package:fujin/pages/chat/widgets/media_gallery.dart';
import 'package:fujin/pages/chat/widgets/video_duration_chip.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/chat_media/widgets/media_picture.dart';
import 'package:motor/motor.dart';

class UploadTile extends HookWidget {
  const UploadTile({required this.media, required this.single, super.key});

  static const double _dimmed = 0.5;

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
    final percent = media.percent;
    final sending = useRef(false);
    sending.value = sending.value || percent != null;
    final side = (size.longestSide * MediaQuery.devicePixelRatioOf(context))
        .round();
    return Semantics(
      image: true,
      label: switch (media.kind) {
        ChatMediaKind.video => context.intl.chatVideo,
        ChatMediaKind.image => context.intl.chatPhoto,
        ChatMediaKind.voice => context.intl.chatVoice,
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
                SingleMotionBuilder(
                  motion: FujinMotion.dissolve,
                  value: switch (percent) {
                    null => 0.0,
                    _ => _dimmed,
                  },
                  builder: (context, dim, child) => Opacity(
                    opacity: dim.clamp(0, 1),
                    child: child,
                  ),
                  child: ColoredBox(color: colors.backgroundScrim),
                ),
                switch ((percent, sending.value)) {
                  (final percent?, _) => Center(
                    child: UploadRing(percent: percent),
                  ),
                  (null, true) => const Center(child: _Tick()),
                  (null, false) => const SizedBox.shrink(),
                },
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Tick extends HookWidget {
  const _Tick();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final gone = useState(false);
    useEffect(() {
      final hide = Timer(FujinMotion.uploadTick, () => gone.value = true);
      return hide.cancel;
    }, const []);
    return SingleMotionBuilder(
      motion: FujinMotion.dissolve,
      from: 0,
      value: switch (gone.value) {
        true => 0.0,
        false => 1.0,
      },
      builder: (context, opacity, child) =>
          Opacity(opacity: opacity.clamp(0, 1), child: child),
      child: SingleMotionBuilder(
        motion: FujinMotion.of(context, FujinMotion.pop),
        from: 0,
        value: 1,
        builder: (context, scale, child) =>
            Transform.scale(scale: math.max(scale, 0), child: child),
        child: UploadDisc(
          child: MediaGlyph(
            ChatMediaIcon.check,
            size: FujinSize.icon,
            color: colors.backgroundAccent,
          ),
        ),
      ),
    );
  }
}
