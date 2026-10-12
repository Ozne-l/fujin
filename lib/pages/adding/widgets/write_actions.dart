import 'package:flutter/foundation.dart';
import 'package:fujin/app/fujin_route.dart';

typedef WriteActions = ({
  VoidCallback retry,
  VoidCallback retryEkklo,
  VoidCallback undo,
  VoidCallback dismiss,
  ValueChanged<FujinRoute> signIn,
});
