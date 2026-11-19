import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum CameraChipSize {
  chip(
    height: FujinSize.controlHeight,
    icon: FujinSize.hintIcon,
    padding: FujinSpace.s3,
  ),
  compact(
    height: FujinSize.buttonCompact,
    icon: FujinSize.tileIcon,
    padding: FujinSpace.s4,
  );

  const CameraChipSize({
    required this.height,
    required this.icon,
    required this.padding,
  });

  final double height;
  final double icon;
  final double padding;
}
