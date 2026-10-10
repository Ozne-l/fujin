import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/accounts/account.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final sessionsProvider = NotifierProvider<SessionsNotifier, void>(
  SessionsNotifier.new,
);

final class SessionsNotifier extends Notifier<void> {
  @override
  void build() {}

  Future<void> signOut(Account account) =>
      ref.read(accountsServiceProvider).signOut(account);

  Future<void> clearSessions() =>
      ref.read(accountsServiceProvider).clearSessions();
}
