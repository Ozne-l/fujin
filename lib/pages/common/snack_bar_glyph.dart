import 'dart:ui';

import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/pages/common/alert_icon.dart';
import 'package:fujin/pages/common/check_icon.dart';
import 'package:fujin/pages/common/refresh_icon.dart';

enum SnackBarGlyph {
  done(CheckIcon.asset),
  undone('assets/icons/undo.svg'),
  alert(AlertIcon.asset),
  refresh(RefreshIcon.asset);

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
