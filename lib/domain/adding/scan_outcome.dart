import 'package:myfitnesspal_client/myfitnesspal_client.dart';

sealed class ScanOutcome {
  const ScanOutcome(this.barcode);

  final String barcode;
}

final class ScanFound extends ScanOutcome {
  const ScanFound(super.barcode, this.food, {required this.remembered});

  final MfpFood food;
  final bool remembered;
}

final class ScanUnresolved extends ScanOutcome {
  const ScanUnresolved(
    super.barcode, {
    required this.description,
    required this.brandName,
  });

  final String description;
  final String? brandName;
}

final class ScanUnknown extends ScanOutcome {
  const ScanUnknown(super.barcode);
}
