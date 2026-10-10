import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class SheetSearching extends StatelessWidget {
  const SheetSearching({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(vertical: FujinSpace.s4),
    child: Center(
      child: SizedBox.square(
        dimension: FujinSize.icon,
        child: CircularProgressIndicator(strokeWidth: FujinStroke.icon),
      ),
    ),
  );
}
