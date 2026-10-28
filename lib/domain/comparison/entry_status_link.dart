import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/comparison/entry_status.dart';

extension EntryStatusLink on EntryStatus {
  SentLink? get sentLink => switch (this) {
    InEkklo(:final link) || ToUpdate(:final link) => link,
    ToSend() => null,
  };
}
