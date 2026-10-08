import 'package:dart_mappable/dart_mappable.dart';
import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/sending/name_match.dart';
import 'package:fujin/domain/sending/nutrient_deltas.dart';

part 'ekklo_candidate.mapper.dart';

@MappableClass()
final class EkkloCandidate with EkkloCandidateMappable {
  const EkkloCandidate({
    required this.food,
    required this.grams,
    required this.gramsInferred,
    required this.deltas,
    required this.nameMatch,
  });

  final EkkloFood food;
  final double grams;
  final bool gramsInferred;
  final NutrientDeltas deltas;
  final NameMatch nameMatch;

  bool get acceptable => nameMatch != NameMatch.none && deltas.withinTolerance;
}
