import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/chat/marked_read.dart';

EkkloMessage keepingRead(
  EkkloMessage incoming, {
  required EkkloMessage? cached,
}) => switch ((incoming.readByOther, cached?.readByOther)) {
  (false, true) => markedRead(incoming),
  _ => incoming,
};
