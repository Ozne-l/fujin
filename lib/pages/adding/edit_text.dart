import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/entry_quantity.dart';
import 'package:fujin/domain/editing/ekklo_edit.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/sending/send_text.dart';

abstract final class EditText {
  static (String, String)? ekkloSummary(
    AppLocalizations intl,
    EkkloEdit edit,
  ) {
    final planned = edit.planned;
    final to = _amount(intl, planned);
    return switch ((edit, _foodName(planned))) {
      (NotInEkkloYet(), _) => (intl.editNotInEkklo, intl.editNextSend(to)),
      (_, null) => null,
      (AlreadyInEkklo(), final name?) => (
        intl.addEkkloFood(name, to),
        intl.editEkkloAlready,
      ),
      (QuantityInPlace(:final from, :final link), final name?) => (
        intl.editEkkloAmount(name, _itemAmount(intl, from, link), to),
        intl.editEkkloQuantity,
      ),
      (MealMove(:final from), final name?) => (
        intl.addEkkloFood(name, to),
        intl.editEkkloMeal(from, planned.ekkloMealName),
      ),
      (DayMove(from: final day, to: final newDay), final name?) => (
        intl.addEkkloFood(name, to),
        intl.editEkkloDay(day, newDay),
      ),
      (Replaced(before: final before?), final name?) => (
        intl.editEkkloReplaced(before, name, to),
        AddText.ekkloSummary(intl, planned).$2,
      ),
      (Replaced(before: null), final name?) => (
        intl.editEkkloReplacedUnnamed(name, to),
        AddText.ekkloSummary(intl, planned).$2,
      ),
    };
  }

  static String? _foodName(PlannedEntry planned) => switch (planned.choice) {
    SendToEkkloFood(:final ekkloFoodName) => ekkloFoodName,
    SendAsOwnCopy(reuse: OwnCopy(:final ekkloFoodName)) => ekkloFoodName,
    SendAsOwnCopy() || SkipEntry() => null,
  };

  static String? readOnly(AppLocalizations intl, ReadProblem? problem) =>
      switch (problem) {
        ReadProblem.offline => intl.editOffline,
        ReadProblem.mfpSessionExpired => intl.editMfpSessionExpired,
        ReadProblem.ekkloSessionExpired => intl.editEkkloSessionExpired,
        ReadProblem.mfpUnavailable ||
        ReadProblem.ekkloUnavailable ||
        ReadProblem.unknown ||
        null => null,
      };

  static String _amount(AppLocalizations intl, PlannedEntry planned) =>
      switch ((planned.choice, entryGrams(planned.entry))) {
        (SendToEkkloFood(:final grams), _) => SendText.grams(intl, grams),
        (_, final grams?) => SendText.grams(intl, grams),
        (_, null) => EntryText.serving(intl, planned.entry),
      };

  static String _itemAmount(
    AppLocalizations intl,
    EkkloDailyMealItem item,
    SentLink link,
  ) => switch (item.quantityType == EkkloQuantityType.grams) {
    true => SendText.grams(intl, item.quantity),
    false => EntryText.linkServing(intl, link),
  };
}
