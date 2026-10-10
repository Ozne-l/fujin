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
  String get memoryForget => 'Forget this food';

  @override
  String get memoryForgetNote => 'The next send will ask you to choose again.';

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
  String get previousWeek => 'Previous week';

  @override
  String get nextWeek => 'Next week';

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
}
