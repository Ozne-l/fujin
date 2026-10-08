import 'package:flutter/painting.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum PillSize {
  regular(
    height: FujinSize.pill,
    inset: FujinSpace.s3,
    style: FujinText.inter12Medium,
  ),
  small(
    height: FujinSize.pillSmall,
    inset: FujinSpace.s2,
    style: FujinText.inter11Medium,
  );

  const PillSize({
    required this.height,
    required this.inset,
    required this.style,
  });

  final double height;
  final double inset;
  final TextStyle style;
}
