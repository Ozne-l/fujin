import 'package:flutter/material.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/flow_header.dart';
import 'package:fujin/pages/common/title_text.dart';
import 'package:go_router/go_router.dart';

class SendHeader extends StatelessWidget {
  const SendHeader({required this.plan, this.closable = true, super.key});

  final SendPlan plan;
  final bool closable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return FlowHeader(
      title: l10n.sendTitle,
      subtitle: TitleText.capitalized(l10n.sendSubtitle(plan.date, plan.total)),
      closes: true,
      onBack: switch (closable) {
        true => context.pop,
        false => null,
      },
    );
  }
}
