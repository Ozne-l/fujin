import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test_driver.dart';

Future<void> main() => integrationDriver(
  responseDataCallback: (data) async {
    for (final MapEntry(:key, :value) in (data ?? const {}).entries) {
      await TimelineSummary.summarize(
        Timeline.fromJson(value as Map<String, dynamic>),
      ).writeTimelineToFile(key, pretty: true);
    }
  },
);
