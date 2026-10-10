import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fujin/app/config.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/app/splash_app.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:fujin/data/hints/hint_repository.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final environment = Config.environment;
  runApp(SplashApp(environment: environment));
  final directory = await getApplicationSupportDirectory();
  final database = FujinDatabase.open(
    '${directory.path}/${FujinDatabase.fileName}',
  );
  final userAgent = await InAppWebViewController.getDefaultUserAgent();
  final package = await PackageInfo.fromPlatform();
  final preferences = await HintRepository.openPreferences();
  runApp(
    ProviderScope(
      overrides: [
        appEnvironmentProvider.overrideWithValue(environment),
        databaseProvider.overrideWithValue(database),
        mfpUserAgentProvider.overrideWithValue(userAgent),
        appVersionProvider.overrideWithValue(package.version),
        preferencesProvider.overrideWithValue(preferences),
      ],
      child: const FujinApp(),
    ),
  );
}
