import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';

class BreezeIndicator extends StatelessWidget {
  const BreezeIndicator({required this.streaks, super.key});

  final BreezeStreaks streaks;

  @override
  Widget build(BuildContext context) => Container(
    width: streaks.width,
    padding: streaks.padding,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: streaks.alignment,
      spacing: streaks.gap,
      children: [
        for (final streak in streaks.streaks)
          Container(
            margin: EdgeInsetsDirectional.only(start: streak.start),
            width: streak.length,
            height: FujinStroke.streak,
            decoration: const BoxDecoration(
              color: FujinColor.sora,
              borderRadius: BorderRadius.all(
                Radius.circular(FujinRadius.pill),
              ),
            ),
          ),
      ],
    ),
  );
}
