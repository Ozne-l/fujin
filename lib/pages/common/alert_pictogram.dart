import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/round_pictogram.dart';

class AlertPictogram extends StatelessWidget {
  const AlertPictogram({required this.icon, super.key});

  final String icon;

  @override
  Widget build(BuildContext context) => RoundPictogram(
    icon: icon,
    side: FujinSize.pictogram,
    iconSide: FujinSize.pictogramIcon,
    background: FujinColorRole.backgroundAlert,
    foreground: FujinColorRole.textAlert,
  );
}
