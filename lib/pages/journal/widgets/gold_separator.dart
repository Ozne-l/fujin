import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class GoldSeparator extends StatelessWidget {
  const GoldSeparator({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(
      horizontal: FujinSize.margeEcran,
      vertical: FujinSpace.s4,
    ),
    child: Divider(
      color: FujinRole.bordureSeparateur,
      thickness: FujinStroke.anneauJour,
      height: FujinStroke.anneauJour,
    ),
  );
}
