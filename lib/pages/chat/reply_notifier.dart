import 'package:ekklo_client/ekklo_client.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:hooks_riverpod/misc.dart';

final NotifierProviderFamily<ReplyNotifier, EkkloMessage?, String>
replyProvider = NotifierProvider.autoDispose
    .family<ReplyNotifier, EkkloMessage?, String>((_) => ReplyNotifier());

final class ReplyNotifier extends Notifier<EkkloMessage?> {
  @override
  EkkloMessage? build() => null;

  EkkloMessage? get message => state;

  set message(EkkloMessage? message) => state = message;

  void cancel() => state = null;
}
