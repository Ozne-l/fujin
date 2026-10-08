import 'package:fujin/data/database/calendar_date_hook.dart';

enum FujinRoute {
  journal('/'),
  welcome('/welcome'),
  mfpSignIn('/mfp-sign-in'),
  ekkloSignIn('/ekklo-sign-in'),
  send('/send/:${FujinRoute.dateParameter}');

  const FujinRoute(this.path);

  static const dateParameter = 'date';

  final String path;

  String forDate(DateTime date) =>
      path.replaceFirst(':$dateParameter', CalendarDateHook.format(date));
}
