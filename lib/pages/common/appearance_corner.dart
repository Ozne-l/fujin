import 'package:flutter/widgets.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/appearance_toggle.dart';

class AppearanceCorner extends StatelessWidget {
  const AppearanceCorner({required this.child, super.key});

  final Widget child;

  static const double top = FujinSpace.s1;
  static const double centre = top + FujinSize.touchTarget / 2;
  static const double bar = centre * 2;

  @override
  Widget build(BuildContext context) => Stack(
    children: [
      child,
      PositionedDirectional(
        top: MediaQuery.paddingOf(context).top + top,
        end: FujinSize.screenMargin,
        child: const AppearanceToggle(),
      ),
    ],
  );
}
