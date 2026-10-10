import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/accounts/account.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class AccountsService {
  const AccountsService({
    required this._mfp,
    required this._ekklo,
    required this._clearWebCookies,
  });

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;
  final Future<void> Function() _clearWebCookies;

  Future<ConnectedAccounts> read() async => ConnectedAccounts(
    mfp: await _mfp.isSignedIn,
    ekklo: await _ekklo.isSignedIn,
  );

  Future<void> signOut(Account account) async {
    switch (account) {
      case Account.mfp:
        await _mfp.clearLocalSession();
        await _clearWebCookies();
      case Account.ekklo:
        await _ekklo.clearLocalSession();
    }
  }

  Future<void> clearSessions() async {
    for (final account in Account.values) {
      await signOut(account);
    }
  }
}
