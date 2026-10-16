import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/recents/recent_food.dart';

RecentFood? recentOf(RememberedFood food, List<RecentFood> recents) => recents
    .where(
      (recent) => switch (food) {
        MatchedFood(:final mfpFoodId) => recent.mfpFoodId == mfpFoodId,
        OwnCopy(:final mfpFoodId, :final mfpUnit) =>
          recent.mfpFoodId == mfpFoodId && recent.servingUnit == mfpUnit,
      },
    )
    .firstOrNull;
