import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/tabs/fujin_tab.dart';

class MemoryEmptyView extends StatelessWidget {
  const MemoryEmptyView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSpace.s6),
      child: Column(
        spacing: FujinSpace.s3,
        children: [
          SvgPicture.asset(
            FujinTab.memory.icon,
            width: FujinSize.glyphHero,
            height: FujinSize.glyphHero,
            theme: const SvgTheme(currentColor: FujinColorRole.textPrimary),
            excludeFromSemantics: true,
          ),
          Text(
            l10n.memoryEmptyTitle,
            textAlign: TextAlign.center,
            style: FujinText.hina26.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
          Text(
            l10n.memoryEmptyDetail,
            textAlign: TextAlign.center,
            style: FujinText.inter15Regular.copyWith(
              color: FujinColorRole.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
