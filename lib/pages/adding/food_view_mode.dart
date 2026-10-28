import 'package:flutter/foundation.dart';
import 'package:fujin/domain/adding/added_food.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/editing/edit_outcome.dart';

sealed class FoodViewMode {
  const FoodViewMode();
}

final class AddingFood extends FoodViewMode {
  const AddingFood({required this.onLeave, this.barcodeToLink});

  final ValueChanged<AddedFood> onLeave;
  final String? barcodeToLink;
}

final class EditingFood extends FoodViewMode {
  const EditingFood({
    required this.entryId,
    required this.original,
    required this.newVersion,
    required this.onLeave,
  });

  final String entryId;
  final ComparedEntry original;
  final bool newVersion;
  final ValueChanged<EditOutcome> onLeave;
}
