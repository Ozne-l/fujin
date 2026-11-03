import 'package:flutter/material.dart';
import 'package:fujin/data/entries/logged_entry.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/flow_header.dart';

class EditFoodHeader extends StatelessWidget {
  const EditFoodHeader({required this.entry, required this.onBack, super.key});

  final LoggedEntry entry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return FlowHeader(
      title: context.intl.editFoodTitle,
      subtitle: context.intl.editFoodSubtitle(entry.mealName, entry.entry.date),
      onBack: onBack,
    );
  }
}
