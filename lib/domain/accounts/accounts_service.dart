import 'package:ekklo_client/ekklo_client.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

final class AccountsService {
  const AccountsService({required this._mfp, required this._ekklo});

  final MyFitnessPalClient _mfp;
  final EkkloClient _ekklo;

  Future<ConnectedAccounts> read() async => ConnectedAccounts(
    mfp: await _mfp.isSignedIn,
    ekklo: await _ekklo.isSignedIn,
  );
}
