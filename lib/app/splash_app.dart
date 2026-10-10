import 'package:flutter/material.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/splash/splash_view.dart';

class SplashApp extends StatelessWidget {
  const SplashApp({required this.environment, super.key});

  final AppEnvironment environment;

  @override
  Widget build(BuildContext context) => MaterialApp(
    onGenerateTitle: (context) => AppLocalizations.of(context).appName,
    theme: FujinTheme.light(),
    home: const SplashView(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    debugShowCheckedModeBanner: false,
    builder: FujinApp.bannerFor(environment),
  );
}
