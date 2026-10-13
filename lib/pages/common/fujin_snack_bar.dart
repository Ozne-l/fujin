import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';

extension FujinSnackBar on ScaffoldMessengerState {
  void showFujinSnackBar(SnackBar snackBar) =>
      showSnackBar(snackBar, snackBarAnimationStyle: FujinMotion.snackBar);
}
