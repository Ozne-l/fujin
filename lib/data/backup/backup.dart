import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/connectors/connector.dart';
import 'package:fujin/data/foods/food.dart';
import 'package:fujin/data/foods/food_barcode.dart';
import 'package:fujin/data/foods/food_reference.dart';
import 'package:fujin/data/foods/food_serving.dart';
import 'package:fujin/data/foods/food_unit.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/meals/connector_meal.dart';
import 'package:fujin/data/meals/meal.dart';
import 'package:fujin/data/memory/barcode_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

part 'backup.mapper.dart';

@MappableClass()
sealed class Backup with BackupMappable {
  const Backup({
    required this.exportedAt,
    required this.links,
    required this.version,
    this.goals,
    this.format = formatName,
  });

  static const formatName = 'fujin-backup';

  final String format;
  final int version;
  final DateTime exportedAt;
  final List<SentLink> links;
  final Goals? goals;

  int get foodCount;

  int get mealCount;
}

@MappableClass()
final class BackupV3 extends Backup with BackupV3Mappable {
  const BackupV3({
    required super.exportedAt,
    required super.links,
    required this.foods,
    required this.foodServings,
    required this.foodUnits,
    required this.foodReferences,
    required this.barcodeLinks,
    required this.meals,
    required this.mealMappings,
    super.goals,
    super.format = Backup.formatName,
    super.version = currentVersion,
  });

  static const currentVersion = 3;

  final List<Food> foods;
  final List<FoodServing> foodServings;
  final List<FoodUnit> foodUnits;
  final List<FoodReference> foodReferences;
  final List<FoodBarcode> barcodeLinks;
  final List<Meal> meals;
  final List<ConnectorMeal> mealMappings;

  @override
  int get foodCount => foodReferences
      .where(
        (reference) =>
            reference.deletedAt == null &&
            switch (reference) {
              MfpReference() => false,
              EkkloReference() || OwnCopyReference() => true,
            },
      )
      .length;

  @override
  int get mealCount => mealMappings
      .where(
        (mapping) =>
            mapping.deletedAt == null && mapping.connector == Connector.ekklo,
      )
      .length;
}

@MappableClass()
final class BackupV2 extends Backup with BackupV2Mappable {
  const BackupV2({
    required super.exportedAt,
    required super.links,
    required super.version,
    required this.matches,
    required this.ownCopies,
    required this.units,
    required this.meals,
    required this.barcodeLinks,
    super.goals,
    super.format = Backup.formatName,
  });

  final List<MatchedFood> matches;
  final List<OwnCopy> ownCopies;
  final List<RememberedUnit> units;
  final List<MealMapping> meals;
  final List<BarcodeLink> barcodeLinks;

  Memory get memory => Memory(
    matches: matches,
    ownCopies: ownCopies,
    units: units,
    meals: meals,
    barcodeLinks: barcodeLinks,
  );

  @override
  int get foodCount => matches.length + ownCopies.length;

  @override
  int get mealCount => meals.length;
}
