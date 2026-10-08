// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Fūjin';

  @override
  String get devEnvironmentBanner => 'DEV';

  @override
  String get journalToday => 'Today';

  @override
  String journalDay(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String weekdayShort(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.E(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String dayOfMonth(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.d(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get sourceMyFitnessPal => 'MyFitnessPal';

  @override
  String get sourceEkklo => 'Ekklo';

  @override
  String kilocalories(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString kcal';
  }

  @override
  String kilocaloriesValue(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String ekkloProgress(int sent, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      total,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return '· $sent of $total $_temp0 ›';
  }

  @override
  String sendFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return 'Send $count $_temp0 to Ekklo';
  }

  @override
  String updateFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return 'Update $count $_temp0 in Ekklo';
  }

  @override
  String sendAndUpdateFoods(int send, int update) {
    String _temp0 = intl.Intl.pluralLogic(
      send,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    String _temp1 = intl.Intl.pluralLogic(
      update,
      locale: localeName,
      other: 'updates',
      one: 'update',
    );
    return 'Send $send $_temp0 and $update $_temp1';
  }

  @override
  String get mealsOfTheDay => 'TODAY\'S MEALS';

  @override
  String mealProgress(int inEkklo, int total) {
    return '$inEkklo/$total in Ekklo';
  }

  @override
  String get statusInEkklo => 'In Ekklo';

  @override
  String get statusToSend => 'To send';

  @override
  String get statusToUpdate => 'To update';

  @override
  String mealToSend(int count) {
    return '$count to send';
  }

  @override
  String mealToUpdate(int count) {
    return '$count to update';
  }

  @override
  String servingLine(double servings, double value, String unit) {
    final intl.NumberFormat servingsNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String servingsString = servingsNumberFormat.format(servings);
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$servingsString × $valueString $unit';
  }

  @override
  String brandedServingLine(String brand, String serving) {
    return '$brand · $serving';
  }

  @override
  String inEkkloAs(String serving) {
    return 'In Ekklo: $serving';
  }

  @override
  String macros(
    String protein,
    String carbohydrates,
    String fat,
    String fiber,
  ) {
    return 'P $protein · C $carbohydrates · F $fat · Fi $fiber';
  }

  @override
  String macroValue(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String get macroUnknown => 'n/a';

  @override
  String get nothingNewTitle => 'Nothing new';

  @override
  String get nothingNewDetail => 'Changed in MyFitnessPal? Sync the app';

  @override
  String get disconnected => 'Signed out';

  @override
  String get mfpSessionExpired => 'Your MyFitnessPal session has expired.';

  @override
  String get mfpSessionExpiredDetail =>
      'Sign in again to read your diary.\nNothing is lost.';

  @override
  String get ekkloSessionExpired => 'Your Ekklo session has expired.';

  @override
  String get ekkloSessionExpiredDetail =>
      'Sign in again to add and send. Your MyFitnessPal diary stays readable.';

  @override
  String get readFailed => 'Couldn\'t load';

  @override
  String get readFailedDetail => 'Pull down to try again.';

  @override
  String get ekkloReconnect => 'Sign in to Ekklo again';

  @override
  String get ekkloSignInTitle => 'Ekklo sign-in';

  @override
  String get ekkloSignInHeading => 'Your Ekklo account';

  @override
  String get ekkloSignInSubtitle => 'The one your coach uses to follow you.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordShow => 'Show';

  @override
  String get passwordHide => 'Hide';

  @override
  String get signIn => 'Sign in';

  @override
  String get ekkloSignInRefused => 'Ekklo refused the sign-in';

  @override
  String ekkloSignInMessage(String message) {
    return '“$message”';
  }

  @override
  String get ekkloSignInUnreachable => 'Ekklo isn\'t responding';

  @override
  String get ekkloSignInUnreachableDetail =>
      'Check your connection, then try again.';

  @override
  String get mfpReconnect => 'Sign in to MyFitnessPal again';

  @override
  String get welcomeHeading => 'Log once,\nyour coach sees it all.';

  @override
  String get welcomeIntro =>
      'You log in MyFitnessPal.\nFūjin sends your day to Ekklo.';

  @override
  String get mfpAccountRole => 'Your diary, the source';

  @override
  String get ekkloAccountRole => 'Your coach\'s follow-up';

  @override
  String get accountSessionActive => 'Session active';

  @override
  String get accountConnected => 'Connected';

  @override
  String get credentialsStayOnPhone => 'Your credentials stay on this phone.';

  @override
  String get continueAction => 'Continue';

  @override
  String get reload => 'Reload';

  @override
  String get mfpSignInHint =>
      'Sign in as usual.\nThis page will close by itself.';

  @override
  String get mfpSignInRefused =>
      'MyFitnessPal refused the session.\nSign in again on this page.';

  @override
  String get mfpSignInUnreachable =>
      'MyFitnessPal isn\'t responding.\nCheck your connection, then reload the page.';
}
