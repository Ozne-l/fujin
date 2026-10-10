import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/pages/splash/splash_view.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends HookWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    useEffect(() {
      unawaited(
        Future(() {
          if (context.mounted) context.go(FujinRoute.journal.path);
        }),
      );
      return null;
    }, const []);
    return const SplashView();
  }
}
