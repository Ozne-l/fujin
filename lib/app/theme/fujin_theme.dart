import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

abstract final class FujinTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: FujinRole.fondPage,
    canvasColor: FujinRole.fondPage,
    dividerColor: FujinRole.bordureFilet,
    fontFamily: FujinFont.inter,
    textTheme: _textTheme,
    dividerTheme: const DividerThemeData(
      color: FujinRole.bordureFilet,
      thickness: FujinStroke.carte,
      space: FujinStroke.carte,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: FujinRole.texteLien,
      refreshBackgroundColor: FujinRole.fondCarte,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: FujinRole.fondSombre,
      contentTextStyle: FujinText.inter14Regular.copyWith(
        color: FujinRole.texteSurSombre,
      ),
      actionTextColor: FujinRole.texteSurSombre,
      behavior: SnackBarBehavior.floating,
    ),
  );

  static const _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: FujinRole.texteLien,
    onPrimary: FujinRole.texteSurSombre,
    primaryContainer: FujinRole.fondSucces,
    onPrimaryContainer: FujinRole.texteLien,
    secondary: FujinRole.boutonPrincipalFond,
    onSecondary: FujinRole.boutonPrincipalTexte,
    secondaryContainer: FujinRole.fondInfo,
    onSecondaryContainer: FujinRole.textePrincipal,
    tertiary: FujinRole.texteOr,
    onTertiary: FujinRole.texteSurSombre,
    error: FujinRole.texteAlerte,
    onError: FujinRole.boutonAlerteTexte,
    errorContainer: FujinRole.fondAlerte,
    onErrorContainer: FujinRole.texteAlerte,
    surface: FujinRole.fondCarte,
    onSurface: FujinRole.textePrincipal,
    onSurfaceVariant: FujinRole.texteSecondaire,
    surfaceContainerLowest: FujinRole.fondCarte,
    surfaceContainerLow: FujinRole.fondCarte,
    surfaceContainer: FujinRole.fondCarte,
    surfaceContainerHigh: FujinRole.fondCarte,
    surfaceContainerHighest: FujinRole.fondCarte,
    surfaceTint: FujinRole.fondCarte,
    outline: FujinRole.bordureCarte,
    outlineVariant: FujinRole.bordureFilet,
    shadow: FujinRole.fondVoile,
    scrim: FujinRole.fondVoile,
    inverseSurface: FujinRole.fondSombre,
    onInverseSurface: FujinRole.texteSurSombre,
  );

  static final TextTheme _textTheme =
      const TextTheme(
        displayLarge: FujinText.hina44,
        displayMedium: FujinText.hina30,
        displaySmall: FujinText.hina28,
        headlineLarge: FujinText.hina26,
        headlineMedium: FujinText.hina24,
        headlineSmall: FujinText.hina22,
        titleLarge: FujinText.inter22Semibold,
        titleMedium: FujinText.inter16Medium,
        titleSmall: FujinText.inter14Medium,
        bodyLarge: FujinText.inter16Regular,
        bodyMedium: FujinText.inter14Regular,
        bodySmall: FujinText.inter12Regular,
        labelLarge: FujinText.inter14Medium,
        labelMedium: FujinText.inter12Medium,
        labelSmall: FujinText.inter11Medium,
      ).apply(
        bodyColor: FujinRole.textePrincipal,
        displayColor: FujinRole.textePrincipal,
      );
}
