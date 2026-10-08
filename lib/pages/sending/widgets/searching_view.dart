import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/sending/widgets/plan_row.dart';
import 'package:fujin/pages/sending/widgets/progress_card.dart';
import 'package:fujin/pages/sending/widgets/send_header.dart';

class SearchingView extends StatelessWidget {
  const SearchingView({required this.plan, super.key});

  final SendPlan plan;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = [
      for (final planned in plan.entries) PlanRow.planned(planned),
      for (final (index, entry) in plan.pending.indexed)
        PlanRow.pending(entry, searching: index == 0),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SendHeader(plan: plan),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: FujinSpace.s4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: FujinSpace.s4,
              children: [
                ProgressCard(
                  title: l10n.searchingTitle,
                  detail: l10n.searchingDetail,
                  note: l10n.searchingNote,
                  done: plan.entries.length,
                  total: plan.total,
                ),
                if (rows.isNotEmpty) PlanRow.card(rows),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(
            FujinSize.screenMargin,
            0,
            FujinSize.screenMargin,
            FujinSpace.s2,
          ),
          child: FilledButton(onPressed: null, child: Text(l10n.sendToEkklo)),
        ),
      ],
    );
  }
}
