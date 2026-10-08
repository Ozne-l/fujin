import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/memory/remembered_food.dart';
import 'package:fujin/domain/sending/unit_weight.dart';

part 'send_choice.mapper.dart';

@MappableClass(discriminatorKey: 'choice')
sealed class SendChoice with SendChoiceMappable {
  const SendChoice();
}

@MappableClass(discriminatorValue: 'ekklo_food')
final class SendToEkkloFood extends SendChoice with SendToEkkloFoodMappable {
  const SendToEkkloFood({
    required this.ekkloFoodId,
    required this.ekkloFoodName,
    required this.grams,
    required this.remembered,
    this.weight = UnitWeight.notNeeded,
    this.gramsPerUnit,
    this.food,
  });

  final String ekkloFoodId;
  final String ekkloFoodName;
  final double grams;
  final bool remembered;
  final UnitWeight weight;
  final double? gramsPerUnit;
  final EkkloFood? food;
}

@MappableClass(discriminatorValue: 'own_copy')
final class SendAsOwnCopy extends SendChoice with SendAsOwnCopyMappable {
  const SendAsOwnCopy({this.reuse});

  final OwnCopy? reuse;
}

@MappableClass(discriminatorValue: 'skip')
final class SkipEntry extends SendChoice with SkipEntryMappable {
  const SkipEntry();
}
