import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';

enum SnackBarGlyph {
  done('assets/icons/check.svg', FujinColor.fujin),
  undone('assets/icons/undo.svg', FujinColor.fujin),
  alert('assets/icons/alert.svg', FujinColor.shu),
  refresh('assets/icons/refresh.svg', FujinColor.fujin);

  const SnackBarGlyph(this.asset, this.background);

  final String asset;
  final Color background;
}
