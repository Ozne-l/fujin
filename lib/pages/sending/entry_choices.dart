import 'package:flutter/foundation.dart';
import 'package:fujin/domain/sending/ekklo_candidate.dart';

typedef EntryChoices = ({
  ValueChanged<EkkloCandidate> choose,
  VoidCallback ownCopy,
  ValueChanged<double> weigh,
  VoidCallback? skip,
});
