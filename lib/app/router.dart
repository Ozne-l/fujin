import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_page.dart';
import 'package:fujin/pages/journal/journal_page.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_page.dart';
import 'package:fujin/pages/sending/send_page.dart';
import 'package:fujin/pages/welcome/welcome_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: FujinRoute.journal.path,
    routes: [
      GoRoute(
        path: FujinRoute.journal.path,
        redirect: (context, state) async =>
            switch (await ref.read(accountsServiceProvider).read()) {
              ConnectedAccounts(both: true) => null,
              ConnectedAccounts() => FujinRoute.welcome.path,
            },
        builder: (context, state) => const JournalPage(),
      ),
      GoRoute(
        path: FujinRoute.welcome.path,
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: FujinRoute.mfpSignIn.path,
        builder: (context, state) => const MfpSignInPage(),
      ),
      GoRoute(
        path: FujinRoute.ekkloSignIn.path,
        builder: (context, state) => const EkkloSignInPage(),
      ),
      GoRoute(
        path: FujinRoute.send.path,
        builder: (context, state) =>
            switch (state.pathParameters[FujinRoute.dateParameter]) {
              final date? => SendPage(
                date: SelectedDay.calendarDay(DateTime.parse(date)),
              ),
              null => throw StateError(
                '${FujinRoute.send.path} needs ${FujinRoute.dateParameter}',
              ),
            },
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
