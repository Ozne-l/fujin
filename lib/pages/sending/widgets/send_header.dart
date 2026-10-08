import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/fujin_icon_button.dart';
import 'package:go_router/go_router.dart';

class SendHeader extends StatelessWidget {
  const SendHeader({required this.plan, this.closable = true, super.key});

  final SendPlan plan;
  final bool closable;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        FujinSize.screenMargin,
        FujinSpace.s2,
        FujinSize.screenMargin,
        FujinSpace.s4,
      ),
      child: Row(
        spacing: FujinSpace.s4,
        children: [
          if (closable)
            FujinIconButton(
              icon: Icons.close,
              tooltip: l10n.close,
              onPressed: context.pop,
            ),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                start: switch (closable) {
                  true => 0,
                  false => FujinSpace.s2,
                },
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: FujinSpace.s1,
                children: [
                  Text(
                    l10n.sendTitle,
                    style: FujinText.inter16Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                  Text(
                    EntryText.capitalized(
                      l10n.sendSubtitle(plan.date, plan.total),
                    ),
                    style: FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
