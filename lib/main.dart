import 'package:flutter/widgets.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:fujin/app/fujin_app.dart';
import 'package:fujin/app/providers.dart';
import 'package:fujin/data/database/fujin_database.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final directory = await getApplicationSupportDirectory();
  final database = FujinDatabase.open(
    '${directory.path}/${FujinDatabase.fileName}',
  );
  final userAgent = await InAppWebViewController.getDefaultUserAgent();
  runApp(
    ProviderScope(
      overrides: [
        databaseProvider.overrideWithValue(database),
        mfpUserAgentProvider.overrideWithValue(userAgent),
      ],
      child: const FujinApp(),
    ),
  );
}
