import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';

abstract final class FujinTheme {
  static const fieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.field)),
    borderSide: BorderSide(color: FujinColorRole.borderCard),
  );

  static const fieldErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.field)),
    borderSide: BorderSide(
      color: FujinColor.shu,
      width: FujinStroke.fieldError,
    ),
  );

  static const searchFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.pill)),
    borderSide: BorderSide(color: FujinColorRole.borderCard),
  );

  static const fieldFocusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.field)),
    borderSide: BorderSide(
      color: FujinColor.fujin,
      width: FujinStroke.fieldFocus,
    ),
  );

  static final ButtonStyle alertButtonStyle = FilledButton.styleFrom(
    minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
    backgroundColor: FujinColorRole.buttonAlertBackground,
    foregroundColor: FujinColorRole.buttonAlertText,
    textStyle: FujinText.inter15Medium,
    shape: const StadiumBorder(),
  );

  static final ButtonStyle largeOutlinedButtonStyle = OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(FujinSize.buttonHeight),
    textStyle: FujinText.inter15Semibold,
  );

  static const _dragHandleSize = Size(
    FujinSize.dragHandleWidth,
    FujinSize.dragHandleHeight,
  );

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
    inputDecorationTheme: InputDecorationThemeData(
      filled: true,
      fillColor: FujinColorRole.backgroundCard,
      contentPadding: const EdgeInsets.all(FujinSpace.s4),
      hintStyle: FujinText.inter16Regular.copyWith(
        color: FujinColorRole.textTertiary,
      ),
      border: fieldBorder,
      enabledBorder: fieldBorder,
      focusedBorder: fieldFocusedBorder,
      errorBorder: fieldErrorBorder,
      focusedErrorBorder: fieldErrorBorder,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: FujinColorRole.textPrimary,
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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(FujinRadius.toast)),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: FujinColorRole.backgroundCard,
      modalBackgroundColor: FujinColorRole.backgroundCard,
      modalBarrierColor: FujinColorRole.backgroundScrim,
      elevation: 0,
      modalElevation: 0,
      clipBehavior: Clip.antiAlias,
      dragHandleColor: FujinColor.kinari,
      dragHandleSize: _dragHandleSize,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(FujinRadius.sheet),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        minimumSize: const Size.fromHeight(FujinSize.buttonHeight),
        backgroundColor: FujinColorRole.buttonPrimaryBackground,
        foregroundColor: FujinColorRole.buttonPrimaryText,
        disabledBackgroundColor: FujinColorRole.buttonDisabledBackground,
        disabledForegroundColor: FujinColorRole.buttonDisabledText,
        textStyle: FujinText.inter15Semibold,
        shape: const StadiumBorder(),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        minimumSize: const Size(0, FujinSize.buttonMedium),
        padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s5),
        backgroundColor: FujinColorRole.backgroundCard,
        foregroundColor: FujinColorRole.textPrimary,
        side: const BorderSide(color: FujinColorRole.borderCard),
        textStyle: FujinText.inter15Medium,
        shape: const StadiumBorder(),
      ),
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
    shadow: FujinColorRole.backgroundDark,
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
