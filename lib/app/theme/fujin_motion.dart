import 'package:flutter/animation.dart';
import 'package:motor/motor.dart';

abstract final class FujinMotion {
  static const Motion progress = MaterialSpringMotion.standardSpatialDefault();
  static const Motion drift = LinearMotion(Duration(milliseconds: 2800));
  static const CurvedMotion weekTurn = CurvedMotion(
    Duration(milliseconds: 350),
    Curves.easeOutCubic,
  );
}
