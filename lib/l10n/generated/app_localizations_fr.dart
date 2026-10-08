// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Fūjin';

  @override
  String get journalToday => 'Aujourd\'hui';

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
      other: 'aliments sur $total',
      one: 'aliment sur 1',
    );
    return '· $sent $_temp0 ›';
  }

  @override
  String sendFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return 'Envoyer $count $_temp0 vers Ekklo';
  }

  @override
  String updateFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return 'Mettre à jour $count $_temp0 dans Ekklo';
  }

  @override
  String sendAndUpdateFoods(int send, int update) {
    String _temp0 = intl.Intl.pluralLogic(
      send,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    String _temp1 = intl.Intl.pluralLogic(
      update,
      locale: localeName,
      other: 'mises à jour',
      one: 'mise à jour',
    );
    return 'Envoyer $send $_temp0 et $update $_temp1';
  }

  @override
  String get mealsOfTheDay => 'REPAS DU JOUR';

  @override
  String mealProgress(int inEkklo, int total) {
    return '$inEkklo/$total dans Ekklo';
  }

  @override
  String get statusInEkklo => 'Dans Ekklo';

  @override
  String get statusToSend => 'À envoyer';

  @override
  String get statusToUpdate => 'À mettre à jour';

  @override
  String mealToSend(int count) {
    return '$count à envoyer';
  }

  @override
  String mealToUpdate(int count) {
    return '$count à mettre à jour';
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
    return 'Dans Ekklo : $serving';
  }

  @override
  String macros(
    String protein,
    String carbohydrates,
    String fat,
    String fiber,
  ) {
    return 'P $protein · G $carbohydrates · L $fat · F $fiber';
  }

  @override
  String macroValue(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String get macroUnknown => 'n.c.';

  @override
  String get nothingNewTitle => 'Rien de nouveau';

  @override
  String get nothingNewDetail =>
      'Modifié dans MyFitnessPal ? Synchronise l\'app';

  @override
  String get disconnected => 'Déconnecté';

  @override
  String get mfpSessionExpired => 'Ta session MyFitnessPal a expiré.';

  @override
  String get mfpSessionExpiredDetail =>
      'Reconnecte-toi pour lire ton journal.\nRien n\'est perdu.';

  @override
  String get ekkloSessionExpired => 'Ta session Ekklo a expiré.';

  @override
  String get ekkloSessionExpiredDetail =>
      'Reconnecte-toi pour ajouter et envoyer. Ton journal MyFitnessPal reste lisible.';

  @override
  String get readFailed => 'Lecture impossible';

  @override
  String get readFailedDetail => 'Tire vers le bas pour réessayer.';

  @override
  String get ekkloReconnect => 'Se reconnecter à Ekklo';

  @override
  String get ekkloSignInTitle => 'Connexion Ekklo';

  @override
  String get ekkloSignInHeading => 'Ton compte Ekklo';

  @override
  String get ekkloSignInSubtitle =>
      'Celui que ton coach utilise pour te suivre.';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordShow => 'Afficher';

  @override
  String get passwordHide => 'Masquer';

  @override
  String get signIn => 'Se connecter';

  @override
  String get ekkloSignInRefused => 'Ekklo a refusé la connexion';

  @override
  String ekkloSignInMessage(String message) {
    return '« $message »';
  }

  @override
  String get ekkloSignInUnreachable => 'Ekklo ne répond pas';

  @override
  String get ekkloSignInUnreachableDetail =>
      'Vérifie ta connexion, puis réessaie.';

  @override
  String get mfpReconnect => 'Se reconnecter à MyFitnessPal';

  @override
  String get welcomeHeading => 'Note une fois,\nton coach voit tout.';

  @override
  String get welcomeIntro =>
      'Tu notes dans MyFitnessPal.\nFūjin envoie ta journée vers Ekklo.';

  @override
  String get mfpAccountRole => 'Ton journal, la source';

  @override
  String get ekkloAccountRole => 'Le suivi de ton coach';

  @override
  String get accountSessionActive => 'Session active';

  @override
  String get accountConnected => 'Connecté';

  @override
  String get credentialsStayOnPhone =>
      'Tes identifiants restent sur ce téléphone.';

  @override
  String get continueAction => 'Continuer';

  @override
  String get reload => 'Recharger';

  @override
  String get mfpSignInHint =>
      'Connecte-toi comme d\'habitude.\nCette page se fermera toute seule.';

  @override
  String get mfpSignInRefused =>
      'MyFitnessPal a refusé la session.\nConnecte-toi à nouveau sur cette page.';

  @override
  String get mfpSignInUnreachable =>
      'MyFitnessPal ne répond pas.\nVérifie ta connexion, puis recharge la page.';
}
