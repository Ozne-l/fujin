import 'package:dart_mappable/dart_mappable.dart';

part 'review_reason.mapper.dart';

@MappableEnum()
enum ReviewReason {
  weightToConfirm,
  newAssociation,
  noCloseFood,
  skipped,
  confirmed,
}
