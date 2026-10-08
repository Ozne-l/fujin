import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final FutureProvider<ConnectedAccounts> connectedAccountsProvider =
    FutureProvider.autoDispose<ConnectedAccounts>(
      (ref) => ref.watch(accountsServiceProvider).read(),
    );
