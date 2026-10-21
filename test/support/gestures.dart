import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart' show WidgetTester;

const _slideSteps = 8;

Future<void> slide(WidgetTester tester, Offset from, Offset to) async {
  final finger = await tester.startGesture(from);
  for (var step = 1; step <= _slideSteps; step++) {
    await finger.moveTo(Offset.lerp(from, to, step / _slideSteps) ?? to);
    await tester.pump();
  }
  await finger.up();
}
