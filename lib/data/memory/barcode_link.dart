import 'package:dart_mappable/dart_mappable.dart';

part 'barcode_link.mapper.dart';

@MappableClass()
final class BarcodeLink with BarcodeLinkMappable {
  const BarcodeLink({required this.barcode, required this.mfpFoodId});

  final String barcode;
  final String mfpFoodId;
}
