import 'package:motor/motor.dart';

abstract final class FujinMotion {
  static const Motion progress = MaterialSpringMotion.standardSpatialDefault();
  static const Motion drift = LinearMotion(Duration(milliseconds: 2800));
}
