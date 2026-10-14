import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:fujin/domain/journal/calendar_week.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class AddText {
  static const _percent = 100;
  static const _afternoon = 12;
  static const _evening = 18;
  static const baseMultiplier = 1.0;

  static String serving(AppLocalizations intl, MfpServingSize serving) =>
      intl.addServing(serving.value, serving.unit);

  static String barcodeFormat(MfpBarcodeFormat format) => switch (format) {
    MfpBarcodeFormat.ean8 => 'EAN-8',
    MfpBarcodeFormat.upcA => 'UPC-A',
    MfpBarcodeFormat.ean13 => 'EAN-13',
    MfpBarcodeFormat.gtin14 => 'GTIN-14',
  };

  static String result(AppLocalizations intl, MfpFood food) =>
      switch (food.servingSizes.firstOrNull) {
        final first? => EntryText.branded(
          intl,
          food.brandName,
          serving(intl, first),
        ),
        null => food.brandName ?? '',
      };

  static double? kilocalories(MfpFood food) =>
      switch ((food.nutrients?.energy?.kilocalories, food.servingSizes)) {
        (final energy?, [final first, ...]) =>
          energy * (first.nutritionMultiplier ?? baseMultiplier),
        (final energy?, []) => energy,
        (null, _) => null,
      };

  static String recent(
    AppLocalizations intl,
    RecentFood recent, {
    required DateTime today,
  }) => intl.addRecentLine(
    EntryText.branded(
      intl,
      recent.brandName,
      intl.servingLine(
        recent.servings,
        recent.servingValue,
        recent.servingUnit,
      ),
    ),
    when(intl, recent.addedAt, today: today),
  );

  static String when(
    AppLocalizations intl,
    DateTime moment, {
    required DateTime today,
  }) {
    final day = DateTime.utc(moment.year, moment.month, moment.day);
    final reference = DateTime.utc(today.year, today.month, today.day);
    return switch (reference.difference(day).inDays) {
      0 => switch (moment.hour) {
        < _afternoon => intl.addThisMorning,
        < _evening => intl.addThisAfternoon,
        _ => intl.addThisEvening,
      },
      1 => intl.addYesterday,
      final days when days > 0 && days < CalendarWeek.daysPerWeek =>
        intl.addWeekday(
          moment,
        ),
      _ => intl.addShortDate(moment),
    };
  }

  static String forServing(AppLocalizations intl, AddDraft draft) {
    final entry = draft.entry;
    final serving = EntryText.serving(intl, entry);
    return switch (entryGrams(entry)) {
      final grams? when draft.servings != AddDraft.oneServing =>
        intl.addForGrams(
          serving,
          SendText.grams(intl, grams),
        ),
      _ => intl.addFor(serving),
    };
  }

  static (String, String) ekkloSummary(
    AppLocalizations intl,
    PlannedEntry planned,
  ) {
    final entry = planned.entry;
    final unit = entry.servingSize.unit;
    final gramUnit = isGramUnit(unit);
    final ownAmount = switch (entryGrams(entry)) {
      final grams? => SendText.grams(intl, grams),
      null => EntryText.serving(intl, entry),
    };
    final food = switch (planned.choice) {
      SendToEkkloFood(:final ekkloFoodName, :final grams) => intl.addEkkloFood(
        ekkloFoodName,
        SendText.grams(intl, grams),
      ),
      SendAsOwnCopy(:final reuse?) => intl.addEkkloFood(
        reuse.ekkloFoodName,
        ownAmount,
      ),
      SendAsOwnCopy() => intl.addWillBeCreated,
      SkipEntry() => intl.addToChoose,
    };
    return switch (EkkloSide.of(planned)) {
      EkkloSide.remembered => (food, intl.addRemembered),
      EkkloSide.foundAutomatically => (
        food,
        intl.addFoundAutomatically(_gap(planned)),
      ),
      EkkloSide.willBeCreated => (
        intl.addWillBeCreated,
        intl.addWillBeCreatedDetail(ownAmount),
      ),
      EkkloSide.toChoose => (
        intl.addToChoose,
        switch (gramUnit) {
          true => intl.addToChooseDetail,
          false => intl.addToChooseWeightDetail(unit),
        },
      ),
      EkkloSide.chosen => (
        food,
        switch ((planned.choice, gramUnit)) {
          (SendToEkkloFood(:final gramsPerUnit?), false) =>
            intl.addChosenWeight(unit, SendText.grams(intl, gramsPerUnit)),
          _ => intl.addChosen,
        },
      ),
    };
  }

  static double _gap(PlannedEntry planned) => switch (planned.choice) {
    SendToEkkloFood(:final ekkloFoodId) => switch (planned.candidates
        .where((candidate) => candidate.food.id == ekkloFoodId)
        .firstOrNull) {
      final candidate? =>
        (candidate.deltas.kilocalories * _percent).abs().roundToDouble(),
      null => 0,
    },
    SendAsOwnCopy() || SkipEntry() => 0,
  };
}
