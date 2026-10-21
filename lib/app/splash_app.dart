import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/splash/splash_view.dart';

class SplashApp extends StatelessWidget {
  const SplashApp({
    required this.environment,
    required this.appearance,
    super.key,
  });

  final AppEnvironment environment;
  final Appearance appearance;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => context.intl.appName,
    theme: FujinTheme.light(),
    darkTheme: FujinTheme.dark(),
    themeMode: FujinApp.themeModeOf(appearance),
    home: const SplashView(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    debugShowCheckedModeBanner: false,
    themeAnimationStyle: AnimationStyle.noAnimation,
    builder: FujinApp.builderFor(environment, appearance: appearance),
  );
}
