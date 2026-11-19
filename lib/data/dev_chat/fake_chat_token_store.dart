import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/data/dev_chat/fake_chat.dart';

final class FakeChatTokenStore implements EkkloTokenStore {
  const FakeChatTokenStore();

  @override
  Future<EkkloTokens?> read() async => FakeChat.ownerTokens;

  @override
  Future<void> write(EkkloTokens tokens) async {}

  @override
  Future<void> clear() async {}
}
