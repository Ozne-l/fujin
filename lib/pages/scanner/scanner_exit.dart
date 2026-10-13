import 'package:dart_mappable/dart_mappable.dart';
import 'package:fujin/domain/adding/added_food.dart';

part 'scanner_exit.mapper.dart';

@MappableClass(discriminatorKey: 'exit')
sealed class ScannerExit with ScannerExitMappable {
  const ScannerExit();
}

@MappableClass(discriminatorValue: 'added')
final class ScannerAdded extends ScannerExit with ScannerAddedMappable {
  const ScannerAdded(this.added);

  final AddedFood added;
}

@MappableClass(discriminatorValue: 'search')
final class ScannerSearch extends ScannerExit with ScannerSearchMappable {
  const ScannerSearch({
    required this.query,
    this.barcode,
    this.unresolved = false,
  });

  static const _wordSeparator = ' ';

  final String query;
  final String? barcode;
  final bool unresolved;

  static String queryOf(String description, String? brandName) =>
      [description, ?brandName].join(_wordSeparator);
}
