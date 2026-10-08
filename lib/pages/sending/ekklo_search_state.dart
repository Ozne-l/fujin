import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/pages/sending/send_failure.dart';

part 'ekklo_search_state.mapper.dart';

@MappableClass()
final class EkkloSearchState with EkkloSearchStateMappable {
  const EkkloSearchState({required this.query, this.results, this.failure});

  final String query;
  final List<EkkloCandidate>? results;
  final SendFailure? failure;

  bool get searching => results == null && failure == null;
}
