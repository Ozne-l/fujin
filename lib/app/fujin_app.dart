import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FujinApp extends ConsumerWidget {
  const FujinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    onGenerateTitle: (context) => AppLocalizations.of(context).appName,
    theme: FujinTheme.light(),
    routerConfig: ref.watch(routerProvider),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    debugShowCheckedModeBanner: false,
    builder: switch (ref.watch(appEnvironmentProvider)) {
      AppEnvironment.production => null,
      AppEnvironment.dev => _devBanner,
    },
  );

  static Widget _devBanner(BuildContext context, Widget? child) => Banner(
    message: AppLocalizations.of(context).devEnvironmentBanner,
    location: BannerLocation.topEnd,
    color: FujinColorRole.buttonAlertBackground,
    textStyle: FujinText.inter11Semibold.copyWith(
      color: FujinColorRole.buttonAlertText,
    ),
    child: child,
  );
}
