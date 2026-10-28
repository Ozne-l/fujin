import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/comparison/entry_status_link.dart';
import 'package:fujin/domain/comparison/placement.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/send_choice.dart';

sealed class EkkloEdit {
  const EkkloEdit(this.planned);

  final PlannedEntry planned;

  static EkkloEdit of({
    required ComparedEntry original,
    required PlannedEntry planned,
    required List<EkkloDailyMeal> ekkloMeals,
    required bool changed,
  }) {
    final link = original.status.sentLink;
    final placement = switch (link) {
      final link? => placementsOf(ekkloMeals)[link.ekkloItemId],
      null => null,
    };
    return switch ((original.status, link, placement)) {
      (ToSend(), _, _) || (_, null, _) || (_, _, null) => NotInEkkloYet(
        planned,
      ),
      (InEkklo(), _, _) when !changed => AlreadyInEkklo(planned),
      (_, final SentLink link, (:final meal, :final item)) => switch ((
        sameDay(original.entry.date, planned.entry.date),
        _targetFood(planned),
      )) {
        (false, _) => DayMove(
          planned,
          from: original.entry.date,
          to: planned.entry.date,
        ),
        (true, final target?) when target != item.foodId => Replaced(
          planned,
          before: item.food?.name,
        ),
        (true, _) when meal.name != planned.ekkloMealName => MealMove(
          planned,
          from: meal.name,
        ),
        (true, _) => QuantityInPlace(planned, from: item, link: link),
      },
    };
  }

  static String? _targetFood(PlannedEntry planned) => switch (planned.choice) {
    SendToEkkloFood(:final ekkloFoodId) => ekkloFoodId,
    SendAsOwnCopy(reuse: OwnCopy(:final ekkloFoodId)) => ekkloFoodId,
    SendAsOwnCopy() || SkipEntry() => null,
  };
}

final class AlreadyInEkklo extends EkkloEdit {
  const AlreadyInEkklo(super.planned);
}

final class QuantityInPlace extends EkkloEdit {
  const QuantityInPlace(
    super.planned, {
    required this.from,
    required this.link,
  });

  final EkkloDailyMealItem from;
  final SentLink link;
}

final class MealMove extends EkkloEdit {
  const MealMove(super.planned, {required this.from});

  final String from;
}

final class DayMove extends EkkloEdit {
  const DayMove(super.planned, {required this.from, required this.to});

  final DateTime from;
  final DateTime to;
}

final class NotInEkkloYet extends EkkloEdit {
  const NotInEkkloYet(super.planned);
}

final class Replaced extends EkkloEdit {
  const Replaced(super.planned, {required this.before});

  final String? before;
}
