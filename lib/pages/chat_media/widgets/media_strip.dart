import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/media_text.dart';
import 'package:fujin/pages/chat_media/use_lingering.dart';
import 'package:fujin/pages/chat_media/widgets/dark_badge.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/chat_media/widgets/media_picture.dart';
import 'package:fujin/pages/common/fade_through.dart';
import 'package:motor/motor.dart';

class MediaStrip extends HookWidget {
  const MediaStrip({
    required this.media,
    required this.selected,
    required this.onSelected,
    required this.onRemoved,
    required this.onAdd,
    super.key,
  });

  static const double _pitch = FujinSize.mediaStripTile + FujinSpace.s2;
  static const double _entryScale = 0.8;

  final List<EditedMedia> media;
  final int selected;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onRemoved;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) {
    final (value: merged, :settle) = useLingering<List<_Slot>>(
      (held) => _Slot.merged(held, media),
    );
    final colors = context.colors;
    final reduced = FujinMotion.reduced(context);
    final indices = {
      for (final (index, item) in media.indexed) item.path: index,
    };
    return SizedBox(
      height:
          FujinSize.mediaStripTile + 2 * FujinSize.mediaStripPaddingVertical,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: FujinSize.screenMargin,
          vertical: FujinSize.mediaStripPaddingVertical,
        ),
        child: Stack(
          children: [
            Row(
              children: [
                for (final slot in merged)
                  SingleMotionBuilder(
                    key: ValueKey(slot.media.path),
                    value: switch (slot.leaving) {
                      true => 0,
                      false => 1,
                    },
                    from: switch (slot.entering) {
                      true => 0,
                      false => null,
                    },
                    motion: FujinMotion.dissolveOf(
                      context,
                      FujinMotion.spatialFast,
                    ),
                    onAnimationStatusChanged: (status) {
                      if (slot.leaving && !status.isAnimating) {
                        settle(
                          (slots) => [
                            for (final kept in slots)
                              if (!kept.leaving ||
                                  kept.media.path != slot.media.path)
                                kept,
                          ],
                        );
                      }
                    },
                    builder: (context, shown, child) => Align(
                      alignment: Alignment.centerLeft,
                      widthFactor: switch (reduced) {
                        true => 1,
                        false => shown.clamp(0, 1),
                      },
                      child: Opacity(
                        opacity: shown.clamp(0, 1),
                        child: Transform.scale(
                          scale: switch (reduced) {
                            true => 1,
                            false =>
                              _entryScale +
                                  (1 - _entryScale) * shown.clamp(0, 1),
                          },
                          child: child,
                        ),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: FujinSpace.s2),
                      child: switch (indices[slot.media.path]) {
                        final index? when !slot.leaving => _Thumbnail(
                          media: slot.media,
                          selected: index == selected,
                          onTap: () => onSelected(index),
                          onRemove: () => onRemoved(index),
                        ),
                        _ => IgnorePointer(
                          child: ExcludeSemantics(
                            child: _Thumbnail(
                              media: slot.media,
                              selected: false,
                            ),
                          ),
                        ),
                      },
                    ),
                  ),
                if (onAdd case final onAdd?) _AddTile(onTap: onAdd),
              ],
            ),
            if (selected >= 0 && selected < media.length)
              SingleMotionBuilder(
                value: selected * _pitch,
                motion: FujinMotion.of(context, FujinMotion.lift),
                builder: (context, left, _) => Positioned(
                  left: left,
                  top: 0,
                  width: FujinSize.mediaStripTile,
                  height: FujinSize.mediaStripTile,
                  child: IgnorePointer(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(FujinRadius.tile),
                        border: Border.all(
                          color: colors.borderFocus,
                          width: FujinStroke.stripFocus,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

@immutable
final class _Slot {
  const _Slot(this.media, {this.leaving = false, this.entering = false});

  final EditedMedia media;
  final bool leaving;
  final bool entering;

  static List<_Slot> merged(List<_Slot>? previous, List<EditedMedia> media) {
    if (previous == null) return [for (final item in media) _Slot(item)];
    final alive = {for (final item in media) item.path};
    final known = {
      for (final slot in previous)
        if (alive.contains(slot.media.path)) slot.media.path,
    };
    final merged = <_Slot>[];
    var next = 0;
    void enterNew() {
      while (next < media.length && !known.contains(media[next].path)) {
        merged.add(_Slot(media[next], entering: true));
        next++;
      }
    }

    for (final slot in previous) {
      switch (known.contains(slot.media.path)) {
        case false:
          merged.add(_Slot(slot.media, leaving: true));
        case true:
          enterNew();
          if (next < media.length) {
            merged.add(_Slot(media[next]));
            next++;
          }
      }
    }
    enterNew();
    return merged;
  }
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.media,
    required this.selected,
    this.onTap,
    this.onRemove,
  });

  static const double _decodeScale = 3;

  final EditedMedia media;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    return SizedBox.square(
      dimension: FujinSize.mediaStripTile,
      child: Stack(
        children: [
          Positioned.fill(
            child: Semantics(
              button: true,
              selected: selected,
              label: intl.chatMedia,
              child: GestureDetector(
                onTap: onTap,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(FujinRadius.tile),
                  child: MediaPicture(
                    media: media,
                    decodedSide:
                        (FujinSize.mediaStripTile *
                                MediaQuery.devicePixelRatioOf(context) *
                                _decodeScale)
                            .round(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: FujinSize.stripRemoveInset,
            right: FujinSize.stripRemoveInset,
            child: Semantics(
              button: true,
              label: intl.chatTrayRemove,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: DarkBadge(
                  diameter: FujinSize.stripRemove,
                  child: Icon(
                    Icons.close,
                    size: FujinSize.stripRemoveIcon,
                    color: colors.textOnDark,
                  ),
                ),
              ),
            ),
          ),
          if (media is EditedVideo)
            Positioned(
              left: FujinSpace.s1,
              bottom: FujinSpace.s1,
              child: DarkBadge(
                diameter: FujinSize.stripBadge,
                child: MediaGlyph(
                  ChatMediaIcon.play,
                  size: FujinSize.stripPlayIcon,
                  color: colors.textOnDark,
                ),
              ),
            ),
          Positioned(
            right: FujinSpace.s1,
            bottom: FujinSpace.s1,
            child: FadeThrough(
              scale: 1 - FujinMotion.swapScale,
              child: switch (media.mark) {
                final mark? => DarkBadge(
                  key: ValueKey(mark),
                  diameter: FujinSize.stripBadge,
                  child: MediaGlyph(
                    MediaText.markIcon(mark),
                    size: FujinSize.stripBadgeIcon,
                    color: colors.textOnDark,
                  ),
                ),
                null => const SizedBox.shrink(),
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Semantics(
      button: true,
      label: context.intl.chatTrayAdd,
      child: GestureDetector(
        onTap: onTap,
        child: CustomPaint(
          painter: _DashedTile(color: colors.borderCard),
          child: SizedBox.square(
            dimension: FujinSize.mediaStripTile,
            child: Center(
              child: MediaGlyph(
                ChatMediaIcon.add,
                size: FujinSize.addTileIcon,
                color: colors.textPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedTile extends CustomPainter {
  const _DashedTile({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final outline = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          (Offset.zero & size).deflate(FujinStroke.addTile / 2),
          const Radius.circular(FujinRadius.tile),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = FujinStroke.addTile;
    for (final metric in outline.computeMetrics()) {
      for (
        var distance = 0.0;
        distance < metric.length;
        distance += FujinSize.dashedBorderDash + FujinSize.dashedBorderGap
      ) {
        canvas.drawPath(
          metric.extractPath(distance, distance + FujinSize.dashedBorderDash),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DashedTile oldDelegate) => oldDelegate.color != color;
}
