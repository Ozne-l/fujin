import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
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
                  context.intl.appName,
                  style: FujinText.hina44.copyWith(
                    color: context.colors.textPrimary,
                  ),
                ),
                const SizedBox(height: FujinSpace.s4),
                Text(
                  context.intl.splashTagline,
                  style: FujinText.hina22.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                const SizedBox(height: FujinSize.splashRuleGap),
                SizedBox(
                  width: FujinSize.goldRuleWidth,
                  height: FujinStroke.goldRule,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: context.colors.borderDivider,
                      borderRadius: const BorderRadius.all(
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
  Widget build(BuildContext context) => SizedBox.square(
    dimension: FujinSize.logo,
    child: DecoratedBox(
      decoration: BoxDecoration(
        image: const DecorationImage(image: _image),
        border: Border.fromBorderSide(
          BorderSide(color: context.colors.borderCard),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(FujinRadius.logo)),
        boxShadow: [
          BoxShadow(
            color: context.colors.shadowLogo,
            blurRadius: FujinSize.logoShadowBlur,
            offset: const Offset(0, FujinSize.logoShadowOffset),
          ),
        ],
      ),
    ),
  );
}
