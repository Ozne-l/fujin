import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

abstract final class FujinTheme {
  static ThemeData light() => ThemeData(
    useMaterial3: true,
    colorScheme: _colorScheme,
    scaffoldBackgroundColor: FujinColorRole.backgroundPage,
    canvasColor: FujinColorRole.backgroundPage,
    dividerColor: FujinColorRole.borderHairline,
    fontFamily: FujinFont.inter,
    textTheme: _textTheme,
    dividerTheme: const DividerThemeData(
      color: FujinColorRole.borderHairline,
      thickness: FujinStroke.card,
      space: FujinStroke.card,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: FujinColorRole.textLink,
      refreshBackgroundColor: FujinColorRole.backgroundCard,
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: FujinColorRole.backgroundDark,
      contentTextStyle: FujinText.inter14Regular.copyWith(
        color: FujinColorRole.textOnDark,
      ),
      actionTextColor: FujinColorRole.textOnDark,
      behavior: SnackBarBehavior.floating,
    ),
  );

  static const _colorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: FujinColorRole.textLink,
    onPrimary: FujinColorRole.textOnDark,
    primaryContainer: FujinColorRole.backgroundSuccess,
    onPrimaryContainer: FujinColorRole.textLink,
    secondary: FujinColorRole.buttonPrimaryBackground,
    onSecondary: FujinColorRole.buttonPrimaryText,
    secondaryContainer: FujinColorRole.backgroundInfo,
    onSecondaryContainer: FujinColorRole.textPrimary,
    tertiary: FujinColorRole.textGold,
    onTertiary: FujinColorRole.textOnDark,
    error: FujinColorRole.textAlert,
    onError: FujinColorRole.buttonAlertText,
    errorContainer: FujinColorRole.backgroundAlert,
    onErrorContainer: FujinColorRole.textAlert,
    surface: FujinColorRole.backgroundCard,
    onSurface: FujinColorRole.textPrimary,
    onSurfaceVariant: FujinColorRole.textSecondary,
    surfaceContainerLowest: FujinColorRole.backgroundCard,
    surfaceContainerLow: FujinColorRole.backgroundCard,
    surfaceContainer: FujinColorRole.backgroundCard,
    surfaceContainerHigh: FujinColorRole.backgroundCard,
    surfaceContainerHighest: FujinColorRole.backgroundCard,
    surfaceTint: FujinColorRole.backgroundCard,
    outline: FujinColorRole.borderCard,
    outlineVariant: FujinColorRole.borderHairline,
    shadow: FujinColorRole.backgroundScrim,
    scrim: FujinColorRole.backgroundScrim,
    inverseSurface: FujinColorRole.backgroundDark,
    onInverseSurface: FujinColorRole.textOnDark,
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
        bodyColor: FujinColorRole.textPrimary,
        displayColor: FujinColorRole.textPrimary,
      );
}
