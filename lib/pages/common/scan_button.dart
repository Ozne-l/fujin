import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/glass_surface.dart';
import 'package:fujin/pages/common/scan_icon.dart';

class ScanButton extends StatelessWidget {
  const ScanButton({required this.onTap, super.key});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Semantics(
    button: true,
    enabled: onTap != null,
    label: AppLocalizations.of(context).tabScanner,
    excludeSemantics: true,
    onTap: onTap,
    child: GlassSurface(
      child: SizedBox.square(
        dimension: FujinSize.tabBar,
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            customBorder: const CircleBorder(),
            onTap: onTap,
            child: Center(
              child: SvgPicture.asset(
                ScanIcon.asset,
                width: FujinSize.scanIcon,
                height: FujinSize.scanIcon,
                theme: SvgTheme(
                  currentColor: switch (onTap) {
                    null => FujinColorRole.textDisabled,
                    _ => FujinColorRole.textPrimary,
                  },
                ),
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
