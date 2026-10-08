import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_theme.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_plan.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/sending/widgets/send_footer.dart';
import 'package:fujin/pages/sending/widgets/send_header.dart';
import 'package:fujin/pages/sending/widgets/storm_card.dart';
import 'package:go_router/go_router.dart';

class StormView extends StatelessWidget {
  const StormView({
    required this.plan,
    required this.card,
    this.children = const [],
    super.key,
  });

  final SendPlan plan;
  final StormCard card;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      SendHeader(plan: plan),
      Expanded(
        child: ListView(
          padding: const EdgeInsets.only(bottom: FujinSpace.s6),
          children: [card, ...children],
        ),
      ),
      SendFooter(
        child: OutlinedButton(
          style: FujinTheme.largeOutlinedButtonStyle,
          onPressed: context.pop,
          child: Text(AppLocalizations.of(context).later),
        ),
      ),
    ],
  );
}
