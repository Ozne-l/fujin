import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/comparison/gram_unit.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

double entryUnits(MfpFoodEntry entry) =>
    entry.servingSize.value * entry.servings;

double? entryGrams(MfpFoodEntry entry, {double? gramsPerUnit}) =>
    switch ((isGramUnit(entry.servingSize.unit), gramsPerUnit)) {
      (true, _) => entryUnits(entry),
      (false, final perUnit?) => entryUnits(entry) * perUnit,
      (false, null) => null,
    };

EkkloQuantityType ownCopyQuantityType(String mfpUnit) =>
    switch (isGramUnit(mfpUnit)) {
      true => EkkloQuantityType.grams,
      false => EkkloQuantityType.portion,
    };
