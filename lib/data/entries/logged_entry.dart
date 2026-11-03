import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/data/entries/entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';

part 'logged_entry.mapper.dart';

@MappableClass()
final class LoggedEntry with LoggedEntryMappable {
  const LoggedEntry({
    required this.entry,
    required this.mealName,
    this.foodName,
    this.brand,
    this.mfpFoodId,
    this.mfpLink,
    this.ekkloLink,
  });

  final Entry entry;
  final String? foodName;
  final String? brand;
  final String? mfpFoodId;
  final String mealName;
  final MfpLink? mfpLink;
  final EkkloLink? ekkloLink;
}
