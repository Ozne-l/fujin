import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MediaGlyph extends StatelessWidget {
  const MediaGlyph(
    this.asset, {
    required this.size,
    required this.color,
    super.key,
  });

  final String asset;
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    asset,
    width: size,
    height: size,
    theme: SvgTheme(currentColor: color),
    excludeFromSemantics: true,
  );
}
