import 'package:flutter/physics.dart';
import 'package:motor/motor.dart';

final class InstantMotion extends Motion {
  const InstantMotion();

  @override
  bool get needsSettle => false;

  @override
  bool get unboundedWillSettle => true;

  @override
  Simulation createSimulation({
    double start = 0,
    double end = 1,
    double velocity = 0,
  }) => _Arrived(end, tolerance);

  @override
  bool operator ==(Object other) => other is InstantMotion;

  @override
  int get hashCode => (InstantMotion).hashCode;
}

final class _Arrived extends Simulation {
  _Arrived(this._end, Tolerance tolerance) : super(tolerance: tolerance);

  final double _end;

  @override
  double x(double time) => _end;

  @override
  double dx(double time) => 0;

  @override
  bool isDone(double time) => true;
}
