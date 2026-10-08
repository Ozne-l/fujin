import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum BreezeStreaks {
  marker(
    streaks: [
      (start: 0, length: FujinSize.streakShort),
      (start: 0, length: FujinSize.streakMedium),
    ],
    gap: FujinSpace.s1,
    alignment: CrossAxisAlignment.start,
    padding: EdgeInsets.zero,
  ),
  searching(
    streaks: [
      (start: 0, length: FujinSize.streakMedium),
      (start: FujinSize.streakOffset, length: FujinSize.streakLong),
      (start: FujinSize.streakOffsetSmall, length: FujinSize.streakShort),
    ],
    gap: FujinSize.breezeGap,
    alignment: CrossAxisAlignment.start,
    padding: EdgeInsets.only(
      top: FujinSize.breezeInsetTop,
      bottom: FujinSize.breezeInsetBottom,
    ),
    width: FujinSize.breezeIndicator,
  ),
  transit(
    streaks: [
      (start: 0, length: FujinSize.streakTransitLong),
      (start: 0, length: FujinSize.streakTransitShort),
    ],
    gap: FujinSpace.s1,
    alignment: CrossAxisAlignment.end,
    padding: EdgeInsets.zero,
  );

  const BreezeStreaks({
    required this.streaks,
    required this.gap,
    required this.alignment,
    required this.padding,
    this.width,
  });

  final List<({double start, double length})> streaks;
  final double gap;
  final CrossAxisAlignment alignment;
  final EdgeInsets padding;
  final double? width;
}
