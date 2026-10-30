import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/unattended/unattended_item.dart';
import 'package:fujin/domain/comparison/adopt_waiting.dart';
import 'package:fujin/domain/comparison/compare_ekklo_day.dart';
import 'package:fujin/domain/comparison/compare_mfp_day.dart';
import 'package:fujin/domain/comparison/day_comparison.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

DayComparison compareDay({
  required DateTime date,
  required StoredDay stored,
  required List<MfpFoodEntry> diary,
  required List<EkkloDailyMeal> meals,
  required List<SentLink> waitingLinks,
  required List<UnattendedItem> waitingUnattended,
  required Memory memory,
  required Food? Function(String mfpFoodId) foodOf,
  required String? Function(String mfpMealName) mealOf,
  required DateTime now,
  required DateTime diaryReadAt,
  required IdSource ids,
}) => compareEkkloDay(
  compareMfpDay(
    adoptWaiting(
      DayDraft.of(stored, date: date),
      diary: diary,
      links: waitingLinks,
      unattended: waitingUnattended,
      foodOf: foodOf,
      mealOf: mealOf,
      now: now,
      ids: ids,
    ),
    diary: diary,
    foodOf: foodOf,
    mealOf: mealOf,
    now: now,
    readAt: diaryReadAt,
    ids: ids,
  ),
  meals: meals,
  memory: memory,
  now: now,
  ids: ids,
);
