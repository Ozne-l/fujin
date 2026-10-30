import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/entries/ekklo_link_hook.dart';
import 'package:fujin/data/entries/linked_item.dart';
import 'package:fujin/data/entries/unattended_expectation.dart';

part 'ekklo_link.mapper.dart';

@MappableClass(hook: EkkloLinkHook())
final class EkkloLink with EkkloLinkMappable {
  const EkkloLink({
    required this.id,
    required this.entryId,
    required this.updatedAt,
    this.item,
    this.unattended,
    this.deletedAt,
  });

  final String id;
  final String entryId;
  final LinkedItem? item;
  final UnattendedExpectation? unattended;
  final DateTime updatedAt;
  final DateTime? deletedAt;
}
