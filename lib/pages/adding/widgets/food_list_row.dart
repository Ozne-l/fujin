import 'package:flutter/foundation.dart';

typedef FoodListRow = ({
  String title,
  String detail,
  bool verified,
  String? energy,
  VoidCallback onTap,
});
