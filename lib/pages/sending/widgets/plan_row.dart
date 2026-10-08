import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/data/links/sent_link.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/breeze_indicator.dart';
import 'package:fujin/pages/common/breeze_streaks.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/pill_tone.dart';
import 'package:fujin/pages/common/status_pill.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:myfitnesspal_client/myfitnesspal_client.dart';

class PlanRow extends StatelessWidget {
  PlanRow.planned(PlannedEntry planned, {super.key}) : _row = _Planned(planned);

  PlanRow.pending(
    MfpFoodEntry entry, {
    required bool searching,
    super.key,
  }) : _row = _Pending(entry, searching: searching);

  PlanRow.inEkklo(MfpFoodEntry entry, SentLink link, {super.key})
    : _row = _InEkkloRow(entry, link);

  final _RowKind _row;

  static Widget card(List<PlanRow> rows) => _PlanCard(rows);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (name, detail, detailColor, trailing) = switch (_row) {
      _Planned(:final planned) => (
        planned.entry.food.description,
        SendText.target(l10n, planned),
        FujinColorRole.textSecondary,
        _plannedPill(l10n, planned),
      ),
      _Pending(:final entry, searching: true) => (
        entry.food.description,
        l10n.rowSearching,
        FujinColor.sora,
        const BreezeIndicator(streaks: BreezeStreaks.searching),
      ),
      _Pending(:final entry, searching: false) => (
        entry.food.description,
        l10n.rowWaiting,
        FujinColorRole.textTertiary,
        null,
      ),
      _InEkkloRow(:final entry, :final link) => (
        entry.food.description,
        EntryText.linkedServing(l10n, link),
        FujinColorRole.textSecondary,
        StatusPill(label: l10n.statusInEkklo, tone: PillTone.validated),
      ),
    };
    return Row(
      spacing: FujinSpace.s4,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: FujinSpace.s1,
            children: [
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FujinText.inter15Medium.copyWith(
                  color: FujinColorRole.textPrimary,
                ),
              ),
              Text(
                detail,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FujinText.inter13Regular.copyWith(color: detailColor),
              ),
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }

  static Widget _plannedPill(AppLocalizations l10n, PlannedEntry planned) =>
      switch ((planned.reviewed, planned.replacing)) {
        (false, null) => StatusPill(
          label: l10n.pillRemembered,
          tone: PillTone.attention,
        ),
        (false, _) => StatusPill(
          label: l10n.statusToUpdate,
          tone: PillTone.info,
          icon: Icons.refresh,
        ),
        (true, _) => switch (SendText.reason(l10n, planned.reason)) {
          (final label, final tone) => StatusPill(label: label, tone: tone),
        },
      };
}

sealed class _RowKind {
  const _RowKind();
}

final class _Planned extends _RowKind {
  const _Planned(this.planned);

  final PlannedEntry planned;
}

final class _Pending extends _RowKind {
  const _Pending(this.entry, {required this.searching});

  final MfpFoodEntry entry;
  final bool searching;
}

final class _InEkkloRow extends _RowKind {
  const _InEkkloRow(this.entry, this.link);

  final MfpFoodEntry entry;
  final SentLink link;
}

class _PlanCard extends StatelessWidget {
  const _PlanCard(this.rows);

  final List<PlanRow> rows;

  @override
  Widget build(BuildContext context) => Container(
    margin: const EdgeInsets.symmetric(horizontal: FujinSize.screenMargin),
    padding: const EdgeInsets.fromLTRB(
      FujinSpace.s5,
      FujinSpace.s4,
      FujinSpace.s5,
      FujinSpace.s3,
    ),
    decoration: BoxDecoration(
      color: FujinColorRole.backgroundCard,
      borderRadius: BorderRadius.circular(FujinRadius.card),
      border: Border.all(color: FujinColorRole.borderCard),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: FujinSpace.s2,
      children: [
        for (final (index, row) in rows.indexed) ...[
          if (index > 0) const Divider(),
          row,
        ],
      ],
    ),
  );
}
