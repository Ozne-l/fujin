import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class AlertPictogram extends StatelessWidget {
  const AlertPictogram({required this.icon, super.key});

  final String icon;

  @override
  Widget build(BuildContext context) => Container(
    width: FujinSize.pictogram,
    height: FujinSize.pictogram,
    alignment: Alignment.center,
    decoration: const BoxDecoration(
      color: FujinColorRole.backgroundAlert,
      shape: BoxShape.circle,
    ),
    child: SvgPicture.asset(
      icon,
      width: FujinSize.pictogramIcon,
      height: FujinSize.pictogramIcon,
      theme: const SvgTheme(currentColor: FujinColorRole.textAlert),
      excludeFromSemantics: true,
    ),
  );
}
