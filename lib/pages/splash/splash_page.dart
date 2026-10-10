import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    useEffect(() {
      unawaited(
        Future(() {
          if (context.mounted) context.go(FujinRoute.journal.path);
        }),
      );
      return null;
    }, const []);

    return Scaffold(
      body: Stack(
        children: [
          const PositionedDirectional(
            start: 0,
            end: 0,
            bottom: 0,
            child: SeigaihaBand(height: FujinSize.motifBandSplash),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _Logo(),
                const SizedBox(height: FujinSize.splashTitleGap),
                Text(
                  l10n.appName,
                  style: FujinText.hina44.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                const SizedBox(height: FujinSpace.s4),
                Text(
                  l10n.splashTagline,
                  style: FujinText.hina22.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
                const SizedBox(height: FujinSize.splashRuleGap),
                const SizedBox(
                  width: FujinSize.goldRuleWidth,
                  height: FujinStroke.goldRule,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: FujinColorRole.borderDivider,
                      borderRadius: BorderRadius.all(
                        Radius.circular(FujinRadius.pill),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  static const _image = AssetImage('assets/images/logo.png');

  @override
  Widget build(BuildContext context) => const SizedBox.square(
    dimension: FujinSize.logo,
    child: DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(image: _image),
        border: Border.fromBorderSide(
          BorderSide(color: FujinColorRole.borderCard),
        ),
        borderRadius: BorderRadius.all(Radius.circular(FujinRadius.logo)),
        boxShadow: [
          BoxShadow(
            color: FujinColorRole.shadowLogo,
            blurRadius: FujinSize.logoShadowBlur,
            offset: Offset(0, FujinSize.logoShadowOffset),
          ),
        ],
      ),
    ),
  );
}
