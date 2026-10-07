import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Fūjin'**
  String get appName;

  /// No description provided for @journalToday.
  ///
  /// In fr, this message translates to:
  /// **'Aujourd\'hui'**
  String get journalToday;

  /// No description provided for @journalDay.
  ///
  /// In fr, this message translates to:
  /// **'{date}'**
  String journalDay(DateTime date);

  /// No description provided for @weekdayShort.
  ///
  /// In fr, this message translates to:
  /// **'{date}'**
  String weekdayShort(DateTime date);

  /// No description provided for @dayOfMonth.
  ///
  /// In fr, this message translates to:
  /// **'{date}'**
  String dayOfMonth(DateTime date);

  /// No description provided for @sourceMyFitnessPal.
  ///
  /// In fr, this message translates to:
  /// **'MyFitnessPal'**
  String get sourceMyFitnessPal;

  /// No description provided for @sourceEkklo.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo'**
  String get sourceEkklo;

  /// No description provided for @kilocalories.
  ///
  /// In fr, this message translates to:
  /// **'{value} kcal'**
  String kilocalories(double value);

  /// No description provided for @kilocaloriesValue.
  ///
  /// In fr, this message translates to:
  /// **'{value}'**
  String kilocaloriesValue(double value);

  /// No description provided for @ekkloProgress.
  ///
  /// In fr, this message translates to:
  /// **'· {sent} {total, plural, =1{aliment sur 1} other{aliments sur {total}}} ›'**
  String ekkloProgress(int sent, int total);

  /// No description provided for @sendFoods.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer {count} {count, plural, =1{aliment} other{aliments}} vers Ekklo'**
  String sendFoods(int count);

  /// No description provided for @updateFoods.
  ///
  /// In fr, this message translates to:
  /// **'Mettre à jour {count} {count, plural, =1{aliment} other{aliments}} dans Ekklo'**
  String updateFoods(int count);

  /// No description provided for @sendAndUpdateFoods.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer {send} {send, plural, =1{aliment} other{aliments}} et {update} {update, plural, =1{mise à jour} other{mises à jour}}'**
  String sendAndUpdateFoods(int send, int update);

  /// No description provided for @mealsOfTheDay.
  ///
  /// In fr, this message translates to:
  /// **'REPAS DU JOUR'**
  String get mealsOfTheDay;

  /// No description provided for @mealProgress.
  ///
  /// In fr, this message translates to:
  /// **'{inEkklo}/{total} dans Ekklo'**
  String mealProgress(int inEkklo, int total);

  /// No description provided for @statusInEkklo.
  ///
  /// In fr, this message translates to:
  /// **'Dans Ekklo'**
  String get statusInEkklo;

  /// No description provided for @statusToSend.
  ///
  /// In fr, this message translates to:
  /// **'À envoyer'**
  String get statusToSend;

  /// No description provided for @statusToUpdate.
  ///
  /// In fr, this message translates to:
  /// **'À mettre à jour'**
  String get statusToUpdate;

  /// No description provided for @mealToSend.
  ///
  /// In fr, this message translates to:
  /// **'{count} à envoyer'**
  String mealToSend(int count);

  /// No description provided for @mealToUpdate.
  ///
  /// In fr, this message translates to:
  /// **'{count} à mettre à jour'**
  String mealToUpdate(int count);

  /// No description provided for @servingLine.
  ///
  /// In fr, this message translates to:
  /// **'{servings} × {value} {unit}'**
  String servingLine(double servings, double value, String unit);

  /// No description provided for @brandedServingLine.
  ///
  /// In fr, this message translates to:
  /// **'{brand} · {serving}'**
  String brandedServingLine(String brand, String serving);

  /// No description provided for @inEkkloAs.
  ///
  /// In fr, this message translates to:
  /// **'Dans Ekklo : {serving}'**
  String inEkkloAs(String serving);

  /// No description provided for @macros.
  ///
  /// In fr, this message translates to:
  /// **'P {protein} · G {carbohydrates} · L {fat} · F {fiber}'**
  String macros(String protein, String carbohydrates, String fat, String fiber);

  /// No description provided for @macroValue.
  ///
  /// In fr, this message translates to:
  /// **'{value}'**
  String macroValue(double value);

  /// No description provided for @macroUnknown.
  ///
  /// In fr, this message translates to:
  /// **'n.c.'**
  String get macroUnknown;

  /// No description provided for @nothingNewTitle.
  ///
  /// In fr, this message translates to:
  /// **'Rien de nouveau'**
  String get nothingNewTitle;

  /// No description provided for @nothingNewDetail.
  ///
  /// In fr, this message translates to:
  /// **'Modifié dans MyFitnessPal ? Synchronise l\'app'**
  String get nothingNewDetail;

  /// No description provided for @disconnected.
  ///
  /// In fr, this message translates to:
  /// **'Déconnecté'**
  String get disconnected;

  /// No description provided for @mfpSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Ta session MyFitnessPal a expiré.'**
  String get mfpSessionExpired;

  /// No description provided for @mfpSessionExpiredDetail.
  ///
  /// In fr, this message translates to:
  /// **'Reconnecte-toi pour lire ton journal.\nRien n\'est perdu.'**
  String get mfpSessionExpiredDetail;

  /// No description provided for @ekkloSessionExpired.
  ///
  /// In fr, this message translates to:
  /// **'Ta session Ekklo a expiré.'**
  String get ekkloSessionExpired;

  /// No description provided for @ekkloSessionExpiredDetail.
  ///
  /// In fr, this message translates to:
  /// **'Reconnecte-toi pour ajouter et envoyer. Ton journal MyFitnessPal reste lisible.'**
  String get ekkloSessionExpiredDetail;

  /// No description provided for @readFailed.
  ///
  /// In fr, this message translates to:
  /// **'Lecture impossible'**
  String get readFailed;

  /// No description provided for @readFailedDetail.
  ///
  /// In fr, this message translates to:
  /// **'Tire vers le bas pour réessayer.'**
  String get readFailedDetail;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
