import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/domain/adding/add_draft.dart';
import 'package:fujin/domain/journal/same_day.dart';

bool draftChanges(AddDraft draft, LoggedEntry original) =>
    draft.servingSize.unit != original.entry.servingUnit ||
    draft.servingSize.value != original.entry.servingValue ||
    draft.servings != original.entry.servings ||
    draft.mfpMealName != original.mealName ||
    !sameDay(draft.date, original.entry.date);
