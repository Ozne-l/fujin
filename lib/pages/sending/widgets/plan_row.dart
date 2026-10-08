import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/comparison/compared_entry.dart';
import 'package:fujin/domain/comparison/entry_status.dart';
import 'package:fujin/domain/sending/planned_entry.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
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

  PlanRow.inEkklo(ComparedEntry compared, {super.key})
    : _row = _InEkkloRow(compared);

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
        const _BreezeIndicator(),
      ),
      _Pending(:final entry, searching: false) => (
        entry.food.description,
        l10n.rowWaiting,
        FujinColorRole.textTertiary,
        null,
      ),
      _InEkkloRow(:final compared) => (
        compared.entry.food.description,
        _inEkkloDetail(l10n, compared),
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

  static String _inEkkloDetail(
    AppLocalizations l10n,
    ComparedEntry compared,
  ) => switch (compared.status) {
    InEkklo(:final link) || ToUpdate(:final link) => l10n.inEkkloAs(
      l10n.servingLine(
        link.mfpServings,
        link.mfpServingValue,
        link.mfpServingUnit,
      ),
    ),
    ToSend() => EntryText.brandedServing(l10n, compared.entry),
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
  const _InEkkloRow(this.compared);

  final ComparedEntry compared;
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

class _BreezeIndicator extends StatelessWidget {
  const _BreezeIndicator();

  static const double _width = 24;
  static const double _stroke = 2;
  static const double _gap = 3;
  static const EdgeInsets _padding = EdgeInsets.only(top: 3, bottom: 1);
  static const List<({double start, double length})> _bars = [
    (start: 0.0, length: 14.0),
    (start: 6.0, length: 18.0),
    (start: 2.0, length: 10.0),
  ];

  @override
  Widget build(BuildContext context) => Container(
    width: _width,
    padding: _padding,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: _gap,
      children: [
        for (final bar in _bars)
          Container(
            margin: EdgeInsetsDirectional.only(start: bar.start),
            width: bar.length,
            height: _stroke,
            decoration: BoxDecoration(
              color: FujinColor.sora,
              borderRadius: BorderRadius.circular(_stroke / 2),
            ),
          ),
      ],
    ),
  );
}
