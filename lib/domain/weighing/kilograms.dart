import 'package:myfitnesspal_client/myfitnesspal_client.dart';

abstract final class Kilograms {
  static const _tenthsPerKilogram = 10;
  static const _tolerance = 0.05;
  static const _perPound = 0.45359237;
  static const lightest = 20;
  static const heaviest = 300;

  static double rounded(double kilograms) =>
      (kilograms * _tenthsPerKilogram).round() / _tenthsPerKilogram;

  static bool plausible(double kilograms) =>
      kilograms >= lightest && kilograms <= heaviest;

  static bool same(double a, double b) => (a - b).abs() < _tolerance;

  static double? of(MfpMeasurement measurement) =>
      switch (MfpWeightUnit.values.asNameMap()[measurement.unit]) {
        MfpWeightUnit.kilograms => measurement.value,
        MfpWeightUnit.pounds => measurement.value * _perPound,
        null => null,
      };
}
