import 'package:ekklo_client/ekklo_client.dart';
import 'package:flutter/services.dart';
import 'package:fujin/app/app_environment.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class Config {
  static final AppEnvironment environment = AppEnvironment.fromFlavor(
    appFlavor,
  );
  static final Uri mfpWebUri = _uri(
    const String.fromEnvironment('MFP_WEB_URI'),
    MyFitnessPalClient.defaultWebUri,
  );
  static final Uri mfpApiUri = _uri(
    const String.fromEnvironment('MFP_API_URI'),
    MyFitnessPalClient.defaultApiUri,
  );
  static final Uri mfpSignInUri = mfpWebUri.resolve(_mfpSignInPath);
  static final Uri ekkloBaseUri = _uri(
    const String.fromEnvironment('EKKLO_BASE_URI'),
    EkkloClient.defaultBaseUri,
  );

  static const _mfpSignInPath = '/account/login';

  static Uri _uri(String defined, Uri fallback) => switch (defined) {
    '' => fallback,
    _ => Uri.parse(defined),
  };
}
