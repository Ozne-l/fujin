import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/check_icon.dart';

enum SnackBarGlyph {
  done(CheckIcon.asset),
  undone('assets/icons/undo.svg'),
  alert('assets/icons/alert.svg'),
  refresh('assets/icons/refresh.svg');

  const SnackBarGlyph(this.asset);

  final String asset;

  Color background(FujinColors colors) => switch (this) {
    done || undone || refresh => colors.backgroundAccent,
    alert => colors.buttonAlertBackground,
  };

  Color foreground(FujinColors colors) => switch (this) {
    done || undone || refresh => colors.textOnAccent,
    alert => colors.buttonAlertText,
  };
}
