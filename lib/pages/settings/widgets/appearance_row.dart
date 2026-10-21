import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_motion.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/settings/appearance.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_segments.dart';

class AppearanceRow extends StatelessWidget {
  const AppearanceRow({
    required this.appearance,
    required this.onChoose,
    super.key,
  });

  final Appearance appearance;
  final void Function(Appearance appearance, BuildContext origin) onChoose;

  static String _label(AppLocalizations intl, Appearance appearance) =>
      switch (appearance) {
        Appearance.system => intl.appearanceSystem,
        Appearance.light => intl.appearanceLight,
        Appearance.dark => intl.appearanceDark,
      };

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.fromSTEB(
      FujinSpace.s5,
      FujinSpace.s3 - FujinSegments.outset,
      FujinSpace.s5,
      FujinSpace.s3,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSize.controlNoteGap - FujinSegments.outset,
      children: [
        FujinSegments(
          position: appearance.index.toDouble(),
          motion: FujinMotion.tabSlide,
          labels: [
            for (final choice in Appearance.values)
              _label(context.intl, choice),
          ],
          onSelect: (index, segment) =>
              onChoose(Appearance.values[index], segment),
        ),
        Text(
          context.intl.appearanceDetail,
          style: FujinText.inter13Regular.copyWith(
            color: context.colors.textSecondary,
          ),
        ),
      ],
    ),
  );
}
