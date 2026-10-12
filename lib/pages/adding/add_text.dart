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
  static const _baseMultiplier = 1.0;

  static String serving(AppLocalizations l10n, MfpServingSize serving) =>
      l10n.addServing(serving.value, serving.unit);

  static String result(AppLocalizations l10n, MfpFood food) =>
      switch (food.servingSizes.firstOrNull) {
        final first? => EntryText.branded(
          l10n,
          food.brandName,
          serving(l10n, first),
        ),
        null => food.brandName ?? '',
      };

  static double? kilocalories(MfpFood food) =>
      switch ((food.nutrients?.energy?.kilocalories, food.servingSizes)) {
        (final energy?, [final first, ...]) =>
          energy * (first.nutritionMultiplier ?? _baseMultiplier),
        (final energy?, []) => energy,
        (null, _) => null,
      };

  static String recent(
    AppLocalizations l10n,
    RecentFood recent, {
    required DateTime today,
  }) => l10n.addRecentLine(
    EntryText.branded(
      l10n,
      recent.brandName,
      l10n.servingLine(
        recent.servings,
        recent.servingValue,
        recent.servingUnit,
      ),
    ),
    when(l10n, recent.addedAt, today: today),
  );

  static String when(
    AppLocalizations l10n,
    DateTime moment, {
    required DateTime today,
  }) {
    final day = DateTime.utc(moment.year, moment.month, moment.day);
    final reference = DateTime.utc(today.year, today.month, today.day);
    return switch (reference.difference(day).inDays) {
      0 => switch (moment.hour) {
        < _afternoon => l10n.addThisMorning,
        < _evening => l10n.addThisAfternoon,
        _ => l10n.addThisEvening,
      },
      1 => l10n.addYesterday,
      final days when days > 0 && days < CalendarWeek.daysPerWeek =>
        l10n.addWeekday(
          moment,
        ),
      _ => l10n.addShortDate(moment),
    };
  }

  static String forServing(AppLocalizations l10n, AddDraft draft) {
    final entry = draft.entry;
    final serving = EntryText.serving(l10n, entry);
    return switch (entryGrams(entry)) {
      final grams? when draft.servings != AddDraft.oneServing =>
        l10n.addForGrams(
          serving,
          SendText.grams(l10n, grams),
        ),
      _ => l10n.addFor(serving),
    };
  }

  static (String, String) ekkloSummary(
    AppLocalizations l10n,
    PlannedEntry planned,
  ) {
    final entry = planned.entry;
    final unit = entry.servingSize.unit;
    final gramUnit = isGramUnit(unit);
    final ownAmount = switch (entryGrams(entry)) {
      final grams? => SendText.grams(l10n, grams),
      null => EntryText.serving(l10n, entry),
    };
    final food = switch (planned.choice) {
      SendToEkkloFood(:final ekkloFoodName, :final grams) => l10n.addEkkloFood(
        ekkloFoodName,
        SendText.grams(l10n, grams),
      ),
      SendAsOwnCopy(:final reuse?) => l10n.addEkkloFood(
        reuse.ekkloFoodName,
        ownAmount,
      ),
      SendAsOwnCopy() => l10n.addWillBeCreated,
      SkipEntry() => l10n.addToChoose,
    };
    return switch (EkkloSide.of(planned)) {
      EkkloSide.remembered => (food, l10n.addRemembered),
      EkkloSide.foundAutomatically => (
        food,
        l10n.addFoundAutomatically(_gap(planned)),
      ),
      EkkloSide.willBeCreated => (
        l10n.addWillBeCreated,
        l10n.addWillBeCreatedDetail(ownAmount),
      ),
      EkkloSide.toChoose => (
        l10n.addToChoose,
        switch (gramUnit) {
          true => l10n.addToChooseDetail,
          false => l10n.addToChooseWeightDetail(unit),
        },
      ),
      EkkloSide.chosen => (
        food,
        switch ((planned.choice, gramUnit)) {
          (SendToEkkloFood(:final gramsPerUnit?), false) =>
            l10n.addChosenWeight(unit, SendText.grams(l10n, gramsPerUnit)),
          _ => l10n.addChosen,
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
