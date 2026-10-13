import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/check_icon.dart';

enum SnackBarGlyph {
  done(CheckIcon.asset, FujinColor.fujin),
  undone('assets/icons/undo.svg', FujinColor.fujin),
  alert('assets/icons/alert.svg', FujinColor.shu),
  refresh('assets/icons/refresh.svg', FujinColor.fujin);

  const SnackBarGlyph(this.asset, this.background);

  final String asset;
  final Color background;
}
