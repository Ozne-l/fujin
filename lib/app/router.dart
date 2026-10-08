import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/pages/ekklo_sign_in/ekklo_sign_in_page.dart';
import 'package:fujin/pages/journal/journal_page.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final router = GoRouter(
    initialLocation: FujinRoute.journal.path,
    routes: [
      GoRoute(
        path: FujinRoute.journal.path,
        builder: (context, state) => const JournalPage(),
      ),
      GoRoute(
        path: FujinRoute.ekkloSignIn.path,
        builder: (context, state) => const EkkloSignInPage(),
      ),
    ],
  );
  ref.onDispose(router.dispose);
  return router;
});
