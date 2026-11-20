import 'package:flutter_test/flutter_test.dart' show TestFailure;

const _patience = 2000;
const _settle = Duration(milliseconds: 1);

Future<T> until<T>(T? Function() read, bool Function(T value) test) async {
  for (var turn = 0; turn < _patience; turn++) {
    if (read() case final value? when test(value)) return value;
    await Future<void>.delayed(_settle);
  }
  throw TestFailure('never reached, last: ${read()}');
}
