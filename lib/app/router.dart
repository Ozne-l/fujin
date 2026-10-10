import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/domain/accounts/connected_accounts.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_page.dart';
import 'package:fujin/pages/journal/journal_page.dart';
import 'package:fujin/pages/journal/selected_day.dart';
import 'package:fujin/pages/memory/memory_food_page.dart';
import 'package:fujin/pages/memory/memory_page.dart';
import 'package:fujin/pages/mfp_sign_in/mfp_sign_in_page.dart';
import 'package:fujin/pages/sending/send_page.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';
import 'package:fujin/pages/tabs/tab_shell.dart';
import 'package:fujin/pages/welcome/welcome_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: FujinRoute.journal.path,
    routes: [
      StatefulShellRoute.indexedStack(
        redirect: (context, state) async =>
            switch (await ref.read(accountsServiceProvider).read()) {
              ConnectedAccounts(both: true) => null,
              ConnectedAccounts() => FujinRoute.welcome.path,
            },
        builder: (context, state, navigationShell) =>
            TabShell(navigationShell: navigationShell),
        branches: [
          for (final tab in FujinTab.values)
            StatefulShellBranch(
              routes: switch (tab) {
                FujinTab.journal => [
                  GoRoute(
                    path: FujinRoute.journal.path,
                    builder: (context, state) => const JournalPage(),
                  ),
                ],
                FujinTab.memory => [
                  GoRoute(
                    path: FujinRoute.memory.path,
                    builder: (context, state) => const MemoryPage(),
                  ),
                  GoRoute(
                    path: FujinRoute.memoryFood.path,
                    builder: (context, state) => switch (state
                        .pathParameters[FujinRoute.foodParameter]) {
                      final food? => MemoryFoodPage(
                        mfpFoodId: food,
                        mfpUnit:
                            state.uri.queryParameters[FujinRoute.unitParameter],
                      ),
                      null => throw StateError(
                        '${FujinRoute.memoryFood.path} needs '
                        '${FujinRoute.foodParameter}',
                      ),
                    },
                  ),
                ],
              },
            ),
        ],
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
