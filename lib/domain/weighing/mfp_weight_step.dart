import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/weighing/kilograms.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'mfp_weight_step.mapper.dart';

@MappableClass(discriminatorKey: 'step')
sealed class MfpWeightStep with MfpWeightStepMappable {
  const MfpWeightStep();

  static MfpWeightStep next(double kilograms, List<MfpMeasurement> day) =>
      switch (day) {
        [] => const PostWeight(),
        [final first, ...] => switch (Kilograms.of(first)) {
          final held? when Kilograms.same(held, kilograms) => AdoptMeasurement(
            first.id,
          ),
          _ => RemoveMeasurement(first.id),
        },
      };
}

@MappableClass(discriminatorValue: 'post')
final class PostWeight extends MfpWeightStep with PostWeightMappable {
  const PostWeight();
}

@MappableClass(discriminatorValue: 'adopt')
final class AdoptMeasurement extends MfpWeightStep
    with AdoptMeasurementMappable {
  const AdoptMeasurement(this.measurementId);

  final String measurementId;
}

@MappableClass(discriminatorValue: 'remove')
final class RemoveMeasurement extends MfpWeightStep
    with RemoveMeasurementMappable {
  const RemoveMeasurement(this.measurementId);

  final String measurementId;
}
