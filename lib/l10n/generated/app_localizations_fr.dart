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
}
