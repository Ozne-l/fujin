import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/breeze_indicator.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';

class SheetSearching extends StatelessWidget {
  const SheetSearching({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: FujinSpace.s4),
    child: Center(
      child: BreezeIndicator(
        streaks: BreezeStreaks.searching,
        drifting: true,
      ),
    ),
  );
}
