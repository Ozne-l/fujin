import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/glass_fill.dart';
import 'package:fujin/pages/common/glass_finish.dart';

abstract final class FujinTheme {
  static const double cursorWidth = FujinStroke.fieldFocus;

  static final ButtonStyle largeOutlinedButtonStyle = OutlinedButton.styleFrom(
    minimumSize: const Size.fromHeight(FujinSize.buttonHeight),
    textStyle: FujinText.inter15Semibold,
  );

  static const _dragHandleSize = Size(
    FujinSize.dragHandleWidth,
    FujinSize.dragHandleHeight,
  );

  static ThemeData light() => _build(FujinColors.light);

  static ThemeData dark() => _build(FujinColors.dark);

  static OutlineInputBorder fieldBorder(FujinColors colors) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(FujinRadius.field),
        ),
        borderSide: BorderSide(color: colors.borderCard),
      );

  static OutlineInputBorder fieldErrorBorder(FujinColors colors) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(FujinRadius.field),
        ),
        borderSide: BorderSide(
          color: colors.borderAlert,
          width: FujinStroke.fieldError,
        ),
      );

  static OutlineInputBorder fieldFocusedBorder(FujinColors colors) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(FujinRadius.field),
        ),
        borderSide: BorderSide(
          color: colors.borderFocus,
          width: FujinStroke.fieldFocus,
        ),
      );

  static OutlineInputBorder searchFieldBorder(FujinColors colors) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(FujinRadius.pill),
        ),
        borderSide: BorderSide(color: colors.borderCard),
      );

  static const OutlineInputBorder glassSearchFieldBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(FujinRadius.pill)),
    borderSide: BorderSide.none,
  );

  static OutlineInputBorder searchFieldFocusedBorder(FujinColors colors) =>
      OutlineInputBorder(
        borderRadius: const BorderRadius.all(
          Radius.circular(FujinRadius.pill),
        ),
        borderSide: BorderSide(
          color: colors.textLink,
          width: FujinStroke.fieldFocus,
        ),
      );

  static ButtonStyle alertButtonStyle(FujinColors colors) =>
      GlassFill.style(colors, GlassFinish.alert).merge(
        FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(FujinSize.buttonMedium),
          textStyle: FujinText.inter15Medium,
          shape: const StadiumBorder(),
        ).copyWith(overlayColor: pressedOverlay(colors)),
      );

  static ButtonStyle floatingButtonStyle(FujinColors colors) =>
      GlassFill.style(colors, GlassFinish.ink, floating: true);

  static WidgetStateProperty<Color?> pressedOverlay(FujinColors colors) =>
      WidgetStatePropertyAll<Color?>(colors.backgroundPressed);

  static BoxShadow floatingShadow(FujinColors colors) => BoxShadow(
    color: colors.shadowFloating,
    blurRadius: FujinSize.floatingShadowBlur,
    offset: const Offset(0, FujinSize.floatingShadowOffset),
  );

  static BoxShadow smallFloatingShadow(FujinColors colors) => BoxShadow(
    color: colors.shadowFloating,
    blurRadius: FujinSize.floatingShadowSmallBlur,
    offset: const Offset(0, FujinSize.floatingShadowSmallOffset),
  );

  static ThemeData _build(FujinColors colors) {
    final brightness = ThemeData.estimateBrightnessForColor(
      colors.backgroundPage,
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: _colorScheme(colors, brightness),
      extensions: [colors],
      cupertinoOverrideTheme: CupertinoThemeData(brightness: brightness),
      scaffoldBackgroundColor: colors.backgroundPage,
      canvasColor: colors.backgroundPage,
      pageTransitionsTheme: PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(
            fallbackColor: colors.backgroundPage,
          ),
          TargetPlatform.iOS: const CupertinoPageTransitionsBuilder(),
        },
      ),
      dividerColor: colors.borderHairline,
      fontFamily: FujinFont.inter,
      textTheme: _textTheme.apply(
        bodyColor: colors.textPrimary,
        displayColor: colors.textPrimary,
      ),
      dividerTheme: DividerThemeData(
        color: colors.borderHairline,
        thickness: FujinStroke.card,
        space: FujinStroke.card,
      ),
      inputDecorationTheme: InputDecorationThemeData(
        filled: true,
        fillColor: colors.backgroundCard,
        contentPadding: const EdgeInsets.all(FujinSpace.s4),
        hintStyle: FujinText.inter16Regular.copyWith(
          color: colors.textTertiary,
        ),
        border: fieldBorder(colors),
        enabledBorder: fieldBorder(colors),
        focusedBorder: fieldFocusedBorder(colors),
        errorBorder: fieldErrorBorder(colors),
        focusedErrorBorder: fieldErrorBorder(colors),
      ),
      splashFactory: InkRipple.splashFactory,
      splashColor: colors.backgroundPressed,
      highlightColor: colors.backgroundPressed,
      hoverColor: colors.backgroundPressed,
      focusColor: colors.backgroundPressed,
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: colors.textLink,
        selectionColor: colors.backgroundSuccess,
        selectionHandleColor: colors.backgroundAccent,
      ),
      tooltipTheme: TooltipThemeData(
        decoration: BoxDecoration(
          color: colors.backgroundDark,
          borderRadius: const BorderRadius.all(
            Radius.circular(FujinRadius.hint),
          ),
        ),
        padding: const EdgeInsetsDirectional.fromSTEB(
          FujinSpace.s3,
          FujinSize.hintPaddingVertical,
          FujinSize.hintPaddingEnd,
          FujinSize.hintPaddingVertical,
        ),
        textStyle: FujinText.inter13Medium.copyWith(
          color: colors.textOnDark,
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.backgroundDark,
        contentTextStyle: FujinText.inter14Regular.copyWith(
          color: colors.textOnDark,
        ),
        actionTextColor: colors.textOnDark,
        behavior: SnackBarBehavior.floating,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(FujinRadius.toast)),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.backgroundCard,
        modalBackgroundColor: colors.backgroundCard,
        modalBarrierColor: colors.backgroundScrim,
        elevation: 0,
        modalElevation: 0,
        clipBehavior: Clip.antiAlias,
        dragHandleColor: colors.borderControl,
        dragHandleSize: _dragHandleSize,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(FujinRadius.sheet),
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: GlassFill.style(colors, GlassFinish.ink).merge(
          FilledButton.styleFrom(
            minimumSize: const Size.fromHeight(FujinSize.buttonHeight),
            textStyle: FujinText.inter15Semibold,
            shape: const StadiumBorder(),
          ).copyWith(overlayColor: pressedOverlay(colors)),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: GlassFill.style(colors, GlassFinish.clear).merge(
          OutlinedButton.styleFrom(
            minimumSize: const Size(0, FujinSize.buttonMedium),
            padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s5),
            textStyle: FujinText.inter15Medium,
            shape: const StadiumBorder(),
          ).copyWith(overlayColor: pressedOverlay(colors)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            FujinSize.touchTarget,
            FujinSize.buttonMedium,
          ),
          padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s5),
          foregroundColor: colors.textLink,
          disabledForegroundColor: colors.buttonDisabledText,
          textStyle: FujinText.inter15Medium,
          shape: const StadiumBorder(),
        ).copyWith(overlayColor: pressedOverlay(colors)),
      ),
    );
  }

  static ColorScheme _colorScheme(
    FujinColors colors,
    Brightness brightness,
  ) => ColorScheme(
    brightness: brightness,
    primary: colors.textLink,
    onPrimary: colors.textOnAccent,
    primaryContainer: colors.backgroundSuccess,
    onPrimaryContainer: colors.textLink,
    secondary: colors.buttonPrimaryBackground,
    onSecondary: colors.buttonPrimaryText,
    secondaryContainer: colors.backgroundInfo,
    onSecondaryContainer: colors.textPrimary,
    tertiary: colors.textGold,
    onTertiary: colors.textOnAccent,
    error: colors.textAlert,
    onError: colors.buttonAlertText,
    errorContainer: colors.backgroundAlert,
    onErrorContainer: colors.textAlert,
    surface: colors.backgroundCard,
    onSurface: colors.textPrimary,
    onSurfaceVariant: colors.textSecondary,
    surfaceContainerLowest: colors.backgroundCard,
    surfaceContainerLow: colors.backgroundCard,
    surfaceContainer: colors.backgroundCard,
    surfaceContainerHigh: colors.backgroundCard,
    surfaceContainerHighest: colors.backgroundCard,
    surfaceTint: colors.backgroundCard,
    outline: colors.borderCard,
    outlineVariant: colors.borderHairline,
    shadow: colors.shadowFloating,
    scrim: colors.backgroundScrim,
    inverseSurface: colors.backgroundDark,
    onInverseSurface: colors.textOnDark,
  );

  static const _textTheme = TextTheme(
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
  );
}
