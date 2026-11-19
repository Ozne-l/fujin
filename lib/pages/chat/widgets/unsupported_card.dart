import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/chat/widgets/chat_bubble.dart';
import 'package:fujin/pages/chat_media/chat_media_icon.dart';
import 'package:fujin/pages/chat_media/widgets/media_glyph.dart';

class UnsupportedCard extends StatelessWidget {
  const UnsupportedCard({super.key});

  static const double _iconGap = 10;
  static const double _lineGap = 2;

  @override
  Widget build(BuildContext context) => CustomPaint(
    painter: _DashedOutline(
      fill: context.colors.backgroundCard,
      stroke: context.colors.borderCard,
    ),
    child: Padding(
      padding: ChatBubble.textPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        spacing: _iconGap,
        children: [
          MediaGlyph(
            ChatMediaIcon.externalLink,
            size: FujinSize.rowActionIcon,
            color: context.colors.textPrimary,
          ),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: _lineGap,
              children: [
                Text(
                  context.intl.chatUnsupportedTitle,
                  style: FujinText.inter15Medium.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                Text(
                  context.intl.chatUnsupportedDetail,
                  style: FujinText.inter13Regular.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class _DashedOutline extends CustomPainter {
  const _DashedOutline({required this.fill, required this.stroke});

  final Color fill;
  final Color stroke;

  static const double _dash = 4;
  static const double _gap = 3;

  @override
  void paint(Canvas canvas, Size size) {
    final shape = RRect.fromRectAndRadius(
      (Offset.zero & size).deflate(FujinStroke.card / 2),
      const Radius.circular(FujinRadius.field),
    );
    canvas.drawRRect(shape, Paint()..color = fill);
    final line = Paint()
      ..color = stroke
      ..style = PaintingStyle.stroke
      ..strokeWidth = FujinStroke.card;
    for (final metric in (Path()..addRRect(shape)).computeMetrics()) {
      for (var start = 0.0; start < metric.length; start += _dash + _gap) {
        canvas.drawPath(metric.extractPath(start, start + _dash), line);
      }
    }
  }

  @override
  bool shouldRepaint(_DashedOutline oldDelegate) =>
      oldDelegate.fill != fill || oldDelegate.stroke != stroke;
}
