import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/journal/read_problem.dart';

part 'delete_outcome.mapper.dart';

@MappableClass(discriminatorKey: 'outcome')
sealed class DeleteOutcome with DeleteOutcomeMappable {
  const DeleteOutcome();
}

@MappableClass(discriminatorValue: 'deleted')
final class MessageDeleted extends DeleteOutcome with MessageDeletedMappable {
  const MessageDeleted();
}

@MappableClass(discriminatorValue: 'kept_by_ekklo')
final class KeptByEkklo extends DeleteOutcome with KeptByEkkloMappable {
  const KeptByEkklo();
}

@MappableClass(discriminatorValue: 'not_deleted')
final class NotDeleted extends DeleteOutcome with NotDeletedMappable {
  const NotDeleted(this.problem);

  final ReadProblem problem;
}
