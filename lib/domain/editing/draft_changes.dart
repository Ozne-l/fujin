import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/same_day.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

bool draftChanges(AddDraft draft, MfpFoodEntry original) =>
    draft.servingSize.unit != original.servingSize.unit ||
    draft.servingSize.value != original.servingSize.value ||
    draft.servings != original.servings ||
    draft.mfpMealName != original.mealName ||
    !sameDay(draft.date, original.date);
