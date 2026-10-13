import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/info_banner.dart';
import 'package:fujin/pages/common/scan_icon.dart';

class ScannedBanner extends StatelessWidget {
  const ScannedBanner({super.key});

  @override
  Widget build(BuildContext context) => InfoBanner(
    icon: SvgPicture.asset(
      ScanIcon.asset,
      width: FujinSize.tileIcon,
      height: FujinSize.tileIcon,
      theme: const SvgTheme(currentColor: FujinColorRole.textOnDark),
      excludeFromSemantics: true,
    ),
    detail: AppLocalizations.of(context).addScannedUnresolved,
  );
}
