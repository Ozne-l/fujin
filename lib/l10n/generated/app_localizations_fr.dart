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
  String get devEnvironmentBanner => 'DEV';

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
  String get ekkloSignInRefusedDetail =>
      'Vérifie ton email et ton mot de passe, puis réessaie.';

  @override
  String ekkloSignInMessage(String message) {
    return 'Vérifie ton email et ton mot de passe, puis réessaie. Réponse d’Ekklo : « $message »';
  }

  @override
  String get ekkloSignInUnreachable => 'Ekklo ne répond pas';

  @override
  String get ekkloSignInUnreachableDetail =>
      'Vérifie ta connexion, puis réessaie.';

  @override
  String get mfpReconnect => 'Se reconnecter à MyFitnessPal';

  @override
  String get splashTagline => 'Laisse le vent faire.';

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

  @override
  String get sendTitle => 'Envoi vers Ekklo';

  @override
  String sendSubtitle(DateTime date, int count) {
    final intl.DateFormat dateDateFormat = intl.DateFormat(
      'EEEE d MMM',
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return '$dateString · $count $_temp0';
  }

  @override
  String get searchingTitle => 'Recherche en cours';

  @override
  String get searchingDetail => 'Fūjin cherche tes aliments dans Ekklo.';

  @override
  String get searchingNote =>
      'Une requête Ekklo par aliment. Les aliments mémorisés vont plus vite.';

  @override
  String progressCount(int done, int total) {
    return '$done / $total';
  }

  @override
  String gramsValue(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString g';
  }

  @override
  String towards(String name) {
    return '→ $name';
  }

  @override
  String towardsAmount(String name, String amount) {
    return '→ $name · $amount';
  }

  @override
  String get rowSearching => 'Recherche dans Ekklo…';

  @override
  String get rowWaiting => 'En attente';

  @override
  String get pillRemembered => 'Mémorisé';

  @override
  String get pillNewUnit => 'Nouvelle unité';

  @override
  String get pillFoodChanged => 'Aliment modifié';

  @override
  String get pillWeightToConfirm => 'Poids à confirmer';

  @override
  String get pillNewAssociation => 'Nouvelle association';

  @override
  String get pillNoCloseFood => 'Aucun aliment proche';

  @override
  String get pillConfirmed => 'Confirmé';

  @override
  String get pillSkipped => 'Sauté';

  @override
  String get sendToEkklo => 'Envoyer vers Ekklo';

  @override
  String filterToReview(int count) {
    return '$count à vérifier';
  }

  @override
  String filterAutomatic(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'automatiques',
      one: 'automatique',
    );
    return '$count $_temp0';
  }

  @override
  String filterInEkklo(int count) {
    return '$count déjà dans Ekklo';
  }

  @override
  String get sectionToReview => 'À VÉRIFIER';

  @override
  String get sectionAutomatic => 'AUTOMATIQUES';

  @override
  String get sectionInEkklo => 'DÉJÀ DANS EKKLO';

  @override
  String mealTowards(String mfp, String ekklo) {
    return '$mfp → $ekklo';
  }

  @override
  String entryDetail(String serving, String energy) {
    return '$serving · $energy';
  }

  @override
  String get change => 'Changer ›';

  @override
  String ekkloAmount(String amount) {
    return 'Ekklo · $amount';
  }

  @override
  String ekkloAmountMatch(String amount, String match) {
    return 'Ekklo · $amount · $match';
  }

  @override
  String get nameMatchProduct => 'nom identique';

  @override
  String get nameMatchBrand => 'même marque';

  @override
  String get nameMatchNone => 'nom différent';

  @override
  String get nutrientKilocalories => 'kcal';

  @override
  String get nutrientProtein => 'P';

  @override
  String get nutrientCarbohydrates => 'G';

  @override
  String get nutrientFat => 'L';

  @override
  String get nutrientFiber => 'F';

  @override
  String deltaUp(String nutrient, int value) {
    return '$nutrient +$value %';
  }

  @override
  String deltaDown(String nutrient, int value) {
    return '$nutrient −$value %';
  }

  @override
  String deltaNone(String nutrient) {
    return '$nutrient 0 %';
  }

  @override
  String deltaUnknown(String nutrient) {
    return '$nutrient n.c.';
  }

  @override
  String get confirm => 'Confirmer';

  @override
  String get ownCopyToCreate => 'Aliment perso à créer';

  @override
  String get ownCopyExact => 'Copie exacte des valeurs MyFitnessPal';

  @override
  String get skippedDetail => 'Reste hors de cet envoi.';

  @override
  String get proposalsUsed =>
      'Sans changement de ta part, les propositions sont utilisées.';

  @override
  String get searchEkklo => 'Chercher dans Ekklo';

  @override
  String get ekkloCandidates => 'CANDIDATS EKKLO';

  @override
  String get rejectedCandidates => 'CANDIDATS ÉCARTÉS';

  @override
  String get noEkkloResult => 'Aucun aliment Ekklo trouvé.';

  @override
  String get toleranceNote =>
      'Écarts calculés sur la portion MFP. Vert : dans la tolérance (kcal 12 %, macros 10 %). F n.c. : fibres non communiquées.';

  @override
  String get associateAndRemember => 'Associer et mémoriser';

  @override
  String get ownCopy => 'Aliment perso';

  @override
  String get skip => 'Sauter';

  @override
  String weightQuestion(String unit) {
    return 'Combien pèse\n1 « $unit » ?';
  }

  @override
  String weightLabel(String unit) {
    return 'Poids d\'1 $unit';
  }

  @override
  String get gramsSuffix => 'g';

  @override
  String weightEstimate(String energy, String unit) {
    return 'Estimé à partir des kcal : $energy pour 1 $unit.';
  }

  @override
  String get inEkkloTitle => 'Dans Ekklo';

  @override
  String get weightRemembered =>
      'Retenu pour les prochains envois de cet aliment.';

  @override
  String get validate => 'Valider';

  @override
  String get noCloseFoodTitle => 'Aucun aliment Ekklo assez proche';

  @override
  String get noCloseFoodDetail =>
      'Fūjin propose de créer un aliment perso, copie exacte des valeurs MFP.';

  @override
  String get ownCopyLabel => 'Ekklo · aliment perso';

  @override
  String ownCopyServing(String serving, String energy) {
    return '$serving (MFP) · $energy';
  }

  @override
  String get createOwnCopy => 'Créer l\'aliment perso';

  @override
  String get chooseCandidate => 'Choisir un candidat';

  @override
  String candidateBrandMatch(String brand, String match) {
    return '$brand · $match';
  }

  @override
  String weightFoodBrand(String food, String brand) {
    return '$food · $brand';
  }

  @override
  String weightInEkklo(String name, String amount) {
    return '$name · $amount';
  }

  @override
  String get sendingTitle => 'Envoi en cours';

  @override
  String get sendingDetail => 'Les aliments partent vers Ekklo…';

  @override
  String get sendingNote =>
      'D\'abord les aliments perso, puis un envoi par repas.';

  @override
  String get stepOwnCopyDone => 'Aliment perso créé';

  @override
  String get stepOwnCopy => 'Aliment perso';

  @override
  String stepOnTheWay(String subject) {
    return '$subject · en route';
  }

  @override
  String stepWaiting(String subject) {
    return '$subject · en attente';
  }

  @override
  String stepFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return '$count $_temp0';
  }

  @override
  String stepFoodsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments ajoutés',
      one: 'aliment ajouté',
    );
    return '$count $_temp0';
  }

  @override
  String stepFoodsNotSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments non envoyés',
      one: 'aliment non envoyé',
    );
    return '$count $_temp0';
  }

  @override
  String get stepQuantity => 'Quantité';

  @override
  String get stepQuantityDone => 'Quantité mise à jour';

  @override
  String get stepQuantityFailed => 'Quantité non mise à jour';

  @override
  String get stepFailed => 'Non créé';

  @override
  String get sentTitle => 'Envoi terminé';

  @override
  String sentDetail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return 'Fūjin a envoyé $count $_temp0 vers Ekklo.';
  }

  @override
  String sentAt(DateTime date, DateTime time) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return '$dateString · $timeString';
  }

  @override
  String sentReused(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments mémorisés réutilisés',
      one: 'aliment mémorisé réutilisé',
    );
    return '$count $_temp0';
  }

  @override
  String sentAssociations(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'nouvelles associations',
      one: 'nouvelle association',
    );
    return '$count $_temp0 : $names';
  }

  @override
  String sentWeights(int count, String weights) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'poids retenus',
      one: 'poids retenu',
    );
    return '$count $_temp0 : $weights';
  }

  @override
  String unitWeight(String unit, String grams) {
    return '1 $unit = $grams';
  }

  @override
  String sentOwnCopies(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments perso créés',
      one: 'aliment perso créé',
    );
    return '$count $_temp0 : $names';
  }

  @override
  String sentUpdated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments mis à jour',
      one: 'aliment mis à jour',
    );
    return '$count $_temp0';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get backToJournal => 'Retour au journal';

  @override
  String get automaticSentNote =>
      'Mode automatique : rien ne t\'a été demandé.';

  @override
  String unattendedChoices(int count) {
    return 'CHOIX FAITS SANS TOI ($count)';
  }

  @override
  String unattendedClosest(String name) {
    return '→ $name (le plus proche)';
  }

  @override
  String unattendedWeight(String amount) {
    return '→ $amount, poids déduit des kcal';
  }

  @override
  String get unattendedOwnCopy => '→ aliment perso créé';

  @override
  String get unattendedNote =>
      'Ces choix ne sont pas mémorisés. « Revoir » permet\nde les garder pour les prochaines fois.';

  @override
  String get review => 'Revoir';

  @override
  String get keepFailed =>
      'Choix non gardé : l\'aliment perso n\'a pas pu être créé dans Ekklo.';

  @override
  String get interruptedTitle => 'Envoi interrompu';

  @override
  String interruptedNetwork(String step) {
    return 'Plus de réseau pendant l\'envoi : $step.';
  }

  @override
  String interruptedSession(String step) {
    return 'Ta session Ekklo a expiré pendant l\'envoi : $step.';
  }

  @override
  String interruptedRefused(String step) {
    return 'Ekklo a refusé l\'envoi : $step.';
  }

  @override
  String interruptedOther(String step) {
    return 'L\'envoi s\'est arrêté : $step.';
  }

  @override
  String interruptedDev(String step) {
    return 'Fūjin DEV n\'écrit pas dans Ekklo : $step n\'est pas parti.';
  }

  @override
  String interruptedWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments attendent',
      one: 'aliment attend',
    );
    return '$count $_temp0. Rien n\'est perdu.';
  }

  @override
  String sendRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les $count aliments restants',
      one: 'l\'aliment restant',
    );
    return 'Envoyer $_temp0';
  }

  @override
  String get tryAgain => 'Réessayer';

  @override
  String get interruptedNote =>
      'Ce qui est coché est déjà dans Ekklo et y reste.\nFūjin n\'enverra que ce qui manque.';

  @override
  String get later => 'Plus tard';

  @override
  String get searchFailedTitle => 'Recherche interrompue';

  @override
  String get searchFailedNetwork =>
      'Plus de réseau pendant la recherche. Rien n\'a été envoyé.';

  @override
  String get searchFailedOther => 'Ekklo ne répond pas. Rien n\'a été envoyé.';

  @override
  String get sendFailedNetwork =>
      'Plus de réseau avant l\'envoi. Rien n\'a été envoyé.';

  @override
  String get sendFailedOther =>
      'L\'envoi n\'a pas pu commencer. Rien n\'a été envoyé.';

  @override
  String get tabJournal => 'Journal';

  @override
  String get tabMemory => 'Mémoire';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get tabScanner => 'Scanner';

  @override
  String get memorySubtitle => 'Ce que Fūjin a appris de tes choix.';

  @override
  String memoryFoods(int count) {
    return 'Aliments ($count)';
  }

  @override
  String memoryMeals(int count) {
    return 'Repas ($count)';
  }

  @override
  String get memorySearchHint => 'Rechercher un aliment';

  @override
  String get memorySearchEmpty => 'Aucun aliment mémorisé ne correspond.';

  @override
  String memoryTarget(String name) {
    return '→ $name';
  }

  @override
  String get memoryOwnCopyTarget => '→ Aliment perso (copie MFP)';

  @override
  String get memoryEmptyTitle => 'Aucun aliment mémorisé';

  @override
  String get memoryEmptyDetail =>
      'Chaque choix fait pendant un envoi\nest retenu ici pour la suite.';

  @override
  String memoryUnitQuoted(String unit) {
    return '« $unit »';
  }

  @override
  String memoryServedIn(String units) {
    return 'Servi en $units';
  }

  @override
  String get memoryChange => 'Changer ›';

  @override
  String memoryPerGrams(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'pour $amountString g';
  }

  @override
  String memoryPerMilliliters(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'pour $amountString ml';
  }

  @override
  String get memoryPerPortion => 'par portion';

  @override
  String get memoryUnitWeights => 'POIDS PAR UNITÉ';

  @override
  String memoryOneUnit(String unit) {
    return '1 $unit';
  }

  @override
  String memoryUnitWeightNote(String units) {
    return 'Utilisé quand MyFitnessPal compte en $units\net non en grammes.';
  }

  @override
  String get memoryForget => 'Oublier cet aliment';

  @override
  String get memoryForgetNote =>
      'Le prochain envoi te redemandera quoi choisir.';

  @override
  String get memoryMealsNote =>
      'Un repas MyFitnessPal sans correspondance\ngarde son nom dans Ekklo.';

  @override
  String get memoryChangeSubtitle =>
      'Choisis l\'aliment Ekklo à retenir pour la suite.';

  @override
  String memoryEnergyPer(String energy, String portion) {
    return '$energy · $portion';
  }

  @override
  String get settingsAccounts => 'COMPTES';

  @override
  String get settingsAccountActive => 'Connecté · session active';

  @override
  String get signOut => 'Déconnecter';

  @override
  String get settingsGoals => 'OBJECTIFS';

  @override
  String get goalsEveryDay => 'Tous les jours';

  @override
  String get goalsNone => 'Aucun objectif';

  @override
  String goalsSummaryPart(String nutrient, String value) {
    return '$nutrient $value';
  }

  @override
  String get summarySeparator => ' · ';

  @override
  String get settingsSending => 'ENVOI';

  @override
  String get automaticMode => 'Mode automatique';

  @override
  String get automaticModeDetail =>
      'Ne me demande rien : aliments mémorisés,\npuis meilleur candidat, sinon aliment perso.';

  @override
  String get settingsBackup => 'SAUVEGARDE';

  @override
  String get backupExport => 'Exporter une sauvegarde';

  @override
  String get backupExportDetail => 'Mémoire et liens d’envoi, dans un fichier';

  @override
  String get backupImport => 'Importer une sauvegarde';

  @override
  String get backupImportDetail => 'Remplace la mémoire de ce téléphone';

  @override
  String get settingsData => 'DONNÉES SUR CE TÉLÉPHONE';

  @override
  String get clearSessions => 'Effacer les sessions';

  @override
  String get clearSessionsDetail =>
      'Il faudra te reconnecter aux deux comptes.';

  @override
  String get clearMemory => 'Effacer la mémoire';

  @override
  String memoryCounts(int foods, int meals) {
    String _temp0 = intl.Intl.pluralLogic(
      foods,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return '$foods $_temp0 et $meals repas';
  }

  @override
  String appVersion(String version) {
    return 'Fūjin · $version';
  }

  @override
  String get cancel => 'Annuler';

  @override
  String get signOutMfpTitle => 'Te déconnecter de MyFitnessPal ?';

  @override
  String get signOutMfpDetail =>
      'Fūjin oublie ta session MyFitnessPal sur ce téléphone. Il faudra te reconnecter pour lire ton journal.';

  @override
  String get signOutEkkloTitle => 'Te déconnecter d\'Ekklo ?';

  @override
  String get signOutEkkloDetail =>
      'Fūjin oublie ta session Ekklo sur ce téléphone. Il faudra te reconnecter pour envoyer vers Ekklo.';

  @override
  String get clearSessionsTitle => 'Effacer les sessions ?';

  @override
  String get clearSessionsConfirm =>
      'Fūjin oublie tes sessions MyFitnessPal et Ekklo sur ce téléphone. Il faudra te reconnecter aux deux comptes.';

  @override
  String get clearMemoryTitle => 'Effacer la mémoire ?';

  @override
  String clearMemoryConfirm(String counts) {
    return 'Fūjin oublie $counts. Les liens d’envoi restent : rien ne sera envoyé deux fois.';
  }

  @override
  String get importTitle => 'Importer cette sauvegarde ?';

  @override
  String importDetail(DateTime date, int foods, int meals, int links) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    String _temp0 = intl.Intl.pluralLogic(
      foods,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    String _temp1 = intl.Intl.pluralLogic(
      links,
      locale: localeName,
      other: 'liens d’envoi',
      one: 'lien d’envoi',
    );
    return 'Sauvegarde du $dateString : $foods $_temp0, $meals repas et $links $_temp1. Elle remplace la mémoire de ce téléphone.';
  }

  @override
  String get importConfirm => 'Importer et remplacer';

  @override
  String get backupUnreadable => 'Fichier illisible, rien n\'a changé';

  @override
  String get backupExported => 'Sauvegarde exportée';

  @override
  String get backupImported => 'Sauvegarde importée';

  @override
  String get backupNotWritten => 'Fichier non écrit, rien n\'a changé';

  @override
  String get goalsTitle => 'Objectifs';

  @override
  String get goalsHeading => 'Tes objectifs';

  @override
  String get goalsSubtitle =>
      'Les mêmes chaque jour. Fūjin les compare\nà ton journal MyFitnessPal.';

  @override
  String get goalsSection => 'TOUS LES JOURS';

  @override
  String get goalKilocalories => 'Calories';

  @override
  String get goalProtein => 'Protéines · P';

  @override
  String get goalCarbohydrates => 'Glucides · G';

  @override
  String get goalFat => 'Lipides · L';

  @override
  String get goalFiber => 'Fibres · F';

  @override
  String get goalOptional => 'Facultatif';

  @override
  String get macroNameProtein => 'protéines';

  @override
  String get macroNameCarbohydrates => 'glucides';

  @override
  String get macroNameFat => 'lipides';

  @override
  String macrosTotal(double energy) {
    final intl.NumberFormat energyNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String energyString = energyNumberFormat.format(energy);

    return 'Tes macros font $energyString kcal.';
  }

  @override
  String macrosGoal(double energy) {
    final intl.NumberFormat energyNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String energyString = energyNumberFormat.format(energy);

    return 'Pour un objectif de $energyString kcal. À titre indicatif.';
  }

  @override
  String macrosPartial(int count, String macros, double energy) {
    final intl.NumberFormat energyNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String energyString = energyNumberFormat.format(energy);

    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$macros font $energyString kcal.',
      one: '$macros fait $energyString kcal.',
    );
    return '$_temp0';
  }

  @override
  String macrosMissing(String macros) {
    return '$macros sans objectif : pas de comparaison.';
  }

  @override
  String get listLastSeparator => ' et ';

  @override
  String get save => 'Enregistrer';

  @override
  String get saved => 'Enregistré';

  @override
  String get goalsSavedTitle => '✓ Objectifs enregistrés';

  @override
  String get goalsSavedDetail => 'Le Journal les affiche dès aujourd\'hui.';

  @override
  String journalMonth(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.LLLL(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get backToToday => 'Aujourd\'hui ›';

  @override
  String get setGoals => 'Définir mes objectifs ›';

  @override
  String weekBandDay(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String weekBandDayGoal(String date, String goal) {
    return '$date, $goal';
  }

  @override
  String get dayGoalUpcoming => 'à venir';

  @override
  String get dayGoalNothingLogged => 'rien de noté';

  @override
  String get dayGoalInProgress => 'en cours';

  @override
  String get dayGoalMissed => 'sous l’objectif';

  @override
  String get dayGoalReached => 'objectif atteint';

  @override
  String get dayGoalExceeded => 'objectif dépassé';

  @override
  String get previousWeek => 'Semaine précédente';

  @override
  String get nextWeek => 'Semaine suivante';

  @override
  String get weekBandHint => 'Glisse pour voir les semaines passées';

  @override
  String kilocaloriesGoal(double goal) {
    final intl.NumberFormat goalNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String goalString = goalNumberFormat.format(goal);

    return '/ $goalString kcal';
  }

  @override
  String kilocaloriesAt(double value, DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString kcal à $timeString';
  }

  @override
  String ringValue(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString';
  }

  @override
  String ringGoal(double goal) {
    final intl.NumberFormat goalNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String goalString = goalNumberFormat.format(goal);

    return '/ $goalString';
  }

  @override
  String atLeast(String value) {
    return '≥ $value';
  }

  @override
  String get macroNameFiber => 'fibres';

  @override
  String ekkloFoodCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'aliments',
      one: 'aliment',
    );
    return '· $count $_temp0 ›';
  }

  @override
  String get ekkloNoFood => '· aucun aliment';

  @override
  String get sideUnavailable => 'indisponible';

  @override
  String get ekkloUnavailable => 'Ekklo indisponible';

  @override
  String goalLine(String goals) {
    return 'Objectif · $goals';
  }

  @override
  String get mealEmpty => 'Rien pour l’instant';

  @override
  String get mealAddFood => 'Ajouter un aliment';

  @override
  String mealFolded(int inEkklo, int total, String foods) {
    return '$inEkklo/$total · $foods';
  }

  @override
  String foodAdded(String food) {
    return '$food ajouté';
  }

  @override
  String foodAddedBothSides(String meal) {
    return 'MyFitnessPal et Ekklo · $meal';
  }

  @override
  String foodAddedMfpOnly(String meal) {
    return 'MyFitnessPal seulement · $meal';
  }

  @override
  String get addUndone => 'Ajout annulé';

  @override
  String get addUndoneDetail => 'Supprimé de MyFitnessPal et d’Ekklo';

  @override
  String get addStillInMfp => 'Encore dans MyFitnessPal';

  @override
  String addStillInMfpDetail(String food) {
    return '$food retiré d\'Ekklo seulement';
  }

  @override
  String get addNotUndone => 'Ajout non annulé';

  @override
  String get undoAdd => 'Annuler';

  @override
  String get journalLoading => 'Lecture de MyFitnessPal\net d\'Ekklo…';

  @override
  String get dayDetailTitle => 'Détail du jour';

  @override
  String get close => 'Fermer';

  @override
  String dayDetailPending(int count, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aliments sur $total ne sont pas encore dans Ekklo.',
      one: '1 aliment sur $total n’est pas encore dans Ekklo.',
    );
    return '$_temp0';
  }

  @override
  String get fiberNote =>
      'MyFitnessPal ne donne pas toujours les fibres, d\'où le ≥.';

  @override
  String get offlineTitle => 'Hors ligne';

  @override
  String get offlineHeadline => 'Pas de connexion internet.';

  @override
  String get offlineDetail => 'Fūjin réessaie dès que le réseau revient.';

  @override
  String offlineSince(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Les chiffres datent de $timeString. Fūjin réessaie dès que le réseau revient.';
  }

  @override
  String get unavailableTitle => 'Indisponible';

  @override
  String serviceNotResponding(String service) {
    return '$service ne répond pas.';
  }

  @override
  String get addSearchHint => 'Rechercher dans MyFitnessPal';

  @override
  String get addVerifiedOnly => 'Vérifiés uniquement';

  @override
  String get addRecents => 'RÉCENTS';

  @override
  String get addRecentsAddedFromFujin => 'ajoutés depuis Fūjin';

  @override
  String get addRecentsOnPhone => 'sur ce téléphone';

  @override
  String get addRecentsNote =>
      'Gardés sur ce téléphone, du plus récent au plus ancien.';

  @override
  String get addRecentsEmpty =>
      'Les aliments ajoutés depuis Fūjin apparaîtront ici.';

  @override
  String addRecentLine(String detail, String when) {
    return '$detail · $when';
  }

  @override
  String get addThisMorning => 'ce matin';

  @override
  String get addThisAfternoon => 'cet après-midi';

  @override
  String get addThisEvening => 'ce soir';

  @override
  String get addYesterday => 'hier';

  @override
  String addWeekday(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.EEEE(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String addShortDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String addServing(double value, String unit) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String valueString = valueNumberFormat.format(value);

    return '$valueString $unit';
  }

  @override
  String get addMfpResults => 'RÉSULTATS MYFITNESSPAL';

  @override
  String addFirstResults(int count) {
    return '$count premiers';
  }

  @override
  String addResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count résultats',
      one: '1 résultat',
    );
    return '$_temp0';
  }

  @override
  String get addSearching => 'recherche…';

  @override
  String addBarcodeChip(String format) {
    return 'Code-barres · $format';
  }

  @override
  String get addSearchBarcode => 'Chercher ce code-barres';

  @override
  String addBarcodeValid(String format) {
    return '$format · chiffre de contrôle correct';
  }

  @override
  String addSearchAsText(String query) {
    return 'Chercher « $query » comme texte';
  }

  @override
  String get addBarcodeUnknownTitle => 'Code-barres inconnu';

  @override
  String addBarcodeUnknownDetail(String code) {
    return 'Le code $code n’est pas dans la base MyFitnessPal. Cherche le produit par son nom, ou crée-le dans l’app MyFitnessPal.';
  }

  @override
  String get addBarcodeUnresolvedTitle => 'Produit reconnu, sans fiche';

  @override
  String addBarcodeUnresolvedDetail(String name) {
    return 'MyFitnessPal connaît ce code ($name) mais n’a pas ses valeurs nutritionnelles.';
  }

  @override
  String addSearchQuoted(String query) {
    return 'Chercher « $query »';
  }

  @override
  String get addNoResultTitle => 'Aucun résultat';

  @override
  String get addNoResultDetail =>
      'MyFitnessPal ne trouve rien pour cette recherche.';

  @override
  String get addTryInstead => 'ESSAIE PLUTÔT';

  @override
  String addShorten(String query) {
    return 'Raccourcir : « $query »';
  }

  @override
  String get addIncludeUnverified => 'Inclure les non vérifiés';

  @override
  String get addOfflineTitle => 'Pas de connexion';

  @override
  String get addOfflineDetail =>
      'La recherche reprendra au retour du réseau. Tes récents restent là.';

  @override
  String get addServerTitle => 'MyFitnessPal ne répond pas';

  @override
  String get addServerDetail =>
      'Le serveur a renvoyé une erreur. Ta recherche est gardée.';

  @override
  String addServerCode(int code) {
    return 'Code $code · pour le support';
  }

  @override
  String addToMeal(String meal) {
    return 'Ajouter à $meal';
  }

  @override
  String get addVerified => 'Vérifié';

  @override
  String get addUnverified => 'Non vérifié';

  @override
  String addEan(String code) {
    return 'EAN $code';
  }

  @override
  String get addServingSize => 'TAILLE DE PORTION';

  @override
  String get addServings => 'NOMBRE DE PORTIONS';

  @override
  String get addServingsOther => 'Autre';

  @override
  String get addServingsUnit => 'portions';

  @override
  String addMealDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMEd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String addFor(String serving) {
    return 'Pour $serving';
  }

  @override
  String addForGrams(String serving, String grams) {
    return 'Pour $serving, soit $grams';
  }

  @override
  String get addMyDay => 'Ma journée';

  @override
  String addRemaining(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return 'Il restera $valueString kcal';
  }

  @override
  String addExceeds(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return 'Dépassera de $valueString kcal';
  }

  @override
  String addMacroGrams(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString g';
  }

  @override
  String addEkkloFood(String name, String amount) {
    return 'Ekklo : $name, $amount';
  }

  @override
  String get addRemembered => 'mémorisé';

  @override
  String addFoundAutomatically(double percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String percentString = percentNumberFormat.format(percent);

    return 'trouvé automatiquement, écart $percentString %';
  }

  @override
  String get addWillBeCreated => 'Ekklo : sera créé depuis MFP';

  @override
  String addWillBeCreatedDetail(String amount) {
    return 'aliment perso copié de MFP, $amount';
  }

  @override
  String get addToChoose => 'Ekklo : à choisir';

  @override
  String get addToChooseDetail => 'candidats proches à confirmer';

  @override
  String addToChooseWeightDetail(String unit) {
    return 'candidats proches et poids d’une $unit à confirmer';
  }

  @override
  String get addChosen => 'choisi';

  @override
  String addChosenWeight(String unit, String grams) {
    return 'choisi, poids d’une $unit retenu : $grams';
  }

  @override
  String get addWriteOrder =>
      'Écrit d’abord dans MyFitnessPal, puis dans Ekklo.';

  @override
  String get addToBoth => 'Ajouter à MFP et Ekklo';

  @override
  String get addChooseEkkloFood => 'Choisir l’aliment Ekklo';

  @override
  String get addConfirmAndAdd => 'Confirmer et ajouter';

  @override
  String addDaySubtitle(String date, String food, String amount) {
    return '$date, avec $food, $amount';
  }

  @override
  String get addThisFood => 'Cet aliment';

  @override
  String get addAfterAdding => 'Après l’ajout';

  @override
  String get addGoal => 'Objectif';

  @override
  String addPlus(String value) {
    return '+$value';
  }

  @override
  String get addDayNote =>
      'Calories en kcal, nutriments en grammes. Objectifs réglables dans Réglages.';

  @override
  String addDayExtras(double sugar, double sodium) {
    final intl.NumberFormat sugarNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 1,
        );
    final String sugarString = sugarNumberFormat.format(sugar);
    final intl.NumberFormat sodiumNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String sodiumString = sodiumNumberFormat.format(sodium);

    return 'Sucres +$sugarString g, sodium +$sodiumString mg.';
  }

  @override
  String get addingTitle => 'Ajout en cours';

  @override
  String addWrittenIn(String meal) {
    return 'Écrit dans $meal';
  }

  @override
  String get addWriting => 'Écriture…';

  @override
  String get addAdding => 'Ajout en cours…';

  @override
  String get addAddingNote =>
      'Le bouton reste bloqué jusqu’à la réponse des deux côtés : un double tap n’ajoute rien deux fois.';

  @override
  String get addEkkloNoReply => 'Ekklo n’a pas répondu';

  @override
  String get addNotWritten => 'Non écrit';

  @override
  String get addEkkloFailedDetail =>
      'L’entrée MyFitnessPal est gardée. Réessayer Ekklo n’écrit pas une deuxième fois dans MyFitnessPal.';

  @override
  String get addRetryEkklo => 'Réessayer Ekklo';

  @override
  String get addCancelMfpEntry => 'Annuler l\'entrée MFP';

  @override
  String get addMfpNoReply => 'MyFitnessPal n’a pas répondu';

  @override
  String get addNotSent => 'Pas envoyé';

  @override
  String get addMfpFailedDetail =>
      'Rien n’a été écrit, ni dans MyFitnessPal ni dans Ekklo. Ta saisie est gardée.';

  @override
  String get addEditEntry => 'Modifier la saisie';

  @override
  String get addFoodChangedTitle => 'Cet aliment a changé dans MyFitnessPal';

  @override
  String addFoodChangedDetail(double before, double after, String serving) {
    final intl.NumberFormat beforeNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String beforeString = beforeNumberFormat.format(before);
    final intl.NumberFormat afterNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String afterString = afterNumberFormat.format(after);

    return 'Valeurs rechargées : $beforeString → $afterString kcal / $serving. Ce qui a bougé est surligné en jaune.';
  }

  @override
  String get addMfpSessionTitle => 'Session MyFitnessPal expirée';

  @override
  String addMfpSessionDetail(
    String food,
    String serving,
    String meal,
    DateTime date,
  ) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Reconnecte-toi pour ajouter. Ta saisie est gardée : $food, $serving, $meal du $dateString.';
  }

  @override
  String get addMfpSessionSearchDetail =>
      'Reconnecte-toi pour chercher. Ta recherche est gardée.';

  @override
  String get addEkkloSessionTitle => 'Session Ekklo expirée';

  @override
  String get addEkkloSessionDetail =>
      'MyFitnessPal reste connecté. Reconnecte Ekklo pour écrire des deux côtés ; ta saisie est gardée.';

  @override
  String get addScannedUnresolved =>
      'MyFitnessPal connaît ce code-barres mais n\'a pas de fiche pour cet aliment. Choisis-le dans la recherche.';

  @override
  String get scannerTitle => 'Scanner un code-barres';

  @override
  String scannerContext(String meal, DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMEd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$meal · $dateString';
  }

  @override
  String get scannerAim => 'Place le code-barres dans le cadre';

  @override
  String scannerCodeRead(String code) {
    return 'Code lu : $code';
  }

  @override
  String get scannerTypeCode => 'Saisir le code';

  @override
  String get scannerTorch => 'Lampe';

  @override
  String get scannerTypeTitle => 'Saisir le code-barres';

  @override
  String scannerCodeValid(String format) {
    return '$format, chiffre de contrôle correct';
  }

  @override
  String get scannerSearchCode => 'Chercher ce code';

  @override
  String get scannerErase => 'Effacer';

  @override
  String get scannerFoundByBarcode => '· trouvé par code-barres';

  @override
  String get scannerFromMemory => 'Mémoire · retenu pour ce code-barres';

  @override
  String scannerPer100Grams(double energy) {
    final intl.NumberFormat energyNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String energyString = energyNumberFormat.format(energy);

    return '$energyString kcal / 100 g';
  }

  @override
  String scannerServingEnergy(String serving, String energy) {
    return '$serving · $energy';
  }

  @override
  String get scannerUnverifiedDetail =>
      'Saisi par un membre de MyFitnessPal. Vérifie que c’est bien ton paquet avant de continuer.';

  @override
  String get scannerStoreCode => 'Code magasin';

  @override
  String get scannerStoreCodeDetail =>
      'Les codes qui commencent par 02 ou 20 à 29 sont attribués par chaque enseigne : ce produit n’est peut-être pas le tien.';

  @override
  String get scannerThisProduct => 'C\'est bien ce produit';

  @override
  String get scannerWrongProduct => 'Pas le bon produit : chercher par texte';

  @override
  String scannerNameAndBrand(String name, String brand) {
    return '$name, $brand';
  }

  @override
  String get scannerSearchText => 'Chercher par texte';

  @override
  String get scannerRescan => 'Rescanner';

  @override
  String scannerCheckDigit(int actual, int expected) {
    return 'Chiffre de contrôle $actual, $expected attendu';
  }

  @override
  String get scannerCheckedOnPhone =>
      'Vérifié sur le téléphone, rien n’a été envoyé. Corrige le dernier chiffre.';

  @override
  String get scannerUnavailableTitle => 'Codes-barres indisponibles';

  @override
  String get scannerUnavailableDetail =>
      'Le service code-barres de MyFitnessPal ne répond pas. La recherche par texte, elle, fonctionne.';

  @override
  String get scannerRetryScan => 'Réessayer le scan';

  @override
  String get scannerOfflineTitle => 'Pas de connexion';

  @override
  String scannerFailedDetail(String code) {
    return 'Le code $code n\'a pas pu être cherché.';
  }

  @override
  String scannerMfpSessionDetail(String code) {
    return 'Reconnecte-toi pour chercher le code $code. Il est gardé.';
  }

  @override
  String get scannerCameraRefusedTitle => 'Pas d\'accès à l\'appareil photo';

  @override
  String get scannerCameraRefusedDetail =>
      'Autorise l\'appareil photo pour Fūjin dans les réglages du téléphone, ou saisis le code à la main.';

  @override
  String get dayPickerTitle => 'Choisir le jour';

  @override
  String dayPickerMonth(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMM(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String dayPickerDay(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMEEEEd(
      localeName,
    );
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get previousMonth => 'Mois précédent';

  @override
  String get nextMonth => 'Mois suivant';

  @override
  String memoryMealMenu(String meal) {
    return 'Repas Ekklo pour $meal';
  }
}
