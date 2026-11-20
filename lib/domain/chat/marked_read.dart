import 'package:ekklo_client/ekklo_client.dart';

const _readByOtherKey = 'read_by_other';

EkkloMessage markedRead(EkkloMessage message) => message.copyWith(
  readByOther: true,
  receivedJson: {...message.receivedJson, _readByOtherKey: true},
);
