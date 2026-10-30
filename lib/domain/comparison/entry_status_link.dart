import 'package:fujin/data/entries/ekklo_link.dart';
import 'package:fujin/domain/comparison/entry_status.dart';

extension EntryStatusLink on EntryStatus {
  EkkloLink? get ekkloLink => switch (this) {
    InEkklo(:final link) || ToUpdate(:final link) => link,
    ToSend() => null,
  };
}
