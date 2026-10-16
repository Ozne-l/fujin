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
  String get mealsOfTheDay => 'MEALS OF THE DAY';

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
  String get ekkloSignInRefusedDetail =>
      'Check your email and password, then try again.';

  @override
  String ekkloSignInMessage(String message) {
    return 'Check your email and password, then try again. Ekklo said: “$message”';
  }

  @override
  String get ekkloSignInUnreachable => 'Ekklo isn\'t responding';

  @override
  String get ekkloSignInUnreachableDetail =>
      'Check your connection, then try again.';

  @override
  String get mfpReconnect => 'Sign in to MyFitnessPal again';

  @override
  String get splashTagline => 'Let the wind do it.';

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

  @override
  String get sendTitle => 'Sending to Ekklo';

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
      other: 'foods',
      one: 'food',
    );
    return '$dateString · $count $_temp0';
  }

  @override
  String get searchingTitle => 'Searching';

  @override
  String get searchingDetail => 'Fūjin is looking for your foods in Ekklo.';

  @override
  String get searchingNote =>
      'One Ekklo request per food. Remembered foods go faster.';

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
  String get rowSearching => 'Searching Ekklo…';

  @override
  String get rowWaiting => 'Waiting';

  @override
  String get pillRemembered => 'Remembered';

  @override
  String get pillNewUnit => 'New unit';

  @override
  String get pillFoodChanged => 'Food changed';

  @override
  String get pillWeightToConfirm => 'Weight to confirm';

  @override
  String get pillNewAssociation => 'New match';

  @override
  String get pillNoCloseFood => 'No close food';

  @override
  String get pillConfirmed => 'Confirmed';

  @override
  String get pillSkipped => 'Skipped';

  @override
  String get sendToEkklo => 'Send to Ekklo';

  @override
  String filterToReview(int count) {
    return '$count to review';
  }

  @override
  String filterAutomatic(int count) {
    return '$count automatic';
  }

  @override
  String filterInEkklo(int count) {
    return '$count already in Ekklo';
  }

  @override
  String get sectionToReview => 'TO REVIEW';

  @override
  String get sectionAutomatic => 'AUTOMATIC';

  @override
  String get sectionInEkklo => 'ALREADY IN EKKLO';

  @override
  String mealTowards(String mfp, String ekklo) {
    return '$mfp → $ekklo';
  }

  @override
  String entryDetail(String serving, String energy) {
    return '$serving · $energy';
  }

  @override
  String get change => 'Change ›';

  @override
  String ekkloAmount(String amount) {
    return 'Ekklo · $amount';
  }

  @override
  String ekkloAmountMatch(String amount, String match) {
    return 'Ekklo · $amount · $match';
  }

  @override
  String get nameMatchProduct => 'same name';

  @override
  String get nameMatchBrand => 'same brand';

  @override
  String get nameMatchNone => 'different name';

  @override
  String get nutrientKilocalories => 'kcal';

  @override
  String get nutrientProtein => 'P';

  @override
  String get nutrientCarbohydrates => 'C';

  @override
  String get nutrientFat => 'F';

  @override
  String get nutrientFiber => 'Fi';

  @override
  String deltaUp(String nutrient, int value) {
    return '$nutrient +$value%';
  }

  @override
  String deltaDown(String nutrient, int value) {
    return '$nutrient −$value%';
  }

  @override
  String deltaNone(String nutrient) {
    return '$nutrient 0%';
  }

  @override
  String deltaUnknown(String nutrient) {
    return '$nutrient n/a';
  }

  @override
  String get confirm => 'Confirm';

  @override
  String get ownCopyToCreate => 'Own food to create';

  @override
  String get ownCopyExact => 'Exact copy of the MyFitnessPal values';

  @override
  String get skippedDetail => 'Left out of this send.';

  @override
  String get proposalsUsed => 'Unless you change them, the proposals are used.';

  @override
  String get searchEkklo => 'Search Ekklo';

  @override
  String get ekkloCandidates => 'EKKLO CANDIDATES';

  @override
  String get rejectedCandidates => 'REJECTED CANDIDATES';

  @override
  String get noEkkloResult => 'No Ekklo food found.';

  @override
  String get toleranceNote =>
      'Gaps computed on the MFP portion. Green: within tolerance (kcal 12%, macros 10%). Fi n/a: fiber not given.';

  @override
  String get associateAndRemember => 'Match and remember';

  @override
  String get ownCopy => 'Own food';

  @override
  String get skip => 'Skip';

  @override
  String weightQuestion(String unit) {
    return 'How much does\n1 \"$unit\" weigh?';
  }

  @override
  String weightLabel(String unit) {
    return 'Weight of 1 $unit';
  }

  @override
  String get gramsSuffix => 'g';

  @override
  String weightEstimate(String energy, String unit) {
    return 'Estimated from the kcal: $energy for 1 $unit.';
  }

  @override
  String get inEkkloTitle => 'In Ekklo';

  @override
  String get weightRemembered => 'Kept for the next sends of this food.';

  @override
  String get validate => 'Confirm';

  @override
  String get noCloseFoodTitle => 'No Ekklo food close enough';

  @override
  String get noCloseFoodDetail =>
      'Fūjin suggests creating an own food, an exact copy of the MFP values.';

  @override
  String get ownCopyLabel => 'Ekklo · own food';

  @override
  String ownCopyServing(String serving, String energy) {
    return '$serving (MFP) · $energy';
  }

  @override
  String get createOwnCopy => 'Create the own food';

  @override
  String get chooseCandidate => 'Choose a candidate';

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
  String get sendingTitle => 'Sending';

  @override
  String get sendingDetail => 'Foods are on their way to Ekklo…';

  @override
  String get sendingNote => 'Own foods first, then one send per meal.';

  @override
  String get sendingStay =>
      'The send runs to the end. You can go back to the journal right after.';

  @override
  String get stepOwnCopyDone => 'Own food created';

  @override
  String get stepOwnCopy => 'Own food';

  @override
  String stepOnTheWay(String subject) {
    return '$subject · on the way';
  }

  @override
  String stepWaiting(String subject) {
    return '$subject · waiting';
  }

  @override
  String stepFoods(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return '$count $_temp0';
  }

  @override
  String stepFoodsAdded(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods added',
      one: 'food added',
    );
    return '$count $_temp0';
  }

  @override
  String stepFoodsNotSent(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods not sent',
      one: 'food not sent',
    );
    return '$count $_temp0';
  }

  @override
  String get stepQuantity => 'Quantity';

  @override
  String get stepQuantityDone => 'Quantity updated';

  @override
  String get stepQuantityFailed => 'Quantity not updated';

  @override
  String get stepFailed => 'Not created';

  @override
  String get sentTitle => 'Sent';

  @override
  String sentDetail(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return 'Fūjin sent $count $_temp0 to Ekklo.';
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
      other: 'foods',
      one: 'food',
    );
    return '$count remembered $_temp0 reused';
  }

  @override
  String sentAssociations(int count, String names) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'matches',
      one: 'match',
    );
    return '$count new $_temp0: $names';
  }

  @override
  String sentWeights(int count, String weights) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'weights',
      one: 'weight',
    );
    return '$count $_temp0 kept: $weights';
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
      other: 'foods',
      one: 'food',
    );
    return '$count own $_temp0 created: $names';
  }

  @override
  String sentUpdated(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return '$count $_temp0 updated';
  }

  @override
  String get listSeparator => ', ';

  @override
  String get backToJournal => 'Back to the journal';

  @override
  String get automaticSentNote => 'Automatic mode: nothing was asked of you.';

  @override
  String unattendedChoices(int count) {
    return 'CHOICES MADE WITHOUT YOU ($count)';
  }

  @override
  String unattendedClosest(String name) {
    return '→ $name (the closest)';
  }

  @override
  String unattendedWeight(String amount) {
    return '→ $amount, weight inferred from kcal';
  }

  @override
  String get unattendedOwnCopy => '→ own food created';

  @override
  String get unattendedNote =>
      'These choices are not remembered. “Review” lets you\nkeep them for the next times.';

  @override
  String get review => 'Review';

  @override
  String get keepFailed =>
      'Choice not kept: the own food could not be created in Ekklo.';

  @override
  String get interruptedTitle => 'Sending stopped';

  @override
  String interruptedNetwork(String step) {
    return 'The network dropped while sending: $step.';
  }

  @override
  String interruptedSession(String step) {
    return 'Your Ekklo session expired while sending: $step.';
  }

  @override
  String interruptedRefused(String step) {
    return 'Ekklo refused the send: $step.';
  }

  @override
  String interruptedOther(String step) {
    return 'Sending stopped: $step.';
  }

  @override
  String interruptedDev(String step) {
    return 'Fūjin DEV does not write to Ekklo: $step was not sent.';
  }

  @override
  String interruptedWaiting(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods are',
      one: 'food is',
    );
    return '$count $_temp0 waiting. Nothing is lost.';
  }

  @override
  String sendRemaining(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count remaining foods',
      one: 'remaining food',
    );
    return 'Send the $_temp0';
  }

  @override
  String get tryAgain => 'Try again';

  @override
  String get interruptedNote =>
      'What is ticked is already in Ekklo and stays there.\nFūjin will only send what is missing.';

  @override
  String get later => 'Later';

  @override
  String get searchFailedTitle => 'Search stopped';

  @override
  String get searchFailedNetwork =>
      'The network dropped during the search. Nothing was sent.';

  @override
  String get searchFailedOther => 'Ekklo isn\'t responding. Nothing was sent.';

  @override
  String get sendFailedNetwork =>
      'The network dropped before sending. Nothing was sent.';

  @override
  String get sendFailedOther => 'Sending could not start. Nothing was sent.';

  @override
  String get tabJournal => 'Diary';

  @override
  String get tabMemory => 'Memory';

  @override
  String get tabSettings => 'Settings';

  @override
  String get tabScanner => 'Scanner';

  @override
  String get memorySubtitle => 'What Fūjin learned from your choices.';

  @override
  String memoryFoods(int count) {
    return 'Foods ($count)';
  }

  @override
  String memoryMeals(int count) {
    return 'Meals ($count)';
  }

  @override
  String get memorySearchHint => 'Search a food';

  @override
  String get memorySearchEmpty => 'No remembered food matches.';

  @override
  String memoryTarget(String name) {
    return '→ $name';
  }

  @override
  String get memoryOwnCopyTarget => '→ Own food (MFP copy)';

  @override
  String get memoryEmptyTitle => 'No remembered food';

  @override
  String get memoryEmptyDetail =>
      'Each choice made during a send\nis kept here for next time.';

  @override
  String memoryUnitQuoted(String unit) {
    return '“$unit”';
  }

  @override
  String memoryServedIn(String units) {
    return 'Logged in $units';
  }

  @override
  String get memoryChange => 'Change ›';

  @override
  String memoryPerGrams(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'per $amountString g';
  }

  @override
  String memoryPerMilliliters(double amount) {
    final intl.NumberFormat amountNumberFormat =
        intl.NumberFormat.decimalPattern(localeName);
    final String amountString = amountNumberFormat.format(amount);

    return 'per $amountString ml';
  }

  @override
  String get memoryPerPortion => 'per portion';

  @override
  String get memoryUnitWeights => 'WEIGHT PER UNIT';

  @override
  String memoryOneUnit(String unit) {
    return '1 $unit';
  }

  @override
  String memoryUnitWeightNote(String units) {
    return 'Used when MyFitnessPal counts in $units\nrather than grams.';
  }

  @override
  String get memoryAdd => 'Add';

  @override
  String get memoryForget => 'Forget this food';

  @override
  String get memoryForgetNote => 'The next send will ask you to choose again.';

  @override
  String get memoryForgetTitle => 'Forget this food?';

  @override
  String memoryForgetDetail(String food, int units) {
    String _temp0 = intl.Intl.pluralLogic(
      units,
      locale: localeName,
      other: ' and its $units unit weights',
      one: ' and its unit weight',
      zero: '',
    );
    return 'Fūjin forgets the Ekklo food chosen for “$food”$_temp0. The next send will ask you to choose again.';
  }

  @override
  String get memoryForgetConfirm => 'Forget';

  @override
  String get memoryMealsNote =>
      'A MyFitnessPal meal with no match\nkeeps its name in Ekklo.';

  @override
  String get memoryChangeSubtitle =>
      'Choose the Ekklo food to remember from now on.';

  @override
  String memoryEnergyPer(String energy, String portion) {
    return '$energy · $portion';
  }

  @override
  String get settingsAccounts => 'ACCOUNTS';

  @override
  String get settingsAccountActive => 'Connected · session active';

  @override
  String get signOut => 'Sign out';

  @override
  String get settingsGoals => 'GOALS';

  @override
  String get goalsEveryDay => 'Every day';

  @override
  String get goalsNone => 'No goal';

  @override
  String goalsSummaryPart(String nutrient, String value) {
    return '$nutrient $value';
  }

  @override
  String get summarySeparator => ' · ';

  @override
  String get settingsSending => 'SENDING';

  @override
  String get automaticMode => 'Automatic mode';

  @override
  String get automaticModeDetail =>
      'Don\'t ask me anything: remembered foods,\nthen the best candidate, else an own food.';

  @override
  String get settingsBackup => 'BACKUP';

  @override
  String get backupExport => 'Export a backup';

  @override
  String get backupExportDetail => 'Memory and sent links, in a file';

  @override
  String get backupImport => 'Import a backup';

  @override
  String get backupImportDetail => 'Replaces the memory on this phone';

  @override
  String get settingsData => 'DATA ON THIS PHONE';

  @override
  String get clearSessions => 'Clear the sessions';

  @override
  String get clearSessionsDetail =>
      'You will have to sign in to both accounts again.';

  @override
  String get clearMemory => 'Clear the memory';

  @override
  String memoryCounts(int foods, int meals) {
    String _temp0 = intl.Intl.pluralLogic(
      foods,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    String _temp1 = intl.Intl.pluralLogic(
      meals,
      locale: localeName,
      other: 'meals',
      one: 'meal',
    );
    return '$foods $_temp0 and $meals $_temp1';
  }

  @override
  String appVersion(String version) {
    return 'Fūjin · $version';
  }

  @override
  String get cancel => 'Cancel';

  @override
  String get signOutMfpTitle => 'Sign out of MyFitnessPal?';

  @override
  String get signOutMfpDetail =>
      'Fūjin forgets your MyFitnessPal session on this phone. You will have to sign in again to read your diary.';

  @override
  String get signOutEkkloTitle => 'Sign out of Ekklo?';

  @override
  String get signOutEkkloDetail =>
      'Fūjin forgets your Ekklo session on this phone. You will have to sign in again to send to Ekklo.';

  @override
  String get clearSessionsTitle => 'Clear the sessions?';

  @override
  String get clearSessionsConfirm =>
      'Fūjin forgets your MyFitnessPal and Ekklo sessions on this phone. You will have to sign in to both accounts again.';

  @override
  String get clearMemoryTitle => 'Clear the memory?';

  @override
  String clearMemoryConfirm(String counts) {
    return 'Fūjin forgets $counts. Sent links stay: nothing will be sent twice.';
  }

  @override
  String get importTitle => 'Import this backup?';

  @override
  String importDetail(DateTime date, int foods, int meals, int links) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.yMMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    String _temp0 = intl.Intl.pluralLogic(
      foods,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    String _temp1 = intl.Intl.pluralLogic(
      meals,
      locale: localeName,
      other: 'meals',
      one: 'meal',
    );
    String _temp2 = intl.Intl.pluralLogic(
      links,
      locale: localeName,
      other: 'sent links',
      one: 'sent link',
    );
    return 'Backup from $dateString: $foods $_temp0, $meals $_temp1 and $links $_temp2. It replaces the memory on this phone.';
  }

  @override
  String get importConfirm => 'Import and replace';

  @override
  String get backupUnreadable => 'Unreadable file, nothing changed';

  @override
  String get backupExported => 'Backup exported';

  @override
  String get backupImported => 'Backup imported';

  @override
  String get backupNotWritten => 'File not written, nothing changed';

  @override
  String get goalsTitle => 'Goals';

  @override
  String get goalsHeading => 'Your goals';

  @override
  String get goalsSubtitle =>
      'The same every day. Fūjin compares them\nwith your MyFitnessPal diary.';

  @override
  String get goalsSection => 'EVERY DAY';

  @override
  String get goalKilocalories => 'Calories';

  @override
  String get goalProtein => 'Protein · P';

  @override
  String get goalCarbohydrates => 'Carbs · C';

  @override
  String get goalFat => 'Fat · F';

  @override
  String get goalFiber => 'Fiber · Fi';

  @override
  String get goalOptional => 'Optional';

  @override
  String get macroNameProtein => 'protein';

  @override
  String get macroNameCarbohydrates => 'carbs';

  @override
  String get macroNameFat => 'fat';

  @override
  String macrosTotal(double energy) {
    final intl.NumberFormat energyNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String energyString = energyNumberFormat.format(energy);

    return 'Your macros add up to $energyString kcal.';
  }

  @override
  String macrosGoal(double energy) {
    final intl.NumberFormat energyNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String energyString = energyNumberFormat.format(energy);

    return 'For a goal of $energyString kcal. For reference only.';
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
      other: '$macros add up to $energyString kcal.',
      one: '$macros adds up to $energyString kcal.',
    );
    return '$_temp0';
  }

  @override
  String macrosMissing(String macros) {
    return '$macros without a goal: no comparison.';
  }

  @override
  String get listLastSeparator => ' and ';

  @override
  String get save => 'Save';

  @override
  String get saved => 'Saved';

  @override
  String get goalsSavedTitle => '✓ Goals saved';

  @override
  String get goalsSavedDetail => 'The Journal shows them from today.';

  @override
  String journalMonth(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.LLLL(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String get backToToday => 'Today ›';

  @override
  String get setGoals => 'Set my goals ›';

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
  String get dayGoalUpcoming => 'upcoming';

  @override
  String get dayGoalNothingLogged => 'nothing logged';

  @override
  String get dayGoalInProgress => 'in progress';

  @override
  String get dayGoalMissed => 'under the goal';

  @override
  String get dayGoalReached => 'goal reached';

  @override
  String get dayGoalExceeded => 'goal exceeded';

  @override
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

  @override
  String get weekBandHint => 'Swipe to see past weeks';

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

    return '$valueString kcal at $timeString';
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
  String get macroNameFiber => 'fiber';

  @override
  String ekkloFoodCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'foods',
      one: 'food',
    );
    return '· $count $_temp0 ›';
  }

  @override
  String get ekkloNoFood => '· no food';

  @override
  String get sideUnavailable => 'unavailable';

  @override
  String get ekkloUnavailable => 'Ekklo unavailable';

  @override
  String goalLine(String goals) {
    return 'Goal · $goals';
  }

  @override
  String get mealEmpty => 'Nothing yet';

  @override
  String get mealAddFood => 'Add a food';

  @override
  String mealFolded(int inEkklo, int total, String foods) {
    return '$inEkklo/$total · $foods';
  }

  @override
  String foodAdded(String food) {
    return '$food added';
  }

  @override
  String foodAddedBothSides(String meal) {
    return 'MyFitnessPal and Ekklo · $meal';
  }

  @override
  String foodAddedMfpOnly(String meal) {
    return 'MyFitnessPal only · $meal';
  }

  @override
  String get addUndone => 'Addition undone';

  @override
  String get addUndoneDetail => 'Removed from MyFitnessPal and Ekklo';

  @override
  String get addStillInMfp => 'Still in MyFitnessPal';

  @override
  String addStillInMfpDetail(String food) {
    return '$food removed from Ekklo only';
  }

  @override
  String get addNotUndone => 'Addition not undone';

  @override
  String get undoAdd => 'Undo';

  @override
  String get journalLoading => 'Reading MyFitnessPal\nand Ekklo…';

  @override
  String get dayDetailTitle => 'Day details';

  @override
  String get close => 'Close';

  @override
  String dayDetailPending(int count, int total) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count foods of $total are not in Ekklo yet.',
      one: '1 food of $total is not in Ekklo yet.',
    );
    return '$_temp0';
  }

  @override
  String get fiberNote =>
      'MyFitnessPal does not always give fiber, hence the ≥.';

  @override
  String get offlineTitle => 'Offline';

  @override
  String get offlineHeadline => 'No internet connection.';

  @override
  String get offlineDetail =>
      'Fūjin tries again as soon as the network is back.';

  @override
  String offlineSince(DateTime time) {
    final intl.DateFormat timeDateFormat = intl.DateFormat.Hm(localeName);
    final String timeString = timeDateFormat.format(time);

    return 'Figures from $timeString. Fūjin tries again as soon as the network is back.';
  }

  @override
  String get unavailableTitle => 'Unavailable';

  @override
  String serviceNotResponding(String service) {
    return '$service is not responding.';
  }

  @override
  String get addSearchHint => 'Search MyFitnessPal';

  @override
  String get addVerifiedOnly => 'Verified only';

  @override
  String get addRecents => 'RECENT';

  @override
  String get addRecentsAddedFromFujin => 'added from Fūjin';

  @override
  String get addRecentsOnPhone => 'on this phone';

  @override
  String get addRecentsNote => 'Kept on this phone, newest first.';

  @override
  String get addRecentsEmpty => 'Foods added from Fūjin will show up here.';

  @override
  String addRecentLine(String detail, String when) {
    return '$detail · $when';
  }

  @override
  String get addRememberedFoods => 'REMEMBERED';

  @override
  String get addRememberedLinked => 'linked to Ekklo';

  @override
  String addRememberedFound(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count found',
      one: '1 found',
    );
    return '$_temp0';
  }

  @override
  String get addRememberedNote =>
      'Fūjin sends them to Ekklo without asking you anything.';

  @override
  String addOwnCopyTarget(String unit) {
    return '→ Own food · $unit';
  }

  @override
  String get addThisMorning => 'this morning';

  @override
  String get addThisAfternoon => 'this afternoon';

  @override
  String get addThisEvening => 'this evening';

  @override
  String get addYesterday => 'yesterday';

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
  String get addMfpResults => 'MYFITNESSPAL RESULTS';

  @override
  String addFirstResults(int count) {
    return 'first $count';
  }

  @override
  String addResultCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count results',
      one: '1 result',
    );
    return '$_temp0';
  }

  @override
  String get addSearching => 'searching…';

  @override
  String addBarcodeChip(String format) {
    return 'Barcode · $format';
  }

  @override
  String get addSearchBarcode => 'Look up this barcode';

  @override
  String addBarcodeValid(String format) {
    return '$format · check digit correct';
  }

  @override
  String addSearchAsText(String query) {
    return 'Search “$query” as text';
  }

  @override
  String get addBarcodeUnknownTitle => 'Unknown barcode';

  @override
  String addBarcodeUnknownDetail(String code) {
    return 'The code $code is not in the MyFitnessPal database. Search the product by name, or create it in the MyFitnessPal app.';
  }

  @override
  String get addBarcodeUnresolvedTitle => 'Product known, no details';

  @override
  String addBarcodeUnresolvedDetail(String name) {
    return 'MyFitnessPal knows this code ($name) but has no nutrition values for it.';
  }

  @override
  String addSearchQuoted(String query) {
    return 'Search “$query”';
  }

  @override
  String get addNoResultTitle => 'No results';

  @override
  String get addNoResultDetail => 'MyFitnessPal finds nothing for this search.';

  @override
  String get addTryInstead => 'TRY INSTEAD';

  @override
  String addShorten(String query) {
    return 'Shorten: “$query”';
  }

  @override
  String get addIncludeUnverified => 'Include unverified';

  @override
  String get addOfflineTitle => 'No connection';

  @override
  String get addOfflineDetail =>
      'Search resumes when the network is back. Your recent foods stay here.';

  @override
  String get addServerTitle => 'MyFitnessPal is not responding';

  @override
  String get addServerDetail =>
      'The server returned an error. Your search is kept.';

  @override
  String addServerCode(int code) {
    return 'Code $code · for support';
  }

  @override
  String addToMeal(String meal) {
    return 'Add to $meal';
  }

  @override
  String get addVerified => 'Verified';

  @override
  String get addUnverified => 'Not verified';

  @override
  String addEan(String code) {
    return 'EAN $code';
  }

  @override
  String get addServingSize => 'SERVING SIZE';

  @override
  String get addServings => 'NUMBER OF SERVINGS';

  @override
  String get addServingsOther => 'Other';

  @override
  String get addServingsUnit => 'servings';

  @override
  String addMealDate(DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMEd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$dateString';
  }

  @override
  String addFor(String serving) {
    return 'For $serving';
  }

  @override
  String addForGrams(String serving, String grams) {
    return 'For $serving, that is $grams';
  }

  @override
  String get addMyDay => 'My day';

  @override
  String addRemaining(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return '$valueString kcal left';
  }

  @override
  String addExceeds(double value) {
    final intl.NumberFormat valueNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String valueString = valueNumberFormat.format(value);

    return 'Over by $valueString kcal';
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
    return 'Ekklo: $name, $amount';
  }

  @override
  String get addRemembered => 'remembered';

  @override
  String addFoundAutomatically(double percent) {
    final intl.NumberFormat percentNumberFormat =
        intl.NumberFormat.decimalPatternDigits(
          locale: localeName,
          decimalDigits: 0,
        );
    final String percentString = percentNumberFormat.format(percent);

    return 'found automatically, $percentString % apart';
  }

  @override
  String get addWillBeCreated => 'Ekklo: will be created from MFP';

  @override
  String addWillBeCreatedDetail(String amount) {
    return 'own food copied from MFP, $amount';
  }

  @override
  String get addToChoose => 'Ekklo: to choose';

  @override
  String get addToChooseDetail => 'close candidates to confirm';

  @override
  String addToChooseWeightDetail(String unit) {
    return 'close candidates and weight of one $unit to confirm';
  }

  @override
  String get addChosen => 'chosen';

  @override
  String addChosenWeight(String unit, String grams) {
    return 'chosen, weight of one $unit kept: $grams';
  }

  @override
  String get addWriteOrder => 'Written to MyFitnessPal first, then to Ekklo.';

  @override
  String get addToBoth => 'Add to MFP and Ekklo';

  @override
  String get addChooseEkkloFood => 'Choose the Ekklo food';

  @override
  String get addConfirmAndAdd => 'Confirm and add';

  @override
  String addDaySubtitle(String date, String food, String amount) {
    return '$date, with $food, $amount';
  }

  @override
  String get addThisFood => 'This food';

  @override
  String get addAfterAdding => 'After adding';

  @override
  String get addGoal => 'Goal';

  @override
  String addPlus(String value) {
    return '+$value';
  }

  @override
  String get addDayNote =>
      'Calories in kcal, nutrients in grams. Goals can be set in Settings.';

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

    return 'Sugar +$sugarString g, sodium +$sodiumString mg.';
  }

  @override
  String get addingTitle => 'Adding';

  @override
  String addWrittenIn(String meal) {
    return 'Written to $meal';
  }

  @override
  String get addWriting => 'Writing…';

  @override
  String get addAdding => 'Adding…';

  @override
  String get addAddingNote =>
      'The button stays locked until both sides answer: a double tap never adds twice.';

  @override
  String get addEkkloNoReply => 'Ekklo did not answer';

  @override
  String get addNotWritten => 'Not written';

  @override
  String get addEkkloFailedDetail =>
      'The MyFitnessPal entry is kept. Retrying Ekklo does not write to MyFitnessPal a second time.';

  @override
  String get addRetryEkklo => 'Retry Ekklo';

  @override
  String get addCancelMfpEntry => 'Undo the MFP entry';

  @override
  String get addMfpNoReply => 'MyFitnessPal did not answer';

  @override
  String get addNotSent => 'Not sent';

  @override
  String get addMfpFailedDetail =>
      'Nothing was written, neither to MyFitnessPal nor to Ekklo. Your entry is kept.';

  @override
  String get addEditEntry => 'Edit the entry';

  @override
  String get addFoodChangedTitle => 'This food changed in MyFitnessPal';

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

    return 'Values reloaded: $beforeString → $afterString kcal / $serving. What changed is highlighted in yellow.';
  }

  @override
  String get addMfpSessionTitle => 'MyFitnessPal session expired';

  @override
  String addMfpSessionDetail(
    String food,
    String serving,
    String meal,
    DateTime date,
  ) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMMd(localeName);
    final String dateString = dateDateFormat.format(date);

    return 'Sign in again to add. Your entry is kept: $food, $serving, $meal on $dateString.';
  }

  @override
  String get addMfpSessionSearchDetail =>
      'Sign in again to search. Your search is kept.';

  @override
  String get addEkkloSessionTitle => 'Ekklo session expired';

  @override
  String get addEkkloSessionDetail =>
      'MyFitnessPal stays connected. Reconnect Ekklo to write to both sides; your entry is kept.';

  @override
  String get addScannedUnresolved =>
      'MyFitnessPal knows this barcode but has no food card for it. Choose the food in the search.';

  @override
  String get scannerTitle => 'Scan a barcode';

  @override
  String scannerContext(String meal, DateTime date) {
    final intl.DateFormat dateDateFormat = intl.DateFormat.MMMEd(localeName);
    final String dateString = dateDateFormat.format(date);

    return '$meal · $dateString';
  }

  @override
  String get scannerAim => 'Place the barcode inside the frame';

  @override
  String scannerCodeRead(String code) {
    return 'Code read: $code';
  }

  @override
  String get scannerTypeCode => 'Type the code';

  @override
  String get scannerTorch => 'Torch';

  @override
  String get scannerTypeTitle => 'Type the barcode';

  @override
  String scannerCodeValid(String format) {
    return '$format, check digit correct';
  }

  @override
  String get scannerSearchCode => 'Look up this code';

  @override
  String get scannerErase => 'Delete';

  @override
  String get scannerFoundByBarcode => '· found by barcode';

  @override
  String get scannerFromMemory => 'Memory · kept for this barcode';

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
      'Entered by a MyFitnessPal member. Check that it is your package before going on.';

  @override
  String get scannerStoreCode => 'Store code';

  @override
  String get scannerStoreCodeDetail =>
      'Codes starting with 02 or 20 to 29 are assigned by each retailer: this product may not be yours.';

  @override
  String get scannerThisProduct => 'This is the product';

  @override
  String get scannerWrongProduct => 'Wrong product: search by text';

  @override
  String scannerNameAndBrand(String name, String brand) {
    return '$name, $brand';
  }

  @override
  String get scannerSearchText => 'Search by text';

  @override
  String get scannerRescan => 'Scan again';

  @override
  String scannerCheckDigit(int actual, int expected) {
    return 'Check digit $actual, $expected expected';
  }

  @override
  String get scannerCheckedOnPhone =>
      'Checked on the phone, nothing was sent. Fix the last digit.';

  @override
  String get scannerUnavailableTitle => 'Barcodes unavailable';

  @override
  String get scannerUnavailableDetail =>
      'The MyFitnessPal barcode service is not responding. Text search still works.';

  @override
  String get scannerRetryScan => 'Retry the scan';

  @override
  String get scannerOfflineTitle => 'No connection';

  @override
  String scannerFailedDetail(String code) {
    return 'The code $code could not be looked up.';
  }

  @override
  String scannerMfpSessionDetail(String code) {
    return 'Sign in again to look up the code $code. It is kept.';
  }

  @override
  String get scannerCameraRefusedTitle => 'No access to the camera';

  @override
  String get scannerCameraRefusedDetail =>
      'Allow the camera for Fūjin in the phone settings, or type the code by hand.';

  @override
  String get dayPickerTitle => 'Choose the day';

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
  String get previousMonth => 'Previous month';

  @override
  String get nextMonth => 'Next month';

  @override
  String memoryMealMenu(String meal) {
    return 'Ekklo meal for $meal';
  }
}
