import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum PillTone {
  validated(FujinRole.fondSucces, FujinRole.texteLien),
  attention(FujinColor.kinClair, FujinRole.texteOr),
  info(FujinRole.fondInfo, FujinColor.sora),
  error(FujinRole.fondAlerte, FujinRole.texteAlerte);

  const PillTone(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
