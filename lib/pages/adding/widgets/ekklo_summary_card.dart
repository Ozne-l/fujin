import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/adding/ekklo_side.dart';
import 'package:fujin/domain/journal/read_problem.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/adding/add_text.dart';
import 'package:fujin/pages/common/breeze_indicator.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';
import 'package:fujin/pages/journal/journal_text.dart';

class EkkloSummaryCard extends StatelessWidget {
  const EkkloSummaryCard({
    required this.planned,
    required this.problem,
    required this.onTap,
    required this.onRetry,
    required this.onSignIn,
    super.key,
  });

  final PlannedEntry? planned;
  final ReadProblem? problem;
  final VoidCallback onTap;
  final VoidCallback onRetry;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final side = switch (planned) {
      final planned? => EkkloSide.of(planned),
      null => null,
    };
    final toChoose = side == EkkloSide.toChoose;
    final (icon, iconColor, iconBackground) = switch (side) {
      EkkloSide.willBeCreated => (
        Icons.copy_all_outlined,
        context.colors.sourceEkkloText,
        context.colors.sourceEkkloBackground,
      ),
      EkkloSide.toChoose => (
        Icons.help_outline,
        context.colors.textPrimary,
        context.colors.backgroundCard,
      ),
      EkkloSide.remembered ||
      EkkloSide.foundAutomatically ||
      EkkloSide.chosen ||
      null => (
        Icons.bookmark_border,
        context.colors.sourceEkkloText,
        context.colors.sourceEkkloBackground,
      ),
    };
    final (tileColor, tile) = switch (planned ?? problem) {
      null => (
        context.colors.backgroundInfo,
        const BreezeIndicator(
          streaks: BreezeStreaks.searching,
          drifting: true,
        ),
      ),
      _ => (
        iconBackground,
        Icon(icon, size: FujinSize.searchIcon, color: iconColor),
      ),
    };
    final (title, detail) = switch ((planned, problem)) {
      (final planned?, _) => AddText.ekkloSummary(context.intl, planned),
      (null, final problem?) => (
        JournalText.problemHeadline(context.intl, problem),
        switch (problem) {
          ReadProblem.ekkloSessionExpired => context.intl.ekkloReconnect,
          ReadProblem.offline ||
          ReadProblem.mfpSessionExpired ||
          ReadProblem.mfpUnavailable ||
          ReadProblem.ekkloUnavailable ||
          ReadProblem.unknown => context.intl.tryAgain,
        },
      ),
      (null, null) => (context.intl.rowSearching, ''),
    };
    final detailColor = switch (side) {
      EkkloSide.remembered ||
      EkkloSide.foundAutomatically ||
      EkkloSide.chosen => context.colors.textLink,
      EkkloSide.willBeCreated => context.colors.sourceEkkloText,
      EkkloSide.toChoose => context.colors.textGold,
      null => context.colors.textSecondary,
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(FujinRadius.card),
      side: BorderSide(
        color: switch (toChoose) {
          true => context.colors.borderWarning,
          false => context.colors.borderCard,
        },
      ),
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
      child: Material(
        color: switch (toChoose) {
          true => context.colors.backgroundHighlight,
          false => context.colors.backgroundCard,
        },
        shape: shape,
        child: InkWell(
          customBorder: shape,
          onTap: switch ((planned, problem)) {
            (_?, _) => onTap,
            (null, ReadProblem.ekkloSessionExpired) => onSignIn,
            (null, _?) => onRetry,
            (null, null) => null,
          },
          child: Padding(
            padding: const EdgeInsets.all(FujinSpace.s4),
            child: Row(
              spacing: FujinSpace.s3,
              children: [
                CircleAvatar(
                  radius: FujinSize.tile / 2,
                  backgroundColor: tileColor,
                  child: tile,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: FujinSpace.s1,
                    children: [
                      Text(
                        title,
                        style: FujinText.inter15Medium.copyWith(
                          color: context.colors.textPrimary,
                        ),
                      ),
                      if (detail.isNotEmpty)
                        Text(
                          detail,
                          style: FujinText.inter13Regular.copyWith(
                            color: detailColor,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  size: FujinSize.rowChevron,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
