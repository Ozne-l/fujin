import 'package:fujin/data/connectors/role.dart';
import 'package:fujin/data/database/id_source.dart';
import 'package:fujin/data/entries/stored_day.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/unattended/unattended_item.dart';
import 'package:fujin/domain/comparison/adopt_waiting.dart';
import 'package:fujin/domain/comparison/compare_mfp_day.dart';
import 'package:fujin/domain/comparison/day_draft.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

DayDraft draftMfpDay({
  required DateTime date,
  required StoredDay stored,
  required List<MfpFoodEntry> diary,
  required List<SentLink> waitingLinks,
  required List<UnattendedItem> waitingUnattended,
  required Food? Function(String mfpFoodId) foodOf,
  required String? Function(String mfpMealName) mealOf,
  required DateTime now,
  required DateTime diaryReadAt,
  required IdSource ids,
  required Role role,
}) => compareMfpDay(
  adoptWaiting(
    DayDraft.of(stored, date: date),
    diary: diary,
    links: waitingLinks,
    unattended: waitingUnattended,
    foodOf: foodOf,
    mealOf: mealOf,
    now: now,
    ids: ids,
    role: role,
  ),
  diary: diary,
  foodOf: foodOf,
  mealOf: mealOf,
  now: now,
  readAt: diaryReadAt,
  ids: ids,
  role: role,
);
