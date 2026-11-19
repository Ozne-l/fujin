import 'dart:ui';

import 'package:dart_mappable/dart_mappable.dart';

part 'crop_aspect.mapper.dart';

@MappableEnum()
enum CropAspect {
  free(),
  original(),
  square(width: 1, height: 1),
  fourFive(width: 4, height: 5),
  sixteenNine(width: 16, height: 9),
  nineSixteen(width: 9, height: 16);

  const CropAspect({this.width, this.height});

  final int? width;
  final int? height;

  double? ratioIn(Size picture) => switch (this) {
    CropAspect.free => null,
    CropAspect.original => picture.width / picture.height,
    CropAspect(:final width?, :final height?) => width / height,
    CropAspect() => null,
  };
}
