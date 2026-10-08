import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

class GoldVolute extends StatelessWidget {
  const GoldVolute({super.key});

  static const _asset = 'assets/icons/volute.svg';

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
    _asset,
    theme: const SvgTheme(currentColor: FujinColor.kin),
    excludeFromSemantics: true,
  );
}
