import 'package:flutter/material.dart';
import 'package:fujin/app/theme/fujin_tokens.g.dart';
import 'package:fujin/domain/sending/send_report.dart';
import 'package:fujin/l10n/generated/app_localizations.dart';
import 'package:fujin/pages/common/entry_text.dart';
import 'package:fujin/pages/common/fujin_weather.dart';
import 'package:fujin/pages/common/fujin_weather_glyph.dart';
import 'package:fujin/pages/common/gold_volute.dart';
import 'package:fujin/pages/common/seigaiha_band.dart';
import 'package:fujin/pages/sending/send_text.dart';
import 'package:go_router/go_router.dart';

class SentView extends StatelessWidget {
  const SentView({required this.report, super.key});

  static const double _glyphSide = 72;
  static const double _tile = 32;
  static const double _tileRadius = 10;
  static const double _tileIcon = 16;
  static const double _volute = 22;
  static const double _goldRule = 2;

  final SendReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rows = _rows(l10n);
    return Stack(
      children: [
        const PositionedDirectional(
          start: 0,
          end: 0,
          bottom: 0,
          child: SeigaihaBand(),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(
                  FujinSize.screenMargin,
                  FujinSpace.s8 + FujinSpace.s3,
                  FujinSize.screenMargin,
                  FujinSpace.s6,
                ),
                children: [
                  const Center(
                    child: FujinWeatherGlyph(
                      weather: FujinWeather.calm,
                      side: _glyphSide,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s4),
                  Text(
                    l10n.sentTitle,
                    textAlign: TextAlign.center,
                    style: FujinText.hina44.copyWith(
                      color: FujinColorRole.textLink,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s5),
                  Text(
                    l10n.sentDetail(report.sent),
                    textAlign: TextAlign.center,
                    style: FujinText.inter15Medium.copyWith(
                      color: FujinColorRole.textPrimary,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s1),
                  Text(
                    EntryText.capitalized(
                      l10n.sentAt(report.date, report.sentAt),
                    ),
                    textAlign: TextAlign.center,
                    style: FujinText.inter13Regular.copyWith(
                      color: FujinColorRole.textSecondary,
                    ),
                  ),
                  const SizedBox(height: FujinSpace.s5),
                  const _GoldSeparator(),
                  if (rows.isNotEmpty) ...[
                    const SizedBox(height: FujinSpace.s3),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: FujinSpace.s4,
                        vertical: FujinSpace.s1,
                      ),
                      decoration: BoxDecoration(
                        color: FujinColorRole.backgroundCard,
                        borderRadius: BorderRadius.circular(FujinRadius.card),
                        border: Border.all(color: FujinColorRole.borderCard),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final (index, row) in rows.indexed) ...[
                            if (index > 0)
                              const Padding(
                                padding: EdgeInsetsDirectional.only(
                                  start: _tile + FujinSpace.s3,
                                ),
                                child: Divider(),
                              ),
                            row,
                          ],
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                FujinSize.screenMargin,
                FujinSpace.s3,
                FujinSize.screenMargin,
                FujinSpace.s4,
              ),
              child: FilledButton(
                onPressed: context.pop,
                child: Text(l10n.backToJournal),
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<_Row> _rows(AppLocalizations l10n) {
    final separator = l10n.listSeparator;
    return [
      if (report.reused > 0)
        _Row(
          label: l10n.sentReused(report.reused),
          tile: FujinColorRole.backgroundSuccess,
          icon: Icons.refresh,
          iconColor: FujinColorRole.textLink,
        ),
      if (report.newAssociations case final names when names.isNotEmpty)
        _Row(
          label: l10n.sentAssociations(names.length, names.join(separator)),
          tile: FujinColor.kinLight,
          icon: Icons.auto_awesome_outlined,
          iconColor: FujinColorRole.textGold,
        ),
      if (report.weights case final weights when weights.isNotEmpty)
        _Row(
          label: l10n.sentWeights(
            weights.length,
            weights
                .map(
                  (weight) => l10n.unitWeight(
                    weight.unit,
                    SendText.grams(l10n, weight.grams),
                  ),
                )
                .join(separator),
          ),
          tile: FujinColor.kinari,
          icon: Icons.scale_outlined,
          iconColor: FujinColorRole.textPrimary,
        ),
      if (report.ownCopies case final names when names.isNotEmpty)
        _Row(
          label: l10n.sentOwnCopies(names.length, names.join(separator)),
          tile: FujinColor.kinari,
          icon: Icons.add,
          iconColor: FujinColorRole.textPrimary,
        ),
      if (report.updated > 0)
        _Row(
          label: l10n.sentUpdated(report.updated),
          tile: FujinColorRole.backgroundInfo,
          icon: Icons.refresh,
          iconColor: FujinColor.sora,
        ),
    ];
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.tile,
    required this.icon,
    required this.iconColor,
  });

  final String label;
  final Color tile;
  final IconData icon;
  final Color iconColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: FujinSpace.s3),
    child: Row(
      spacing: FujinSpace.s3,
      children: [
        Container(
          width: SentView._tile,
          height: SentView._tile,
          decoration: BoxDecoration(
            color: tile,
            borderRadius: BorderRadius.circular(SentView._tileRadius),
          ),
          child: Icon(icon, size: SentView._tileIcon, color: iconColor),
        ),
        Expanded(
          child: Text(
            label,
            style: FujinText.inter14Medium.copyWith(
              color: FujinColorRole.textPrimary,
            ),
          ),
        ),
      ],
    ),
  );
}

class _GoldSeparator extends StatelessWidget {
  const _GoldSeparator();

  @override
  Widget build(BuildContext context) => const Padding(
    padding: EdgeInsets.symmetric(
      horizontal: FujinSize.textInset - FujinSize.screenMargin,
    ),
    child: Row(
      spacing: FujinSpace.s2,
      children: [
        Expanded(child: _GoldRule()),
        SizedBox.square(dimension: SentView._volute, child: GoldVolute()),
        Expanded(child: _GoldRule()),
      ],
    ),
  );
}

class _GoldRule extends StatelessWidget {
  const _GoldRule();

  @override
  Widget build(BuildContext context) => const SizedBox(
    height: SentView._goldRule,
    child: ColoredBox(color: FujinColor.kin),
  );
}
