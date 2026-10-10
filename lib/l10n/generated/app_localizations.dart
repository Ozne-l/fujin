import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('fr'),
    Locale('en'),
  ];

  /// No description provided for @appName.
  ///
  /// In fr, this message translates to:
  /// **'Fūjin'**
  String get appName;

  /// No description provided for @devEnvironmentBanner.
  ///
  /// In fr, this message translates to:
  /// **'DEV'**
  String get devEnvironmentBanner;

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

  /// No description provided for @ekkloReconnect.
  ///
  /// In fr, this message translates to:
  /// **'Se reconnecter à Ekklo'**
  String get ekkloReconnect;

  /// No description provided for @ekkloSignInTitle.
  ///
  /// In fr, this message translates to:
  /// **'Connexion Ekklo'**
  String get ekkloSignInTitle;

  /// No description provided for @ekkloSignInHeading.
  ///
  /// In fr, this message translates to:
  /// **'Ton compte Ekklo'**
  String get ekkloSignInHeading;

  /// No description provided for @ekkloSignInSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'Celui que ton coach utilise pour te suivre.'**
  String get ekkloSignInSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In fr, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// No description provided for @passwordShow.
  ///
  /// In fr, this message translates to:
  /// **'Afficher'**
  String get passwordShow;

  /// No description provided for @passwordHide.
  ///
  /// In fr, this message translates to:
  /// **'Masquer'**
  String get passwordHide;

  /// No description provided for @signIn.
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signIn;

  /// No description provided for @ekkloSignInRefused.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo a refusé la connexion'**
  String get ekkloSignInRefused;

  /// No description provided for @ekkloSignInMessage.
  ///
  /// In fr, this message translates to:
  /// **'« {message} »'**
  String ekkloSignInMessage(String message);

  /// No description provided for @ekkloSignInUnreachable.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo ne répond pas'**
  String get ekkloSignInUnreachable;

  /// No description provided for @ekkloSignInUnreachableDetail.
  ///
  /// In fr, this message translates to:
  /// **'Vérifie ta connexion, puis réessaie.'**
  String get ekkloSignInUnreachableDetail;

  /// No description provided for @mfpReconnect.
  ///
  /// In fr, this message translates to:
  /// **'Se reconnecter à MyFitnessPal'**
  String get mfpReconnect;

  /// No description provided for @welcomeHeading.
  ///
  /// In fr, this message translates to:
  /// **'Note une fois,\nton coach voit tout.'**
  String get welcomeHeading;

  /// No description provided for @welcomeIntro.
  ///
  /// In fr, this message translates to:
  /// **'Tu notes dans MyFitnessPal.\nFūjin envoie ta journée vers Ekklo.'**
  String get welcomeIntro;

  /// No description provided for @mfpAccountRole.
  ///
  /// In fr, this message translates to:
  /// **'Ton journal, la source'**
  String get mfpAccountRole;

  /// No description provided for @ekkloAccountRole.
  ///
  /// In fr, this message translates to:
  /// **'Le suivi de ton coach'**
  String get ekkloAccountRole;

  /// No description provided for @accountSessionActive.
  ///
  /// In fr, this message translates to:
  /// **'Session active'**
  String get accountSessionActive;

  /// No description provided for @accountConnected.
  ///
  /// In fr, this message translates to:
  /// **'Connecté'**
  String get accountConnected;

  /// No description provided for @credentialsStayOnPhone.
  ///
  /// In fr, this message translates to:
  /// **'Tes identifiants restent sur ce téléphone.'**
  String get credentialsStayOnPhone;

  /// No description provided for @continueAction.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueAction;

  /// No description provided for @reload.
  ///
  /// In fr, this message translates to:
  /// **'Recharger'**
  String get reload;

  /// No description provided for @mfpSignInHint.
  ///
  /// In fr, this message translates to:
  /// **'Connecte-toi comme d\'habitude.\nCette page se fermera toute seule.'**
  String get mfpSignInHint;

  /// No description provided for @mfpSignInRefused.
  ///
  /// In fr, this message translates to:
  /// **'MyFitnessPal a refusé la session.\nConnecte-toi à nouveau sur cette page.'**
  String get mfpSignInRefused;

  /// No description provided for @mfpSignInUnreachable.
  ///
  /// In fr, this message translates to:
  /// **'MyFitnessPal ne répond pas.\nVérifie ta connexion, puis recharge la page.'**
  String get mfpSignInUnreachable;

  /// No description provided for @sendTitle.
  ///
  /// In fr, this message translates to:
  /// **'Envoi vers Ekklo'**
  String get sendTitle;

  /// No description provided for @sendSubtitle.
  ///
  /// In fr, this message translates to:
  /// **'{date} · {count} {count, plural, =1{aliment} other{aliments}}'**
  String sendSubtitle(DateTime date, int count);

  /// No description provided for @searchingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche en cours'**
  String get searchingTitle;

  /// No description provided for @searchingDetail.
  ///
  /// In fr, this message translates to:
  /// **'Fūjin cherche tes aliments dans Ekklo.'**
  String get searchingDetail;

  /// No description provided for @searchingNote.
  ///
  /// In fr, this message translates to:
  /// **'Une requête Ekklo par aliment. Les aliments mémorisés vont plus vite.'**
  String get searchingNote;

  /// No description provided for @progressCount.
  ///
  /// In fr, this message translates to:
  /// **'{done} / {total}'**
  String progressCount(int done, int total);

  /// No description provided for @gramsValue.
  ///
  /// In fr, this message translates to:
  /// **'{value} g'**
  String gramsValue(double value);

  /// No description provided for @towards.
  ///
  /// In fr, this message translates to:
  /// **'→ {name}'**
  String towards(String name);

  /// No description provided for @towardsAmount.
  ///
  /// In fr, this message translates to:
  /// **'→ {name} · {amount}'**
  String towardsAmount(String name, String amount);

  /// No description provided for @rowSearching.
  ///
  /// In fr, this message translates to:
  /// **'Recherche dans Ekklo…'**
  String get rowSearching;

  /// No description provided for @rowWaiting.
  ///
  /// In fr, this message translates to:
  /// **'En attente'**
  String get rowWaiting;

  /// No description provided for @pillRemembered.
  ///
  /// In fr, this message translates to:
  /// **'Mémorisé'**
  String get pillRemembered;

  /// No description provided for @pillNewUnit.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle unité'**
  String get pillNewUnit;

  /// No description provided for @pillFoodChanged.
  ///
  /// In fr, this message translates to:
  /// **'Aliment modifié'**
  String get pillFoodChanged;

  /// No description provided for @pillWeightToConfirm.
  ///
  /// In fr, this message translates to:
  /// **'Poids à confirmer'**
  String get pillWeightToConfirm;

  /// No description provided for @pillNewAssociation.
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle association'**
  String get pillNewAssociation;

  /// No description provided for @pillNoCloseFood.
  ///
  /// In fr, this message translates to:
  /// **'Aucun aliment proche'**
  String get pillNoCloseFood;

  /// No description provided for @pillConfirmed.
  ///
  /// In fr, this message translates to:
  /// **'Confirmé'**
  String get pillConfirmed;

  /// No description provided for @pillSkipped.
  ///
  /// In fr, this message translates to:
  /// **'Sauté'**
  String get pillSkipped;

  /// No description provided for @sendToEkklo.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer vers Ekklo'**
  String get sendToEkklo;

  /// No description provided for @filterToReview.
  ///
  /// In fr, this message translates to:
  /// **'{count} à vérifier'**
  String filterToReview(int count);

  /// No description provided for @filterAutomatic.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{automatique} other{automatiques}}'**
  String filterAutomatic(int count);

  /// No description provided for @filterInEkklo.
  ///
  /// In fr, this message translates to:
  /// **'{count} déjà dans Ekklo'**
  String filterInEkklo(int count);

  /// No description provided for @sectionToReview.
  ///
  /// In fr, this message translates to:
  /// **'À VÉRIFIER'**
  String get sectionToReview;

  /// No description provided for @sectionAutomatic.
  ///
  /// In fr, this message translates to:
  /// **'AUTOMATIQUES'**
  String get sectionAutomatic;

  /// No description provided for @sectionInEkklo.
  ///
  /// In fr, this message translates to:
  /// **'DÉJÀ DANS EKKLO'**
  String get sectionInEkklo;

  /// No description provided for @mealTowards.
  ///
  /// In fr, this message translates to:
  /// **'{mfp} → {ekklo}'**
  String mealTowards(String mfp, String ekklo);

  /// No description provided for @entryDetail.
  ///
  /// In fr, this message translates to:
  /// **'{serving} · {energy}'**
  String entryDetail(String serving, String energy);

  /// No description provided for @change.
  ///
  /// In fr, this message translates to:
  /// **'Changer ›'**
  String get change;

  /// No description provided for @ekkloAmount.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo · {amount}'**
  String ekkloAmount(String amount);

  /// No description provided for @ekkloAmountMatch.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo · {amount} · {match}'**
  String ekkloAmountMatch(String amount, String match);

  /// No description provided for @nameMatchProduct.
  ///
  /// In fr, this message translates to:
  /// **'nom identique'**
  String get nameMatchProduct;

  /// No description provided for @nameMatchBrand.
  ///
  /// In fr, this message translates to:
  /// **'même marque'**
  String get nameMatchBrand;

  /// No description provided for @nameMatchNone.
  ///
  /// In fr, this message translates to:
  /// **'nom différent'**
  String get nameMatchNone;

  /// No description provided for @nutrientKilocalories.
  ///
  /// In fr, this message translates to:
  /// **'kcal'**
  String get nutrientKilocalories;

  /// No description provided for @nutrientProtein.
  ///
  /// In fr, this message translates to:
  /// **'P'**
  String get nutrientProtein;

  /// No description provided for @nutrientCarbohydrates.
  ///
  /// In fr, this message translates to:
  /// **'G'**
  String get nutrientCarbohydrates;

  /// No description provided for @nutrientFat.
  ///
  /// In fr, this message translates to:
  /// **'L'**
  String get nutrientFat;

  /// No description provided for @nutrientFiber.
  ///
  /// In fr, this message translates to:
  /// **'F'**
  String get nutrientFiber;

  /// No description provided for @deltaUp.
  ///
  /// In fr, this message translates to:
  /// **'{nutrient} +{value} %'**
  String deltaUp(String nutrient, int value);

  /// No description provided for @deltaDown.
  ///
  /// In fr, this message translates to:
  /// **'{nutrient} −{value} %'**
  String deltaDown(String nutrient, int value);

  /// No description provided for @deltaNone.
  ///
  /// In fr, this message translates to:
  /// **'{nutrient} 0 %'**
  String deltaNone(String nutrient);

  /// No description provided for @deltaUnknown.
  ///
  /// In fr, this message translates to:
  /// **'{nutrient} n.c.'**
  String deltaUnknown(String nutrient);

  /// No description provided for @confirm.
  ///
  /// In fr, this message translates to:
  /// **'Confirmer'**
  String get confirm;

  /// No description provided for @ownCopyToCreate.
  ///
  /// In fr, this message translates to:
  /// **'Aliment perso à créer'**
  String get ownCopyToCreate;

  /// No description provided for @ownCopyExact.
  ///
  /// In fr, this message translates to:
  /// **'Copie exacte des valeurs MyFitnessPal'**
  String get ownCopyExact;

  /// No description provided for @skippedDetail.
  ///
  /// In fr, this message translates to:
  /// **'Reste hors de cet envoi.'**
  String get skippedDetail;

  /// No description provided for @proposalsUsed.
  ///
  /// In fr, this message translates to:
  /// **'Sans changement de ta part, les propositions sont utilisées.'**
  String get proposalsUsed;

  /// No description provided for @searchEkklo.
  ///
  /// In fr, this message translates to:
  /// **'Chercher dans Ekklo'**
  String get searchEkklo;

  /// No description provided for @ekkloCandidates.
  ///
  /// In fr, this message translates to:
  /// **'CANDIDATS EKKLO'**
  String get ekkloCandidates;

  /// No description provided for @rejectedCandidates.
  ///
  /// In fr, this message translates to:
  /// **'CANDIDATS ÉCARTÉS'**
  String get rejectedCandidates;

  /// No description provided for @noEkkloResult.
  ///
  /// In fr, this message translates to:
  /// **'Aucun aliment Ekklo trouvé.'**
  String get noEkkloResult;

  /// No description provided for @toleranceNote.
  ///
  /// In fr, this message translates to:
  /// **'Écarts calculés sur la portion MFP. Vert : dans la tolérance (kcal 12 %, macros 10 %). F n.c. : fibres non communiquées.'**
  String get toleranceNote;

  /// No description provided for @associateAndRemember.
  ///
  /// In fr, this message translates to:
  /// **'Associer et mémoriser'**
  String get associateAndRemember;

  /// No description provided for @ownCopy.
  ///
  /// In fr, this message translates to:
  /// **'Aliment perso'**
  String get ownCopy;

  /// No description provided for @skip.
  ///
  /// In fr, this message translates to:
  /// **'Sauter'**
  String get skip;

  /// No description provided for @weightQuestion.
  ///
  /// In fr, this message translates to:
  /// **'Combien pèse\n1 « {unit} » ?'**
  String weightQuestion(String unit);

  /// No description provided for @weightLabel.
  ///
  /// In fr, this message translates to:
  /// **'Poids d\'1 {unit}'**
  String weightLabel(String unit);

  /// No description provided for @gramsSuffix.
  ///
  /// In fr, this message translates to:
  /// **'g'**
  String get gramsSuffix;

  /// No description provided for @weightEstimate.
  ///
  /// In fr, this message translates to:
  /// **'Estimé à partir des kcal : {energy} pour 1 {unit}.'**
  String weightEstimate(String energy, String unit);

  /// No description provided for @inEkkloTitle.
  ///
  /// In fr, this message translates to:
  /// **'Dans Ekklo'**
  String get inEkkloTitle;

  /// No description provided for @weightRemembered.
  ///
  /// In fr, this message translates to:
  /// **'Retenu pour les prochains envois de cet aliment.'**
  String get weightRemembered;

  /// No description provided for @validate.
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get validate;

  /// No description provided for @noCloseFoodTitle.
  ///
  /// In fr, this message translates to:
  /// **'Aucun aliment Ekklo assez proche'**
  String get noCloseFoodTitle;

  /// No description provided for @noCloseFoodDetail.
  ///
  /// In fr, this message translates to:
  /// **'Fūjin propose de créer un aliment perso, copie exacte des valeurs MFP.'**
  String get noCloseFoodDetail;

  /// No description provided for @ownCopyLabel.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo · aliment perso'**
  String get ownCopyLabel;

  /// No description provided for @ownCopyServing.
  ///
  /// In fr, this message translates to:
  /// **'{serving} (MFP) · {energy}'**
  String ownCopyServing(String serving, String energy);

  /// No description provided for @createOwnCopy.
  ///
  /// In fr, this message translates to:
  /// **'Créer l\'aliment perso'**
  String get createOwnCopy;

  /// No description provided for @chooseCandidate.
  ///
  /// In fr, this message translates to:
  /// **'Choisir un candidat'**
  String get chooseCandidate;

  /// No description provided for @candidateBrandMatch.
  ///
  /// In fr, this message translates to:
  /// **'{brand} · {match}'**
  String candidateBrandMatch(String brand, String match);

  /// No description provided for @weightFoodBrand.
  ///
  /// In fr, this message translates to:
  /// **'{food} · {brand}'**
  String weightFoodBrand(String food, String brand);

  /// No description provided for @weightInEkklo.
  ///
  /// In fr, this message translates to:
  /// **'{name} · {amount}'**
  String weightInEkklo(String name, String amount);

  /// No description provided for @sendingTitle.
  ///
  /// In fr, this message translates to:
  /// **'Envoi en cours'**
  String get sendingTitle;

  /// No description provided for @sendingDetail.
  ///
  /// In fr, this message translates to:
  /// **'Les aliments partent vers Ekklo…'**
  String get sendingDetail;

  /// No description provided for @sendingNote.
  ///
  /// In fr, this message translates to:
  /// **'D\'abord les aliments perso, puis un envoi par repas.'**
  String get sendingNote;

  /// No description provided for @stepOwnCopyDone.
  ///
  /// In fr, this message translates to:
  /// **'Aliment perso créé'**
  String get stepOwnCopyDone;

  /// No description provided for @stepOwnCopy.
  ///
  /// In fr, this message translates to:
  /// **'Aliment perso'**
  String get stepOwnCopy;

  /// No description provided for @stepOnTheWay.
  ///
  /// In fr, this message translates to:
  /// **'{subject} · en route'**
  String stepOnTheWay(String subject);

  /// No description provided for @stepWaiting.
  ///
  /// In fr, this message translates to:
  /// **'{subject} · en attente'**
  String stepWaiting(String subject);

  /// No description provided for @stepFoods.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment} other{aliments}}'**
  String stepFoods(int count);

  /// No description provided for @stepFoodsAdded.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment ajouté} other{aliments ajoutés}}'**
  String stepFoodsAdded(int count);

  /// No description provided for @stepFoodsNotSent.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment non envoyé} other{aliments non envoyés}}'**
  String stepFoodsNotSent(int count);

  /// No description provided for @stepQuantity.
  ///
  /// In fr, this message translates to:
  /// **'Quantité'**
  String get stepQuantity;

  /// No description provided for @stepQuantityDone.
  ///
  /// In fr, this message translates to:
  /// **'Quantité mise à jour'**
  String get stepQuantityDone;

  /// No description provided for @stepQuantityFailed.
  ///
  /// In fr, this message translates to:
  /// **'Quantité non mise à jour'**
  String get stepQuantityFailed;

  /// No description provided for @stepFailed.
  ///
  /// In fr, this message translates to:
  /// **'Non créé'**
  String get stepFailed;

  /// No description provided for @sentTitle.
  ///
  /// In fr, this message translates to:
  /// **'Envoi terminé'**
  String get sentTitle;

  /// No description provided for @sentDetail.
  ///
  /// In fr, this message translates to:
  /// **'Fūjin a envoyé {count} {count, plural, =1{aliment} other{aliments}} vers Ekklo.'**
  String sentDetail(int count);

  /// No description provided for @sentAt.
  ///
  /// In fr, this message translates to:
  /// **'{date} · {time}'**
  String sentAt(DateTime date, DateTime time);

  /// No description provided for @sentReused.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment mémorisé réutilisé} other{aliments mémorisés réutilisés}}'**
  String sentReused(int count);

  /// No description provided for @sentAssociations.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{nouvelle association} other{nouvelles associations}} : {names}'**
  String sentAssociations(int count, String names);

  /// No description provided for @sentWeights.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{poids retenu} other{poids retenus}} : {weights}'**
  String sentWeights(int count, String weights);

  /// No description provided for @unitWeight.
  ///
  /// In fr, this message translates to:
  /// **'1 {unit} = {grams}'**
  String unitWeight(String unit, String grams);

  /// No description provided for @sentOwnCopies.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment perso créé} other{aliments perso créés}} : {names}'**
  String sentOwnCopies(int count, String names);

  /// No description provided for @sentUpdated.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment mis à jour} other{aliments mis à jour}}'**
  String sentUpdated(int count);

  /// No description provided for @listSeparator.
  ///
  /// In fr, this message translates to:
  /// **', '**
  String get listSeparator;

  /// No description provided for @backToJournal.
  ///
  /// In fr, this message translates to:
  /// **'Retour au journal'**
  String get backToJournal;

  /// No description provided for @interruptedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Envoi interrompu'**
  String get interruptedTitle;

  /// No description provided for @interruptedNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Plus de réseau pendant l\'envoi : {step}.'**
  String interruptedNetwork(String step);

  /// No description provided for @interruptedSession.
  ///
  /// In fr, this message translates to:
  /// **'Ta session Ekklo a expiré pendant l\'envoi : {step}.'**
  String interruptedSession(String step);

  /// No description provided for @interruptedRefused.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo a refusé l\'envoi : {step}.'**
  String interruptedRefused(String step);

  /// No description provided for @interruptedOther.
  ///
  /// In fr, this message translates to:
  /// **'L\'envoi s\'est arrêté : {step}.'**
  String interruptedOther(String step);

  /// No description provided for @interruptedDev.
  ///
  /// In fr, this message translates to:
  /// **'Fūjin DEV n\'écrit pas dans Ekklo : {step} n\'est pas parti.'**
  String interruptedDev(String step);

  /// No description provided for @interruptedWaiting.
  ///
  /// In fr, this message translates to:
  /// **'{count} {count, plural, =1{aliment attend} other{aliments attendent}}. Rien n\'est perdu.'**
  String interruptedWaiting(int count);

  /// No description provided for @sendRemaining.
  ///
  /// In fr, this message translates to:
  /// **'Envoyer {count, plural, =1{l\'aliment restant} other{les {count} aliments restants}}'**
  String sendRemaining(int count);

  /// No description provided for @tryAgain.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get tryAgain;

  /// No description provided for @interruptedNote.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui est coché est déjà dans Ekklo et y reste.\nFūjin n\'enverra que ce qui manque.'**
  String get interruptedNote;

  /// No description provided for @later.
  ///
  /// In fr, this message translates to:
  /// **'Plus tard'**
  String get later;

  /// No description provided for @searchFailedTitle.
  ///
  /// In fr, this message translates to:
  /// **'Recherche interrompue'**
  String get searchFailedTitle;

  /// No description provided for @searchFailedNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Plus de réseau pendant la recherche. Rien n\'a été envoyé.'**
  String get searchFailedNetwork;

  /// No description provided for @searchFailedOther.
  ///
  /// In fr, this message translates to:
  /// **'Ekklo ne répond pas. Rien n\'a été envoyé.'**
  String get searchFailedOther;

  /// No description provided for @sendFailedNetwork.
  ///
  /// In fr, this message translates to:
  /// **'Plus de réseau avant l\'envoi. Rien n\'a été envoyé.'**
  String get sendFailedNetwork;

  /// No description provided for @sendFailedOther.
  ///
  /// In fr, this message translates to:
  /// **'L\'envoi n\'a pas pu commencer. Rien n\'a été envoyé.'**
  String get sendFailedOther;
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
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
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
