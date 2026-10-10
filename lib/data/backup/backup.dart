import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/goals/goals.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/data/memory/meal_mapping.dart';
import 'package:fujin/data/memory/memory.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/data/memory/remembered_unit.dart';

part 'backup.mapper.dart';

@MappableClass()
final class Backup with BackupMappable {
  const Backup({
    required this.exportedAt,
    required this.matches,
    required this.ownCopies,
    required this.units,
    required this.meals,
    required this.links,
    this.goals,
    this.format = formatName,
    this.version = currentVersion,
  });

  static const formatName = 'fujin-backup';
  static const currentVersion = 1;

  final String format;
  final int version;
  final DateTime exportedAt;
  final List<MatchedFood> matches;
  final List<OwnCopy> ownCopies;
  final List<RememberedUnit> units;
  final List<MealMapping> meals;
  final List<SentLink> links;
  final Goals? goals;

  Memory get memory => Memory(
    matches: matches,
    ownCopies: ownCopies,
    units: units,
    meals: meals,
  );

  int get foodCount => matches.length + ownCopies.length;
}
