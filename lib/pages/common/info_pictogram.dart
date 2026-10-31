import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/round_pictogram.dart';

class InfoPictogram extends StatelessWidget {
  const InfoPictogram({required this.icon, super.key});

  final String icon;

  @override
  Widget build(BuildContext context) => RoundPictogram(
    icon: icon,
    side: FujinSize.pictogram,
    iconSide: FujinSize.pictogramIcon,
    background: context.colors.backgroundInfo,
    foreground: context.colors.textInfo,
  );
}
