import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';
import 'package:fujin/pages/sending/send_failure.dart';

part 'ekklo_search_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class EkkloSearchState with EkkloSearchStateMappable {
  const EkkloSearchState(this.query);

  final String query;
}

@MappableClass(discriminatorValue: 'running')
final class EkkloSearchRunning extends EkkloSearchState
    with EkkloSearchRunningMappable {
  const EkkloSearchRunning(super.query);
}

@MappableClass(discriminatorValue: 'done')
final class EkkloSearchDone extends EkkloSearchState
    with EkkloSearchDoneMappable {
  const EkkloSearchDone(super.query, this.results);

  final List<EkkloCandidate> results;
}

@MappableClass(discriminatorValue: 'failed')
final class EkkloSearchFailed extends EkkloSearchState
    with EkkloSearchFailedMappable {
  const EkkloSearchFailed(super.query, this.failure);

  final SendFailure failure;
}
