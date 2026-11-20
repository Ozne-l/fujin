import 'package:dart_mappable/dart_mappable.dart';

part 'foreground_stamp.mapper.dart';

@MappableClass()
final class ForegroundStamp with ForegroundStampMappable {
  const ForegroundStamp({required this.at, this.id = onlyRow});

  static const onlyRow = 1;

  final int id;
  final DateTime at;
}
