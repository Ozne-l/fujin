import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/comparison/update_kind.dart';

part 'entry_status.mapper.dart';

@MappableClass(discriminatorKey: 'status')
sealed class EntryStatus with EntryStatusMappable {
  const EntryStatus();
}

@MappableClass(discriminatorValue: 'in_ekklo')
final class InEkklo extends EntryStatus with InEkkloMappable {
  const InEkklo(this.link);

  final SentLink link;
}

@MappableClass(discriminatorValue: 'to_send')
final class ToSend extends EntryStatus with ToSendMappable {
  const ToSend();
}

@MappableClass(discriminatorValue: 'to_update')
final class ToUpdate extends EntryStatus with ToUpdateMappable {
  const ToUpdate(this.link, this.kind);

  final SentLink link;
  final UpdateKind kind;
}
