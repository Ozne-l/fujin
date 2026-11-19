import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/chat/edit/edited_media.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/media_text.dart';
import 'package:fujin/pages/chat_media/widgets/dark_badge.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';
import 'package:fujin/pages/chat_media/widgets/media_picture.dart';

class MediaStrip extends StatelessWidget {
  const MediaStrip({
    required this.media,
    required this.selected,
    required this.onSelected,
    required this.onRemoved,
    required this.onAdd,
    super.key,
  });

  static const double tile = 56;
  static const double _vertical = 2;

  final List<EditedMedia> media;
  final int selected;
  final ValueChanged<int> onSelected;
  final ValueChanged<int> onRemoved;
  final VoidCallback? onAdd;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: tile + 2 * _vertical,
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: FujinSize.screenMargin,
        vertical: _vertical,
      ),
      children: [
        for (final (index, item) in media.indexed)
          Padding(
            padding: const EdgeInsets.only(right: FujinSpace.s2),
            child: _Thumbnail(
              media: item,
              selected: index == selected,
              onTap: () => onSelected(index),
              onRemove: () => onRemoved(index),
            ),
          ),
        if (onAdd case final onAdd?) _AddTile(onTap: onAdd),
      ],
    ),
  );
}

class _Thumbnail extends StatelessWidget {
  const _Thumbnail({
    required this.media,
    required this.selected,
    required this.onTap,
    required this.onRemove,
  });

  static const double _inset = 3;
  static const double _markInset = 4;
  static const double _remove = 20;
  static const double _removeIcon = 12;
  static const double _mark = 18;
  static const double _markIcon = 11;
  static const double _playIcon = 9;
  static const double _focus = 2;
  static const double _decodeScale = 3;

  final EditedMedia media;
  final bool selected;
  final VoidCallback onTap;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final intl = context.intl;
    return SizedBox.square(
      dimension: MediaStrip.tile,
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
                        (MediaStrip.tile *
                                MediaQuery.devicePixelRatioOf(context) *
                                _decodeScale)
                            .round(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          if (selected)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(FujinRadius.tile),
                    border: Border.all(
                      color: colors.borderFocus,
                      width: _focus,
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: _inset,
            right: _inset,
            child: Semantics(
              button: true,
              label: intl.chatTrayRemove,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onRemove,
                child: DarkBadge(
                  diameter: _remove,
                  child: Icon(
                    Icons.close,
                    size: _removeIcon,
                    color: colors.textOnDark,
                  ),
                ),
              ),
            ),
          ),
          if (media is EditedVideo)
            Positioned(
              left: _markInset,
              bottom: _markInset,
              child: DarkBadge(
                diameter: _mark,
                child: MediaGlyph(
                  ChatMediaIcon.play,
                  size: _playIcon,
                  color: colors.textOnDark,
                ),
              ),
            ),
          if (media.mark case final mark?)
            Positioned(
              right: _markInset,
              bottom: _markInset,
              child: DarkBadge(
                diameter: _mark,
                child: MediaGlyph(
                  MediaText.markIcon(mark),
                  size: _markIcon,
                  color: colors.textOnDark,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AddTile extends StatelessWidget {
  const _AddTile({required this.onTap});

  static const double _dash = 4;
  static const double _gap = 3;
  static const double _stroke = 1.5;
  static const double _icon = 22;

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
            dimension: MediaStrip.tile,
            child: Center(
              child: MediaGlyph(
                ChatMediaIcon.add,
                size: _icon,
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
          (Offset.zero & size).deflate(_AddTile._stroke / 2),
          const Radius.circular(FujinRadius.tile),
        ),
      );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = _AddTile._stroke;
    for (final metric in outline.computeMetrics()) {
      for (
        var distance = 0.0;
        distance < metric.length;
        distance += _AddTile._dash + _AddTile._gap
      ) {
        canvas.drawPath(
          metric.extractPath(distance, distance + _AddTile._dash),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(_DashedTile oldDelegate) => oldDelegate.color != color;
}
