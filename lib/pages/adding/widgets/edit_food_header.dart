import 'package:flutter/material.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/flow_header.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class EditFoodHeader extends StatelessWidget {
  const EditFoodHeader({required this.entry, required this.onBack, super.key});

  final MfpFoodEntry entry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return FlowHeader(
      title: context.intl.editFoodTitle,
      subtitle: context.intl.editFoodSubtitle(entry.mealName, entry.date),
      onBack: onBack,
    );
  }
}
