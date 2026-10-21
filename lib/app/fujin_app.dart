import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/router.dart';
import 'package:fujin/app/theme/fujin_scroll_behavior.dart';
import 'package:fujin/app/theme/fujin_system_bars.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/appearance_notifier.dart';
import 'package:fujin/pages/common/theme_reveal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class FujinApp extends ConsumerWidget {
  const FujinApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appearance = ref.watch(appearanceProvider);
    return MaterialApp.router(
      onGenerateTitle: (context) => context.intl.appName,
      theme: FujinTheme.light(),
      darkTheme: FujinTheme.dark(),
      themeMode: themeModeOf(appearance),
      themeAnimationStyle: AnimationStyle.noAnimation,
      scrollBehavior: const FujinScrollBehavior(),
      routerConfig: ref.watch(routerProvider),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      builder: builderFor(
        ref.watch(appEnvironmentProvider),
        appearance: appearance,
      ),
    );
  }

  static ThemeMode themeModeOf(Appearance appearance) => switch (appearance) {
    Appearance.system => ThemeMode.system,
    Appearance.light => ThemeMode.light,
    Appearance.dark => ThemeMode.dark,
  };

  static TransitionBuilder builderFor(
    AppEnvironment environment, {
    required Appearance appearance,
  }) =>
      (context, child) => AnnotatedRegion<SystemUiOverlayStyle>(
        value: FujinSystemBars.of(
          context.colors,
          Theme.of(context).brightness,
        ),
        child: ThemeReveal(
          appearance: appearance,
          child: switch (environment) {
            AppEnvironment.production => child ?? const SizedBox.shrink(),
            AppEnvironment.dev => _devBanner(context, child),
          },
        ),
      );

  static Widget _devBanner(BuildContext context, Widget? child) => Banner(
    message: context.intl.devEnvironmentBanner,
    location: BannerLocation.topStart,
    color: context.colors.buttonAlertBackground,
    textStyle: FujinText.inter11Semibold.copyWith(
      color: context.colors.buttonAlertText,
    ),
    child: child,
  );
}
