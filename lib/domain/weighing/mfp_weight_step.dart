import 'package:fujin/domain/weighing/kilograms.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

sealed class MfpWeightStep {
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

final class PostWeight extends MfpWeightStep {
  const PostWeight();
}

final class AdoptMeasurement extends MfpWeightStep {
  const AdoptMeasurement(this.measurementId);

  final String measurementId;
}

final class RemoveMeasurement extends MfpWeightStep {
  const RemoveMeasurement(this.measurementId);

  final String measurementId;
}
