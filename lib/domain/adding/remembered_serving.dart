import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';
import 'package:fujin/domain/adding/recent_of.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

MfpServingSize? rememberedServing(
  MfpFood food, {
  required RememberedFood remembered,
  required Memory memory,
  required List<RecentFood> recents,
}) {
  final wanted = [
    ?recentOf(remembered, recents)?.servingUnit,
    if (remembered case OwnCopy(:final mfpUnit)) mfpUnit,
    for (final unit in memory.unitsOf(remembered)) unit.mfpUnit,
  ];
  return wanted
      .expand(
        (unit) => food.servingSizes.where((serving) => serving.unit == unit),
      )
      .firstOrNull;
}
