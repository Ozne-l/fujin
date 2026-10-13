import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

part 'scanner_state.mapper.dart';

@MappableClass(discriminatorKey: 'state')
sealed class ScannerState with ScannerStateMappable {
  const ScannerState();
}

@MappableClass(discriminatorValue: 'aiming')
final class ScannerAiming extends ScannerState with ScannerAimingMappable {
  const ScannerAiming();
}

@MappableClass(discriminatorValue: 'refused')
final class ScannerRefused extends ScannerState with ScannerRefusedMappable {
  const ScannerRefused();
}

@MappableClass(discriminatorValue: 'typing')
final class ScannerTyping extends ScannerState with ScannerTypingMappable {
  const ScannerTyping(this.code);

  final String code;
}

@MappableClass(discriminatorValue: 'looking')
final class ScannerLooking extends ScannerState with ScannerLookingMappable {
  const ScannerLooking(this.code);

  final String code;
}

@MappableClass(discriminatorValue: 'found')
final class ScannerFound extends ScannerState with ScannerFoundMappable {
  const ScannerFound(this.code, this.food, {required this.remembered});

  final String code;
  final MfpFood food;
  final bool remembered;
}

@MappableClass(discriminatorValue: 'unknown')
final class ScannerUnknown extends ScannerState with ScannerUnknownMappable {
  const ScannerUnknown(this.code);

  final String code;
}

@MappableClass(discriminatorValue: 'unresolved')
final class ScannerUnresolved extends ScannerState
    with ScannerUnresolvedMappable {
  const ScannerUnresolved(
    this.code, {
    required this.description,
    required this.brandName,
  });

  final String code;
  final String description;
  final String? brandName;
}

@MappableClass(discriminatorValue: 'failed')
final class ScannerFailed extends ScannerState with ScannerFailedMappable {
  const ScannerFailed(this.code, this.problem);

  final String code;
  final ReadProblem problem;
}
