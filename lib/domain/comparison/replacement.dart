import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/data/entries/mfp_link.dart';

part 'replacement.mapper.dart';

@MappableClass(discriminatorKey: 'replaced')
sealed class Replacement with ReplacementMappable {
  const Replacement(this.logged);

  final LoggedEntry logged;
}

@MappableClass(discriminatorValue: 'edit')
final class ReplacedEdit extends Replacement with ReplacedEditMappable {
  const ReplacedEdit(super.logged, {required this.before});

  final MfpLink before;
}

@MappableClass(discriminatorValue: 'deletion')
final class ReplacedDeletion extends Replacement with ReplacedDeletionMappable {
  const ReplacedDeletion(super.logged);
}
