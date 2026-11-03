import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/round_pictogram.dart';

class AlertPictogram extends StatelessWidget {
  const AlertPictogram({
    required this.icon,
    this.tone = PillTone.error,
    super.key,
  });

  final String icon;
  final PillTone tone;

  @override
  Widget build(BuildContext context) => RoundPictogram(
    icon: icon,
    side: FujinSize.pictogram,
    iconSide: FujinSize.pictogramIcon,
    background: tone.background(context.colors),
    foreground: tone.foreground(context.colors),
  );
}
