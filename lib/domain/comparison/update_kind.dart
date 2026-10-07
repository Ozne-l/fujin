import 'package:dart_mappable/dart_mappable.dart';

part 'update_kind.mapper.dart';

@MappableEnum()
enum UpdateKind { quantityOnly, mealChanged }
