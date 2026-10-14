import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fujin/app/fujin_route.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/domain/sending/review_reason.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/l10n/intl_context.dart';
import 'package:fujin/pages/common/fujin_snack_bar.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/common/text_inset.dart';
import 'package:fujin/pages/sending/entry_choices.dart';
import 'package:fujin/pages/sending/kept_choices_notifier.dart';
import 'package:fujin/pages/sending/send_failure.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:fujin/pages/sending/sheets/match_sheet.dart';
import 'package:fujin/pages/sending/sheets/own_copy_sheet.dart';
import 'package:fujin/pages/sending/sheets/weight_sheet.dart';
import 'package:fujin/pages/sending/widgets/sent_frame.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class AutomaticSentView extends ConsumerWidget {
  const AutomaticSentView({required this.report, super.key});

  final SendReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final choices = ref.watch(keptChoicesProvider(report.date));
    final note = FujinText.inter12Regular.copyWith(
      color: FujinColorRole.textSecondary,
    );
    return SentFrame(
      report: report,
      note: context.intl.automaticSentNote,
      children: [
        if (report.unattended case final unattended
            when unattended.isNotEmpty) ...[
          TextInset(
            top: FujinSpace.s4,
            bottom: FujinSpace.s2,
            child: Text(
              context.intl.unattendedChoices(unattended.length),
              style: FujinText.inter12Medium.copyWith(
                color: FujinColorRole.textSecondary,
              ),
            ),
          ),
          SentFrame.card([
            for (final planned in unattended)
              _ChoiceRow(
                key: ValueKey(planned.entryId),
                sent: planned,
                kept: choices.kept[planned.entryId],
                keeping: choices.keeping.contains(planned.entryId),
              ),
          ]),
          TextInset(
            top: FujinSpace.s4,
            child: Text(context.intl.unattendedNote, style: note),
          ),
        ],
      ],
    );
  }
}

class _ChoiceRow extends ConsumerWidget {
  const _ChoiceRow({
    required this.sent,
    required this.kept,
    required this.keeping,
    super.key,
  });

  final PlannedEntry sent;
  final PlannedEntry? kept;
  final bool keeping;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
      child: Row(
        spacing: FujinSpace.s3,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: FujinSpace.s1,
              children: [
                Text(
                  sent.entry.food.description,
                  style: FujinText.inter15Medium.copyWith(
                    color: FujinColorRole.textPrimary,
                  ),
                ),
                Text(
                  switch (kept) {
                    final kept? => SendText.kept(context.intl, kept),
                    null => SendText.unattended(context.intl, sent),
                  },
                  style: FujinText.inter13Regular.copyWith(
                    color: FujinColorRole.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          switch (kept) {
            _? => StatusPill(
              label: context.intl.pillRemembered,
              tone: PillTone.validated,
            ),
            null => Semantics(
              button: true,
              enabled: !keeping,
              child: InkWell(
                onTap: switch (keeping) {
                  true => null,
                  false => () => _review(context, ref),
                },
                child: Text(
                  context.intl.review,
                  style: FujinText.inter15Medium.copyWith(
                    color: switch (keeping) {
                      true => FujinColorRole.textDisabled,
                      false => FujinColorRole.textLink,
                    },
                  ),
                ),
              ),
            ),
          },
        ],
      ),
    );
  }

  void _review(BuildContext context, WidgetRef ref) {
    final kept = ref.read(keptChoicesProvider(sent.entry.date).notifier);
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);
    final intl = context.intl;

    void keep(PlannedEntry planned) => unawaited(
      kept.keep(planned).then((failure) {
        if (failure case final failure?) {
          messenger.showFujinSnackBar(
            SnackBar(
              content: Text(_failed(intl, failure)),
              action: switch (failure) {
                SendFailure.ekkloSession => SnackBarAction(
                  label: intl.ekkloReconnect,
                  onPressed: () =>
                      unawaited(router.push<bool>(FujinRoute.ekkloSignIn.path)),
                ),
                SendFailure.network ||
                SendFailure.mfpSession ||
                SendFailure.refused ||
                SendFailure.blockedInDev ||
                SendFailure.other => null,
              },
            ),
          );
        }
      }),
    );

    final EntryChoices choices = (
      choose: (candidate) => keep(sent.choose(candidate)),
      ownCopy: () => keep(sent.asOwnCopy()),
      weigh: (gramsPerUnit) => keep(sent.weighing(gramsPerUnit)),
      skip: null,
    );
    unawaited(switch (sent.reason) {
      ReviewReason.weightToConfirm => showWeightSheet(
        context,
        planned: sent,
        choices: choices,
      ),
      ReviewReason.noCloseFood => showOwnCopySheet(
        context,
        planned: sent,
        choices: choices,
      ),
      ReviewReason.newAssociation ||
      ReviewReason.skipped ||
      ReviewReason.confirmed => showMatchSheet(
        context,
        planned: sent,
        choices: choices,
      ),
    });
  }

  String _failed(AppLocalizations intl, SendFailure failure) =>
      switch (failure) {
        SendFailure.network => intl.offlineHeadline,
        SendFailure.ekkloSession => intl.ekkloSessionExpired,
        SendFailure.mfpSession => intl.mfpSessionExpired,
        SendFailure.blockedInDev => intl.interruptedDev(
          sent.entry.food.description,
        ),
        SendFailure.refused || SendFailure.other => intl.keepFailed,
      };
}
